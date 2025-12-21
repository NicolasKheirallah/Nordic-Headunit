#include "MediaService.h"

MediaService::MediaService(QObject *parent)
    : QObject(parent),
      m_currentIndex(0),
      m_playing(false),
      m_position(0),
      m_currentSource("Bluetooth"),
      m_currentRadioIndex(0),
      m_shuffleEnabled(false),
      m_repeatEnabled(false),
      m_isConnected(true),
      m_isLoading(false)
{
    // Mock Playlist
    m_playlist.append({"Blinding Lights", "The Weeknd", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 200});
    m_playlist.append({"Midnight City", "M83", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 243});
    m_playlist.append({"Levitating", "Dua Lipa", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 180});
    m_playlist.append({"Starboy", "The Weeknd", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 230});
    m_playlist.append({"Take On Me", "a-ha", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 225});
    m_playlist.append({"Sweet Dreams", "Eurythmics", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 216});
    
    // Mock Radio Stations
    m_radioStations.append({"Radio 1", "101.5", "FM"});
    m_radioStations.append({"Classic FM", "98.3", "FM"});
    m_radioStations.append({"Jazz Radio", "105.7", "FM"});
    m_radioStations.append({"News 24", "88.1", "FM"});
    m_radioStations.append({"Rock FM", "92.5", "FM"});
    m_radioStations.append({"Pop Hits", "94.9", "FM"});
    
    m_timer = new QTimer(this);
    m_timer->setInterval(1000);
    connect(m_timer, &QTimer::timeout, this, &MediaService::updatePosition);
}

const Track& MediaService::currentTrack() const
{
    return m_playlist[m_currentIndex];
}

QString MediaService::title() const { 
    if (isRadioMode()) return m_radioStations[m_currentRadioIndex].name;
    return currentTrack().title; 
}

QString MediaService::artist() const { 
    if (isRadioMode()) return m_radioStations[m_currentRadioIndex].frequency + " " + m_radioStations[m_currentRadioIndex].band;
    return currentTrack().artist; 
}

QString MediaService::coverSource() const { return currentTrack().coverSource; }
bool MediaService::playing() const { return m_playing; }
int MediaService::position() const { return m_position; }
int MediaService::duration() const { 
    if (isRadioMode()) return 0;
    return currentTrack().duration; 
}

