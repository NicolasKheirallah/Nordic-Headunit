#include "MediaService.h"
#include <QUrl>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>


MediaService::MediaService(QObject *parent)
    : QObject(parent),
      m_currentIndex(0),
      m_shuffleEnabled(false),
      m_repeatEnabled(false),
      m_currentSource("Bluetooth"),
      m_currentRadioIndex(0),
      m_currentFrequency(101.5),
      m_isConnected(true),
      m_isLoading(false)
{
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_player->setAudioOutput(m_audioOutput);
    m_audioOutput->setVolume(1.0);  // Default max volume

    m_playlistModel = new PlaylistModel(this);
    m_radioModel = new RadioModel(this);

    connect(m_player, &QMediaPlayer::positionChanged, this, &MediaService::onMediaPlayerPositionChanged);
    connect(m_player, &QMediaPlayer::durationChanged, this, &MediaService::onMediaPlayerDurationChanged);
    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, &MediaService::onMediaPlayerStatusChanged);
    connect(m_player, &QMediaPlayer::errorOccurred, this, &MediaService::onMediaPlayerErrorOccurred);

    loadPresets();
    loadMockData();
    
    // Set initial station active
    m_radioModel->setActive(0);
}

void MediaService::loadMockData() {
    // Scan local Music directory
    QStringList musicPaths = QStandardPaths::standardLocations(QStandardPaths::MusicLocation);
    QStringList filters;
    filters << "*.mp3" << "*.wav" << "*.m4a";
    
    bool foundLocal = false;
    for (const QString &path : musicPaths) {
        QDir dir(path);
        dir.setNameFilters(filters);
        QFileInfoList files = dir.entryInfoList();
        for (const QFileInfo &file : files) {
            Track t;
            t.title = file.baseName(); // Simple parsing
            t.artist = "Unknown Artist";
            t.album = "Unknown Album";
            t.sourceUrl = file.absoluteFilePath();
            t.coverUrl = "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"; // Fallback cover
            t.duration = 0; // Not available until played without metadata lib
            m_playlistModel->addTrack(t);
            foundLocal = true;
        }
    }

    if (!foundLocal) {
        // Fallback Mock Playlist
        m_playlistModel->addTrack({"Blinding Lights", "The Weeknd", "After Hours", "qrc:/qt/qml/NordicHeadunit/assets/music/track1.mp3", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 200});
        m_playlistModel->addTrack({"Midnight City", "M83", "Hurry Up, We're Dreaming", "qrc:/qt/qml/NordicHeadunit/assets/music/track2.mp3", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 243});
        m_playlistModel->addTrack({"Levitating", "Dua Lipa", "Future Nostalgia", "qrc:/qt/qml/NordicHeadunit/assets/music/track3.mp3", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 180});
        m_playlistModel->addTrack({"Starboy", "The Weeknd", "Starboy", "qrc:/qt/qml/NordicHeadunit/assets/music/track4.mp3", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 230});
    }
    
    // Mock Radio Stations (Persist as defaults if empty)
    if (m_radioModel->rowCount() == 0) {
        m_radioModel->addStation({"Radio 1", "101.5", "FM", false});
        m_radioModel->addStation({"Classic FM", "98.3", "FM", false});
        m_radioModel->addStation({"Jazz Radio", "105.7", "FM", false});
        m_radioModel->addStation({"News 24", "88.1", "FM", false});
        m_radioModel->addStation({"Rock FM", "92.5", "FM", false});
    }
}

// Getters
QString MediaService::title() const { 
    if (isRadioMode()) return radioName().isEmpty() ? ("FM " + radioFrequency()) : radioName();
    Track t = m_playlistModel->getTrack(m_currentIndex);
    return t.title.isEmpty() ? "Unknown Title" : t.title;
}

QString MediaService::artist() const { 
    if (isRadioMode()) return radioFrequency() + " FM";
    Track t = m_playlistModel->getTrack(m_currentIndex);
    return t.artist.isEmpty() ? "Unknown Artist" : t.artist;
}

QString MediaService::coverSource() const { 
    return m_playlistModel->getTrack(m_currentIndex).coverUrl; 
}

bool MediaService::playing() const { 
    return m_player->playbackState() == QMediaPlayer::PlayingState; 
}

qint64 MediaService::position() const { 
    if (isRadioMode()) return 0;
    return m_player->position() / 1000; // Return seconds for UI consistency
}

qint64 MediaService::duration() const { 
    if (isRadioMode()) return 0;
    return m_player->duration() / 1000; // Return seconds
}

double MediaService::progress() const {
    qint64 dur = duration();
    if (isRadioMode() || dur == 0) return 0;
    return (double)position() / dur;
}

