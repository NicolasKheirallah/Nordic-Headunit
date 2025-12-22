#include "VehicleService.h"
#include <QDebug>
#include <QTime>

VehicleService::VehicleService(IVehicleHAL *hal, QObject *parent)
    : QObject(parent)
    , m_hal(hal)
    , m_speed(0)
    , m_gear("P")
    , m_outsideTemp(20.0)
    , m_batteryLevel(85)
    , m_range(336)
    , m_driverTemp(21)
    , m_passengerTemp(21)
    , m_fanSpeed(3)
    , m_leftSeatHeat(false)
    , m_rightSeatHeat(false)
    , m_acEnabled(false)
    , m_autoClimate(true)
    , m_recircEnabled(false)
    , m_defrostEnabled(false)
    , m_leftSeatVentilation(false)
    , m_rightSeatVentilation(false)
    , m_frontDefrostEnabled(false)
    , m_rearDefrostEnabled(false)
{
    if (!m_hal) {
        qWarning() << "VehicleService created with null HAL!";
        return;
    }

    // Connect HAL signals to internal cache & re-emit
    connect(m_hal, &IVehicleHAL::speedChanged, this, [this](int speed) {
        if (m_speed != speed) { m_speed = speed; emit speedChanged(m_speed); }
    });
    
    connect(m_hal, &IVehicleHAL::gearChanged, this, [this](QString gear) {
        if (m_gear != gear) { m_gear = gear; emit gearChanged(m_gear); }
    });

    connect(m_hal, &IVehicleHAL::outsideTempChanged, this, [this](double temp) {
        if (!qFuzzyCompare(m_outsideTemp, temp)) { m_outsideTemp = temp; emit outsideTempChanged(m_outsideTemp); }
    });

    connect(m_hal, &IVehicleHAL::batteryLevelChanged, this, [this](int level) {
        if (m_batteryLevel != level) { m_batteryLevel = level; emit batteryLevelChanged(m_batteryLevel); }
    });

    connect(m_hal, &IVehicleHAL::rangeChanged, this, [this](int range) {
        if (m_range != range) { m_range = range; emit rangeChanged(m_range); }
    });

    connect(m_hal, &IVehicleHAL::driverTempChanged, this, [this](int temp) {
        if (m_driverTemp != temp) { m_driverTemp = temp; emit driverTempChanged(m_driverTemp); }
    });
    
    connect(m_hal, &IVehicleHAL::passengerTempChanged, this, [this](int temp) {
        if (m_passengerTemp != temp) { m_passengerTemp = temp; emit passengerTempChanged(m_passengerTemp); }
    });

    connect(m_hal, &IVehicleHAL::fanSpeedChanged, this, [this](int speed) {
        if (m_fanSpeed != speed) { m_fanSpeed = speed; emit fanSpeedChanged(m_fanSpeed); }
    });
    
    connect(m_hal, &IVehicleHAL::leftSeatHeatChanged, this, [this](bool on) {
        if (m_leftSeatHeat != on) { m_leftSeatHeat = on; emit leftSeatHeatChanged(m_leftSeatHeat); }
    });
    
    connect(m_hal, &IVehicleHAL::rightSeatHeatChanged, this, [this](bool on) {
        if (m_rightSeatHeat != on) { m_rightSeatHeat = on; emit rightSeatHeatChanged(m_rightSeatHeat); }
    });
    
    // Initial fetch
    m_speed = m_hal->getSpeed();
    m_gear = m_hal->getGear();
    m_outsideTemp = m_hal->getOutsideTemp();
    m_batteryLevel = m_hal->getBatteryLevel();
    m_range = m_hal->getRange();
}

// Basic Data
int VehicleService::speed() const { return m_speed; }
QString VehicleService::gear() const { return m_gear; }
double VehicleService::outsideTemp() const { return m_outsideTemp; }
int VehicleService::batteryLevel() const { return m_batteryLevel; }
int VehicleService::range() const { return m_range; }

// Climate
int VehicleService::driverTemp() const { return m_driverTemp; }
int VehicleService::passengerTemp() const { return m_passengerTemp; }
int VehicleService::fanSpeed() const { return m_fanSpeed; }
bool VehicleService::leftSeatHeat() const { return m_leftSeatHeat; }
bool VehicleService::rightSeatHeat() const { return m_rightSeatHeat; }
bool VehicleService::leftSeatVentilation() const { return m_leftSeatVentilation; }
bool VehicleService::rightSeatVentilation() const { return m_rightSeatVentilation; }

void VehicleService::setDriverTemp(int temp) {
    if (m_driverTemp == temp) return;
    m_driverTemp = temp;
    emit driverTempChanged(m_driverTemp);
    if (m_hal) m_hal->setDriverTemp(temp);
}

void VehicleService::setPassengerTemp(int temp) {
    if (m_passengerTemp == temp) return;
    m_passengerTemp = temp;
    emit passengerTempChanged(m_passengerTemp);
    if (m_hal) m_hal->setPassengerTemp(temp);
}

void VehicleService::setFanSpeed(int speed) {
    if (m_fanSpeed == speed) return;
    m_fanSpeed = speed;
    emit fanSpeedChanged(m_fanSpeed);
    if (m_hal) m_hal->setFanSpeed(speed);
}

void VehicleService::setLeftSeatHeat(bool on) {
    if (m_leftSeatHeat == on) return;
    m_leftSeatHeat = on;
    emit leftSeatHeatChanged(m_leftSeatHeat);
    if (m_hal) m_hal->setLeftSeatHeat(on);
}

void VehicleService::setRightSeatHeat(bool on) {
    if (m_rightSeatHeat == on) return;
    m_rightSeatHeat = on;
    emit rightSeatHeatChanged(m_rightSeatHeat);
    if (m_hal) m_hal->setRightSeatHeat(on);
}

