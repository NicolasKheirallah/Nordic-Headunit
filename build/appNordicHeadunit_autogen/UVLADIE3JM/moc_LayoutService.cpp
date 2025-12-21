/****************************************************************************
** Meta object code from reading C++ file 'LayoutService.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/LayoutService.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'LayoutService.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN13LayoutServiceE_t {};
} // unnamed namespace

template <> constexpr inline auto LayoutService::qt_create_metaobjectdata<qt_meta_tag_ZN13LayoutServiceE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "LayoutService",
        "layoutChanged",
        "",
        "updateLayout",
        "size",
        "widthClass",
        "WidthClass",
        "heightClass",
        "HeightClass",
        "isLandscape",
        "isCompact",
        "screenSize",
        "CompactWidth",
        "RegularWidth",
        "ExpandedWidth",
        "ShortHeight",
        "NormalHeight",
        "TallHeight"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'layoutChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'updateLayout'
        QtMocHelpers::SlotData<void(const QSize &)>(3, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QSize, 4 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'widthClass'
        QtMocHelpers::PropertyData<enum WidthClass>(5, 0x80000000 | 6, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'heightClass'
        QtMocHelpers::PropertyData<enum HeightClass>(7, 0x80000000 | 8, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'isLandscape'
        QtMocHelpers::PropertyData<bool>(9, QMetaType::Bool, QMC::DefaultPropertyFlags, 0),
        // property 'isCompact'
        QtMocHelpers::PropertyData<bool>(10, QMetaType::Bool, QMC::DefaultPropertyFlags, 0),
        // property 'screenSize'
        QtMocHelpers::PropertyData<QSize>(11, QMetaType::QSize, QMC::DefaultPropertyFlags, 0),
    };
    QtMocHelpers::UintData qt_enums {
        // enum 'WidthClass'
        QtMocHelpers::EnumData<enum WidthClass>(6, 6, QMC::EnumFlags{}).add({
            {   12, WidthClass::CompactWidth },
            {   13, WidthClass::RegularWidth },
            {   14, WidthClass::ExpandedWidth },
        }),
        // enum 'HeightClass'
        QtMocHelpers::EnumData<enum HeightClass>(8, 8, QMC::EnumFlags{}).add({
            {   15, HeightClass::ShortHeight },
            {   16, HeightClass::NormalHeight },
            {   17, HeightClass::TallHeight },
        }),
    };
    return QtMocHelpers::metaObjectData<LayoutService, qt_meta_tag_ZN13LayoutServiceE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject LayoutService::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13LayoutServiceE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13LayoutServiceE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN13LayoutServiceE_t>.metaTypes,
    nullptr
} };

void LayoutService::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<LayoutService *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->layoutChanged(); break;
        case 1: _t->updateLayout((*reinterpret_cast< std::add_pointer_t<QSize>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (LayoutService::*)()>(_a, &LayoutService::layoutChanged, 0))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<enum WidthClass*>(_v) = _t->widthClass(); break;
        case 1: *reinterpret_cast<enum HeightClass*>(_v) = _t->heightClass(); break;
        case 2: *reinterpret_cast<bool*>(_v) = _t->isLandscape(); break;
        case 3: *reinterpret_cast<bool*>(_v) = _t->isCompact(); break;
        case 4: *reinterpret_cast<QSize*>(_v) = _t->screenSize(); break;
        default: break;
        }
    }
}

const QMetaObject *LayoutService::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *LayoutService::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN13LayoutServiceE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int LayoutService::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 2)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 2)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 2;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    }
    return _id;
}

// SIGNAL 0
void LayoutService::layoutChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