bool MediaService::shuffleEnabled() const { return m_shuffleEnabled; }
void MediaService::setShuffleEnabled(bool enabled) {
    if (m_shuffleEnabled == enabled) return;
    m_shuffleEnabled = enabled;
    emit shuffleEnabledChanged();
}

bool MediaService::repeatEnabled() const { return m_repeatEnabled; }
void MediaService::setRepeatEnabled(bool enabled) {
    if (m_repeatEnabled == enabled) return;
    m_repeatEnabled = enabled;
    emit repeatEnabledChanged();
}

QString MediaService::currentSource() const { return m_currentSource; }
bool MediaService::isRadioMode() const { return m_currentSource == "Radio"; }

void MediaService::setCurrentSource(const QString &source) {
    if (m_currentSource == source) return;

    // Save state
    if (!isRadioMode()) {
        m_lastPosition[m_currentSource] = m_player->position();
        m_lastTrackIndex[m_currentSource] = m_currentIndex;
    }
    m_player->stop();

    m_currentSource = source;

    // Restore state
    if (source != "Radio") {
        m_currentIndex = m_lastTrackIndex.value(source, 0);
        qint64 pos = m_lastPosition.value(source, 0);
        
        playTrack(m_currentIndex);
        if (pos > 0) m_player->setPosition(pos);
    } else {
        // Radio mode logic
        emit radioChanged();
    }

    emit currentSourceChanged();
    emit sourcesChanged();
    emit trackChanged();
}

RadioModel* MediaService::radioModel() const { return m_radioModel; }
PlaylistModel* MediaService::playlistModel() const { return m_playlistModel; }

