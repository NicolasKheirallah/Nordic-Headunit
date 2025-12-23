import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Trip Info Widget - Shows trip statistics
Item {
    id: root
    
    signal clicked()
    
    // Trip data (would come from VehicleService in production)
    property real tripDistance: 127.4
    property real tripTime: 95  // minutes
    property real avgSpeed: 78.5
    property real fuelUsed: 12.3
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        clickable: true
        onClicked: root.clicked()
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_3
            spacing: NordicTheme.spacing.space_4
            
            // Trip icon
            Rectangle {
                Layout.preferredWidth: 48
                Layout.preferredHeight: 48
                radius: 24
                color: Theme.accent
                
                NordicIcon {
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                    size: NordicIcon.Size.MD
                    color: NordicTheme.colors.text.inverse
                }
            }
            
            // Stats grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: 4
                columnSpacing: NordicTheme.spacing.space_4
                
                // Distance
                ColumnLayout {
                    spacing: 0
                    NordicText {
                        text: root.tripDistance.toFixed(1) + " km"
                        type: NordicText.Type.TitleMedium
                        color: NordicTheme.colors.text.primary
                    }
                    NordicText {
                        text: qsTr("Distance")
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                    }
                }
                
                // Time
                ColumnLayout {
                    spacing: 0
                    NordicText {
                        text: Math.floor(root.tripTime / 60) + "h " + (root.tripTime % 60) + "m"
                        type: NordicText.Type.TitleMedium
                        color: NordicTheme.colors.text.primary
                    }
                    NordicText {
                        text: qsTr("Duration")
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                    }
                }
                
                // Avg Speed
                ColumnLayout {
                    spacing: 0
                    NordicText {
                        text: root.avgSpeed.toFixed(0) + " km/h"
                        type: NordicText.Type.TitleMedium
                        color: NordicTheme.colors.text.primary
                    }
                    NordicText {
                        text: qsTr("Avg Speed")
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                    }
                }
                
                // Fuel
                ColumnLayout {
                    spacing: 0
                    NordicText {
                        text: root.fuelUsed.toFixed(1) + " L"
                        type: NordicText.Type.TitleMedium
                        color: NordicTheme.colors.text.primary
                    }
                    NordicText {
                        text: qsTr("Fuel Used")
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                    }
                }
            }
        }
    }
}
