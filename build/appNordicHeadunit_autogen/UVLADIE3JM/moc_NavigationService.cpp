/****************************************************************************
** Meta object code from reading C++ file 'NavigationService.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/NavigationService.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'NavigationService.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN17NavigationServiceE_t {};
} // unnamed namespace

template <> constexpr inline auto NavigationService::qt_create_metaobjectdata<qt_meta_tag_ZN17NavigationServiceE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NavigationService",
        "navigationStateChanged",
        "",
        "guidanceChanged",
        "vehiclePositionChanged",
        "voiceInstruction",
        "text",
        "searchResultReceived",
        "QVariantList",
        "results",
        "recentSearchesChanged",
        "mapPinsChanged",
        "routeCalculated",
        "QVariantMap",
        "routeData",
        "errorOccurred",
        "message",
        "onSearchFinished",
        "onRouteFinished",
        "startNavigation",
        "dest",
        "stopNavigation",
        "searchPlaces",
        "query",
        "searchCategory",
        "category",
        "clearMapPins",
        "calculateRoute",
        "QGeoCoordinate",
        "start",
        "end",
        "vehiclePosition",
        "vehicleBearing",
        "isNavigating",
        "nextManeuver",
        "distanceToManeuver",
        "destination",
        "currentRoadName",
        "speedLimit",
        "trafficSegments",
        "recentSearches",
        "mapPins"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'navigationStateChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'guidanceChanged'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'vehiclePositionChanged'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'voiceInstruction'
        QtMocHelpers::SignalData<void(const QString &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 6 },
        }}),
        // Signal 'searchResultReceived'
        QtMocHelpers::SignalData<void(const QVariantList &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 8, 9 },
        }}),
        // Signal 'recentSearchesChanged'
        QtMocHelpers::SignalData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'mapPinsChanged'
        QtMocHelpers::SignalData<void()>(11, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'routeCalculated'
        QtMocHelpers::SignalData<void(const QVariantMap &)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 13, 14 },
        }}),
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(const QString &)>(15, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 16 },
        }}),
        // Slot 'onSearchFinished'
        QtMocHelpers::SlotData<void()>(17, 2, QMC::AccessPrivate, QMetaType::Void),
        // Slot 'onRouteFinished'
        QtMocHelpers::SlotData<void()>(18, 2, QMC::AccessPrivate, QMetaType::Void),
        // Method 'startNavigation'
        QtMocHelpers::MethodData<void(const QString &)>(19, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 20 },
        }}),
        // Method 'stopNavigation'
        QtMocHelpers::MethodData<void()>(21, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'searchPlaces'
        QtMocHelpers::MethodData<void(const QString &)>(22, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 23 },
        }}),
        // Method 'searchCategory'
        QtMocHelpers::MethodData<void(const QString &)>(24, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 25 },
        }}),
        // Method 'clearMapPins'
        QtMocHelpers::MethodData<void()>(26, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'calculateRoute'
        QtMocHelpers::MethodData<void(const QGeoCoordinate &, const QGeoCoordinate &)>(27, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 28, 29 }, { 0x80000000 | 28, 30 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'vehiclePosition'
        QtMocHelpers::PropertyData<QGeoCoordinate>(31, 0x80000000 | 28, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 2),
        // property 'vehicleBearing'
        QtMocHelpers::PropertyData<qreal>(32, QMetaType::QReal, QMC::DefaultPropertyFlags, 2),
        // property 'isNavigating'
        QtMocHelpers::PropertyData<bool>(33, QMetaType::Bool, QMC::DefaultPropertyFlags, 0),
        // property 'nextManeuver'
        QtMocHelpers::PropertyData<QString>(34, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'distanceToManeuver'
        QtMocHelpers::PropertyData<QString>(35, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'destination'
        QtMocHelpers::PropertyData<QString>(36, QMetaType::QString, QMC::DefaultPropertyFlags, 0),
        // property 'currentRoadName'
        QtMocHelpers::PropertyData<QString>(37, QMetaType::QString, QMC::DefaultPropertyFlags, 1),
        // property 'speedLimit'
        QtMocHelpers::PropertyData<int>(38, QMetaType::Int, QMC::DefaultPropertyFlags, 1),
        // property 'trafficSegments'
        QtMocHelpers::PropertyData<QVariantList>(39, 0x80000000 | 8, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 7),
        // property 'recentSearches'
        QtMocHelpers::PropertyData<QVariantList>(40, 0x80000000 | 8, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 5),
        // property 'mapPins'
        QtMocHelpers::PropertyData<QVariantList>(41, 0x80000000 | 8, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 6),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<NavigationService, qt_meta_tag_ZN17NavigationServiceE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NavigationService::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN17NavigationServiceE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN17NavigationServiceE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN17NavigationServiceE_t>.metaTypes,
    nullptr
} };

void NavigationService::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<NavigationService *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->navigationStateChanged(); break;
        case 1: _t->guidanceChanged(); break;
        case 2: _t->vehiclePositionChanged(); break;
        case 3: _t->voiceInstruction((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 4: _t->searchResultReceived((*reinterpret_cast< std::add_pointer_t<QVariantList>>(_a[1]))); break;
        case 5: _t->recentSearchesChanged(); break;
        case 6: _t->mapPinsChanged(); break;
        case 7: _t->routeCalculated((*reinterpret_cast< std::add_pointer_t<QVariantMap>>(_a[1]))); break;
        case 8: _t->errorOccurred((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 9: _t->onSearchFinished(); break;
        case 10: _t->onRouteFinished(); break;
        case 11: _t->startNavigation((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 12: _t->stopNavigation(); break;
        case 13: _t->searchPlaces((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 14: _t->searchCategory((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 15: _t->clearMapPins(); break;
        case 16: _t->calculateRoute((*reinterpret_cast< std::add_pointer_t<QGeoCoordinate>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QGeoCoordinate>>(_a[2]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 16:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 1:
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QGeoCoordinate >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)()>(_a, &NavigationService::navigationStateChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)()>(_a, &NavigationService::guidanceChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)()>(_a, &NavigationService::vehiclePositionChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)(const QString & )>(_a, &NavigationService::voiceInstruction, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)(const QVariantList & )>(_a, &NavigationService::searchResultReceived, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)()>(_a, &NavigationService::recentSearchesChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)()>(_a, &NavigationService::mapPinsChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)(const QVariantMap & )>(_a, &NavigationService::routeCalculated, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (NavigationService::*)(const QString & )>(_a, &NavigationService::errorOccurred, 8))
            return;
    }
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QGeoCoordinate >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QGeoCoordinate*>(_v) = _t->vehiclePosition(); break;
        case 1: *reinterpret_cast<qreal*>(_v) = _t->vehicleBearing(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->isNavigating(); break;
        case 3: *reinterpret_cast<QString*>(_v) = _t->nextManeuver(); break;
        case 4: *reinterpret_cast<QString*>(_v) = _t->distanceToManeuver(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->destination(); break;
        case 6: *reinterpret_cast<QString*>(_v) = _t->currentRoadName(); break;
        case 7: *reinterpret_cast<int*>(_v) = _t->speedLimit(); break;
        case 8: *reinterpret_cast<QVariantList*>(_v) = _t->trafficSegments(); break;
        case 9: *reinterpret_cast<QVariantList*>(_v) = _t->recentSearches(); break;
        case 10: *reinterpret_cast<QVariantList*>(_v) = _t->mapPins(); break;
        default: break;
        }
    }
}

const QMetaObject *NavigationService::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NavigationService::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN17NavigationServiceE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int NavigationService::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 17)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 17;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 17)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 17;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    }
    return _id;
}

// SIGNAL 0
void NavigationService::navigationStateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NavigationService::guidanceChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void NavigationService::vehiclePositionChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void NavigationService::voiceInstruction(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void NavigationService::searchResultReceived(const QVariantList & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1);
}

// SIGNAL 5
void NavigationService::recentSearchesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void NavigationService::mapPinsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void NavigationService::routeCalculated(const QVariantMap & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1);
}

// SIGNAL 8
void NavigationService::errorOccurred(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1);
}
QT_WARNING_POP
