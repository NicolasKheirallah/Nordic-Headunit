/****************************************************************************
** Meta object code from reading C++ file 'VehicleService.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/VehicleService.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'VehicleService.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN14VehicleServiceE_t {};
} // unnamed namespace

template <> constexpr inline auto VehicleService::qt_create_metaobjectdata<qt_meta_tag_ZN14VehicleServiceE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "VehicleService",
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
        "leftSeatVentilationChanged",
        "rightSeatVentilationChanged",
        "acEnabledChanged",
        "autoClimateChanged",
        "recircEnabledChanged",
        "defrostEnabledChanged",
        "frontDefrostEnabledChanged",
        "rearDefrostEnabledChanged",
        "frontLeftDoorOpenChanged",
        "open",
        "frontRightDoorOpenChanged",
        "rearLeftDoorOpenChanged",
        "rearRightDoorOpenChanged",
        "trunkOpenChanged",
        "hoodOpenChanged",
        "doorsStatusChanged",
        "connectionStateChanged",
        "ignitionStateChanged",
        "lastUpdateTimeChanged",
        "handbrakeEngagedChanged",
        "batteryStatusChanged",
        "tirePressureChanged",
        "tripDataChanged",
        "warningsChanged",
        "isLockedChanged",
        "locked",
        "interiorLightOnChanged",
        "outsideTemp",
        "batteryLevel",
        "driverTemp",
        "passengerTemp",
        "fanSpeed",
        "leftSeatHeat",
        "rightSeatHeat",
        "leftSeatVentilation",
        "rightSeatVentilation",
        "acEnabled",
        "autoClimate",
        "recircEnabled",
        "defrostEnabled",
        "frontDefrostEnabled",
        "rearDefrostEnabled",
        "frontLeftDoorOpen",
        "frontRightDoorOpen",
        "rearLeftDoorOpen",
        "rearRightDoorOpen",
        "trunkOpen",
        "hoodOpen",
        "doorsStatus",
        "connectionState",
        "ignitionState",
        "lastUpdateTime",
        "handbrakeEngaged",
        "batteryStatus",
        "tirePressureFL",
        "tirePressureFR",
        "tirePressureRL",
        "tirePressureRR",
        "tirePressureSupported",
        "tripDistance",
        "tripTime",
        "avgSpeed",
        "fuelConsumption",
        "warnings",
        "QVariantList",
        "hasWarnings",
        "isLocked",
        "interiorLightOn"
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
        // Signal 'leftSeatVentilationChanged'
        QtMocHelpers::SignalData<void(bool)>(18, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'rightSeatVentilationChanged'
        QtMocHelpers::SignalData<void(bool)>(19, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'acEnabledChanged'
        QtMocHelpers::SignalData<void(bool)>(20, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'autoClimateChanged'
        QtMocHelpers::SignalData<void(bool)>(21, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'recircEnabledChanged'
        QtMocHelpers::SignalData<void(bool)>(22, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'defrostEnabledChanged'
        QtMocHelpers::SignalData<void(bool)>(23, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'frontDefrostEnabledChanged'
        QtMocHelpers::SignalData<void(bool)>(24, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'rearDefrostEnabledChanged'
        QtMocHelpers::SignalData<void(bool)>(25, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
        // Signal 'frontLeftDoorOpenChanged'
        QtMocHelpers::SignalData<void(bool)>(26, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 27 },
        }}),
        // Signal 'frontRightDoorOpenChanged'
        QtMocHelpers::SignalData<void(bool)>(28, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 27 },
        }}),
        // Signal 'rearLeftDoorOpenChanged'
        QtMocHelpers::SignalData<void(bool)>(29, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 27 },
        }}),
        // Signal 'rearRightDoorOpenChanged'
        QtMocHelpers::SignalData<void(bool)>(30, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 27 },
        }}),
        // Signal 'trunkOpenChanged'
        QtMocHelpers::SignalData<void(bool)>(31, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 27 },
        }}),
        // Signal 'hoodOpenChanged'
        QtMocHelpers::SignalData<void(bool)>(32, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 27 },
        }}),
        // Signal 'doorsStatusChanged'
        QtMocHelpers::SignalData<void()>(33, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'connectionStateChanged'
        QtMocHelpers::SignalData<void()>(34, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'ignitionStateChanged'
        QtMocHelpers::SignalData<void()>(35, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'lastUpdateTimeChanged'
        QtMocHelpers::SignalData<void()>(36, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'handbrakeEngagedChanged'
        QtMocHelpers::SignalData<void()>(37, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'batteryStatusChanged'
        QtMocHelpers::SignalData<void()>(38, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'tirePressureChanged'
        QtMocHelpers::SignalData<void()>(39, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'tripDataChanged'
        QtMocHelpers::SignalData<void()>(40, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'warningsChanged'
        QtMocHelpers::SignalData<void()>(41, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'isLockedChanged'
        QtMocHelpers::SignalData<void(bool)>(42, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 43 },
        }}),
        // Signal 'interiorLightOnChanged'
        QtMocHelpers::SignalData<void(bool)>(44, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 16 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'speed'
        QtMocHelpers::PropertyData<int>(3, QMetaType::Int, QMC::DefaultPropertyFlags, 0),
        // property 'gear'
        QtMocHelpers::PropertyData<QString>(5, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'outsideTemp'
        QtMocHelpers::PropertyData<double>(45, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'batteryLevel'
        QtMocHelpers::PropertyData<int>(46, QMetaType::Int, QMC::DefaultPropertyFlags, 3),
        // property 'range'
        QtMocHelpers::PropertyData<int>(11, QMetaType::Int, QMC::DefaultPropertyFlags, 4),
        // property 'driverTemp'
        QtMocHelpers::PropertyData<int>(47, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'passengerTemp'
        QtMocHelpers::PropertyData<int>(48, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 6),
        // property 'fanSpeed'
        QtMocHelpers::PropertyData<int>(49, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 7),
        // property 'leftSeatHeat'
        QtMocHelpers::PropertyData<bool>(50, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 8),
        // property 'rightSeatHeat'
        QtMocHelpers::PropertyData<bool>(51, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 9),
        // property 'leftSeatVentilation'
        QtMocHelpers::PropertyData<bool>(52, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 10),
        // property 'rightSeatVentilation'
        QtMocHelpers::PropertyData<bool>(53, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 11),
        // property 'acEnabled'
        QtMocHelpers::PropertyData<bool>(54, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 12),
        // property 'autoClimate'
        QtMocHelpers::PropertyData<bool>(55, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 13),
        // property 'recircEnabled'
        QtMocHelpers::PropertyData<bool>(56, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 14),
        // property 'defrostEnabled'
        QtMocHelpers::PropertyData<bool>(57, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 15),
        // property 'frontDefrostEnabled'
        QtMocHelpers::PropertyData<bool>(58, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 16),
        // property 'rearDefrostEnabled'
        QtMocHelpers::PropertyData<bool>(59, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 17),
        // property 'frontLeftDoorOpen'
        QtMocHelpers::PropertyData<bool>(60, QMetaType::Bool, QMC::DefaultPropertyFlags, 18),
        // property 'frontRightDoorOpen'
        QtMocHelpers::PropertyData<bool>(61, QMetaType::Bool, QMC::DefaultPropertyFlags, 19),
        // property 'rearLeftDoorOpen'
        QtMocHelpers::PropertyData<bool>(62, QMetaType::Bool, QMC::DefaultPropertyFlags, 20),
        // property 'rearRightDoorOpen'
        QtMocHelpers::PropertyData<bool>(63, QMetaType::Bool, QMC::DefaultPropertyFlags, 21),
        // property 'trunkOpen'
        QtMocHelpers::PropertyData<bool>(64, QMetaType::Bool, QMC::DefaultPropertyFlags, 22),
        // property 'hoodOpen'
        QtMocHelpers::PropertyData<bool>(65, QMetaType::Bool, QMC::DefaultPropertyFlags, 23),
        // property 'doorsStatus'
        QtMocHelpers::PropertyData<QString>(66, QMetaType::QString, QMC::DefaultPropertyFlags, 24),
        // property 'connectionState'
        QtMocHelpers::PropertyData<QString>(67, QMetaType::QString, QMC::DefaultPropertyFlags, 25),
        // property 'ignitionState'
        QtMocHelpers::PropertyData<QString>(68, QMetaType::QString, QMC::DefaultPropertyFlags, 26),
        // property 'lastUpdateTime'
        QtMocHelpers::PropertyData<QString>(69, QMetaType::QString, QMC::DefaultPropertyFlags, 27),
        // property 'handbrakeEngaged'
        QtMocHelpers::PropertyData<bool>(70, QMetaType::Bool, QMC::DefaultPropertyFlags, 28),
        // property 'batteryStatus'
        QtMocHelpers::PropertyData<QString>(71, QMetaType::QString, QMC::DefaultPropertyFlags, 29),
        // property 'tirePressureFL'
        QtMocHelpers::PropertyData<double>(72, QMetaType::Double, QMC::DefaultPropertyFlags, 30),
        // property 'tirePressureFR'
        QtMocHelpers::PropertyData<double>(73, QMetaType::Double, QMC::DefaultPropertyFlags, 30),
        // property 'tirePressureRL'
        QtMocHelpers::PropertyData<double>(74, QMetaType::Double, QMC::DefaultPropertyFlags, 30),
        // property 'tirePressureRR'
        QtMocHelpers::PropertyData<double>(75, QMetaType::Double, QMC::DefaultPropertyFlags, 30),
        // property 'tirePressureSupported'
        QtMocHelpers::PropertyData<bool>(76, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'tripDistance'
        QtMocHelpers::PropertyData<int>(77, QMetaType::Int, QMC::DefaultPropertyFlags, 31),
        // property 'tripTime'
        QtMocHelpers::PropertyData<int>(78, QMetaType::Int, QMC::DefaultPropertyFlags, 31),
        // property 'avgSpeed'
        QtMocHelpers::PropertyData<int>(79, QMetaType::Int, QMC::DefaultPropertyFlags, 31),
        // property 'fuelConsumption'
        QtMocHelpers::PropertyData<double>(80, QMetaType::Double, QMC::DefaultPropertyFlags, 31),
        // property 'warnings'
        QtMocHelpers::PropertyData<QVariantList>(81, 0x80000000 | 82, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 32),
        // property 'hasWarnings'
        QtMocHelpers::PropertyData<bool>(83, QMetaType::Bool, QMC::DefaultPropertyFlags, 32),
        // property 'isLocked'
        QtMocHelpers::PropertyData<bool>(84, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 33),
        // property 'interiorLightOn'
        QtMocHelpers::PropertyData<bool>(85, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 34),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<VehicleService, qt_meta_tag_ZN14VehicleServiceE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject VehicleService::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14VehicleServiceE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14VehicleServiceE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14VehicleServiceE_t>.metaTypes,
    nullptr
} };

void VehicleService::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<VehicleService *>(_o);
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
        case 10: _t->leftSeatVentilationChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 11: _t->rightSeatVentilationChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 12: _t->acEnabledChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 13: _t->autoClimateChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 14: _t->recircEnabledChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 15: _t->defrostEnabledChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 16: _t->frontDefrostEnabledChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 17: _t->rearDefrostEnabledChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 18: _t->frontLeftDoorOpenChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 19: _t->frontRightDoorOpenChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 20: _t->rearLeftDoorOpenChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 21: _t->rearRightDoorOpenChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 22: _t->trunkOpenChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 23: _t->hoodOpenChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 24: _t->doorsStatusChanged(); break;
        case 25: _t->connectionStateChanged(); break;
        case 26: _t->ignitionStateChanged(); break;
        case 27: _t->lastUpdateTimeChanged(); break;
        case 28: _t->handbrakeEngagedChanged(); break;
        case 29: _t->batteryStatusChanged(); break;
        case 30: _t->tirePressureChanged(); break;
        case 31: _t->tripDataChanged(); break;
        case 32: _t->warningsChanged(); break;
        case 33: _t->isLockedChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 34: _t->interiorLightOnChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(int )>(_a, &VehicleService::speedChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(QString )>(_a, &VehicleService::gearChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(double )>(_a, &VehicleService::outsideTempChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(int )>(_a, &VehicleService::batteryLevelChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(int )>(_a, &VehicleService::rangeChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(int )>(_a, &VehicleService::driverTempChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(int )>(_a, &VehicleService::passengerTempChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(int )>(_a, &VehicleService::fanSpeedChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::leftSeatHeatChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::rightSeatHeatChanged, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::leftSeatVentilationChanged, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::rightSeatVentilationChanged, 11))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::acEnabledChanged, 12))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::autoClimateChanged, 13))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::recircEnabledChanged, 14))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::defrostEnabledChanged, 15))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::frontDefrostEnabledChanged, 16))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::rearDefrostEnabledChanged, 17))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::frontLeftDoorOpenChanged, 18))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::frontRightDoorOpenChanged, 19))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::rearLeftDoorOpenChanged, 20))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::rearRightDoorOpenChanged, 21))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::trunkOpenChanged, 22))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::hoodOpenChanged, 23))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::doorsStatusChanged, 24))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::connectionStateChanged, 25))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::ignitionStateChanged, 26))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::lastUpdateTimeChanged, 27))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::handbrakeEngagedChanged, 28))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::batteryStatusChanged, 29))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::tirePressureChanged, 30))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::tripDataChanged, 31))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)()>(_a, &VehicleService::warningsChanged, 32))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::isLockedChanged, 33))
            return;
        if (QtMocHelpers::indexOfMethod<void (VehicleService::*)(bool )>(_a, &VehicleService::interiorLightOnChanged, 34))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<int*>(_v) = _t->speed(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->gear(); break;
        case 2: *reinterpret_cast<double*>(_v) = _t->outsideTemp(); break;
        case 3: *reinterpret_cast<int*>(_v) = _t->batteryLevel(); break;
        case 4: *reinterpret_cast<int*>(_v) = _t->range(); break;
        case 5: *reinterpret_cast<int*>(_v) = _t->driverTemp(); break;
        case 6: *reinterpret_cast<int*>(_v) = _t->passengerTemp(); break;
        case 7: *reinterpret_cast<int*>(_v) = _t->fanSpeed(); break;
        case 8: *reinterpret_cast<bool*>(_v) = _t->leftSeatHeat(); break;
        case 9: *reinterpret_cast<bool*>(_v) = _t->rightSeatHeat(); break;
        case 10: *reinterpret_cast<bool*>(_v) = _t->leftSeatVentilation(); break;
        case 11: *reinterpret_cast<bool*>(_v) = _t->rightSeatVentilation(); break;
        case 12: *reinterpret_cast<bool*>(_v) = _t->acEnabled(); break;
        case 13: *reinterpret_cast<bool*>(_v) = _t->autoClimate(); break;
        case 14: *reinterpret_cast<bool*>(_v) = _t->recircEnabled(); break;
        case 15: *reinterpret_cast<bool*>(_v) = _t->defrostEnabled(); break;
        case 16: *reinterpret_cast<bool*>(_v) = _t->frontDefrostEnabled(); break;
        case 17: *reinterpret_cast<bool*>(_v) = _t->rearDefrostEnabled(); break;
        case 18: *reinterpret_cast<bool*>(_v) = _t->frontLeftDoorOpen(); break;
        case 19: *reinterpret_cast<bool*>(_v) = _t->frontRightDoorOpen(); break;
        case 20: *reinterpret_cast<bool*>(_v) = _t->rearLeftDoorOpen(); break;
        case 21: *reinterpret_cast<bool*>(_v) = _t->rearRightDoorOpen(); break;
        case 22: *reinterpret_cast<bool*>(_v) = _t->trunkOpen(); break;
        case 23: *reinterpret_cast<bool*>(_v) = _t->hoodOpen(); break;
        case 24: *reinterpret_cast<QString*>(_v) = _t->doorsStatus(); break;
        case 25: *reinterpret_cast<QString*>(_v) = _t->connectionState(); break;
        case 26: *reinterpret_cast<QString*>(_v) = _t->ignitionState(); break;
        case 27: *reinterpret_cast<QString*>(_v) = _t->lastUpdateTime(); break;
        case 28: *reinterpret_cast<bool*>(_v) = _t->handbrakeEngaged(); break;
        case 29: *reinterpret_cast<QString*>(_v) = _t->batteryStatus(); break;
        case 30: *reinterpret_cast<double*>(_v) = _t->tirePressureFL(); break;
        case 31: *reinterpret_cast<double*>(_v) = _t->tirePressureFR(); break;
        case 32: *reinterpret_cast<double*>(_v) = _t->tirePressureRL(); break;
        case 33: *reinterpret_cast<double*>(_v) = _t->tirePressureRR(); break;
        case 34: *reinterpret_cast<bool*>(_v) = _t->tirePressureSupported(); break;
        case 35: *reinterpret_cast<int*>(_v) = _t->tripDistance(); break;
        case 36: *reinterpret_cast<int*>(_v) = _t->tripTime(); break;
        case 37: *reinterpret_cast<int*>(_v) = _t->avgSpeed(); break;
        case 38: *reinterpret_cast<double*>(_v) = _t->fuelConsumption(); break;
        case 39: *reinterpret_cast<QVariantList*>(_v) = _t->warnings(); break;
        case 40: *reinterpret_cast<bool*>(_v) = _t->hasWarnings(); break;
        case 41: *reinterpret_cast<bool*>(_v) = _t->isLocked(); break;
        case 42: *reinterpret_cast<bool*>(_v) = _t->interiorLightOn(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 5: _t->setDriverTemp(*reinterpret_cast<int*>(_v)); break;
        case 6: _t->setPassengerTemp(*reinterpret_cast<int*>(_v)); break;
        case 7: _t->setFanSpeed(*reinterpret_cast<int*>(_v)); break;
        case 8: _t->setLeftSeatHeat(*reinterpret_cast<bool*>(_v)); break;
        case 9: _t->setRightSeatHeat(*reinterpret_cast<bool*>(_v)); break;
        case 10: _t->setLeftSeatVentilation(*reinterpret_cast<bool*>(_v)); break;
        case 11: _t->setRightSeatVentilation(*reinterpret_cast<bool*>(_v)); break;
        case 12: _t->setAcEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 13: _t->setAutoClimate(*reinterpret_cast<bool*>(_v)); break;
        case 14: _t->setRecircEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 15: _t->setDefrostEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 16: _t->setFrontDefrostEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 17: _t->setRearDefrostEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 41: _t->setIsLocked(*reinterpret_cast<bool*>(_v)); break;
        case 42: _t->setInteriorLightOn(*reinterpret_cast<bool*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *VehicleService::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *VehicleService::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14VehicleServiceE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int VehicleService::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 35)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 35;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 35)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 35;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 43;
    }
    return _id;
}

// SIGNAL 0
void VehicleService::speedChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void VehicleService::gearChanged(QString _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void VehicleService::outsideTempChanged(double _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void VehicleService::batteryLevelChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void VehicleService::rangeChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1);
}

// SIGNAL 5
void VehicleService::driverTempChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1);
}

// SIGNAL 6
void VehicleService::passengerTempChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void VehicleService::fanSpeedChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}

// SIGNAL 8
void VehicleService::leftSeatHeatChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1);
}

// SIGNAL 9
void VehicleService::rightSeatHeatChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 9, nullptr, _t1);
}

// SIGNAL 10
void VehicleService::leftSeatVentilationChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 10, nullptr, _t1);
}

// SIGNAL 11
void VehicleService::rightSeatVentilationChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 11, nullptr, _t1);
}

// SIGNAL 12
void VehicleService::acEnabledChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 12, nullptr, _t1);
}

// SIGNAL 13
void VehicleService::autoClimateChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 13, nullptr, _t1);
}

// SIGNAL 14
void VehicleService::recircEnabledChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 14, nullptr, _t1);
}

// SIGNAL 15
void VehicleService::defrostEnabledChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 15, nullptr, _t1);
}

// SIGNAL 16
void VehicleService::frontDefrostEnabledChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 16, nullptr, _t1);
}

// SIGNAL 17
void VehicleService::rearDefrostEnabledChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 17, nullptr, _t1);
}

// SIGNAL 18
void VehicleService::frontLeftDoorOpenChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 18, nullptr, _t1);
}

// SIGNAL 19
void VehicleService::frontRightDoorOpenChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 19, nullptr, _t1);
}

// SIGNAL 20
void VehicleService::rearLeftDoorOpenChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 20, nullptr, _t1);
}

// SIGNAL 21
void VehicleService::rearRightDoorOpenChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 21, nullptr, _t1);
}

// SIGNAL 22
void VehicleService::trunkOpenChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 22, nullptr, _t1);
}

// SIGNAL 23
void VehicleService::hoodOpenChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 23, nullptr, _t1);
}

// SIGNAL 24
void VehicleService::doorsStatusChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 24, nullptr);
}

// SIGNAL 25
void VehicleService::connectionStateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 25, nullptr);
}

// SIGNAL 26
void VehicleService::ignitionStateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 26, nullptr);
}

// SIGNAL 27
void VehicleService::lastUpdateTimeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 27, nullptr);
}

// SIGNAL 28
void VehicleService::handbrakeEngagedChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 28, nullptr);
}

// SIGNAL 29
void VehicleService::batteryStatusChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 29, nullptr);
}

// SIGNAL 30
void VehicleService::tirePressureChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 30, nullptr);
}

// SIGNAL 31
void VehicleService::tripDataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 31, nullptr);
}

// SIGNAL 32
void VehicleService::warningsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 32, nullptr);
}

// SIGNAL 33
void VehicleService::isLockedChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 33, nullptr, _t1);
}

// SIGNAL 34
void VehicleService::interiorLightOnChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 34, nullptr, _t1);
}
QT_WARNING_POP
