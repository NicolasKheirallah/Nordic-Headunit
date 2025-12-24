import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Range Widget - Size-aware EV/Fuel range display
Item {
    id: root
    
    // Size detection for adaptive content
    readonly property bool isCompact: width < 150 || height < 120
    readonly property bool isLarge: width >= 250 && height >= 200
    
    // Range data
    property int currentRange: VehicleService?.range ?? 342
    property int batteryPercent: VehicleService?.batteryLevel ?? 78
    property bool isEV: VehicleService?.isElectric ?? true
    property bool isCharging: VehicleService?.isCharging ?? false
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_2
            
            // Battery/Fuel icon with level
            Item {
                Layout.alignment: Qt.AlignHCenter
                // Scale battery icon with widget size
                Layout.preferredWidth: Math.min(root.width * 0.4, 80)
                Layout.preferredHeight: Layout.preferredWidth * 0.45
                
                Rectangle {
                    anchors.fill: parent
                    radius: 4
                    color: "transparent"
                    border.width: 2
                    border.color: root.batteryPercent < 20 ? NordicTheme.colors.semantic.warning : NordicTheme.colors.text.secondary
                    
                    // Battery tip
                    Rectangle {
                        anchors.left: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.height * 0.15; height: parent.height * 0.5
                        radius: 2
                        color: parent.border.color
                    }
                    
                    // Fill level
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.margins: 3
                        width: (parent.width - 6) * (root.batteryPercent / 100)
                        radius: 2
                        color: {
                            if (root.batteryPercent < 20) return NordicTheme.colors.semantic.error
                            if (root.batteryPercent < 40) return NordicTheme.colors.semantic.warning
                            return NordicTheme.colors.semantic.success
                        }
                        
                        Behavior on width { NumberAnimation { duration: 500 } }
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }
                }
                
                // Charging indicator
                NordicText {
                    anchors.centerIn: parent
                    text: "⚡"
                    visible: root.isCharging
                    font.pixelSize: parent.height * 0.8
                }
            }
            
            // Percentage
            NordicText {
                text: root.batteryPercent + "%"
                type: NordicText.Type.TitleLarge
                color: NordicTheme.colors.text.primary
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Range
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                
                NordicText {
                    text: root.currentRange.toString()
                    type: NordicText.Type.TitleMedium
                    color: Theme.accent
                }
                NordicText {
                    text: "km"
                    type: NordicText.Type.BodySmall
                    color: NordicTheme.colors.text.secondary
                }
            }
            
            NordicText {
                text: root.isCharging ? qsTr("Charging...") : qsTr("Range")
                type: NordicText.Type.Caption
                color: NordicTheme.colors.text.tertiary
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
