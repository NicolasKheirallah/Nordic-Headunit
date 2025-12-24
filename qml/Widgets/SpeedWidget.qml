import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Speed Widget - Size-aware speedometer display
Item {
    id: root
    
    // Size detection for adaptive content
    readonly property bool isCompact: width < 210 || height < 120
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
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0
                
                // Centered Speed
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: root.currentSpeed.toString()
                        type: NordicText.Type.DisplayLarge
                        color: root.isOverLimit ? NordicTheme.colors.semantic.warning : NordicTheme.colors.text.primary
                        
                        // Dynamic font size: 35% of width or 50% of height, whichever is smaller
                        // This ensures it fits in 2x1 (wide) and 1x2 (tall) and 2x2 (square)
                        font.pixelSize: Math.min(root.width * 0.4, root.height * 0.6)
                        fontSizeMode: Text.Fit
                        
                        // Tech Font Features
                        font.letterSpacing: 2
                        font.family: "Helvetica" 
                        
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }
                }
                
                // Unit Label (pushed to bottom of speed text area)
                NordicText {
                    text: root.speedUnit.toUpperCase()
                    type: NordicText.Type.BodySmall
                    color: NordicTheme.colors.text.secondary
                    font.letterSpacing: 1.5
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                    Layout.bottomMargin: root.height * 0.05
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
