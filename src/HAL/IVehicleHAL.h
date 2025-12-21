#ifndef IVEHICLEHAL_H
#define IVEHICLEHAL_H

#include <QObject>
#include <QLoggingCategory>

/**
 * @brief Abstract Interface for Vehicle Hardware Abstraction Layer.
 * 
 * Defines the contract for interacting with vehicle hardware (CAN Bus, ECU, etc.).
 * Implementations can be Real (hardware bindings) or Simulated (random data).
 */
class IVehicleHAL : public QObject
{
    Q_OBJECT

public:
    explicit IVehicleHAL(QObject *parent = nullptr) : QObject(parent) {}
    virtual ~IVehicleHAL() = default;

    // --- Connection State ---
    enum ConnectionState {
        Disconnected,
        Connecting,
        Connected,
        Error
    };
    Q_ENUM(ConnectionState)

    // --- Getters ---
    virtual int getSpeed() const = 0;
    virtual QString getGear() const = 0;
    virtual double getOutsideTemp() const = 0;
    virtual int getBatteryLevel() const = 0;
    virtual int getRange() const = 0;

    // --- Control Setters ---
    virtual void setDriverTemp(int temp) = 0;
    virtual void setPassengerTemp(int temp) = 0;
    virtual void setFanSpeed(int speed) = 0;
    virtual void setLeftSeatHeat(bool on) = 0;
    virtual void setRightSeatHeat(bool on) = 0;

    // --- Synchronization ---
    virtual void fetchData() = 0;

signals:
    // --- Data Update Signals ---
    void speedChanged(int speed);
    void gearChanged(QString gear);
    void outsideTempChanged(double temp);
    void batteryLevelChanged(int level);
    void rangeChanged(int range);
    
    // --- State Feedback Signals (Optional, if hardware changes autonomously) ---
    void driverTempChanged(int temp);
    void passengerTempChanged(int temp);
    void fanSpeedChanged(int speed);
    void leftSeatHeatChanged(bool on);
    void rightSeatHeatChanged(bool on);
    
    // --- System Signals ---
    void errorOccurred(const QString &message);
    void connectionStateChanged(IVehicleHAL::ConnectionState state);
};

Q_DECLARE_LOGGING_CATEGORY(vcVehicleHAL)

#endif // IVEHICLEHAL_H
