#ifndef SIMULATEDVEHICLEHAL_H
#define SIMULATEDVEHICLEHAL_H

#include "IVehicleHAL.h"
#include <QTimer>
#include <QMutex>

/**
 * @brief Simulated Implementation of Vehicle HAL.
 * 
 * Provides mock data for testing and development without real hardware.
 */
class SimulatedVehicleHAL : public IVehicleHAL
{
    Q_OBJECT

public:
    explicit SimulatedVehicleHAL(QObject *parent = nullptr);
    
    // IVehicleHAL Interface Impl
    int getSpeed() const override;
    QString getGear() const override;
    double getOutsideTemp() const override;
    int getBatteryLevel() const override;
    int getRange() const override;

    // IVehicleHAL Control
    void fetchData() override;

    void setDriverTemp(int temp) override;
    void setPassengerTemp(int temp) override;
    void setFanSpeed(int speed) override;
    void setLeftSeatHeat(bool on) override;
    void setRightSeatHeat(bool on) override;

private slots:
    void simulateData();

private:
    QTimer *m_simulationTimer;
    mutable QMutex m_mutex;
    
    int m_speed;
    QString m_gear;
    double m_outsideTemp;
    int m_batteryLevel;
    int m_range;
    
    int m_driverTemp;
    int m_passengerTemp;
    int m_fanSpeed;
    bool m_leftSeatHeat;
    bool m_rightSeatHeat;
};

#endif // SIMULATEDVEHICLEHAL_H
