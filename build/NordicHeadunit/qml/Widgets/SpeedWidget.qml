import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Speed Widget - Size-aware speedometer display
Item {
    id: root
    
    // Size detection for adaptive content
    readonly property bool isCompact: width < 150 || height < 120
    readonly property bool isLarge: width >= 250 && height >= 200
    
    // Live speed data (would come from VehicleService)
    property int currentSpeed: VehicleService?.speed ?? 72
    property int speedLimit: VehicleService?.speedLimit ?? 80
    property string speedUnit: "km/h"
    property bool isOverLimit: currentSpeed > speedLimit
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_1
            
            // Large speed display
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                
                NordicText {
                    text: root.currentSpeed.toString()
                    type: NordicText.Type.DisplayLarge
                    color: root.isOverLimit ? NordicTheme.colors.semantic.warning : NordicTheme.colors.text.primary
                    font.pixelSize: Math.min(parent.parent.parent.width * 0.3, 72)
                    // Tech Font Features
                    font.letterSpacing: 2
                    font.family: "Helvetica" // Fallback to a mono/technical font if available, or system default
                    
                    Behavior on color { ColorAnimation { duration: 300 } }
                }
                
                ColumnLayout {
                    spacing: 0
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 8
                    
                    NordicText {
                        text: root.speedUnit.toUpperCase()
                        type: NordicText.Type.BodySmall
                        color: NordicTheme.colors.text.secondary
                        font.letterSpacing: 1.5
                        font.bold: true
                    }
                }
            }
            
            // Speed limit indicator
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: NordicTheme.spacing.space_2
                
                Rectangle {
                    width: 24; height: 24
                    radius: 12
                    color: "transparent"
                    border.width: 2
                    border.color: NordicTheme.colors.semantic.error
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: root.speedLimit.toString()
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.primary
                        font.bold: true
                    }
                }
                
                NordicText {
                    text: qsTr("Speed Limit")
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.tertiary
                }
            }
        }
    }
}
