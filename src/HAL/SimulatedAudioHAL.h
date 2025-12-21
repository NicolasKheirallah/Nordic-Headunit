#ifndef SIMULATEDAUDIOHAL_H
#define SIMULATEDAUDIOHAL_H

#include "IAudioHAL.h"
#include <QMutex>

class SimulatedAudioHAL : public IAudioHAL
{
    Q_OBJECT

public:
    explicit SimulatedAudioHAL(QObject *parent = nullptr);
    
    void setMasterVolume(int volume) override;
    void setEqBass(int level) override;
    void setEqMid(int level) override;
    void setEqTreble(int level) override;
    void setFaderX(double x) override;
    void setFaderY(double y) override;
    
    int getMasterVolume() const override;
    
    // IAudioHAL Control
    void fetchData() override;

private:
    mutable QMutex m_mutex;
    int m_volume;
    int m_bass;
    int m_mid;
    int m_treble;
    double m_faderX;
    double m_faderY;
};

#endif // SIMULATEDAUDIOHAL_H