// Wrappers for QML backward compatibility if needed, but we prefer Models now
QVariantList MediaService::sources() const {
    QVariantList list;
    // ... same source logic as before ...
    // Simplified for brevity
    list.append(QVariantMap{{"name", "Radio"}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg"}, {"active", m_currentSource == "Radio"}, {"lastPlayed", ""}});
    list.append(QVariantMap{{"name", "Bluetooth"}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"}, {"active", m_currentSource == "Bluetooth"}, {"lastPlayed", ""}});
    list.append(QVariantMap{{"name", "USB"}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"}, {"active", m_currentSource == "USB"}, {"lastPlayed", ""}});
    return list;
}

QVariantList MediaService::recentItems() const {
    QVariantList list;
    // Mock recents
    list.append(QVariantMap{{"title", "Blinding Lights"}, {"subtitle", "The Weeknd"}, {"type", "track"}, {"index", 0}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"}});
    list.append(QVariantMap{{"title", "Radio 1"}, {"subtitle", "101.5 FM"}, {"type", "station"}, {"index", 0}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg"}});
    return list;
}

QVariantList MediaService::library() const {
    QVariantList list;
    list.append(QVariantMap{{"name", "Liked Songs"}, {"count", "143 songs"}, {"color", "#00C896"}});
    list.append(QVariantMap{{"name", "Road Trip"}, {"count", "24 songs"}, {"color", "#E91E63"}});
    list.append(QVariantMap{{"name", "Chill Vibes"}, {"count", "56 songs"}, {"color", "#9C27B0"}});
    return list;
}

QString MediaService::radioFrequency() const {
    return QString::number(m_currentFrequency, 'f', 1);
}

QString MediaService::radioName() const {
    // Check if current frequency matches a preset
    QList<RadioStation> stations = m_radioModel->getAll();
    for (const auto& s : stations) {
        if (s.frequency == radioFrequency()) return s.name;
    }
    return "";
}

int MediaService::currentRadioIndex() const { return m_currentRadioIndex; }
bool MediaService::isConnected() const { return m_isConnected; }
bool MediaService::isLoading() const { return m_isLoading; }
bool MediaService::hasError() const { return !m_player->errorString().isEmpty(); }
QString MediaService::errorMessage() const { return m_player->errorString(); }

// Playback Controls
void MediaService::play() { m_player->play(); }
void MediaService::pause() { m_player->pause(); }
void MediaService::togglePlayPause() { 
    if (playing()) pause(); else play(); 
}
void MediaService::setPlaying(bool playing) { if (playing) play(); else pause(); }

void MediaService::seek(qint64 position) {
    if (!isRadioMode()) m_player->setPosition(position * 1000);
}

void MediaService::setSource(const QString &source) { setCurrentSource(source); }

void MediaService::tuneRadio(const QString &frequency) {
    tuneToFrequency(frequency);
}

void MediaService::tuneToFrequency(const QString &frequency) {
    bool ok;
    double freq = frequency.toDouble(&ok);
    if (ok) {
        m_currentFrequency = freq;
        emit radioChanged();
        
        // Update active preset if matches
        QList<RadioStation> stations = m_radioModel->getAll();
        for (int i=0; i<stations.count(); ++i) {
            if (stations[i].frequency == frequency) {
                m_currentRadioIndex = i;
                m_radioModel->setActive(i);
                return;
            }
        }
        // If no match, deselect all
        m_radioModel->setActive(-1); 
    }
}

void MediaService::tuneRadioByIndex(int index) {
    RadioStation s = m_radioModel->getStation(index);
    if (!s.frequency.isEmpty()) {
        m_currentRadioIndex = index;
        tuneToFrequency(s.frequency);
    }
}

void MediaService::tuneStep(double step) {
    m_currentFrequency += step;
    if (m_currentFrequency > 108.0) m_currentFrequency = 87.5;
    if (m_currentFrequency < 87.5) m_currentFrequency = 108.0;
    tuneToFrequency(QString::number(m_currentFrequency, 'f', 1));
}

void MediaService::seekForward() {
    // Basic seek implementation
    tuneStep(0.5); 
}

void MediaService::seekBackward() {
    tuneStep(-0.5);
}

void MediaService::scanRadioStations() {
    m_radioModel->clear();
    loadMockData();
}

void MediaService::playTrack(int index) {
    Track t = m_playlistModel->getTrack(index);
    if (t.sourceUrl.isEmpty()) return;

    m_currentIndex = index;
    // In production, check if file exists. Here, we blindly try to play.
    m_player->setSource(QUrl(t.sourceUrl));
    m_player->play();
    emit trackChanged();
}

void MediaService::playFromRecent(int index) {
    QVariantList items = recentItems();
    if (index < 0 || index >= items.count()) return;
    
    QVariantMap item = items[index].toMap();
    if (item["type"].toString() == "station") {
        tuneRadioByIndex(item["index"].toInt());
    } else {
        playTrack(item["index"].toInt());
    }
}
void MediaService::playPlaylist(const QString &) { playTrack(0); }

bool MediaService::saveCurrentToPreset() {
    if (!isRadioMode()) return false;
    RadioStation s;
    s.frequency = radioFrequency();
    s.band = "FM";
    s.name = "Saved " + s.frequency;
    m_radioModel->addStation(s);
    savePresets();
    return true;
}

void MediaService::next() {
    if (isRadioMode()) {
        int nextIndex = (m_currentRadioIndex + 1) % m_radioModel->rowCount();
        tuneRadioByIndex(nextIndex);
    } else {
        int nextIndex = (m_currentIndex + 1) % m_playlistModel->rowCount();
        playTrack(nextIndex);
    }
}

void MediaService::previous() {
    if (isRadioMode()) {
        int prevIndex = (m_currentRadioIndex - 1 + m_radioModel->rowCount()) % m_radioModel->rowCount();
        tuneRadioByIndex(prevIndex);
    } else {
        int prevIndex = (m_currentIndex - 1 + m_playlistModel->rowCount()) % m_playlistModel->rowCount();
        playTrack(prevIndex);
    }
}

// Media Player Signals
void MediaService::onMediaPlayerPositionChanged(qint64) { emit positionChanged(); }
void MediaService::onMediaPlayerDurationChanged(qint64) { emit trackChanged(); }
void MediaService::onMediaPlayerStatusChanged(QMediaPlayer::MediaStatus status) {
    if (status == QMediaPlayer::EndOfMedia) {
        if (m_repeatEnabled) playTrack(m_currentIndex);
        else next();
    }
    emit playingChanged(playing());
}
void MediaService::onMediaPlayerErrorOccurred(QMediaPlayer::Error, const QString &errorString) {
    qWarning() << "Media Error:" << errorString;
    emit errorChanged();
}

void MediaService::savePresets() {
    QJsonArray array;
    for (const auto &s : m_radioModel->getAll()) {
        QJsonObject obj;
        obj["name"] = s.name;
        obj["frequency"] = s.frequency;
        obj["band"] = s.band;
        array.append(obj);
    }
    
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/radio_presets.json");
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(array).toJson());
    }
}

void MediaService::loadPresets() {
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    if (!dir.exists()) dir.mkpath(".");
    
    QFile file(dir.filePath("radio_presets.json"));
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonArray array = doc.array();
        if (!array.isEmpty()) {
            m_radioModel->clear();
            for (const auto &val : array) {
                QJsonObject obj = val.toObject();
                m_radioModel->addStation({
                    obj["name"].toString(),
                    obj["frequency"].toString(),
                    obj["band"].toString(),
                    false
                });
            }
        }
    }
}
