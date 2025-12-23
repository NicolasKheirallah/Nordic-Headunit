cmake_minimum_required(VERSION 3.16)

project(NordicHeadunit VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects LinguistTools Network Location Positioning Multimedia)

qt_standard_project_setup()

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_add_executable(appNordicHeadunit
    main.cpp
    src/LayoutService.cpp
    src/LayoutService.h
    src/SystemSettings.cpp
    src/SystemSettings.h
    src/VehicleService.cpp
    src/VehicleService.h
    src/MediaService.cpp
    src/MediaService.h
    src/RadioTuner.cpp
    src/RadioTuner.h
    src/MediaLibrary.cpp
    src/MediaLibrary.h
    src/NavigationService.cpp
    src/NavigationService.h
    src/PhoneService.cpp
    src/PhoneService.cpp
    src/PhoneService.h
    src/ContactsModel.cpp
    src/ContactsModel.h
    src/HAL/IVehicleHAL.h
    src/HAL/SimulatedVehicleHAL.h
    src/HAL/SimulatedVehicleHAL.cpp
    src/HAL/IAudioHAL.h
    src/HAL/SimulatedAudioHAL.h
    src/HAL/SimulatedAudioHAL.cpp
    src/TranslationService.cpp
    src/TranslationService.h
    src/Models/RadioModel.h
    src/Models/RadioModel.cpp
    src/Models/PlaylistModel.h
    src/Models/PlaylistModel.cpp
)

