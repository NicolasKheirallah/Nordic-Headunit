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
    NordicCard {
        id: panel
        variant: NordicCard.Variant.Glass
        width: 320
        height: 100
        
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: visibleState ? 120 : -height 
        
        Behavior on anchors.bottomMargin { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
        
        // Interactive Content
        RowLayout {
            anchors.centerIn: parent
            spacing: Theme.spacingSm
            
            // Decrease Temp
            NordicButton {
                text: "-"
                variant: NordicButton.Variant.Tertiary
                size: NordicButton.Size.Sm
                onClicked: {
                    VehicleService.driverTemp = Math.max(16, VehicleService.driverTemp - 1)
                    hideTimer.restart()
                }
            }
            
            // Icon
            NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                size: NordicIcon.Size.MD
                color: Theme.accent
            }
            
            // Temperature Display
            ColumnLayout {
                spacing: 0
                NordicText {
                    text: "Cabin Temp"
                    type: NordicText.Type.Caption
                    color: Theme.textSecondary
                    Layout.alignment: Qt.AlignHCenter
                }
                NordicText {
                    text: root.temperature + "°C"
                    type: NordicText.Type.DisplayMedium
                    color: Theme.textPrimary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            // Increase Temp
            NordicButton {
                text: "+"
                variant: NordicButton.Variant.Tertiary
                size: NordicButton.Size.Sm
                onClicked: {
                    VehicleService.driverTemp = Math.min(30, VehicleService.driverTemp + 1)
                    hideTimer.restart()
                }
            }
        }
    }
}
