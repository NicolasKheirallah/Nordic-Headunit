/****************************************************************************
** Meta object code from reading C++ file 'IVehicleHAL.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/HAL/IVehicleHAL.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'IVehicleHAL.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN11IVehicleHALE_t {};
} // unnamed namespace

template <> constexpr inline auto IVehicleHAL::qt_create_metaobjectdata<qt_meta_tag_ZN11IVehicleHALE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "IVehicleHAL",
        "speedChanged",
        "",
        "speed",
        "gearChanged",
        "gear",
        "outsideTempChanged",
        "temp",
        "batteryLevelChanged",
        "level",
        "rangeChanged",
        "range",
        "driverTempChanged",
        "passengerTempChanged",
        "fanSpeedChanged",
        "leftSeatHeatChanged",
        "on",
        "rightSeatHeatChanged",
        "errorOccurred",
        "message",
        "connectionStateChanged",
        "IVehicleHAL::ConnectionState",
        "state",
        "ConnectionState",
        "Disconnected",
        "Connecting",
        "Connected",
        "Error"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'speedChanged'
        QtMocHelpers::SignalData<void(int)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 },
        }}),
        // Signal 'gearChanged'
        QtMocHelpers::SignalData<void(QString)>(4, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 5 },
        }}),
        // Signal 'outsideTempChanged'
        QtMocHelpers::SignalData<void(double)>(6, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Double, 7 },
        }}),
        // Signal 'batteryLevelChanged'
        QtMocHelpers::SignalData<void(int)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 9 },
        }}),
        // Signal 'rangeChanged'
        QtMocHelpers::SignalData<void(int)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 11 },
        }}),
        // Signal 'driverTempChanged'
        QtMocHelpers::SignalData<void(int)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 7 },
        }}),
        // Signal 'passengerTempChanged'
        QtMocHelpers::SignalData<void(int)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 7 },
        }}),
        // Signal 'fanSpeedChanged'
        QtMocHelpers::SignalData<void(int)>(14, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 },
        }}),
        // Signal 'leftSeatHeatChanged'
        QtMocHelpers::SignalData<void(bool)>(15, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'rightSeatHeatChanged'
        QtMocHelpers::SignalData<void(bool)>(17, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(const QString &)>(18, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 19 },
        }}),
        // Signal 'connectionStateChanged'
        QtMocHelpers::SignalData<void(IVehicleHAL::ConnectionState)>(20, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 21, 22 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
        // enum 'ConnectionState'
        QtMocHelpers::EnumData<enum ConnectionState>(23, 23, QMC::EnumFlags{}).add({
            {   24, ConnectionState::Disconnected },
            {   25, ConnectionState::Connecting },
            {   26, ConnectionState::Connected },
            {   27, ConnectionState::Error },
        }),
    };
    return QtMocHelpers::metaObjectData<IVehicleHAL, qt_meta_tag_ZN11IVehicleHALE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject IVehicleHAL::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11IVehicleHALE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11IVehicleHALE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN11IVehicleHALE_t>.metaTypes,
    nullptr
} };

void IVehicleHAL::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<IVehicleHAL *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->speedChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 1: _t->gearChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 2: _t->outsideTempChanged((*reinterpret_cast< std::add_pointer_t<double>>(_a[1]))); break;
        case 3: _t->batteryLevelChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 4: _t->rangeChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 5: _t->driverTempChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 6: _t->passengerTempChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 7: _t->fanSpeedChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 8: _t->leftSeatHeatChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 9: _t->rightSeatHeatChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 10: _t->errorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 11: _t->connectionStateChanged((*reinterpret_cast< std::add_pointer_t<IVehicleHAL::ConnectionState>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(int )>(_a, &IVehicleHAL::speedChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(QString )>(_a, &IVehicleHAL::gearChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(double )>(_a, &IVehicleHAL::outsideTempChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(int )>(_a, &IVehicleHAL::batteryLevelChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(int )>(_a, &IVehicleHAL::rangeChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(int )>(_a, &IVehicleHAL::driverTempChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(int )>(_a, &IVehicleHAL::passengerTempChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(int )>(_a, &IVehicleHAL::fanSpeedChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(bool )>(_a, &IVehicleHAL::leftSeatHeatChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(bool )>(_a, &IVehicleHAL::rightSeatHeatChanged, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(const QString & )>(_a, &IVehicleHAL::errorOccurred, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (IVehicleHAL::*)(IVehicleHAL::ConnectionState )>(_a, &IVehicleHAL::connectionStateChanged, 11))
            return;
    }
}

const QMetaObject *IVehicleHAL::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *IVehicleHAL::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11IVehicleHALE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int IVehicleHAL::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 12;
    }
    return _id;
}

// SIGNAL 0
void IVehicleHAL::speedChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void IVehicleHAL::gearChanged(QString _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void IVehicleHAL::outsideTempChanged(double _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void IVehicleHAL::batteryLevelChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void IVehicleHAL::rangeChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1);
}

// SIGNAL 5
void IVehicleHAL::driverTempChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1);
}

// SIGNAL 6
void IVehicleHAL::passengerTempChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void IVehicleHAL::fanSpeedChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}

// SIGNAL 8
void IVehicleHAL::leftSeatHeatChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1);
}

// SIGNAL 9
void IVehicleHAL::rightSeatHeatChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 9, nullptr, _t1);
}

// SIGNAL 10
void IVehicleHAL::errorOccurred(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 10, nullptr, _t1);
}

// SIGNAL 11
void IVehicleHAL::connectionStateChanged(IVehicleHAL::ConnectionState _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 11, nullptr, _t1);
}
QT_WARNING_POP
