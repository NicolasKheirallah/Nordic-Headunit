/****************************************************************************
** Meta object code from reading C++ file 'SystemSettings.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../src/SystemSettings.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'SystemSettings.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN14SystemSettingsE_t {};
} // unnamed namespace

template <> constexpr inline auto SystemSettings::qt_create_metaobjectdata<qt_meta_tag_ZN14SystemSettingsE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "SystemSettings",
        "darkModeChanged",
        "",
        "darkMode",
        "wifiEnabledChanged",
        "wifiEnabled",
        "bluetoothEnabledChanged",
        "bluetoothEnabled",
        "masterVolumeChanged",
        "masterVolume",
        "brightnessChanged",
        "brightness",
        "walkAwayLockChanged",
        "walkAwayLock",
        "useMetricChanged",
        "useMetric",
        "languageChanged",
        "language",
        "eqBassChanged",
        "eqBass",
        "eqMidChanged",
        "eqMid",
        "eqTrebleChanged",
        "eqTreble",
        "faderXChanged",
        "faderX",
        "faderYChanged",
        "faderY",
        "lightsModeChanged",
        "lightsMode",
        "childLockChanged",
        "childLock",
        "autoFoldMirrorsChanged",
        "autoFoldMirrors",
        "rainSensingWipersChanged",
        "rainSensingWipers",
        "factoryReset",
        "version"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'darkModeChanged'
        QtMocHelpers::SignalData<void(bool)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 3 },
        }}),
        // Signal 'wifiEnabledChanged'
        QtMocHelpers::SignalData<void(bool)>(4, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 5 },
        }}),
        // Signal 'bluetoothEnabledChanged'
        QtMocHelpers::SignalData<void(bool)>(6, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 7 },
        }}),
        // Signal 'masterVolumeChanged'
        QtMocHelpers::SignalData<void(int)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 9 },
        }}),
        // Signal 'brightnessChanged'
        QtMocHelpers::SignalData<void(int)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 11 },
        }}),
        // Signal 'walkAwayLockChanged'
        QtMocHelpers::SignalData<void(bool)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 13 },
        }}),
        // Signal 'useMetricChanged'
        QtMocHelpers::SignalData<void(bool)>(14, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 15 },
        }}),
        // Signal 'languageChanged'
        QtMocHelpers::SignalData<void(const QString &)>(16, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 17 },
        }}),
        // Signal 'eqBassChanged'
        QtMocHelpers::SignalData<void(int)>(18, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 19 },
        }}),
        // Signal 'eqMidChanged'
        QtMocHelpers::SignalData<void(int)>(20, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 21 },
        }}),
        // Signal 'eqTrebleChanged'
        QtMocHelpers::SignalData<void(int)>(22, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 23 },
        }}),
        // Signal 'faderXChanged'
        QtMocHelpers::SignalData<void(double)>(24, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Double, 25 },
        }}),
        // Signal 'faderYChanged'
        QtMocHelpers::SignalData<void(double)>(26, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Double, 27 },
        }}),
        // Signal 'lightsModeChanged'
        QtMocHelpers::SignalData<void(int)>(28, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 29 },
        }}),
        // Signal 'childLockChanged'
        QtMocHelpers::SignalData<void(bool)>(30, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 31 },
        }}),
        // Signal 'autoFoldMirrorsChanged'
        QtMocHelpers::SignalData<void(bool)>(32, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 33 },
        }}),
        // Signal 'rainSensingWipersChanged'
        QtMocHelpers::SignalData<void(bool)>(34, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 35 },
        }}),
        // Method 'factoryReset'
        QtMocHelpers::MethodData<void()>(36, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'darkMode'
        QtMocHelpers::PropertyData<bool>(3, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 0),
        // property 'wifiEnabled'
        QtMocHelpers::PropertyData<bool>(5, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'bluetoothEnabled'
        QtMocHelpers::PropertyData<bool>(7, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 2),
        // property 'masterVolume'
        QtMocHelpers::PropertyData<int>(9, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 3),
        // property 'brightness'
        QtMocHelpers::PropertyData<int>(11, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 4),
        // property 'walkAwayLock'
        QtMocHelpers::PropertyData<bool>(13, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 5),
        // property 'useMetric'
        QtMocHelpers::PropertyData<bool>(15, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 6),
        // property 'language'
        QtMocHelpers::PropertyData<QString>(17, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 7),
        // property 'version'
        QtMocHelpers::PropertyData<QString>(37, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Constant),
        // property 'eqBass'
        QtMocHelpers::PropertyData<int>(19, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 8),
        // property 'eqMid'
        QtMocHelpers::PropertyData<int>(21, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 9),
        // property 'eqTreble'
        QtMocHelpers::PropertyData<int>(23, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 10),
        // property 'faderX'
        QtMocHelpers::PropertyData<double>(25, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 11),
        // property 'faderY'
        QtMocHelpers::PropertyData<double>(27, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 12),
        // property 'lightsMode'
        QtMocHelpers::PropertyData<int>(29, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 13),
        // property 'childLock'
        QtMocHelpers::PropertyData<bool>(31, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 14),
        // property 'autoFoldMirrors'
        QtMocHelpers::PropertyData<bool>(33, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 15),
        // property 'rainSensingWipers'
        QtMocHelpers::PropertyData<bool>(35, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 16),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<SystemSettings, qt_meta_tag_ZN14SystemSettingsE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject SystemSettings::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14SystemSettingsE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14SystemSettingsE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14SystemSettingsE_t>.metaTypes,
    nullptr
} };

void SystemSettings::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<SystemSettings *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->darkModeChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 1: _t->wifiEnabledChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 2: _t->bluetoothEnabledChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 3: _t->masterVolumeChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 4: _t->brightnessChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 5: _t->walkAwayLockChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 6: _t->useMetricChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 7: _t->languageChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 8: _t->eqBassChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 9: _t->eqMidChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 10: _t->eqTrebleChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 11: _t->faderXChanged((*reinterpret_cast< std::add_pointer_t<double>>(_a[1]))); break;
        case 12: _t->faderYChanged((*reinterpret_cast< std::add_pointer_t<double>>(_a[1]))); break;
        case 13: _t->lightsModeChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 14: _t->childLockChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 15: _t->autoFoldMirrorsChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 16: _t->rainSensingWipersChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 17: _t->factoryReset(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(bool )>(_a, &SystemSettings::darkModeChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(bool )>(_a, &SystemSettings::wifiEnabledChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(bool )>(_a, &SystemSettings::bluetoothEnabledChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(int )>(_a, &SystemSettings::masterVolumeChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(int )>(_a, &SystemSettings::brightnessChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(bool )>(_a, &SystemSettings::walkAwayLockChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(bool )>(_a, &SystemSettings::useMetricChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(const QString & )>(_a, &SystemSettings::languageChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(int )>(_a, &SystemSettings::eqBassChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(int )>(_a, &SystemSettings::eqMidChanged, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(int )>(_a, &SystemSettings::eqTrebleChanged, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(double )>(_a, &SystemSettings::faderXChanged, 11))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(double )>(_a, &SystemSettings::faderYChanged, 12))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(int )>(_a, &SystemSettings::lightsModeChanged, 13))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(bool )>(_a, &SystemSettings::childLockChanged, 14))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(bool )>(_a, &SystemSettings::autoFoldMirrorsChanged, 15))
            return;
        if (QtMocHelpers::indexOfMethod<void (SystemSettings::*)(bool )>(_a, &SystemSettings::rainSensingWipersChanged, 16))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<bool*>(_v) = _t->darkMode(); break;
        case 1: *reinterpret_cast<bool*>(_v) = _t->wifiEnabled(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->bluetoothEnabled(); break;
        case 3: *reinterpret_cast<int*>(_v) = _t->masterVolume(); break;
        case 4: *reinterpret_cast<int*>(_v) = _t->brightness(); break;
        case 5: *reinterpret_cast<bool*>(_v) = _t->walkAwayLock(); break;
        case 6: *reinterpret_cast<bool*>(_v) = _t->useMetric(); break;
        case 7: *reinterpret_cast<QString*>(_v) = _t->language(); break;
        case 8: *reinterpret_cast<QString*>(_v) = _t->version(); break;
        case 9: *reinterpret_cast<int*>(_v) = _t->eqBass(); break;
        case 10: *reinterpret_cast<int*>(_v) = _t->eqMid(); break;
        case 11: *reinterpret_cast<int*>(_v) = _t->eqTreble(); break;
        case 12: *reinterpret_cast<double*>(_v) = _t->faderX(); break;
        case 13: *reinterpret_cast<double*>(_v) = _t->faderY(); break;
        case 14: *reinterpret_cast<int*>(_v) = _t->lightsMode(); break;
        case 15: *reinterpret_cast<bool*>(_v) = _t->childLock(); break;
        case 16: *reinterpret_cast<bool*>(_v) = _t->autoFoldMirrors(); break;
        case 17: *reinterpret_cast<bool*>(_v) = _t->rainSensingWipers(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setDarkMode(*reinterpret_cast<bool*>(_v)); break;
        case 1: _t->setWifiEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 2: _t->setBluetoothEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 3: _t->setMasterVolume(*reinterpret_cast<int*>(_v)); break;
        case 4: _t->setBrightness(*reinterpret_cast<int*>(_v)); break;
        case 5: _t->setWalkAwayLock(*reinterpret_cast<bool*>(_v)); break;
        case 6: _t->setUseMetric(*reinterpret_cast<bool*>(_v)); break;
        case 7: _t->setLanguage(*reinterpret_cast<QString*>(_v)); break;
        case 9: _t->setEqBass(*reinterpret_cast<int*>(_v)); break;
        case 10: _t->setEqMid(*reinterpret_cast<int*>(_v)); break;
        case 11: _t->setEqTreble(*reinterpret_cast<int*>(_v)); break;
        case 12: _t->setFaderX(*reinterpret_cast<double*>(_v)); break;
        case 13: _t->setFaderY(*reinterpret_cast<double*>(_v)); break;
        case 14: _t->setLightsMode(*reinterpret_cast<int*>(_v)); break;
        case 15: _t->setChildLock(*reinterpret_cast<bool*>(_v)); break;
        case 16: _t->setAutoFoldMirrors(*reinterpret_cast<bool*>(_v)); break;
        case 17: _t->setRainSensingWipers(*reinterpret_cast<bool*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *SystemSettings::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SystemSettings::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14SystemSettingsE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SystemSettings::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 18)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 18;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 18)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 18;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 18;
    }
    return _id;
}

// SIGNAL 0
void SystemSettings::darkModeChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void SystemSettings::wifiEnabledChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void SystemSettings::bluetoothEnabledChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void SystemSettings::masterVolumeChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void SystemSettings::brightnessChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1);
}

// SIGNAL 5
void SystemSettings::walkAwayLockChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1);
}

// SIGNAL 6
void SystemSettings::useMetricChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void SystemSettings::languageChanged(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}

// SIGNAL 8
void SystemSettings::eqBassChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1);
}

// SIGNAL 9
void SystemSettings::eqMidChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 9, nullptr, _t1);
}

// SIGNAL 10
void SystemSettings::eqTrebleChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 10, nullptr, _t1);
}

// SIGNAL 11
void SystemSettings::faderXChanged(double _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 11, nullptr, _t1);
}

// SIGNAL 12
void SystemSettings::faderYChanged(double _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 12, nullptr, _t1);
}

// SIGNAL 13
void SystemSettings::lightsModeChanged(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 13, nullptr, _t1);
}

// SIGNAL 14
void SystemSettings::childLockChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 14, nullptr, _t1);
}

// SIGNAL 15
void SystemSettings::autoFoldMirrorsChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 15, nullptr, _t1);
}

// SIGNAL 16
void SystemSettings::rainSensingWipersChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 16, nullptr, _t1);
}
QT_WARNING_POP
