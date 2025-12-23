import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Climate Bottom Bar - Persistent comfort controls
// User-centric: One-tap adjustments, instant feedback, always available
Rectangle {
    id: root
    
    color: NordicTheme.colors.bg.surface
    
    // Fixed height, never changes (per HMI spec)
    implicitHeight: NordicTheme.layout.bottomBarHeight
    
    // Border top for visual separation
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: NordicTheme.colors.border.muted
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: NordicTheme.spacing.space_4
        anchors.rightMargin: NordicTheme.spacing.space_4
        spacing: NordicTheme.spacing.space_2
        
        // =====================================================================
        // Driver Temperature
        // =====================================================================
        RowLayout {
            Layout.fillHeight: true
            spacing: NordicTheme.spacing.space_2
            
            // Minus button
            Rectangle {
                width: 44; height: 44
                radius: 8
                color: tempMinusDriver.pressed ? Theme.surfaceAlt : "transparent"
                Layout.alignment: Qt.AlignVCenter
                
                NordicText {
                    anchors.centerIn: parent
                    text: "−"
                    type: NordicText.Type.TitleLarge
                    color: Theme.textSecondary
                }
                
                MouseArea {
                    id: tempMinusDriver
                    anchors.fill: parent
                    onClicked: VehicleService.driverTemp = Math.max(16, VehicleService.driverTemp - 1)
                }
            }
            
            // Temperature Display
            ColumnLayout {
                spacing: 2
                Layout.alignment: Qt.AlignVCenter
                
                NordicText {
                    text: VehicleService.driverTemp + "°"
                    type: NordicText.Type.TitleLarge
                    Layout.alignment: Qt.AlignHCenter
                }
                NordicText {
                    visible: !NordicTheme.layout.isCompact // Hide in Compact
                    text: "Driver"
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.tertiary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            // Plus button
            Rectangle {
                width: 44; height: 44
                radius: 8
                color: tempPlusDriver.pressed ? Theme.surfaceAlt : "transparent"
                Layout.alignment: Qt.AlignVCenter
                
                NordicText {
                    anchors.centerIn: parent
                    text: "+"
                    type: NordicText.Type.TitleLarge
                    color: Theme.textSecondary
                }
                
                MouseArea {
                    id: tempPlusDriver
                    anchors.fill: parent
                    onClicked: VehicleService.driverTemp = Math.min(28, VehicleService.driverTemp + 1)
                }
            }
        }
        
        // Separator
        Rectangle {
            width: 1; height: 32
            color: NordicTheme.colors.border.muted
            Layout.alignment: Qt.AlignVCenter
        }
        
        // =====================================================================
        // Passenger Temperature (Dual Zone)
        // =====================================================================
        RowLayout {
            Layout.fillHeight: true
            spacing: NordicTheme.spacing.space_2
            
            // Minus button
            Rectangle {
                width: 44; height: 44
                radius: 8
                color: tempMinusPass.pressed ? Theme.surfaceAlt : "transparent"
                Layout.alignment: Qt.AlignVCenter
                
                NordicText {
                    anchors.centerIn: parent
                    text: "−"
                    type: NordicText.Type.TitleLarge
                    color: Theme.textSecondary
                }
                
                MouseArea {
                    id: tempMinusPass
                    anchors.fill: parent
                    onClicked: VehicleService.passengerTemp = Math.max(16, VehicleService.passengerTemp - 1)
                }
            }
            
            // Temperature Display
            ColumnLayout {
                spacing: 2
                Layout.alignment: Qt.AlignVCenter
                
                NordicText {
                    text: VehicleService.passengerTemp + "°"
                    type: NordicText.Type.TitleLarge
                    Layout.alignment: Qt.AlignHCenter
                }
                NordicText {
                    visible: !NordicTheme.layout.isCompact // Hide in Compact
                    text: "Passenger"
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.tertiary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            // Plus button
            Rectangle {
                width: 44; height: 44
                radius: 8
                color: tempPlusPass.pressed ? Theme.surfaceAlt : "transparent"
                Layout.alignment: Qt.AlignVCenter
                
                NordicText {
                    anchors.centerIn: parent
                    text: "+"
                    type: NordicText.Type.TitleLarge
                    color: Theme.textSecondary
                }
                
                MouseArea {
                    id: tempPlusPass
                    anchors.fill: parent
                    onClicked: VehicleService.passengerTemp = Math.min(28, VehicleService.passengerTemp + 1)
                }
            }
        }
        
        // Separator
        Rectangle {
            width: 1; height: 32
            color: NordicTheme.colors.border.muted
            Layout.alignment: Qt.AlignVCenter
        }
        
        // =====================================================================
        // Seat Heating Toggles
        // =====================================================================
        RowLayout {
            spacing: NordicTheme.spacing.space_2
            Layout.alignment: Qt.AlignVCenter
            
            // Driver Seat
            Rectangle {
                width: 48; height: 48
                radius: 8
                color: VehicleService.leftSeatHeat 
                    ? Theme.accent 
                    : Theme.surfaceAlt
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 0
                    
                    NordicText {
                        text: "🔥"
                        type: NordicText.Type.BodyMedium
                        Layout.alignment: Qt.AlignHCenter
                    }
                    NordicText {
                        text: "L"
                        type: NordicText.Type.Caption
                        color: VehicleService.leftSeatHeat ? "white" : NordicTheme.colors.text.tertiary
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: VehicleService.leftSeatHeat = !VehicleService.leftSeatHeat
                }
            }
            
            // Passenger Seat
            Rectangle {
                width: 48; height: 48
                radius: 8
                color: VehicleService.rightSeatHeat 
                    ? Theme.accent 
                    : Theme.surfaceAlt
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 0
                    
                    NordicText {
                        text: "🔥"
                        type: NordicText.Type.BodyMedium
                        Layout.alignment: Qt.AlignHCenter
                    }
                    NordicText {
                        text: "R"
                        type: NordicText.Type.Caption
                        color: VehicleService.rightSeatHeat ? "white" : NordicTheme.colors.text.tertiary
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: VehicleService.rightSeatHeat = !VehicleService.rightSeatHeat
                }
            }
        }
        
        // Spacer
        Item { Layout.fillWidth: true }
        
        // =====================================================================
        // Auto Mode Toggle
        // =====================================================================
        Rectangle {
            width: 64; height: 48
            radius: 8
            color: VehicleService.autoClimate 
                ? Theme.accent 
                : Theme.surfaceAlt
            Layout.alignment: Qt.AlignVCenter
            
            NordicText {
                anchors.centerIn: parent
                text: "AUTO"
                type: NordicText.Type.TitleSmall
                color: VehicleService.autoClimate ? "white" : Theme.textSecondary
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: VehicleService.autoClimate = !VehicleService.autoClimate
            }
        }
        
        // =====================================================================
        // Defrost Button (Contextual Safety)
        // =====================================================================
        Rectangle {
            width: 48; height: 48
            radius: 8
            color: VehicleService.defrostEnabled 
                ? NordicTheme.colors.semantic.info 
                : Theme.surfaceAlt
            Layout.alignment: Qt.AlignVCenter
            
            NordicIcon {
                anchors.centerIn: parent
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/weather_snow.svg"
                size: NordicIcon.Size.MD
                color: VehicleService.defrostEnabled ? "white" : Theme.textSecondary
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: VehicleService.defrostEnabled = !VehicleService.defrostEnabled
            }
        }
    }
}
