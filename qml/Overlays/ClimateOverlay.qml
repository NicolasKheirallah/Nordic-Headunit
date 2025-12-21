import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

Item {
    id: root
    
    property int temperature: VehicleService.driverTemp
    property bool visibleState: false
    
    Timer {
        id: hideTimer
        interval: 3000
        onTriggered: root.visibleState = false
    }
    
    function show(temp) {
        // Guard against undefined temp parameter
        if (typeof temp === "number" && !isNaN(temp)) {
            VehicleService.driverTemp = temp
        }
        root.visibleState = true
        hideTimer.restart()
    }
    
    // Bottom Center Overlay
    Rectangle {
        id: panel
        width: 260
        height: 110
        radius: NordicTheme.shapes.radius_xl
        color: NordicTheme.colors.bg.elevated
        
        // Glass Blur
        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blurMax: 64
            blur: 1.0
            saturation: 1.2
        }
        
        // Gradient Border (Stroke)
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 1
            border.color: Qt.rgba(1,1,1,0.1)
        }
        
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: visibleState ? 120 : -height // Above DockBar/Nav
        
        Behavior on anchors.bottomMargin { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
        
        RowLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_4
            
            // Icon with Glow
            Item {
                width: 40; height: 40
                NordicIcon {
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                    size: NordicIcon.Size.LG
                    color: NordicTheme.colors.accent.primary
                }
            }
            
            // Temperature Display
            ColumnLayout {
                spacing: 0
                NordicText {
                    text: "Cabin Temp"
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.secondary
                }
                NordicText {
                    text: root.temperature + "°C"
                    type: NordicText.Type.DisplayMedium
                    color: NordicTheme.colors.text.primary
                }
            }
        }
    }
}
