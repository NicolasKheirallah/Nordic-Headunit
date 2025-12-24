pragma Singleton
import QtQuick

// Centralized Widget Registry
// Acts as the Single Source of Truth for all available widgets, their default sizes,
// icons, and QML source paths.
QtObject {
    id: registry
    
    // API to get widget metadata
    function get(type) {
        return widgets[type] || null
    }
    
    function getAllTypes() {
        return Object.keys(widgets)
    }
    
    // Internal Registry Data
    // NOTE: In a larger system, this could be loaded from a JSON file or plugin system
    readonly property var widgets: ({
        // ---------------------------------------------------------------------
        // CORE FEATURES
        // ---------------------------------------------------------------------
        "navigation": { 
            label: qsTr("Navigation"), 
            icon: "map", 
            source: "../Widgets/NavigationWidget.qml",
            defaultW: 2, defaultH: 2, 
            allowedSizes: [[2,2], [3,2], [2,1], [3,1]],
            tabIndex: 1, // Targets Map Page
            canDelete: true 
        },
        "nowPlaying": { 
            label: qsTr("Now Playing"), 
            icon: "music", 
            source: "../Widgets/NowPlayingWidget.qml",
            defaultW: 2, defaultH: 1, 
            allowedSizes: [[2,1], [3,1], [2,2], [1,1]],
            tabIndex: 2, // Targets Media Page
            canDelete: true 
        },
        "weather": { 
            label: qsTr("Weather"), 
            icon: "weather_cloudy", 
            source: "../Widgets/WeatherWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1], [1,2]],
            tabIndex: 0,
            canDelete: true 
        },
        "systems": { 
            label: qsTr("Systems"), 
            icon: "car", 
            source: "../Widgets/SystemsWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1]],
            tabIndex: 4, 
            canDelete: true,
            isComplex: true 
        },
        
        // ---------------------------------------------------------------------
        // INFO & TOOLS
        // ---------------------------------------------------------------------
        "clock": { 
            label: qsTr("Clock"), 
            icon: "clock", 
            source: "../Widgets/ClockWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1]],
            tabIndex: 0,
            canDelete: true 
        },
        "compass": { 
            label: qsTr("Compass"), 
            icon: "compass", 
            source: "../Widgets/CompassWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1]],
            tabIndex: 1,
            canDelete: true 
        },
        "tripInfo": { 
            label: qsTr("Trip Info"), 
            icon: "car_info", 
            source: "../Widgets/TripInfoWidget.qml",
            defaultW: 2, defaultH: 1, 
            allowedSizes: [[2,1], [3,1], [1,1]],
            tabIndex: 4,
            canDelete: true 
        },
        "calendar": { 
            label: qsTr("Calendar"), 
            icon: "settings", 
            source: "../Widgets/CalendarWidget.qml",
            defaultW: 1, defaultH: 2, 
            allowedSizes: [[1,2], [2,2], [1,1]],
            tabIndex: 0,
            canDelete: true,
            isComplex: true 
        },
        "favorites": { 
            label: qsTr("Favorites"), 
            icon: "heart", 
            source: "../Widgets/FavoritesWidget.qml",
            defaultW: 2, defaultH: 2, 
            allowedSizes: [[2,2], [2,1], [1,2]],
            tabIndex: 0,
            canDelete: true,
            isComplex: true 
        },
        
        // ---------------------------------------------------------------------
        // DRIVING DATA
        // ---------------------------------------------------------------------
        "speed": { 
            label: qsTr("Speed"), 
            icon: "speed", 
            source: "../Widgets/SpeedWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1], [2,2]],
            tabIndex: 4,
            canDelete: true 
        },
        "range": { 
            label: qsTr("Range"), 
            icon: "battery", 
            source: "../Widgets/RangeWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1]],
            tabIndex: 4,
            canDelete: true 
        },
        "parking": { 
            label: qsTr("Parking"), 
            icon: "car", 
            source: "../Widgets/ParkingWidget.qml",
            defaultW: 2, defaultH: 2, 
            allowedSizes: [[2,2], [2,1]],
            tabIndex: 4,
            canDelete: true 
        },
        "climate": { 
            label: qsTr("Climate"), 
            icon: "settings", 
            source: "../Widgets/ClimateWidget.qml",
            defaultW: 2, defaultH: 1, 
            allowedSizes: [[2,1], [3,1], [2,2]],
            tabIndex: 4,
            canDelete: true,
            isComplex: true 
        },

        // ---------------------------------------------------------------------
        // QUICK ACTIONS
        // ---------------------------------------------------------------------
        "quickCall": { 
            label: qsTr("Call"), 
            icon: "phone", 
            source: "../Widgets/QuickActionWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1]], 
            tabIndex: 3, 
            canDelete: true 
        },
        "quickMedia": { 
            label: qsTr("Media"), 
            icon: "music", 
            source: "../Widgets/QuickActionWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1]], 
            tabIndex: 2, 
            canDelete: true 
        },
        "quickVehicle": { 
            label: qsTr("Vehicle"), 
            icon: "car", 
            source: "../Widgets/QuickActionWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1]], 
            tabIndex: 4, 
            canDelete: true 
        },
        "quickSettings": { 
            label: qsTr("Settings"), 
            icon: "settings", 
            source: "../Widgets/QuickActionWidget.qml",
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1]], 
            tabIndex: 5, 
            canDelete: true 
        }
    })
}
