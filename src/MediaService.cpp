#include "MediaService.h"
#include <QUrl>
#include <QStandardPaths>
#include <QFileInfo>
#include <QDateTime>
#include <QDebug>

MediaService::MediaService(QObject *parent)
    : QObject(parent),
      m_currentSource("Bluetooth"),
      m_currentIndex(0),
      m_shuffleEnabled(false),
      m_repeatEnabled(false),
      m_isSimulating(false),
      m_isConnected(true),
      m_isLoading(false)
{
    // COMPONENTS
    m_player = new QMediaPlayer(this);
    m_audioOutput = new QAudioOutput(this);
    m_player->setAudioOutput(m_audioOutput);
    m_audioOutput->setVolume(1.0);
    
    m_radioTuner = new RadioTuner(this);
    m_mediaLibrary = new MediaLibrary(this);

    // SIGNALS - PLAYER
    connect(m_player, &QMediaPlayer::positionChanged, this, &MediaService::onMPlayerPositionChanged);
    connect(m_player, &QMediaPlayer::durationChanged, this, &MediaService::onMPlayerDurationChanged);
    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, &MediaService::onMPlayerStatusChanged);
    connect(m_player, &QMediaPlayer::errorOccurred, this, [this](QMediaPlayer::Error, const QString &errorString){
        qWarning() << "Media Error:" << errorString;
        emit errorChanged();
    });

    // SIGNALS - TUNER
    connect(m_radioTuner, &RadioTuner::frequencyChanged, this, &MediaService::onRadioFrequencyChanged);
    connect(m_radioTuner, &RadioTuner::stationNameChanged, this, &MediaService::onRadioFrequencyChanged);
    connect(m_radioTuner, &RadioTuner::bandChanged, this, &MediaService::onRadioFrequencyChanged);

    // SIGNALS - LIBRARY
    connect(m_mediaLibrary, &MediaLibrary::libraryUpdated, this, &MediaService::onLibraryUpdated);

    // SIMULATION
    m_simTimer = new QTimer(this);
    m_simTimer->setInterval(100);
    connect(m_simTimer, &QTimer::timeout, this, &MediaService::updateSimulation);
    m_simPos = 0;
    m_simDur = 0;
}

// =============================================================================
// GETTERS
// =============================================================================
RadioTuner* MediaService::radio() const { return m_radioTuner; }
MediaLibrary* MediaService::library() const { return m_mediaLibrary; }

QString MediaService::title() const {
    if (isRadioMode()) return m_radioTuner->stationName().isEmpty() ? ("FM " + radioFrequency()) : m_radioTuner->stationName();
    Track t = m_mediaLibrary->model()->getTrack(m_currentIndex);
    return t.title.isEmpty() ? "Not Playing" : t.title;
}

QString MediaService::artist() const {
    if (isRadioMode()) return radioFrequency() + " MHz";
    Track t = m_mediaLibrary->model()->getTrack(m_currentIndex);
    return t.artist.isEmpty() ? "" : t.artist;
}

QString MediaService::coverSource() const {
    if (isRadioMode()) return "qrc:/qt/qml/NordicHeadunit/assets/icons/radio-tower.svg";
    return m_mediaLibrary->model()->getTrack(m_currentIndex).coverUrl;
}

bool MediaService::playing() const {
    if (isRadioMode()) return true; // Radio always "playing" if active
    if (m_isSimulating) return m_simTimer->isActive();
    return m_player->playbackState() == QMediaPlayer::PlayingState;
}

qint64 MediaService::position() const {
    if (isRadioMode()) return 0;
    if (m_isSimulating) return m_simPos / 1000;
    return m_player->position() / 1000;
}

qint64 MediaService::duration() const {
    if (isRadioMode()) return 0;
    if (m_isSimulating) return m_simDur / 1000;
    return m_player->duration() / 1000;
}

double MediaService::progress() const {
    if (duration() == 0) return 0;
    return (double)position() / duration();
}

bool MediaService::shuffleEnabled() const { return m_shuffleEnabled; }
bool MediaService::repeatEnabled() const { return m_repeatEnabled; }
QString MediaService::currentSource() const { return m_currentSource; }
bool MediaService::isRadioMode() const { return m_currentSource == "Radio"; }
bool MediaService::isConnected() const { return m_isConnected; }
bool MediaService::isLoading() const { return m_isLoading; }
bool MediaService::hasError() const { return !m_player->errorString().isEmpty(); }
QString MediaService::errorMessage() const { return m_player->errorString(); }

