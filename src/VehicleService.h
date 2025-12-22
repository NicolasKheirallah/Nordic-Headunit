#ifndef VEHICLESERVICE_H
#define VEHICLESERVICE_H

#include <QObject>
#include <QVariantList>
#include "HAL/IVehicleHAL.h"

class VehicleService : public QObject
{
    Q_OBJECT
    
    // Basic vehicle data
    Q_PROPERTY(int speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(QString gear READ gear NOTIFY gearChanged)
    Q_PROPERTY(double outsideTemp READ outsideTemp NOTIFY outsideTempChanged)
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY batteryLevelChanged)
    Q_PROPERTY(int range READ range NOTIFY rangeChanged)
    
    // Climate Properties
    Q_PROPERTY(int driverTemp READ driverTemp WRITE setDriverTemp NOTIFY driverTempChanged)
    Q_PROPERTY(int passengerTemp READ passengerTemp WRITE setPassengerTemp NOTIFY passengerTempChanged)
    Q_PROPERTY(int fanSpeed READ fanSpeed WRITE setFanSpeed NOTIFY fanSpeedChanged)
    Q_PROPERTY(bool leftSeatHeat READ leftSeatHeat WRITE setLeftSeatHeat NOTIFY leftSeatHeatChanged)
    Q_PROPERTY(bool rightSeatHeat READ rightSeatHeat WRITE setRightSeatHeat NOTIFY rightSeatHeatChanged)
    Q_PROPERTY(bool leftSeatVentilation READ leftSeatVentilation WRITE setLeftSeatVentilation NOTIFY leftSeatVentilationChanged)
    Q_PROPERTY(bool rightSeatVentilation READ rightSeatVentilation WRITE setRightSeatVentilation NOTIFY rightSeatVentilationChanged)
    Q_PROPERTY(bool acEnabled READ acEnabled WRITE setAcEnabled NOTIFY acEnabledChanged)
    Q_PROPERTY(bool autoClimate READ autoClimate WRITE setAutoClimate NOTIFY autoClimateChanged)
    Q_PROPERTY(bool recircEnabled READ recircEnabled WRITE setRecircEnabled NOTIFY recircEnabledChanged)
    Q_PROPERTY(bool defrostEnabled READ defrostEnabled WRITE setDefrostEnabled NOTIFY defrostEnabledChanged)
    Q_PROPERTY(bool frontDefrostEnabled READ frontDefrostEnabled WRITE setFrontDefrostEnabled NOTIFY frontDefrostEnabledChanged)
    Q_PROPERTY(bool rearDefrostEnabled READ rearDefrostEnabled WRITE setRearDefrostEnabled NOTIFY rearDefrostEnabledChanged)
    
    // Door status (read-only)
    Q_PROPERTY(bool frontLeftDoorOpen READ frontLeftDoorOpen NOTIFY frontLeftDoorOpenChanged)
    Q_PROPERTY(bool frontRightDoorOpen READ frontRightDoorOpen NOTIFY frontRightDoorOpenChanged)
    Q_PROPERTY(bool rearLeftDoorOpen READ rearLeftDoorOpen NOTIFY rearLeftDoorOpenChanged)
    Q_PROPERTY(bool rearRightDoorOpen READ rearRightDoorOpen NOTIFY rearRightDoorOpenChanged)
    Q_PROPERTY(bool trunkOpen READ trunkOpen NOTIFY trunkOpenChanged)
    Q_PROPERTY(bool hoodOpen READ hoodOpen NOTIFY hoodOpenChanged)
    Q_PROPERTY(QString doorsStatus READ doorsStatus NOTIFY doorsStatusChanged)
    
    // Vehicle state (read-only for display)
    Q_PROPERTY(QString connectionState READ connectionState NOTIFY connectionStateChanged)
    Q_PROPERTY(QString ignitionState READ ignitionState NOTIFY ignitionStateChanged)
    Q_PROPERTY(QString lastUpdateTime READ lastUpdateTime NOTIFY lastUpdateTimeChanged)
    Q_PROPERTY(bool handbrakeEngaged READ handbrakeEngaged NOTIFY handbrakeEngagedChanged)
    Q_PROPERTY(QString batteryStatus READ batteryStatus NOTIFY batteryStatusChanged)
    
    // Tire pressure (read-only)
    Q_PROPERTY(double tirePressureFL READ tirePressureFL NOTIFY tirePressureChanged)
    Q_PROPERTY(double tirePressureFR READ tirePressureFR NOTIFY tirePressureChanged)
    Q_PROPERTY(double tirePressureRL READ tirePressureRL NOTIFY tirePressureChanged)
    Q_PROPERTY(double tirePressureRR READ tirePressureRR NOTIFY tirePressureChanged)
    Q_PROPERTY(bool tirePressureSupported READ tirePressureSupported CONSTANT)
    
    // Trip data (read-only)
    Q_PROPERTY(int tripDistance READ tripDistance NOTIFY tripDataChanged)
    Q_PROPERTY(int tripTime READ tripTime NOTIFY tripDataChanged)
    Q_PROPERTY(int avgSpeed READ avgSpeed NOTIFY tripDataChanged)
    Q_PROPERTY(double fuelConsumption READ fuelConsumption NOTIFY tripDataChanged)
    
    // Warnings (read-only)
    Q_PROPERTY(QVariantList warnings READ warnings NOTIFY warningsChanged)
    Q_PROPERTY(bool hasWarnings READ hasWarnings NOTIFY warningsChanged)
    
