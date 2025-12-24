import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import NordicHeadunit

// Systems Status Widget - Shows vehicle systems health with live updates
Item {
    id: root
    
    signal clicked()
    
    // Responsive size detection
    readonly property bool isCompact: width < 180 || height < 130
    readonly property bool isLarge: width >= 280 && height >= 200
    
    // Live vehicle data bindings with fallbacks
    property bool hasWarnings: VehicleService?.hasWarnings ?? false
    property int batteryLevel: VehicleService?.batteryLevel ?? 84
    property int fuelLevel: VehicleService?.fuelLevel ?? 67
    property bool tirePressureOk: VehicleService?.tirePressureOk ?? true
    
    // Status color based on all systems
    readonly property color statusColor: {
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
            anchors.margins: root.isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_3
            spacing: root.isCompact ? NordicTheme.spacing.space_1 : NordicTheme.spacing.space_2
            
            // Scalable Status Icon
            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Math.min(root.width * 0.3, root.height * 0.35, 50)
                Layout.preferredHeight: Layout.preferredWidth
                
                Image {
                    id: statusImg
                    anchors.fill: parent
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                    sourceSize: Qt.size(width * 2, height * 2)
                    fillMode: Image.PreserveAspectFit
                    visible: false
                }
                
                MultiEffect {
                    anchors.fill: statusImg
                    source: statusImg
                    colorization: 1.0
                    colorizationColor: root.statusColor
                    
                    // Pulse animation for warnings
                    SequentialAnimation on opacity {
                        running: root.hasWarnings
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.5; duration: 500 }
                        NumberAnimation { to: 1.0; duration: 500 }
                    }
                    
                    Behavior on colorizationColor { ColorAnimation { duration: 300 } }
                }
            }
            
            NordicText { 
                text: root.hasWarnings ? qsTr("Warning") : qsTr("All OK")
                type: root.isCompact ? NordicText.Type.BodySmall : NordicText.Type.TitleSmall
                color: NordicTheme.colors.text.primary
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Mini status indicators - hide in compact mode
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: root.isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_3
                visible: !root.isCompact
                
                // Battery
                RowLayout {
                    spacing: 2
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
                    spacing: 2
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
