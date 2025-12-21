import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Systems Status Widget - Shows vehicle systems health with live updates
Item {
    id: root
    
    signal clicked()
    
    // Live vehicle data bindings with fallbacks (use ?? for null-coalescing)
    property bool hasWarnings: VehicleService?.hasWarnings ?? false
    property int batteryLevel: VehicleService?.batteryLevel ?? 84
    property int fuelLevel: VehicleService?.fuelLevel ?? 67
    property bool tirePressureOk: VehicleService?.tirePressureOk ?? true
    
    // Status color based on all systems
    property color statusColor: {
        if (hasWarnings) return NordicTheme.colors.semantic.error
        if (batteryLevel < 20 || fuelLevel < 15) return NordicTheme.colors.semantic.warning
        return NordicTheme.colors.semantic.success
    }
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        clickable: true
        onClicked: root.clicked()
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_2
            
            // Animated status icon
            NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                size: NordicIcon.Size.LG
                color: root.statusColor
                Layout.alignment: Qt.AlignHCenter
                
                // Pulse animation for warnings
                SequentialAnimation on opacity {
                    running: root.hasWarnings
                    loops: Animation.Infinite
                    NumberAnimation { to: 0.5; duration: 500 }
                    NumberAnimation { to: 1.0; duration: 500 }
                }
                
                Behavior on color { ColorAnimation { duration: 300 } }
            }
            
            NordicText { 
                text: root.hasWarnings ? qsTr("Warning") : qsTr("All Systems OK")
                type: NordicText.Type.TitleSmall
                color: NordicTheme.colors.text.primary
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Mini status indicators
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: NordicTheme.spacing.space_3
                
                // Battery
                RowLayout {
                    spacing: 4
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/battery.svg"
                        size: NordicIcon.Size.SM
                        color: root.batteryLevel < 20 ? NordicTheme.colors.semantic.warning : NordicTheme.colors.text.tertiary
                    }
                    NordicText {
                        text: root.batteryLevel + "%"
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.secondary
                    }
                }
                
                // Fuel
                RowLayout {
                    spacing: 4
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/fuel.svg"
                        size: NordicIcon.Size.SM
                        color: root.fuelLevel < 15 ? NordicTheme.colors.semantic.warning : NordicTheme.colors.text.tertiary
                    }
                    NordicText {
                        text: root.fuelLevel + "%"
                        type: NordicText.Type.Caption
                        color: root.fuelLevel < 15 ? NordicTheme.colors.semantic.warning : NordicTheme.colors.text.secondary
                    }
                }
            }
        }
    }
}