double MediaService::progress() const {
    if (isRadioMode() || duration() == 0) return 0;
    return (double)m_position / duration();
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

void MediaService::setCurrentSource(const QString &source)
{
    if (m_currentSource == source) return;
    
    // Save current position for resume
    if (!isRadioMode()) {
        m_lastPosition[m_currentSource] = m_position;
        m_lastTrackIndex[m_currentSource] = m_currentIndex;
    }
    
    m_currentSource = source;
    
    // Restore position for new source
    if (source != "Radio") {
        m_position = m_lastPosition.value(source, 0);
        m_currentIndex = m_lastTrackIndex.value(source, 0);
    }
    
    emit currentSourceChanged();
    emit sourcesChanged();
    emit trackChanged();
    emit positionChanged();
}

bool MediaService::isRadioMode() const { return m_currentSource == "Radio"; }

int MediaService::currentRadioIndex() const { return m_currentRadioIndex; }

bool MediaService::isConnected() const { return m_isConnected; }
bool MediaService::isLoading() const { return m_isLoading; }
bool MediaService::hasError() const { return false; }
QString MediaService::errorMessage() const { return QString(); }

QVariantList MediaService::sources() const 
{
    QVariantList list;
    
    QVariantMap radio;
    radio["name"] = "Radio";
    radio["icon"] = "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg";
    radio["active"] = (m_currentSource == "Radio");
    radio["lastPlayed"] = m_radioStations.isEmpty() ? "" : m_radioStations[m_currentRadioIndex].frequency + " " + m_radioStations[m_currentRadioIndex].band;
    list.append(radio);
    
    QVariantMap bluetooth;
    bluetooth["name"] = "Bluetooth";
    bluetooth["icon"] = "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg";
    bluetooth["active"] = (m_currentSource == "Bluetooth");
    bluetooth["lastPlayed"] = m_playlist.isEmpty() ? "" : m_playlist[m_currentIndex].title;
    list.append(bluetooth);
    
    QVariantMap usb;
    usb["name"] = "USB";
    usb["icon"] = "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg";
    usb["active"] = (m_currentSource == "USB");
    usb["lastPlayed"] = "Insert USB drive";
    list.append(usb);
    
    QVariantMap streaming;
    streaming["name"] = "Streaming";
    streaming["icon"] = "qrc:/qt/qml/NordicHeadunit/assets/icons/wifi.svg";
    streaming["active"] = (m_currentSource == "Streaming");
    streaming["lastPlayed"] = "Sign in to stream";
    list.append(streaming);
    
    return list;
}

QVariantList MediaService::radioStations() const 
{
    QVariantList list;
    for (int i = 0; i < m_radioStations.size(); ++i) {
        QVariantMap station;
        station["name"] = m_radioStations[i].name;
        station["frequency"] = m_radioStations[i].frequency;
        station["band"] = m_radioStations[i].band;
        station["active"] = (isRadioMode() && i == m_currentRadioIndex);
        station["index"] = i;
        list.append(station);
    }
    return list;
}

QVariantList MediaService::recentItems() const
{
    QVariantList list;
    
    // Add recent tracks
    for (int i = 0; i < qMin(3, m_playlist.size()); ++i) {
        QVariantMap item;
        item["title"] = m_playlist[i].title;
        item["subtitle"] = m_playlist[i].artist;
        item["type"] = "track";
        item["icon"] = "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg";
        item["index"] = i;
        list.append(item);
    }
    
    // Add recent radio stations
    for (int i = 0; i < qMin(2, m_radioStations.size()); ++i) {
        QVariantMap item;
        item["title"] = m_radioStations[i].name;
        item["subtitle"] = m_radioStations[i].frequency + " " + m_radioStations[i].band;
        item["type"] = "station";
        item["icon"] = "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg";
        item["index"] = i;
        list.append(item);
    }
    
    return list;
}

QVariantList MediaService::library() const
{
    QVariantList list;
    
    QVariantMap liked;
    liked["name"] = "Liked Songs";
    liked["count"] = "143 songs";
    liked["color"] = "#00C896";
    list.append(liked);
    
    QVariantMap roadTrip;
    roadTrip["name"] = "Road Trip";
    roadTrip["count"] = "24 songs";
    roadTrip["color"] = "#E91E63";
    list.append(roadTrip);
    
    QVariantMap chill;
    chill["name"] = "Chill Vibes";
    chill["count"] = "56 songs";
    chill["color"] = "#9C27B0";
    list.append(chill);
    
    QVariantMap workout;
    workout["name"] = "Workout";
    workout["count"] = "32 songs";
    workout["color"] = "#FF5722";
    list.append(workout);
    
    return list;
}

QVariantList MediaService::playlist() const
{
    QVariantList list;
    for (int i = 0; i < m_playlist.size(); ++i) {
        QVariantMap track;
        track["title"] = m_playlist[i].title;
        track["artist"] = m_playlist[i].artist;
        track["duration"] = m_playlist[i].duration;
        track["index"] = i;
        track["isPlaying"] = (i == m_currentIndex);
        list.append(track);
    }
    return list;
}

QString MediaService::radioFrequency() const 
{
    if (m_radioStations.isEmpty()) return "";
    return m_radioStations[m_currentRadioIndex].frequency;
}

QString MediaService::radioName() const
{
    if (m_radioStations.isEmpty()) return "";
    return m_radioStations[m_currentRadioIndex].name;
}

void MediaService::setPlaying(bool playing)
{
    if (m_playing == playing) return;
    m_playing = playing;
    if (m_playing && !isRadioMode()) m_timer->start(); else m_timer->stop();
    emit playingChanged(m_playing);
}

void MediaService::play() { setPlaying(true); }
void MediaService::pause() { setPlaying(false); }
void MediaService::togglePlayPause() { setPlaying(!m_playing); }

void MediaService::seek(int position)
{
    if (isRadioMode()) return;
    m_position = qBound(0, position, duration());
    emit positionChanged();
}

void MediaService::setSource(const QString &source)
{
    setCurrentSource(source);
    play();
}

void MediaService::tuneRadio(const QString &frequency)
{
    for (int i = 0; i < m_radioStations.size(); ++i) {
        if (m_radioStations[i].frequency == frequency) {
            m_currentRadioIndex = i;
            if (m_currentSource != "Radio") {
                setCurrentSource("Radio");
            }
            emit radioChanged();
            emit radioStationsChanged();
            emit trackChanged();
            play();
            return;
        }
    }
}

void MediaService::tuneRadioByIndex(int index)
{
    if (index < 0 || index >= m_radioStations.size()) return;
    m_currentRadioIndex = index;
    if (m_currentSource != "Radio") {
        setCurrentSource("Radio");
    }
    emit radioChanged();
    emit radioStationsChanged();
    emit trackChanged();
    play();
}

void MediaService::tuneToFrequency(const QString &frequency)
{
    // Manual frequency tuning
    // In a real implementation, this would tune the hardware
    // For mock, we check if frequency matches a known station
    for (int i = 0; i < m_radioStations.size(); ++i) {
        if (m_radioStations[i].frequency == frequency) {
            tuneRadioByIndex(i);
            return;
        }
    }
    // Not a known station - still tune to it
    // Mock: just update the first station temporarily
    if (!m_radioStations.isEmpty()) {
        m_radioStations[0].frequency = frequency;
        m_radioStations[0].name = "FM " + frequency;
        m_currentRadioIndex = 0;
    }
    if (m_currentSource != "Radio") {
        setCurrentSource("Radio");
    }
    emit radioChanged();
    emit radioStationsChanged();
    emit trackChanged();
    play();
}

void MediaService::scanRadioStations()
{
    // Mock: simulate a station scan by resetting to default stations
    // In a real implementation, this would trigger hardware scan
    m_radioStations.clear();
    m_radioStations.append({"Radio 1", "101.5", "FM"});
    m_radioStations.append({"NRK P1", "92.4", "FM"});
    m_radioStations.append({"P3", "99.3", "FM"});
    m_radioStations.append({"Mix FM", "104.7", "FM"});
    m_radioStations.append({"Rock FM", "106.1", "FM"});
    m_radioStations.append({"Jazz FM", "98.2", "FM"});
    
    m_currentRadioIndex = 0;
    emit radioStationsChanged();
    emit radioChanged();
}

void MediaService::playTrack(int index)
{
    if (index < 0 || index >= m_playlist.size()) return;
    m_currentIndex = index;
    m_position = 0;
    if (isRadioMode()) {
        setCurrentSource("Bluetooth");
    }
    emit trackChanged();
    emit positionChanged();
    emit playlistChanged();
    play();
}

void MediaService::playFromRecent(int index)
{
    QVariantList recents = recentItems();
    if (index < 0 || index >= recents.size()) return;
    
    QVariantMap item = recents[index].toMap();
    QString type = item["type"].toString();
    int itemIndex = item["index"].toInt();
    
    if (type == "station") {
        tuneRadioByIndex(itemIndex);
    } else {
        playTrack(itemIndex);
    }
}

void MediaService::playPlaylist(const QString &name)
{
    // Mock: just start playing the first track
    m_currentIndex = 0;
    m_position = 0;
    if (isRadioMode()) {
        setCurrentSource("Bluetooth");
    }
    emit trackChanged();
    emit positionChanged();
    emit playlistChanged();
    play();
}

void MediaService::next()
{
    if (isRadioMode()) {
        m_currentRadioIndex = (m_currentRadioIndex + 1) % m_radioStations.size();
        emit radioChanged();
        emit radioStationsChanged();
        emit trackChanged();
    } else {
        m_currentIndex = (m_currentIndex + 1) % m_playlist.size();
        m_position = 0;
        emit trackChanged();
        emit positionChanged();
        emit playlistChanged();
    }
}

void MediaService::previous()
{
    if (isRadioMode()) {
        m_currentRadioIndex = (m_currentRadioIndex - 1 + m_radioStations.size()) % m_radioStations.size();
        emit radioChanged();
        emit radioStationsChanged();
        emit trackChanged();
    } else {
        if (m_position > 5) {
            m_position = 0;
        } else {
            m_currentIndex = (m_currentIndex - 1 + m_playlist.size()) % m_playlist.size();
            m_position = 0;
        }
        emit trackChanged();
        emit positionChanged();
        emit playlistChanged();
    }
}

void MediaService::updatePosition()
{
    if (!isRadioMode() && m_position < duration()) {
        m_position++;
        emit positionChanged();
    } else if (!isRadioMode()) {
        if (m_repeatEnabled) {
            m_position = 0;
            emit positionChanged();
        } else {
            next();
        }
    }
}