QVariantList MediaService::sources() const {
    QVariantList list;
    list.append(QVariantMap{{"name", "Radio"}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg"}, {"active", m_currentSource == "Radio"}, {"lastPlayed", ""}});
    list.append(QVariantMap{{"name", "Bluetooth"}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"}, {"active", m_currentSource == "Bluetooth"}, {"lastPlayed", ""}});
    list.append(QVariantMap{{"name", "USB"}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"}, {"active", m_currentSource == "USB"}, {"lastPlayed", ""}});
    return list;
}

// PROXIES
QString MediaService::radioFrequency() const { return m_radioTuner->frequencyString(); }
QString MediaService::radioName() const { return m_radioTuner->stationName(); }
int MediaService::currentRadioIndex() const { return m_radioTuner->model()->activeStationIndex(); }
int MediaService::currentBand() const { return (int)m_radioTuner->band(); }

QVariantList MediaService::recentItems() const {
    QVariantList list;
    // Real logic would pull specific recent items
    // Mock for now
    list.append(QVariantMap{{"title", "Blinding Lights"}, {"subtitle", "The Weeknd"}, {"type", "track"}, {"index", 0}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"}});
    list.append(QVariantMap{{"title", "Radio 1"}, {"subtitle", "101.5 FM"}, {"type", "station"}, {"index", 0}, {"icon", "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg"}});
    return list;
}

QVariantList MediaService::libraryCategories() const {
    QVariantList list;
    list.append(QVariantMap{{"name", "Liked Songs"}, {"count", "143 songs"}, {"color", "#00C896"}});
    list.append(QVariantMap{{"name", "Road Trip"}, {"count", "24 songs"}, {"color", "#E91E63"}});
    return list;
}


// =============================================================================
// SETTERS & CONTROLS
// =============================================================================

void MediaService::setShuffleEnabled(bool enabled) {
    if (m_shuffleEnabled == enabled) return;
    m_shuffleEnabled = enabled;
    emit shuffleEnabledChanged();
}

void MediaService::setRepeatEnabled(bool enabled) {
    if (m_repeatEnabled == enabled) return;
    m_repeatEnabled = enabled;
    emit repeatEnabledChanged();
}

void MediaService::setCurrentSource(const QString &source) {
    if (m_currentSource == source) return;

    // Stop current
    if (isRadioMode()) stopRadio();
    else {
        m_player->stop();
        stopSimulation();
        m_lastIndex[m_currentSource] = m_currentIndex;
        m_lastPos[m_currentSource] = position();
    }

    m_currentSource = source;

    // Restore new
    if (isRadioMode()) {
        playRadio();
    } else {
        // Restore State
        m_currentIndex = m_lastIndex.value(source, 0);
        qint64 pos = m_lastPos.value(source, 0);
        playTrack(m_currentIndex); // Logic needs to respect pause usage?
        // Actually, just loading the track don't auto play unless it was playing? 
        // For simplicity: auto play
    }
    
    emit currentSourceChanged();
    emit sourcesChanged();
    emit trackChanged();
}

void MediaService::setBand(int band) { m_radioTuner->setBand(static_cast<RadioTuner::Band>(band)); }

void MediaService::play() {
    if (isRadioMode()) return; // Radio is "live"
    if (m_isSimulating) {
        m_simTimer->start();
        emit playingChanged(true);
    } else {
        m_player->play();
    }
}

void MediaService::pause() {
    if (isRadioMode()) return;
    if (m_isSimulating) {
        m_simTimer->stop();
        emit playingChanged(false);
    } else {
        m_player->pause();
    }
}

void MediaService::togglePlayPause() {
    if (isRadioMode()) {
        // Mute?
    } else {
        if (playing()) pause(); else play();
    }
}

void MediaService::setPlaying(bool playing) { if (playing) play(); else pause(); }

void MediaService::next() {
    if (isRadioMode()) {
        tuneStep(0.1); // Basic implementation
    } else {
        int nextIndex = (m_currentIndex + 1) % m_mediaLibrary->model()->rowCount();
        playTrack(nextIndex);
    }
}

void MediaService::previous() {
    if (isRadioMode()) {
        tuneStep(-0.1);
    } else {
        int prevIndex = (m_currentIndex - 1 + m_mediaLibrary->model()->rowCount()) % m_mediaLibrary->model()->rowCount();
        playTrack(prevIndex);
    }
}

void MediaService::seek(qint64 position) {
    if (!isRadioMode() && !m_isSimulating) m_player->setPosition(position * 1000);
}

void MediaService::setSource(const QString &source) { setCurrentSource(source); }

void MediaService::playTrack(int index) {
    if (index < 0 || index >= m_mediaLibrary->model()->rowCount()) return;
    
    Track t = m_mediaLibrary->model()->getTrack(index);
    m_currentIndex = index;
    
    playFile(t.sourceUrl);
    
    // Simulate duration if direct file
    if (t.duration == 0) t.duration = 180; // Minimal fake
    if (m_isSimulating) startSimulation(t.duration * 1000);
}

void MediaService::playFile(const QString &url) {
    QString playUrl = url;
    if (playUrl.startsWith("qrc:/")) playUrl.replace("qrc:/", ":/");
    
    // Check if file, else sim
    if (!QFile::exists(playUrl) && !QFile::exists(url)) {
        m_isSimulating = true;
    } else {
        m_isSimulating = false;
        m_player->setSource(QUrl::fromUserInput(url));
        m_player->play();
    }
    emit trackChanged();
}

void MediaService::playFromRecent(int index) {
    // Basic impl
    setCurrentSource("USB");
    playTrack(index);
}

// RADIO PROXIES
void MediaService::tuneRadioByIndex(int index) {
    if (isRadioMode()) m_radioTuner->tuneToPreset(index);
    else {
        setCurrentSource("Radio");
        m_radioTuner->tuneToPreset(index);
    }
}
void MediaService::tuneStep(double step) {
    if (step > 0) m_radioTuner->stepUp(); else m_radioTuner->stepDown();
}
void MediaService::seekForward() { m_radioTuner->seekUp(); }
void MediaService::seekBackward() { m_radioTuner->seekDown(); }
void MediaService::scanRadioStations() { m_radioTuner->scan(); }
bool MediaService::saveCurrentToPreset() { m_radioTuner->savePreset(); return true; }

// LIBRARY PROXIES
void MediaService::toggleLike() {
    m_mediaLibrary->toggleLike(m_currentIndex);
    emit trackChanged(); // Force UI update
}

bool MediaService::isLiked() const {
    return m_mediaLibrary->isLiked(m_currentIndex);
}

// INTERNAL SLOT HANDLERS
void MediaService::onRadioFrequencyChanged() {
    emit radioChanged();
    if (isRadioMode()) emit trackChanged(); // Update title/artist
}

void MediaService::onLibraryUpdated() {
    emit sourcesChanged(); // Maybe count changed?
}

void MediaService::onMPlayerPositionChanged(qint64) { emit positionChanged(); }
void MediaService::onMPlayerDurationChanged(qint64) { emit trackChanged(); }
void MediaService::onMPlayerStatusChanged(QMediaPlayer::MediaStatus status) {
    if (status == QMediaPlayer::EndOfMedia) next();
    emit playingChanged(playing()); 
}

// SIMULATION
void MediaService::startSimulation(qint64 dur) {
    m_simDur = dur;
    m_simPos = 0;
    m_simTimer->start();
    emit playingChanged(true);
}

void MediaService::stopSimulation() {
    m_isSimulating = false;
    m_simTimer->stop();
    emit playingChanged(false);
}

void MediaService::updateSimulation() {
    if (!m_isSimulating) return;
    m_simPos += 100;
    if (m_simPos >= m_simDur) {
        if (m_repeatEnabled) m_simPos = 0;
        else next();
    }
    emit positionChanged();
}

void MediaService::playRadio() {
    // In real hardware, unmute tuner
    // Here, just emit
}

void MediaService::stopRadio() {
    // Mute tuner
}

// =============================================================================
// ADVANCED PLAYBACK FEATURES
// =============================================================================

void MediaService::setPlaybackSpeed(double speed) {
    if (qFuzzyCompare(m_playbackSpeed, speed)) return;
    m_playbackSpeed = qBound(0.5, speed, 2.0);
    m_player->setPlaybackRate(m_playbackSpeed);
    emit playbackSpeedChanged();
}

void MediaService::setCrossfadeDuration(int seconds) {
    if (m_crossfadeDuration == seconds) return;
    m_crossfadeDuration = qBound(0, seconds, 12);
    emit crossfadeDurationChanged();
}

void MediaService::setGaplessEnabled(bool enabled) {
    if (m_gaplessEnabled == enabled) return;
    m_gaplessEnabled = enabled;
    emit gaplessEnabledChanged();
}

void MediaService::setSleepTimerMinutes(int minutes) {
    m_sleepTimerMinutes = qBound(0, minutes, 120);
    
    if (!m_sleepTimer) {
        m_sleepTimer = new QTimer(this);
        m_sleepTimer->setSingleShot(true);
        connect(m_sleepTimer, &QTimer::timeout, this, [this]() {
            pause();
            m_sleepTimerMinutes = 0;
            emit sleepTimerChanged();
        });
    }
    
    if (m_sleepTimerMinutes > 0) {
        m_sleepTimerEnd = QDateTime::currentDateTime().addSecs(m_sleepTimerMinutes * 60);
        m_sleepTimer->start(m_sleepTimerMinutes * 60 * 1000);
    } else {
        m_sleepTimer->stop();
    }
    emit sleepTimerChanged();
}

int MediaService::sleepTimerRemaining() const {
    if (!m_sleepTimerMinutes || m_sleepTimerEnd.isNull()) return 0;
    int remaining = QDateTime::currentDateTime().secsTo(m_sleepTimerEnd) / 60;
    return qMax(0, remaining);
}

void MediaService::cancelSleepTimer() {
    setSleepTimerMinutes(0);
}

// =============================================================================
// EQ FEATURES
// =============================================================================

void MediaService::setBassLevel(int level) {
    if (m_bassLevel == level) return;
    m_bassLevel = qBound(-10, level, 10);
    // Real implementation would apply EQ via audio framework
    emit eqChanged();
}

void MediaService::setTrebleLevel(int level) {
    if (m_trebleLevel == level) return;
    m_trebleLevel = qBound(-10, level, 10);
    emit eqChanged();
}

void MediaService::setBalanceLevel(int level) {
    if (m_balanceLevel == level) return;
    m_balanceLevel = qBound(-10, level, 10);
    // In real implementation: m_audioOutput->setBalance(...)
    emit eqChanged();
}
