import QtQuick
import QtQuick.Layouts
import NordicHeadunit

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
            spacing: NordicTheme.spacing.space_4
            
            // Driver side
            ColumnLayout {
                Layout.fillHeight: true
                spacing: 4
                
                NordicText {
                    text: qsTr("Driver")
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.tertiary
                }
                
                NordicText {
                    text: root.driverTemp.toFixed(1) + "°"
                    type: NordicText.Type.TitleLarge
                    color: NordicTheme.colors.text.primary
                }
                
                RowLayout {
                    spacing: 4
                    
                    NordicButton {
                        variant: NordicButton.Variant.Tertiary
                        size: NordicButton.Size.Sm
                        text: "−"
                        onClicked: root.driverTemp = Math.max(16, root.driverTemp - 0.5)
                    }
                    NordicButton {
                        variant: NordicButton.Variant.Tertiary
                        size: NordicButton.Size.Sm
                        text: "+"
                        onClicked: root.driverTemp = Math.min(28, root.driverTemp + 0.5)
                    }
                }
            }
            
            // Center controls
            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: NordicTheme.spacing.space_2
                
                // AC button
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 48; height: 48
                    radius: 24
                    color: root.acOn ? Theme.accent : Theme.surfaceAlt
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: "A/C"
                        type: NordicText.Type.TitleSmall
                        color: root.acOn ? NordicTheme.colors.text.inverse : NordicTheme.colors.text.secondary
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
                            width: 8
                            height: 8 + index * 4
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
                
                // Sync button
                NordicButton {
                    Layout.alignment: Qt.AlignHCenter
                    variant: root.syncEnabled ? NordicButton.Variant.Primary : NordicButton.Variant.Tertiary
                    size: NordicButton.Size.Sm
                    text: qsTr("SYNC")
                    onClicked: root.syncEnabled = !root.syncEnabled
                }
            }
            
            // Passenger side
            ColumnLayout {
                Layout.fillHeight: true
                spacing: 4
                visible: !root.syncEnabled
                
                NordicText {
                    text: qsTr("Passenger")
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.tertiary
                }
                
                NordicText {
                    text: root.passengerTemp.toFixed(1) + "°"
                    type: NordicText.Type.TitleLarge
                    color: NordicTheme.colors.text.primary
                }
                
                RowLayout {
                    spacing: 4
                    
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
