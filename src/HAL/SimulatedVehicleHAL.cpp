#include "SimulatedVehicleHAL.h"
#include <QRandomGenerator>
#include <QDebug>

Q_LOGGING_CATEGORY(vcVehicleHAL, "nordic.vehicle.hal")

SimulatedVehicleHAL::SimulatedVehicleHAL(QObject *parent)
    : IVehicleHAL(parent)
    , m_speed(0)
    , m_gear("P")
    , m_outsideTemp(20.5)
    , m_batteryLevel(85)
    , m_range(320)
    , m_driverTemp(21)
    , m_passengerTemp(21)
    , m_fanSpeed(3)
    , m_leftSeatHeat(false)
    , m_rightSeatHeat(false)
{
    m_simulationTimer = new QTimer(this);
    connect(m_simulationTimer, &QTimer::timeout, this, &SimulatedVehicleHAL::simulateData);
    m_simulationTimer->start(2000); // Update every 2 seconds
    
    // Simulate initial connection
    QTimer::singleShot(100, this, [this](){
        emit connectionStateChanged(Connected);
        qCInfo(vcVehicleHAL) << "Simulated Vehicle HAL Connected";
        fetchData();
    });
}

void SimulatedVehicleHAL::fetchData() 
{
    QMutexLocker locker(&m_mutex);
    // In a real HAL, this would poll hardware.
    // For simulation, we just emit current state to ensure UI is synced.
    emit speedChanged(m_speed);
    emit gearChanged(m_gear);
    emit outsideTempChanged(m_outsideTemp);
    emit batteryLevelChanged(m_batteryLevel);
    emit rangeChanged(m_range);
    emit driverTempChanged(m_driverTemp);
    emit passengerTempChanged(m_passengerTemp);
    qCInfo(vcVehicleHAL) << "Data fetched/synced";
}

// -----------------------------------------------------------------------------
// Getters
// -----------------------------------------------------------------------------

int SimulatedVehicleHAL::getSpeed() const { QMutexLocker locker(&m_mutex); return m_speed; }
QString SimulatedVehicleHAL::getGear() const { QMutexLocker locker(&m_mutex); return m_gear; }
double SimulatedVehicleHAL::getOutsideTemp() const { QMutexLocker locker(&m_mutex); return m_outsideTemp; }
int SimulatedVehicleHAL::getBatteryLevel() const { QMutexLocker locker(&m_mutex); return m_batteryLevel; }
int SimulatedVehicleHAL::getRange() const { QMutexLocker locker(&m_mutex); return m_range; }

// -----------------------------------------------------------------------------
// Setters - Simulate Hardware Response
// -----------------------------------------------------------------------------

void SimulatedVehicleHAL::setDriverTemp(int temp) {
    QMutexLocker locker(&m_mutex);
    if (m_driverTemp == temp) return;
    m_driverTemp = temp;
    emit driverTempChanged(m_driverTemp);
}

void SimulatedVehicleHAL::setPassengerTemp(int temp) {
    QMutexLocker locker(&m_mutex);
    if (m_passengerTemp == temp) return;
    m_passengerTemp = temp;
    emit passengerTempChanged(m_passengerTemp);
}

void SimulatedVehicleHAL::setFanSpeed(int speed) {
    QMutexLocker locker(&m_mutex);
    if (m_fanSpeed == speed) return;
    m_fanSpeed = speed;
    emit fanSpeedChanged(m_fanSpeed);
}

void SimulatedVehicleHAL::setLeftSeatHeat(bool on) {
    QMutexLocker locker(&m_mutex);
    if (m_leftSeatHeat == on) return;
    m_leftSeatHeat = on;
    emit leftSeatHeatChanged(m_leftSeatHeat);
}

void SimulatedVehicleHAL::setRightSeatHeat(bool on) {
    QMutexLocker locker(&m_mutex);
    if (m_rightSeatHeat == on) return;
    m_rightSeatHeat = on;
    emit rightSeatHeatChanged(m_rightSeatHeat);
}

// -----------------------------------------------------------------------------
// Simulation Logic
// -----------------------------------------------------------------------------

void SimulatedVehicleHAL::simulateData()
{
    QMutexLocker locker(&m_mutex);
    // Simulate Speed Fluctuation
    int speedDelta = QRandomGenerator::global()->bounded(-5, 6);
    int newSpeed = qBound(0, m_speed + speedDelta, 180);
    
    if (newSpeed != m_speed) {
        m_speed = newSpeed;
        emit speedChanged(m_speed);
        
        // Update Gear based on speed
        QString newGear = (m_speed == 0) ? "P" : "D";
        if (newGear != m_gear) {
            m_gear = newGear;
            emit gearChanged(m_gear);
        }
    }

    // Simulate Temp Fluctuation
    double tempDelta = (QRandomGenerator::global()->bounded(10) - 5) / 10.0;
    m_outsideTemp += tempDelta;
    emit outsideTempChanged(m_outsideTemp);
    
    // Simulate Battery Drain
    if (QRandomGenerator::global()->bounded(100) < 5) { // 5% chance to drop
        m_batteryLevel = qBound(0, m_batteryLevel - 1, 100);
        emit batteryLevelChanged(m_batteryLevel);
        
        m_range = m_batteryLevel * 4; // Approx 4km per %
        emit rangeChanged(m_range);
    }
}