# Declare singletons BEFORE qt_add_qml_module
set_source_files_properties(qml/NordicTheme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(qml/Theme/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(qml/Services/ConnectivityService.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)


qt_add_qml_module(appNordicHeadunit
    URI "NordicHeadunit"
    VERSION 1.0
    # Singleton sources must be declared separately
    QML_FILES
        qml/Main.qml
        qml/NordicTheme.qml
        qml/Theme/Theme.qml
        qml/Layouts/AppLayout.qml
        qml/Layouts/DockBar.qml
        qml/Layouts/StatusBar.qml
    qml/Layouts/NowPlayingBar.qml
    qml/Layouts/ClimateBar.qml
    qml/Layouts/PersistentBottomBar.qml
        qml/Components/ToastManager.qml
    qml/Components/NordicPageRouter.qml
    qml/Pages/HomePage.qml
    qml/Pages/MediaPage.qml
    qml/Pages/SettingsPage.qml
    qml/Pages/VehiclePage.qml
    qml/Pages/PhonePage.qml
    qml/Pages/Phone/KeypadView.qml
    qml/Pages/Phone/ContactsView.qml
    qml/Pages/Phone/FavoritesView.qml
    qml/Pages/Phone/ActiveCallView.qml
    qml/Pages/Phone/RecentsView.qml
    qml/Pages/Media/PlayerView.qml
    qml/Pages/Media/BrowseView.qml
    qml/Pages/Media/SourcesView.qml
    qml/Pages/Media/RadioView.qml
    qml/Pages/MapPage.qml
    qml/Overlays/VolumeOverlay.qml
    qml/Overlays/ControlCenter.qml
    qml/Overlays/ClimateOverlay.qml
    qml/Overlays/RearCameraOverlay.qml
    qml/Overlays/NotificationCenter.qml
    qml/Overlays/VoiceOverlay.qml
    qml/Overlays/TelephonyOverlay.qml
    qml/Services/ConnectivityService.qml

    qml/Services/AudioPolicy.qml
    qml/Overlays/OverlayManager.qml
    qml/Components/NordicButton.qml
        qml/Components/NordicCard.qml
        qml/Components/NordicGlass.qml
        qml/Components/NordicCircularGauge.qml
        qml/Components/NordicIcon.qml
        qml/Components/NordicListItem.qml
        qml/Components/NordicSlider.qml
        qml/Components/NordicText.qml
        qml/Components/NordicTextField.qml
    qml/Components/NordicModal.qml
    qml/Components/NordicToast.qml
    qml/Components/NordicSpinner.qml
    qml/Components/StatusIndicator.qml
    qml/Components/DraggableWidget.qml
    qml/Components/WidgetGrid.qml
    qml/Components/MediaControlButton.qml
    # Premium Maps Components
    qml/Components/Maps/MapSurface.qml
    qml/Components/Maps/GuidanceBanner.qml
    qml/Components/Maps/SearchSheet.qml
    qml/Components/Maps/RoutePreviewSheet.qml
    qml/Components/Maps/FloatingMapControls.qml
    qml/Widgets/NavigationWidget.qml
    qml/Widgets/WeatherWidget.qml
    qml/Widgets/NowPlayingWidget.qml
    qml/Widgets/QuickActionWidget.qml
    qml/Widgets/SystemsWidget.qml
    qml/Widgets/ClockWidget.qml
    qml/Widgets/CompassWidget.qml
    qml/Widgets/TripInfoWidget.qml
    qml/Widgets/SpeedWidget.qml
    qml/Widgets/RangeWidget.qml
    qml/Widgets/ParkingWidget.qml
    qml/Widgets/CalendarWidget.qml
    qml/Widgets/FavoritesWidget.qml
    qml/Widgets/ClimateWidget.qml
    # Settings Components
    qml/Components/SettingsSubPage.qml
    qml/Components/SettingsCategory.qml
    qml/Components/SettingsItem.qml
    qml/Components/SettingsToggle.qml
    qml/Components/SettingsSlider.qml
    # Phase 1: Audio
    qml/Components/BalanceFader.qml
    qml/Components/Equalizer.qml
    qml/Pages/Settings/AudioSettings.qml
    qml/Pages/Settings/WifiSettings.qml
    qml/Pages/Settings/BluetoothSettings.qml
    qml/Pages/Settings/DisplaySettings.qml
    qml/Pages/Settings/ConnectivitySettings.qml
    qml/Pages/Settings/VehicleSettings.qml
    qml/Pages/Settings/SystemSettingsPage.qml
    qml/Pages/Settings/SettingsSplitLayout.qml
    qml/Pages/Settings/SettingsSidebar.qml
    qml/Pages/Settings/MapSettings.qml
    qml/Pages/Settings/NavigationSettings.qml
    qml/Pages/Settings/PrivacySettings.qml
    qml/Pages/Settings/DateTimeSettings.qml
    qml/Pages/Settings/LanguageSettings.qml
    qml/Pages/Settings/ThemePlayground.qml
    RESOURCES
        assets/icons/car.svg
        assets/icons/home.svg
        assets/icons/map.svg
        assets/icons/music.svg
        assets/icons/phone.svg
        assets/icons/wifi.svg
        assets/icons/bluetooth.svg
        assets/icons/settings.svg
        assets/icons/signal.svg
        assets/icons/delete.svg
        assets/icons/battery.svg
        assets/icons/battery-full.svg
        assets/icons/play.svg
        assets/icons/pause.svg
        assets/icons/skip_next.svg
        assets/icons/skip_previous.svg
        assets/icons/shuffle.svg
        assets/icons/repeat.svg
        assets/icons/heart.svg
        assets/icons/volume_off.svg
        assets/icons/volume_up.svg
        assets/icons/weather_snow.svg
        assets/icons/weather_cloudy.svg
        assets/icons/weather_sunny.svg
        assets/icons/weather_partly_cloudy.svg
        assets/icons/fuel.svg
        assets/icons/edit.svg
        assets/icons/focus.svg
        assets/icons/car_info.svg
        assets/icons/clock.svg
        assets/icons/lock.svg
        assets/icons/lock_open.svg
        assets/icons/compass.svg
        assets/icons/list.svg
        assets/icons/play_arrow.svg
        assets/icons/speed.svg
        assets/icons/keypad.svg
        assets/icons/add_call.svg
        assets/icons/speaker.svg
        assets/icons/search.svg
        assets/icons/mic.svg
        assets/icons/turn_right.svg
        assets/icons/turn_left.svg
        assets/icons/u_turn.svg
        assets/icons/fan.svg
        assets/icons/windscreen_defrost.svg
        assets/icons/heated-front-seat.svg
        assets/icons/ventilated-front-seat.svg
        assets/icons/rear-window-defrost.svg
        assets/icons/navigation-arrow.svg
        assets/icons/check.svg
        assets/icons/radio-tower.svg
        assets/icons/cup-of-coffee.svg
        assets/icons/food-dinner.svg
        assets/icons/parking-location.svg
        assets/icons/gas-station.svg
        assets/icons/charging-station.svg
        assets/icons/chevron_down.svg
)

if(COMMAND qt6_add_translations)
    qt6_add_translations(appNordicHeadunit
        TS_FILES
            i18n/nordic_en_US.ts
            i18n/nordic_sv_SE.ts
            i18n/nordic_de_DE.ts
        RESOURCE_PREFIX "/i18n"
    )
else()
    qt6_add_lrelease(appNordicHeadunit
        TS_FILES
            i18n/nordic_en_US.ts
            i18n/nordic_sv_SE.ts
            i18n/nordic_de_DE.ts
        QM_FILES_OUTPUT_VARIABLE qm_files
    )
    qt6_add_resources(appNordicHeadunit "translations"
        PREFIX "/i18n"
        FILES ${qm_files}
    )
endif()

# Note: Singleton declarations are now before qt_add_qml_module above

# Link against Qt modules
target_link_libraries(appNordicHeadunit
    PRIVATE Qt6::Quick
    PRIVATE Qt6::QuickControls2
    PRIVATE Qt6::QuickEffects
    PRIVATE Qt6::Network
    PRIVATE Qt6::Location
    PRIVATE Qt6::Positioning
    PRIVATE Qt6::Multimedia
    PRIVATE Qt6::Concurrent
)

# Test Target
add_executable(test_media
    src/tests/MediaTest.cpp
    src/RadioTuner.cpp
    src/Models/RadioModel.cpp
    src/MediaLibrary.cpp
    src/Models/PlaylistModel.cpp
)
target_include_directories(test_media PRIVATE src)
target_link_libraries(test_media
    PRIVATE Qt6::Core
    PRIVATE Qt6::Multimedia
    PRIVATE Qt6::Concurrent
)

# Resources
# (Future: Add fonts and icons here)