void VehicleService::setLeftSeatVentilation(bool on) {
    if (m_leftSeatVentilation == on) return;
    m_leftSeatVentilation = on;
    emit leftSeatVentilationChanged(m_leftSeatVentilation);
    // if (m_hal) m_hal->setLeftSeatVentilation(on); // Assuming HAL support or mock
}

void VehicleService::setRightSeatVentilation(bool on) {
    if (m_rightSeatVentilation == on) return;
    m_rightSeatVentilation = on;
    emit rightSeatVentilationChanged(m_rightSeatVentilation);
    // if (m_hal) m_hal->setRightSeatVentilation(on); // Assuming HAL support or mock
}

bool VehicleService::acEnabled() const { return m_acEnabled; }
void VehicleService::setAcEnabled(bool on) {
    if (m_acEnabled == on) return;
    m_acEnabled = on;
    emit acEnabledChanged(m_acEnabled);
}

bool VehicleService::autoClimate() const { return m_autoClimate; }
void VehicleService::setAutoClimate(bool on) {
    if (m_autoClimate == on) return;
    m_autoClimate = on;
    emit autoClimateChanged(m_autoClimate);
}

bool VehicleService::recircEnabled() const { return m_recircEnabled; }
void VehicleService::setRecircEnabled(bool on) {
    if (m_recircEnabled == on) return;
    m_recircEnabled = on;
    emit recircEnabledChanged(m_recircEnabled);
}

bool VehicleService::defrostEnabled() const { return m_defrostEnabled; }
void VehicleService::setDefrostEnabled(bool on) {
    if (m_defrostEnabled == on) return;
    m_defrostEnabled = on;
    emit defrostEnabledChanged(m_defrostEnabled);
}

bool VehicleService::frontDefrostEnabled() const { return m_frontDefrostEnabled; }
void VehicleService::setFrontDefrostEnabled(bool on) {
    if (m_frontDefrostEnabled == on) return;
    m_frontDefrostEnabled = on;
    emit frontDefrostEnabledChanged(m_frontDefrostEnabled);
}

bool VehicleService::rearDefrostEnabled() const { return m_rearDefrostEnabled; }
void VehicleService::setRearDefrostEnabled(bool on) {
    if (m_rearDefrostEnabled == on) return;
    m_rearDefrostEnabled = on;
    emit rearDefrostEnabledChanged(m_rearDefrostEnabled);
}

// Door Status
bool VehicleService::frontLeftDoorOpen() const { return m_frontLeftDoorOpen; }
bool VehicleService::frontRightDoorOpen() const { return m_frontRightDoorOpen; }
bool VehicleService::rearLeftDoorOpen() const { return m_rearLeftDoorOpen; }
bool VehicleService::rearRightDoorOpen() const { return m_rearRightDoorOpen; }
bool VehicleService::trunkOpen() const { return m_trunkOpen; }
bool VehicleService::hoodOpen() const { return m_hoodOpen; }

QString VehicleService::doorsStatus() const {
    if (m_frontLeftDoorOpen || m_frontRightDoorOpen || m_rearLeftDoorOpen || 
        m_rearRightDoorOpen || m_trunkOpen || m_hoodOpen) {
        QStringList openDoors;
        if (m_frontLeftDoorOpen) openDoors << "FL";
        if (m_frontRightDoorOpen) openDoors << "FR";
        if (m_rearLeftDoorOpen) openDoors << "RL";
        if (m_rearRightDoorOpen) openDoors << "RR";
        if (m_trunkOpen) openDoors << "Trunk";
        if (m_hoodOpen) openDoors << "Hood";
        return openDoors.join(", ") + " open";
    }
    return "All closed";
}

// Vehicle State
QString VehicleService::connectionState() const { return "Connected"; }
QString VehicleService::ignitionState() const { return m_speed > 0 ? "Running" : "Off"; }
QString VehicleService::lastUpdateTime() const { return QTime::currentTime().toString("HH:mm"); }
bool VehicleService::handbrakeEngaged() const { return m_handbrakeEngaged; }
QString VehicleService::batteryStatus() const { return m_batteryLevel > 20 ? "OK" : "Low"; }

// Tire Pressure
double VehicleService::tirePressureFL() const { return m_tirePressureFL; }
double VehicleService::tirePressureFR() const { return m_tirePressureFR; }
double VehicleService::tirePressureRL() const { return m_tirePressureRL; }
double VehicleService::tirePressureRR() const { return m_tirePressureRR; }
bool VehicleService::tirePressureSupported() const { return true; }

// Trip Data
int VehicleService::tripDistance() const { return m_tripDistance; }
int VehicleService::tripTime() const { return m_tripTime; }
int VehicleService::avgSpeed() const { return m_avgSpeed; }
double VehicleService::fuelConsumption() const { return m_fuelConsumption; }

// Warnings
QVariantList VehicleService::warnings() const {
    QVariantList list;
    
    // Mock warning
    QVariantMap warning1;
    warning1["message"] = "Low washer fluid";
    warning1["time"] = "Today 18:22";
    warning1["severity"] = "warning";
    list.append(warning1);
    
    return list;
}

bool VehicleService::hasWarnings() const { return warnings().size() > 0; }

// Legacy
bool VehicleService::isLocked() const { return m_isLocked; }
void VehicleService::setIsLocked(bool locked) {
    if (m_isLocked == locked) return;
    m_isLocked = locked;
    emit isLockedChanged(m_isLocked);
}

bool VehicleService::interiorLightOn() const { return m_interiorLightOn; }
void VehicleService::setInteriorLightOn(bool on) {
    if (m_interiorLightOn == on) return;
    m_interiorLightOn = on;
    emit interiorLightOnChanged(m_interiorLightOn);
}
