/****************************************************************************
** Meta object code from reading C++ file 'MediaService.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/MediaService.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'MediaService.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN12MediaServiceE_t {};
} // unnamed namespace

template <> constexpr inline auto MediaService::qt_create_metaobjectdata<qt_meta_tag_ZN12MediaServiceE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "MediaService",
        "trackChanged",
        "",
        "playingChanged",
        "playing",
        "positionChanged",
        "currentSourceChanged",
        "radioChanged",
        "recentItemsChanged",
        "sourcesChanged",
        "radioStationsChanged",
        "shuffleEnabledChanged",
        "repeatEnabledChanged",
        "playlistChanged",
        "connectionChanged",
        "loadingChanged",
        "errorChanged",
        "updatePosition",
        "play",
        "pause",
        "next",
        "previous",
        "togglePlayPause",
        "seek",
        "position",
        "setSource",
        "source",
        "tuneRadio",
        "frequency",
        "tuneRadioByIndex",
        "index",
        "tuneToFrequency",
        "tuneStep",
        "step",
        "seekForward",
        "seekBackward",
        "scanRadioStations",
        "playTrack",
        "playFromRecent",
        "playPlaylist",
        "name",
        "title",
        "artist",
        "coverSource",
        "duration",
        "progress",
        "shuffleEnabled",
        "repeatEnabled",
        "currentSource",
        "isRadioMode",
        "sources",
        "QVariantList",
        "radioStations",
        "recentItems",
        "library",
        "playlist",
        "radioFrequency",
        "radioName",
        "currentRadioIndex",
        "isConnected",
        "isLoading",
        "hasError",
        "errorMessage"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'trackChanged'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'playingChanged'
        QtMocHelpers::SignalData<void(bool)>(3, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 4 },
        }}),
        // Signal 'positionChanged'
        QtMocHelpers::SignalData<void()>(5, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'currentSourceChanged'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'radioChanged'
        QtMocHelpers::SignalData<void()>(7, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'recentItemsChanged'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'sourcesChanged'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'radioStationsChanged'
        QtMocHelpers::SignalData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'shuffleEnabledChanged'
        QtMocHelpers::SignalData<void()>(11, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'repeatEnabledChanged'
        QtMocHelpers::SignalData<void()>(12, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'playlistChanged'
        QtMocHelpers::SignalData<void()>(13, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'connectionChanged'
        QtMocHelpers::SignalData<void()>(14, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'loadingChanged'
        QtMocHelpers::SignalData<void()>(15, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'errorChanged'
        QtMocHelpers::SignalData<void()>(16, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'updatePosition'
        QtMocHelpers::SlotData<void()>(17, 2, QMC::AccessPrivate, QMetaType::Void),
        // Method 'play'
        QtMocHelpers::MethodData<void()>(18, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'pause'
        QtMocHelpers::MethodData<void()>(19, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'next'
        QtMocHelpers::MethodData<void()>(20, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'previous'
        QtMocHelpers::MethodData<void()>(21, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'togglePlayPause'
        QtMocHelpers::MethodData<void()>(22, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'seek'
        QtMocHelpers::MethodData<void(int)>(23, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 24 },
        }}),
        // Method 'setSource'
        QtMocHelpers::MethodData<void(const QString &)>(25, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 26 },
        }}),
        // Method 'tuneRadio'
        QtMocHelpers::MethodData<void(const QString &)>(27, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 28 },
        }}),
        // Method 'tuneRadioByIndex'
        QtMocHelpers::MethodData<void(int)>(29, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 30 },
        }}),
        // Method 'tuneToFrequency'
        QtMocHelpers::MethodData<void(const QString &)>(31, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 28 },
        }}),
        // Method 'tuneStep'
        QtMocHelpers::MethodData<void(double)>(32, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Double, 33 },
        }}),
        // Method 'seekForward'
        QtMocHelpers::MethodData<void()>(34, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'seekBackward'
        QtMocHelpers::MethodData<void()>(35, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'scanRadioStations'
        QtMocHelpers::MethodData<void()>(36, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'playTrack'
        QtMocHelpers::MethodData<void(int)>(37, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 30 },
        }}),
        // Method 'playFromRecent'
        QtMocHelpers::MethodData<void(int)>(38, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 30 },
        }}),
        // Method 'playPlaylist'
        QtMocHelpers::MethodData<void(const QString &)>(39, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 40 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'title'
        QtMocHelpers::PropertyData<QString>(41, QMetaType::QString, QMC::DefaultPropertyFlags, 0),
        // property 'artist'
        QtMocHelpers::PropertyData<QString>(42, QMetaType::QString, QMC::DefaultPropertyFlags, 0),
        // property 'coverSource'
        QtMocHelpers::PropertyData<QString>(43, QMetaType::QString, QMC::DefaultPropertyFlags, 0),
        // property 'playing'
        QtMocHelpers::PropertyData<bool>(4, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'position'
        QtMocHelpers::PropertyData<int>(24, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'duration'
        QtMocHelpers::PropertyData<int>(44, QMetaType::Int, QMC::DefaultPropertyFlags, 0),
        // property 'progress'
        QtMocHelpers::PropertyData<double>(45, QMetaType::Double, QMC::DefaultPropertyFlags, 2),
        // property 'shuffleEnabled'
        QtMocHelpers::PropertyData<bool>(46, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 8),
        // property 'repeatEnabled'
        QtMocHelpers::PropertyData<bool>(47, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 9),
        // property 'currentSource'
        QtMocHelpers::PropertyData<QString>(48, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 3),
        // property 'isRadioMode'
        QtMocHelpers::PropertyData<bool>(49, QMetaType::Bool, QMC::DefaultPropertyFlags, 3),
        // property 'sources'
        QtMocHelpers::PropertyData<QVariantList>(50, 0x80000000 | 51, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 6),
        // property 'radioStations'
        QtMocHelpers::PropertyData<QVariantList>(52, 0x80000000 | 51, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 7),
        // property 'recentItems'
        QtMocHelpers::PropertyData<QVariantList>(53, 0x80000000 | 51, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 5),
        // property 'library'
        QtMocHelpers::PropertyData<QVariantList>(54, 0x80000000 | 51, QMC::DefaultPropertyFlags | QMC::EnumOrFlag | QMC::Constant),
        // property 'playlist'
        QtMocHelpers::PropertyData<QVariantList>(55, 0x80000000 | 51, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 10),
        // property 'radioFrequency'
        QtMocHelpers::PropertyData<QString>(56, QMetaType::QString, QMC::DefaultPropertyFlags, 4),
        // property 'radioName'
        QtMocHelpers::PropertyData<QString>(57, QMetaType::QString, QMC::DefaultPropertyFlags, 4),
        // property 'currentRadioIndex'
        QtMocHelpers::PropertyData<int>(58, QMetaType::Int, QMC::DefaultPropertyFlags, 4),
        // property 'isConnected'
        QtMocHelpers::PropertyData<bool>(59, QMetaType::Bool, QMC::DefaultPropertyFlags, 11),
        // property 'isLoading'
        QtMocHelpers::PropertyData<bool>(60, QMetaType::Bool, QMC::DefaultPropertyFlags, 12),
        // property 'hasError'
        QtMocHelpers::PropertyData<bool>(61, QMetaType::Bool, QMC::DefaultPropertyFlags, 13),
        // property 'errorMessage'
        QtMocHelpers::PropertyData<QString>(62, QMetaType::QString, QMC::DefaultPropertyFlags, 13),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<MediaService, qt_meta_tag_ZN12MediaServiceE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject MediaService::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12MediaServiceE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12MediaServiceE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN12MediaServiceE_t>.metaTypes,
    nullptr
} };

void MediaService::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<MediaService *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->trackChanged(); break;
        case 1: _t->playingChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 2: _t->positionChanged(); break;
        case 3: _t->currentSourceChanged(); break;
        case 4: _t->radioChanged(); break;
        case 5: _t->recentItemsChanged(); break;
        case 6: _t->sourcesChanged(); break;
        case 7: _t->radioStationsChanged(); break;
        case 8: _t->shuffleEnabledChanged(); break;
        case 9: _t->repeatEnabledChanged(); break;
        case 10: _t->playlistChanged(); break;
        case 11: _t->connectionChanged(); break;
        case 12: _t->loadingChanged(); break;
        case 13: _t->errorChanged(); break;
        case 14: _t->updatePosition(); break;
        case 15: _t->play(); break;
        case 16: _t->pause(); break;
        case 17: _t->next(); break;
        case 18: _t->previous(); break;
        case 19: _t->togglePlayPause(); break;
        case 20: _t->seek((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 21: _t->setSource((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 22: _t->tuneRadio((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 23: _t->tuneRadioByIndex((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 24: _t->tuneToFrequency((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 25: _t->tuneStep((*reinterpret_cast< std::add_pointer_t<double>>(_a[1]))); break;
        case 26: _t->seekForward(); break;
        case 27: _t->seekBackward(); break;
        case 28: _t->scanRadioStations(); break;
        case 29: _t->playTrack((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 30: _t->playFromRecent((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 31: _t->playPlaylist((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::trackChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)(bool )>(_a, &MediaService::playingChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::positionChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::currentSourceChanged, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::radioChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::recentItemsChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::sourcesChanged, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::radioStationsChanged, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::shuffleEnabledChanged, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::repeatEnabledChanged, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::playlistChanged, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::connectionChanged, 11))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::loadingChanged, 12))
            return;
        if (QtMocHelpers::indexOfMethod<void (MediaService::*)()>(_a, &MediaService::errorChanged, 13))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QString*>(_v) = _t->title(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->artist(); break;
        case 2: *reinterpret_cast<QString*>(_v) = _t->coverSource(); break;
        case 3: *reinterpret_cast<bool*>(_v) = _t->playing(); break;
        case 4: *reinterpret_cast<int*>(_v) = _t->position(); break;
        case 5: *reinterpret_cast<int*>(_v) = _t->duration(); break;
        case 6: *reinterpret_cast<double*>(_v) = _t->progress(); break;
        case 7: *reinterpret_cast<bool*>(_v) = _t->shuffleEnabled(); break;
        case 8: *reinterpret_cast<bool*>(_v) = _t->repeatEnabled(); break;
        case 9: *reinterpret_cast<QString*>(_v) = _t->currentSource(); break;
        case 10: *reinterpret_cast<bool*>(_v) = _t->isRadioMode(); break;
        case 11: *reinterpret_cast<QVariantList*>(_v) = _t->sources(); break;
        case 12: *reinterpret_cast<QVariantList*>(_v) = _t->radioStations(); break;
        case 13: *reinterpret_cast<QVariantList*>(_v) = _t->recentItems(); break;
        case 14: *reinterpret_cast<QVariantList*>(_v) = _t->library(); break;
        case 15: *reinterpret_cast<QVariantList*>(_v) = _t->playlist(); break;
        case 16: *reinterpret_cast<QString*>(_v) = _t->radioFrequency(); break;
        case 17: *reinterpret_cast<QString*>(_v) = _t->radioName(); break;
        case 18: *reinterpret_cast<int*>(_v) = _t->currentRadioIndex(); break;
        case 19: *reinterpret_cast<bool*>(_v) = _t->isConnected(); break;
        case 20: *reinterpret_cast<bool*>(_v) = _t->isLoading(); break;
        case 21: *reinterpret_cast<bool*>(_v) = _t->hasError(); break;
        case 22: *reinterpret_cast<QString*>(_v) = _t->errorMessage(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 3: _t->setPlaying(*reinterpret_cast<bool*>(_v)); break;
        case 7: _t->setShuffleEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 8: _t->setRepeatEnabled(*reinterpret_cast<bool*>(_v)); break;
        case 9: _t->setCurrentSource(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *MediaService::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MediaService::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN12MediaServiceE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int MediaService::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 32)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 32;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 32)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 32;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 23;
    }
    return _id;
}

// SIGNAL 0
void MediaService::trackChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void MediaService::playingChanged(bool _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void MediaService::positionChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void MediaService::currentSourceChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void MediaService::radioChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void MediaService::recentItemsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void MediaService::sourcesChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void MediaService::radioStationsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void MediaService::shuffleEnabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}

// SIGNAL 9
void MediaService::repeatEnabledChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void MediaService::playlistChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 10, nullptr);
}

// SIGNAL 11
void MediaService::connectionChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 11, nullptr);
}

// SIGNAL 12
void MediaService::loadingChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 12, nullptr);
}

// SIGNAL 13
void MediaService::errorChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 13, nullptr);
}
QT_WARNING_POP
