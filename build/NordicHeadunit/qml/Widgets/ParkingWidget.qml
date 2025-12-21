import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Parking/Camera Widget - Shows rear camera or parking sensors (BMW style)
Item {
    id: root
    
    signal clicked()
    
    // Parking sensor data
    property var sensorDistances: VehicleService?.parkingSensors ?? [150, 80, 60, 80, 150]
    property bool cameraAvailable: VehicleService?.rearCameraAvailable ?? true
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_3
            spacing: NordicTheme.spacing.space_2
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                    size: NordicIcon.Size.SM
                    color: NordicTheme.colors.text.secondary
                }
                
                NordicText {
                    text: qsTr("Parking Assist")
                    type: NordicText.Type.TitleSmall
                    color: NordicTheme.colors.text.primary
                }
                
                Item { Layout.fillWidth: true }
                
                NordicButton {
                    variant: NordicButton.Variant.Tertiary
                    size: NordicButton.Size.Sm
                    text: qsTr("Camera")
                    visible: root.cameraAvailable
                    onClicked: root.clicked()
                }
            }
            
            // Parking sensor visualization
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                // Car outline
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.4
                    height: parent.height * 0.7
                    radius: 8
                    color: "transparent"
                    border.width: 2
                    border.color: NordicTheme.colors.border.default_color
                    
                    // Sensor indicators (rear)
                    Row {
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -8
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 4
                        
                        Repeater {
                            model: root.sensorDistances
                            
                            Rectangle {
                                width: 8; height: 8
                                radius: 4
                                color: {
                                    var dist = modelData
                                    if (dist < 50) return NordicTheme.colors.semantic.error
                                    if (dist < 100) return NordicTheme.colors.semantic.warning
                                    return NordicTheme.colors.semantic.success
                                }
                                
                                // Pulse animation for close objects
                                SequentialAnimation on opacity {
                                    running: modelData < 50
                                    loops: Animation.Infinite
                                    NumberAnimation { to: 0.3; duration: 300 }
                                    NumberAnimation { to: 1.0; duration: 300 }
                                }
                            }
                        }
                    }
                }
            }
            
            // Distance display
            NordicText {
                property int minDistance: Math.min(...root.sensorDistances)
                text: minDistance + " cm"
                type: NordicText.Type.TitleMedium
                color: minDistance < 50 ? NordicTheme.colors.semantic.error : NordicTheme.colors.text.primary
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
