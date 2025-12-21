#include "SimulatedAudioHAL.h"
#include <QDebug>
#include <QTimer>

Q_LOGGING_CATEGORY(vcAudioHAL, "nordic.audio.hal")

SimulatedAudioHAL::SimulatedAudioHAL(QObject *parent)
    : IAudioHAL(parent)
    , m_volume(50)
    , m_bass(0)
    , m_mid(0)
    , m_treble(0)
    , m_faderX(0.0)
    , m_faderY(0.0)
{
    // Simulate async startup
    QTimer::singleShot(100, this, [this](){
        fetchData();
    });
}

void SimulatedAudioHAL::fetchData()
{
    QMutexLocker locker(&m_mutex);
    // Sync UI with internal state
    emit masterVolumeChanged(m_volume);
    
    // Emit others if needed, for now just log
    qCInfo(vcAudioHAL) << "Audio HAL Synced. Volume:" << m_volume;
}

void SimulatedAudioHAL::setMasterVolume(int volume) {
    QMutexLocker locker(&m_mutex);
    if (m_volume == volume) return;
    m_volume = volume;
    qCInfo(vcAudioHAL) << "Setting Master Volume:" << m_volume;
    emit masterVolumeChanged(m_volume);
}

void SimulatedAudioHAL::setEqBass(int level) {
    QMutexLocker locker(&m_mutex);
    if (m_bass == level) return;
    m_bass = level;
    qCInfo(vcAudioHAL) << "Setting EQ Bass:" << m_bass;
}

void SimulatedAudioHAL::setEqMid(int level) {
    QMutexLocker locker(&m_mutex);
    if (m_mid == level) return;
    m_mid = level;
    qCInfo(vcAudioHAL) << "Setting EQ Mid:" << m_mid;
}

void SimulatedAudioHAL::setEqTreble(int level) {
    QMutexLocker locker(&m_mutex);
    if (m_treble == level) return;
    m_treble = level;
    qCInfo(vcAudioHAL) << "Setting EQ Treble:" << m_treble;
}

void SimulatedAudioHAL::setFaderX(double x) {
    QMutexLocker locker(&m_mutex);
    if (qFuzzyCompare(m_faderX, x)) return;
    m_faderX = x;
    qCInfo(vcAudioHAL) << "Setting Fader X:" << m_faderX;
}

void SimulatedAudioHAL::setFaderY(double y) {
    QMutexLocker locker(&m_mutex);
    if (qFuzzyCompare(m_faderY, y)) return;
    m_faderY = y;
    qCInfo(vcAudioHAL) << "Setting Fader Y:" << m_faderY;
}

int SimulatedAudioHAL::getMasterVolume() const {
    QMutexLocker locker(&m_mutex);
    return m_volume;
}
