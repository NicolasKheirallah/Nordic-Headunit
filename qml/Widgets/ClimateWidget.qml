import QtQuick
import QtQuick.Layouts
import NordicHeadunit
import "../Components"

// Climate Widget - Size-aware HVAC controls
Item {
    id: root
    
    // Size detection for adaptive content
    readonly property bool isCompact: width < 200 || height < 120
    readonly property bool isLarge: width >= 350 && height >= 150
    
    // Climate data
    property real driverTemp: VehicleService?.driverTemp ?? 22.0
    property real passengerTemp: VehicleService?.passengerTemp ?? 22.0
    property bool acOn: VehicleService?.acOn ?? true
    property int fanSpeed: VehicleService?.fanSpeed ?? 3
    property bool syncEnabled: VehicleService?.climateSync ?? true
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_3
            spacing: NordicTheme.spacing.space_2
            
            // Driver side (Always visible)
            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 4
                
                NordicText {
                    text: qsTr("Driver")
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.tertiary
                    visible: root.height > 140 // Hide label if very short
                }
                
                NordicText {
                    text: root.driverTemp.toFixed(1) + "°"
                    type: NordicText.Type.DisplayMedium
                    color: NordicTheme.colors.text.primary
                    Layout.alignment: Qt.AlignHCenter
                    fontSizeMode: Text.Fit
                    minimumPixelSize: 20
                }
                
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 4
                    visible: root.height > 120
                    
                    NordicButton {
                        variant: NordicButton.Variant.Tertiary
                        size: root.isCompact ? NordicButton.Size.Sm : NordicButton.Size.Md
                        text: "−"
                        onClicked: root.driverTemp = Math.max(16, root.driverTemp - 0.5)
                        Layout.preferredWidth: root.isCompact ? 32 : 40
                    }
                    NordicButton {
                        variant: NordicButton.Variant.Tertiary
                        size: root.isCompact ? NordicButton.Size.Sm : NordicButton.Size.Md
                        text: "+"
                        onClicked: root.driverTemp = Math.min(28, root.driverTemp + 0.5)
                        Layout.preferredWidth: root.isCompact ? 32 : 40
                    }
                }
            }
            
            // Center controls (Hide if very compact width < 250)
            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                visible: root.width > 260
                spacing: NordicTheme.spacing.space_2
                
                // AC button
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: Math.min(parent.width * 0.8, 48)
                    height: width
                    radius: width / 2
                    color: root.acOn ? Theme.accent : Theme.surfaceAlt
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: "A/C"
                        type: NordicText.Type.TitleSmall
                        color: root.acOn ? NordicTheme.colors.text.inverse : NordicTheme.colors.text.secondary
                        font.pixelSize: parent.height * 0.35
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.acOn = !root.acOn
                    }
                }
                
                // Fan speed
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 4
                    
                    Repeater {
                        model: 5
                        Rectangle {
                            width: 6
                            height: 6 + index * 3
                            radius: 2
                            color: index < root.fanSpeed ? Theme.accent : Theme.surfaceAlt
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.fanSpeed = index + 1
                            }
                        }
                    }
                }
            }
            
            // Passenger side (Hide if width < 300 or sync enabled)
            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 4
                visible: !root.syncEnabled && root.width > 340
                
                NordicText {
                    text: qsTr("Pass.")
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.tertiary
                    visible: root.height > 140
                }
                
                NordicText {
                    text: root.passengerTemp.toFixed(1) + "°"
                    type: NordicText.Type.DisplayMedium
                    color: NordicTheme.colors.text.primary
                    Layout.alignment: Qt.AlignHCenter
                    fontSizeMode: Text.Fit
                    minimumPixelSize: 20
                }
                
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 4
                    visible: root.height > 120
                    
                    NordicButton {
                        variant: NordicButton.Variant.Tertiary
                        size: NordicButton.Size.Sm
                        text: "−"
                        onClicked: root.passengerTemp = Math.max(16, root.passengerTemp - 0.5)
                    }
                    NordicButton {
                        variant: NordicButton.Variant.Tertiary
                        size: NordicButton.Size.Sm
                        text: "+"
                        onClicked: root.passengerTemp = Math.min(28, root.passengerTemp + 0.5)
                    }
                }
            }
        }
    }
}
