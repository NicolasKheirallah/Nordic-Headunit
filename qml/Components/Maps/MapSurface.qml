import QtQuick
import QtQuick.Controls
import QtLocation
import QtPositioning
import QtQuick.Effects
import NordicHeadunit

// Production Vector Map Surface (MapLibre)
Item {
    id: root

    // API
    property real zoomLevel: 14.0
    property real tilt: 0.0
    property real bearing: 0.0
    property geoCoordinate center: QtPositioning.coordinate(59.3293, 18.0686)
    property geoCoordinate userLocation: center // Alias removed due to Loader scoping
    property var routePath: [] // Coordinates for polyline
    property bool showTraffic: false
    property bool showRange: false // EV Range Ring

    // Style Logic
    property int mapStyle: SystemSettings.mapStyle
    property string tileUrl: {
        switch(mapStyle) {
            case 1: return "https://a.basemaps.cartocdn.com/dark_all/" // Dark
            case 2: return "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/" // Satellite
            case 3: return "https://a.basemaps.cartocdn.com/light_all/" // Hybrid/Light placeholder
            default: return "https://tile.openstreetmap.org/" // Standard
        }
    }

    // NOTE: Plugin is now defined INSIDE mapComponent for dynamic tileUrl binding

    // Reboot Loader when Style changes (to refresh tiles)
    onTileUrlChanged: {
        console.info("Refreshing Map Tiles for Style: " + mapStyle)
        mapLoader.active = false
        rebootTimer.start()
    }

    Timer {
        id: rebootTimer
        interval: 100 
        onTriggered: {
             mapLoader.active = true
        }
    }
    
    function setZoom(newZoom) {
        zoomLevel = newZoom
    }
    
    function generateRangeCircle(center, radiusMeters) {
        var points = []
        var lat = center.latitude
        var lon = center.longitude
        var d_lat = radiusMeters / 111320.0
        var d_lon = radiusMeters / (40075000.0 * Math.cos(lat * Math.PI / 180.0) / 360.0)
        
        for (var i = 0; i <= 360; i += 10) {
            var theta = i * Math.PI / 180.0
            var plat = lat + (d_lat * Math.sin(theta))
            var plon = lon + (d_lon * Math.cos(theta))
            points.push(QtPositioning.coordinate(plat, plon))
        }
        return points
    }

    // -------------------------------------------------------------------------
    // Map Engine Loader
    // -------------------------------------------------------------------------
    Loader {
        id: mapLoader
        anchors.fill: parent
        sourceComponent: mapComponent
    }
    
    Component {
        id: mapComponent
        
        Map {
            id: mapContent
            anchors.fill: parent
            
            // Plugin defined INSIDE Component - recreated with fresh tileUrl on each reload
            plugin: Plugin {
                name: "osm"
                PluginParameter { name: "osm.mapping.custom.host"; value: root.tileUrl }
                PluginParameter { name: "osm.mapping.providersrepository.disabled"; value: "true" }
                PluginParameter { name: "osm.mapping.providersrepository.address"; value: "http://maps-redirect.qt.io/osm/5.6/" }
            }
            
            onCopyrightLinkActivated: Qt.openUrlExternally(link)
            
            // Robust Error Handling
            onErrorChanged: {
                if (mapContent.error !== Map.NoError) {
                    console.warn("Map Error: " + mapContent.errorString)
                }
            }
            
            // Camera Properties
            center: root.center
            zoomLevel: root.zoomLevel
            tilt: root.tilt
            bearing: root.bearing
            
            // OSM Attribution (Required by License)
            copyrightsVisible: true
            
            property geoCoordinate userLocation: root.center

            // Route Line (Shadow Layer - for visibility on busy tiles)
            MapPolyline {
                id: routeShadow
                line.width: 18
                line.color: "#000000"
                opacity: 0.4
                path: root.routePath
            }
            
            // Route Line (Outline Layer - Dark Accent)
            MapPolyline {
                id: routeOutline
                line.width: 14
                line.color: Qt.darker(Theme.accent, 1.6)
                path: root.routePath
            }
            
            // Route Line (Fill Layer - Accent)
            MapPolyline {
                id: routeLine
                line.width: 10
                line.color: Theme.accent
                path: root.routePath
            }

            // Traffic Segments Overlay (Premium Traffic Flow)
            MapItemView {
                model: NavigationService.trafficSegments
                visible: root.showTraffic
                delegate: MapPolyline {
                    line.width: 10
                    line.color: modelData.color
                    path: modelData.path
                    opacity: 0.8
                }
            }

            // EV Range Ring (Polygon)
            MapPolygon {
                id: rangeRing
                visible: root.showRange
                color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
                border.color: Theme.accent
                border.width: 2
                path: root.generateRangeCircle(root.userLocation, 15000) // 15km Range Mock
            }
            
            // GPS Accuracy Circle (Breathable Animation)
            MapCircle {
                id: accuracyCircle
                center: NavigationService.vehiclePosition
                radius: 50 // Meters - would be dynamic from GPS accuracy
                color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.1)
                border.color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.3)
                border.width: 2
                
                // Breathing animation
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.8; to: 0.4; duration: 1500; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 0.4; to: 0.8; duration: 1500; easing.type: Easing.InOutSine }
                }
            }
            
            // Vehicle Cursor (3D Puck)
            MapQuickItem {
                id: vehicleCursor
                coordinate: NavigationService.vehiclePosition
                anchorPoint.x: carContainer.width / 2
                anchorPoint.y: carContainer.height / 2

                sourceItem: Item {
                    id: carContainer
                    width: 80; height: 80
                    
                    rotation: NavigationService.vehicleBearing - mapContent.bearing
                    
                    Behavior on rotation { RotationAnimation { duration: 150; direction: RotationAnimation.Shortest } }

                    // Glow
                    Rectangle {
                        anchors.centerIn: parent
                        width: 60; height: 60
                        radius: 30
                        color: Theme.accent
                        opacity: 0.6
                    }
                    
                    // Icon
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                        size: NordicIcon.Size.XL
                        color: "white"
                    }
                }
            }
            
            // Map Pins (Search Results)
            MapItemView {
                model: NavigationService.mapPins
                delegate: MapQuickItem {
                    coordinate: QtPositioning.coordinate(modelData.latitude, modelData.longitude)
                    anchorPoint.x: pinIcon.width / 2
                    anchorPoint.y: pinIcon.height
                    
                    sourceItem: NordicIcon {
                        id: pinIcon
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg"
                        size: NordicIcon.Size.XL
                        color: Theme.danger // Red pin
                        
                        // Valid name label
                        Rectangle {
                            anchors.bottom: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: pinText.implicitWidth + 16
                            height: 24
                            color: Theme.surfaceAlt
                            radius: 4
                            
                            NordicText {
                                id: pinText
                                anchors.centerIn: parent
                                text: modelData.name
                                type: NordicText.Type.Caption
                            }
                        }
                    }
                }
            }
            // Behaviors
            Behavior on zoomLevel { enabled: !SystemSettings.reducedMotion; NumberAnimation { duration: 800; easing.type: Easing.OutCubic } }
            Behavior on center { enabled: !SystemSettings.reducedMotion; CoordinateAnimation { duration: 800; easing.type: Easing.OutCubic } }
            Behavior on tilt { enabled: !SystemSettings.reducedMotion; NumberAnimation { duration: 1000; easing.type: Easing.OutQuint } }
            Behavior on bearing { enabled: !SystemSettings.reducedMotion; NumberAnimation { duration: 1000; easing.type: Easing.OutQuint } }
        }
    }
}
