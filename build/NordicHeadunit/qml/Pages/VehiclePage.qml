import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Vehicle Page - Data-First, Insight-Driven Overview
// "How is my car doing right now?" - Not "What can I toggle?"
Page {
    id: root
    
    background: Rectangle { color: NordicTheme.colors.bg.primary }
    
    // Safe property access with fallbacks
    readonly property int batteryLevel: VehicleService?.batteryLevel ?? 0
    readonly property int range: VehicleService?.range ?? 0
    readonly property string connectionState: VehicleService?.connectionState ?? "Unknown"
    readonly property string ignitionState: VehicleService?.ignitionState ?? "Unknown"
    readonly property string lastUpdateTime: VehicleService?.lastUpdateTime ?? "--:--"
    readonly property string batteryStatus: VehicleService?.batteryStatus ?? "Unknown"
    readonly property string doorsStatus: VehicleService?.doorsStatus ?? "Unknown"
    readonly property bool handbrakeEngaged: VehicleService?.handbrakeEngaged ?? true
    readonly property bool hasWarnings: VehicleService?.hasWarnings ?? false
    readonly property var warnings: VehicleService?.warnings ?? []
    readonly property bool frontLeftDoorOpen: VehicleService?.frontLeftDoorOpen ?? false
    readonly property bool frontRightDoorOpen: VehicleService?.frontRightDoorOpen ?? false
    readonly property bool rearLeftDoorOpen: VehicleService?.rearLeftDoorOpen ?? false
    readonly property bool rearRightDoorOpen: VehicleService?.rearRightDoorOpen ?? false
    readonly property bool trunkOpen: VehicleService?.trunkOpen ?? false
    readonly property double tirePressureFL: VehicleService?.tirePressureFL ?? 0
    readonly property double tirePressureFR: VehicleService?.tirePressureFR ?? 0
    readonly property double tirePressureRL: VehicleService?.tirePressureRL ?? 0
    readonly property double tirePressureRR: VehicleService?.tirePressureRR ?? 0
    readonly property bool tirePressureSupported: VehicleService?.tirePressureSupported ?? false
    readonly property int tripDistance: VehicleService?.tripDistance ?? 0
    readonly property int tripTime: VehicleService?.tripTime ?? 0
    readonly property int avgSpeed: VehicleService?.avgSpeed ?? 0
    readonly property double fuelConsumption: VehicleService?.fuelConsumption ?? 0
    
    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: 16
            
            // =========================================================================
            // Section 1: Vehicle Identity & State
            // =========================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: 80
                radius: 16
                color: NordicTheme.colors.bg.surface
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: "My Nordic"
                            font.pixelSize: 24
                            font.weight: Font.Bold
                            font.family: "Helvetica"
                            color: NordicTheme.colors.text.primary
                        }
                        
                        RowLayout {
                            spacing: 8
                            
                            // Connection indicator
                            Rectangle {
                                width: 8; height: 8; radius: 4
                                color: NordicTheme.colors.semantic.success
                            }
                            
                            Text {
                                text: root.connectionState + " · Ignition " + root.ignitionState
                                font.pixelSize: 14
                                font.family: "Helvetica"
                                color: NordicTheme.colors.text.secondary
                            }
                        }
                    }
                    
                    Text {
                        text: "Updated " + root.lastUpdateTime
                        font.pixelSize: 12
                        font.family: "Helvetica"
                        color: NordicTheme.colors.text.tertiary
                    }
                }
            }
            
            // =========================================================================
            // Section 2: Primary Status Cards
            // =========================================================================
            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                spacing: 12
                
                // Battery / Fuel
                StatusCard {
                    Layout.fillWidth: true
                    label: "Battery"
                    value: root.batteryLevel + "%"
                    status: root.batteryLevel > 20 ? "ok" : "warning"
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/battery-full.svg"
                }
                
                // Range
                StatusCard {
                    Layout.fillWidth: true
                    label: "Range"
                    value: root.range + " km"
                    status: root.range > 50 ? "ok" : "warning"
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/navigation-arrow.svg"
                }
                
                // 12V Battery
                StatusCard {
                    Layout.fillWidth: true
                    label: "12V Battery"
                    value: root.batteryStatus
                    status: root.batteryStatus === "OK" ? "ok" : "warning"
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/battery-full.svg"
                }
            }
            
            // =========================================================================
            // Section 3: Secondary Status Cards
            // =========================================================================
            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                spacing: 12
                
                // Doors
                StatusCard {
                    Layout.fillWidth: true
                    label: "Doors"
                    value: root.doorsStatus
                    status: root.doorsStatus === "All closed" ? "ok" : "warning"
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                }
                
                // Handbrake
                StatusCard {
                    Layout.fillWidth: true
                    label: "Handbrake"
                    value: root.handbrakeEngaged ? "Engaged" : "Released"
                    status: "ok"
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                }
                
                // System
                StatusCard {
                    Layout.fillWidth: true
                    label: "System"
                    value: root.hasWarnings ? "Check warnings" : "No warnings"
                    status: root.hasWarnings ? "warning" : "ok"
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg"
                }
            }
            
            // =========================================================================
            // Section 4: Vehicle Graphic with Status Highlights
            // =========================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.preferredHeight: 200
                radius: 16
                color: NordicTheme.colors.bg.surface
                
                Item {
                    anchors.centerIn: parent
                    width: 160; height: 180
                    
                    // Car body silhouette
                    Rectangle {
                        id: carBody
                        anchors.centerIn: parent
                        width: 100; height: 160
                        radius: 20
                        color: NordicTheme.colors.bg.elevated
                        border.width: 2
                        border.color: NordicTheme.colors.border.muted
                        
                        // Windshield
                        Rectangle {
                            width: 60; height: 25
                            anchors.top: parent.top; anchors.topMargin: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 6
                            color: NordicTheme.colors.bg.primary
                        }
                        
                        // Rear window
                        Rectangle {
                            width: 50; height: 18
                            anchors.bottom: parent.bottom; anchors.bottomMargin: 20
                            anchors.horizontalCenter: parent.horizontalCenter
                            radius: 4
                            color: NordicTheme.colors.bg.primary
                        }
                    }
                    
                    // Door indicators
                    Rectangle {
                        x: carBody.x - 14; y: carBody.y + 35
                        width: 10; height: 30; radius: 3
                        color: root.frontLeftDoorOpen ? NordicTheme.colors.semantic.warning : NordicTheme.colors.semantic.success
                    }
                    Rectangle {
                        x: carBody.x + carBody.width + 4; y: carBody.y + 35
                        width: 10; height: 30; radius: 3
                        color: root.frontRightDoorOpen ? NordicTheme.colors.semantic.warning : NordicTheme.colors.semantic.success
                    }
                    Rectangle {
                        x: carBody.x - 14; y: carBody.y + 85
                        width: 10; height: 30; radius: 3
                        color: root.rearLeftDoorOpen ? NordicTheme.colors.semantic.warning : NordicTheme.colors.semantic.success
                    }
                    Rectangle {
                        x: carBody.x + carBody.width + 4; y: carBody.y + 85
                        width: 10; height: 30; radius: 3
                        color: root.rearRightDoorOpen ? NordicTheme.colors.semantic.warning : NordicTheme.colors.semantic.success
                    }
                    
                    // Trunk indicator
                    Rectangle {
                        anchors.horizontalCenter: carBody.horizontalCenter
                        y: carBody.y + carBody.height + 4
                        width: 40; height: 8; radius: 2
                        color: root.trunkOpen ? NordicTheme.colors.semantic.warning : NordicTheme.colors.semantic.success
                    }
                }
            }
            
            // =========================================================================
            // Section 5: Tire Pressure
            // =========================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.preferredHeight: root.tirePressureSupported ? 100 : 60
                radius: 16
                color: NordicTheme.colors.bg.surface
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12
                    
                    Text {
                        text: "Tire Pressure"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.family: "Helvetica"
                        color: NordicTheme.colors.text.secondary
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        visible: root.tirePressureSupported
                        
                        TirePressureCard { label: "FL"; value: root.tirePressureFL; Layout.fillWidth: true }
                        TirePressureCard { label: "FR"; value: root.tirePressureFR; Layout.fillWidth: true }
                        TirePressureCard { label: "RL"; value: root.tirePressureRL; Layout.fillWidth: true }
                        TirePressureCard { label: "RR"; value: root.tirePressureRR; Layout.fillWidth: true }
                    }
                    
                    Text {
                        visible: !root.tirePressureSupported
                        text: "Not supported on this vehicle"
                        font.pixelSize: 13
                        font.family: "Helvetica"
                        color: NordicTheme.colors.text.tertiary
                    }
                }
            }
            
            // =========================================================================
            // Section 6: Trip Data
            // =========================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.preferredHeight: 80
                radius: 16
                color: NordicTheme.colors.bg.surface
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    Text {
                        text: "Today's Trip"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.family: "Helvetica"
                        color: NordicTheme.colors.text.secondary
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 24
                        
                        Text {
                            text: root.tripDistance + " km"
                            font.pixelSize: 18
                            font.weight: Font.Medium
                            font.family: "Helvetica"
                            color: NordicTheme.colors.text.primary
                        }
                        
                        Text {
                            text: Math.floor(root.tripTime / 60) + "h " + (root.tripTime % 60) + "m"
                            font.pixelSize: 14
                            font.family: "Helvetica"
                            color: NordicTheme.colors.text.secondary
                        }
                        
                        Text {
                            text: "Avg " + root.avgSpeed + " km/h"
                            font.pixelSize: 14
                            font.family: "Helvetica"
                            color: NordicTheme.colors.text.secondary
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        Text {
                            text: root.fuelConsumption.toFixed(1) + " kWh/100km"
                            font.pixelSize: 14
                            font.family: "Helvetica"
                            color: NordicTheme.colors.accent.primary
                        }
                    }
                }
            }
            
            // =========================================================================
            // Section 7: Warnings
            // =========================================================================
            Rectangle {
                Layout.fillWidth: true
                Layout.leftMargin: 16
                Layout.rightMargin: 16
                Layout.preferredHeight: warningsColumn.height + 32
                radius: 16
                color: root.hasWarnings ? Qt.rgba(NordicTheme.colors.semantic.warning.r, NordicTheme.colors.semantic.warning.g, NordicTheme.colors.semantic.warning.b, 0.1) : NordicTheme.colors.bg.surface
                visible: root.hasWarnings
                
                ColumnLayout {
                    id: warningsColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 16
                    spacing: 8
                    
                    Repeater {
                        model: root.warnings
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 12
                            
                            Text {
                                text: "⚠"
                                font.pixelSize: 16
                                color: NordicTheme.colors.semantic.warning
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                
                                Text {
                                    text: modelData.message
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                    font.family: "Helvetica"
                                    color: NordicTheme.colors.text.primary
                                }
                                
                                Text {
                                    text: "Last detected: " + modelData.time
                                    font.pixelSize: 12
                                    font.family: "Helvetica"
                                    color: NordicTheme.colors.text.tertiary
                                }
                            }
                        }
                    }
                }
            }
            
            // Bottom spacing
            Item { Layout.preferredHeight: 16 }
        }
    }
    
    // =========================================================================
    // Helper Components
    // =========================================================================
    
    component StatusCard: Rectangle {
        property string label: ""
        property string value: ""
        property string status: "ok"  // ok, warning, error
        property string icon: ""
        
        height: 80
        radius: 12
        color: NordicTheme.colors.bg.surface
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            
            Rectangle {
                width: 40; height: 40
                radius: 10
                color: status === "ok" ? Qt.rgba(NordicTheme.colors.semantic.success.r, NordicTheme.colors.semantic.success.g, NordicTheme.colors.semantic.success.b, 0.2) :
                       status === "warning" ? Qt.rgba(NordicTheme.colors.semantic.warning.r, NordicTheme.colors.semantic.warning.g, NordicTheme.colors.semantic.warning.b, 0.2) :
                       Qt.rgba(NordicTheme.colors.semantic.error.r, NordicTheme.colors.semantic.error.g, NordicTheme.colors.semantic.error.b, 0.2)
                
                NordicIcon {
                    anchors.centerIn: parent
                    source: icon
                    size: NordicIcon.Size.SM
                    color: status === "ok" ? NordicTheme.colors.semantic.success :
                           status === "warning" ? NordicTheme.colors.semantic.warning :
                           NordicTheme.colors.semantic.error
                }
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                
                Text {
                    text: label
                    font.pixelSize: 12
                    font.family: "Helvetica"
                    color: NordicTheme.colors.text.tertiary
                }
                
                Text {
                    text: value
                    font.pixelSize: 16
                    font.weight: Font.Medium
                    font.family: "Helvetica"
                    color: NordicTheme.colors.text.primary
                }
            }
        }
    }
    
    component TirePressureCard: Rectangle {
        property string label: ""
        property double value: 0.0
        property bool isOk: value >= 2.0 && value <= 2.6
        
        height: 48
        radius: 8
        color: isOk ? NordicTheme.colors.bg.elevated : Qt.rgba(NordicTheme.colors.semantic.warning.r, NordicTheme.colors.semantic.warning.g, NordicTheme.colors.semantic.warning.b, 0.2)
        
        Column {
            anchors.centerIn: parent
            spacing: 2
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: label + (isOk ? " OK" : " !")
                font.pixelSize: 11
                font.weight: Font.Medium
                font.family: "Helvetica"
                color: isOk ? NordicTheme.colors.semantic.success : NordicTheme.colors.semantic.warning
            }
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: value.toFixed(1) + " bar"
                font.pixelSize: 13
                font.family: "Helvetica"
                color: NordicTheme.colors.text.primary
            }
        }
    }
}
