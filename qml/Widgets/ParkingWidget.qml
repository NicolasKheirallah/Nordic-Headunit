import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import NordicHeadunit

// Parking/Camera Widget - Shows rear camera or parking sensors (BMW style)
Item {
    id: root
    
    signal clicked()
    
    // Responsive size detection
    readonly property bool isCompact: width < 180 || height < 130
    readonly property bool isLarge: width >= 300 && height >= 220
    
    // Parking sensor data
    property var sensorDistances: VehicleService?.parkingSensors ?? [150, 80, 60, 80, 150]
    property bool cameraAvailable: VehicleService?.rearCameraAvailable ?? true
    property int minDistance: sensorDistances.length > 0 ? Math.min(...sensorDistances) : 150
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        clickable: true
        onClicked: root.clicked()
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_3
            spacing: root.isCompact ? NordicTheme.spacing.space_1 : NordicTheme.spacing.space_2
            
            // Header - hide in compact mode
            RowLayout {
                Layout.fillWidth: true
                visible: !root.isCompact
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                    size: NordicIcon.Size.SM
                    color: NordicTheme.colors.text.secondary
                }
                
                NordicText {
                    text: qsTr("Parking")
                    type: NordicText.Type.TitleSmall
                    color: NordicTheme.colors.text.primary
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
            
            // Main content area with car and sensors
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                // Car Visual - scales with available space
                Item {
                    id: carContainer
                    anchors.centerIn: parent
                    width: Math.min(parent.width * 0.7, parent.height * 0.6, 80)
                    height: width * 0.7
                    
                    Image {
                        id: carImg
                        anchors.fill: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                        sourceSize: Qt.size(width * 2, height * 2)
                        fillMode: Image.PreserveAspectFit
                        visible: false
                    }
                    
                    MultiEffect {
                        anchors.fill: carImg
                        source: carImg
                        colorization: 1.0
                        colorizationColor: NordicTheme.colors.text.tertiary
                        opacity: 0.6
                    }
                }

                // Sensor indicators (rear) - positioned below car
                Row {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: root.isCompact ? 4 : 6
                    
                    Repeater {
                        model: root.sensorDistances
                        
                        Rectangle {
                            width: root.isCompact ? 8 : 10
                            height: root.isCompact ? 4 : 5
                            radius: 2
                            color: {
                                var dist = modelData
                                if (dist < 50) return NordicTheme.colors.semantic.error
                                if (dist < 100) return NordicTheme.colors.semantic.warning
                                return NordicTheme.colors.semantic.success
                            }
                        }
                    }
                }
            }
            
            // Distance display - always visible
            NordicText {
                text: root.minDistance + " cm"
                type: root.isCompact ? NordicText.Type.BodyMedium : NordicText.Type.TitleMedium
                color: root.minDistance < 50 ? NordicTheme.colors.semantic.error : 
                       root.minDistance < 100 ? NordicTheme.colors.semantic.warning : 
                       NordicTheme.colors.text.primary
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
