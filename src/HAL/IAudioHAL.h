#ifndef IAUDIOHAL_H
#define IAUDIOHAL_H

#include <QObject>
#include <QLoggingCategory>

/**
 * @brief Abstract Interface for Audio Hardware Abstraction Layer.
 * 
 * Controls DSP, Amplifier, and System Volume.
 */
class IAudioHAL : public QObject
{
    Q_OBJECT

public:
    explicit IAudioHAL(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~IAudioHAL() = default;

    // --- Control Setters ---
    virtual void setMasterVolume(int volume) = 0;
    virtual void setEqBass(int level) = 0;
    virtual void setEqMid(int level) = 0;
    virtual void setEqTreble(int level) = 0;
    virtual void setFaderX(double x) = 0;
    virtual void setFaderY(double y) = 0;
    
    // --- Getters (Optional, for sync) ---
    virtual int getMasterVolume() const = 0;

    // --- Synchronization ---
    virtual void fetchData() = 0;
    
signals:
    // --- Feedback Signals (if hardware changes externally) ---
    void masterVolumeChanged(int volume);
    
    // --- System Signals ---
    void errorOccurred(const QString &message);
};

Q_DECLARE_LOGGING_CATEGORY(vcAudioHAL)

#endif // IAUDIOHAL_H