    // Legacy write properties (kept for bottom bar climate control)
    Q_PROPERTY(bool isLocked READ isLocked WRITE setIsLocked NOTIFY isLockedChanged)
    Q_PROPERTY(bool interiorLightOn READ interiorLightOn WRITE setInteriorLightOn NOTIFY interiorLightOnChanged)

public:
    explicit VehicleService(IVehicleHAL *hal, QObject *parent = nullptr);

    // Basic data
    int speed() const;
    QString gear() const;
    double outsideTemp() const;
    int batteryLevel() const;
    int range() const;
    
    // Climate
    int driverTemp() const;
    void setDriverTemp(int temp);
    int passengerTemp() const;
    void setPassengerTemp(int temp);
    int fanSpeed() const;
    void setFanSpeed(int speed);
    bool leftSeatHeat() const;
    void setLeftSeatHeat(bool on);
    bool rightSeatHeat() const;
    void setRightSeatHeat(bool on);
    bool leftSeatVentilation() const;
    void setLeftSeatVentilation(bool on);
    bool rightSeatVentilation() const;
    void setRightSeatVentilation(bool on);
    bool acEnabled() const;
    void setAcEnabled(bool on);
    bool autoClimate() const;
    void setAutoClimate(bool on);
    bool recircEnabled() const;
    void setRecircEnabled(bool on);
    bool defrostEnabled() const;
    void setDefrostEnabled(bool on);
    bool frontDefrostEnabled() const;
    void setFrontDefrostEnabled(bool on);
    bool rearDefrostEnabled() const;
    void setRearDefrostEnabled(bool on);
    
    // Door status
    bool frontLeftDoorOpen() const;
    bool frontRightDoorOpen() const;
    bool rearLeftDoorOpen() const;
    bool rearRightDoorOpen() const;
    bool trunkOpen() const;
    bool hoodOpen() const;
    QString doorsStatus() const;
    
    // Vehicle state
    QString connectionState() const;
    QString ignitionState() const;
    QString lastUpdateTime() const;
    bool handbrakeEngaged() const;
    QString batteryStatus() const;
    
    // Tire pressure
    double tirePressureFL() const;
    double tirePressureFR() const;
    double tirePressureRL() const;
    double tirePressureRR() const;
    bool tirePressureSupported() const;
    
    // Trip data
    int tripDistance() const;
    int tripTime() const;
    int avgSpeed() const;
    double fuelConsumption() const;
    
    // Warnings
    QVariantList warnings() const;
    bool hasWarnings() const;
    
    // Legacy
    bool isLocked() const;
    void setIsLocked(bool locked);
    bool interiorLightOn() const;
    void setInteriorLightOn(bool on);

signals:
    void speedChanged(int speed);
    void gearChanged(QString gear);
    void outsideTempChanged(double temp);
    void batteryLevelChanged(int level);
    void rangeChanged(int range);
    void driverTempChanged(int temp);
    void passengerTempChanged(int temp);
    void fanSpeedChanged(int speed);
    void leftSeatHeatChanged(bool on);
    void rightSeatHeatChanged(bool on);
    void leftSeatVentilationChanged(bool on);
    void rightSeatVentilationChanged(bool on);
    void acEnabledChanged(bool on);
    void autoClimateChanged(bool on);
    void recircEnabledChanged(bool on);
    void defrostEnabledChanged(bool on);
    void frontDefrostEnabledChanged(bool on);
    void rearDefrostEnabledChanged(bool on);
    void frontLeftDoorOpenChanged(bool open);
    void frontRightDoorOpenChanged(bool open);
    void rearLeftDoorOpenChanged(bool open);
    void rearRightDoorOpenChanged(bool open);
    void trunkOpenChanged(bool open);
    void hoodOpenChanged(bool open);
    void doorsStatusChanged();
    void connectionStateChanged();
    void ignitionStateChanged();
    void lastUpdateTimeChanged();
    void handbrakeEngagedChanged();
    void batteryStatusChanged();
    void tirePressureChanged();
    void tripDataChanged();
    void warningsChanged();
    void isLockedChanged(bool locked);
    void interiorLightOnChanged(bool on);

private:
    IVehicleHAL *m_hal;
    
    // Basic data cache
    int m_speed;
    QString m_gear;
    double m_outsideTemp;
    int m_batteryLevel;
    int m_range;
    
    // Climate cache
    int m_driverTemp;
    int m_passengerTemp;
    int m_fanSpeed;
    bool m_leftSeatHeat;
    bool m_rightSeatHeat;
    bool m_leftSeatVentilation;
    bool m_rightSeatVentilation;
    bool m_acEnabled;
    bool m_autoClimate;
    bool m_recircEnabled;
    bool m_defrostEnabled;
    bool m_frontDefrostEnabled;
    bool m_rearDefrostEnabled;
    
    // Door status
    bool m_frontLeftDoorOpen = false;
    bool m_frontRightDoorOpen = false;
    bool m_rearLeftDoorOpen = false;
    bool m_rearRightDoorOpen = false;
    bool m_trunkOpen = false;
    bool m_hoodOpen = false;
    
    // Vehicle state
    bool m_handbrakeEngaged = true;
    bool m_isLocked = true;
    bool m_interiorLightOn = false;
    
    // Tire pressure (mock values in bar)
    double m_tirePressureFL = 2.3;
    double m_tirePressureFR = 2.3;
    double m_tirePressureRL = 2.4;
    double m_tirePressureRR = 2.3;
    
    // Trip data (mock)
    int m_tripDistance = 42;
    int m_tripTime = 72;
    int m_avgSpeed = 52;
    double m_fuelConsumption = 17.4;
};

#endif // VEHICLESERVICE_H
