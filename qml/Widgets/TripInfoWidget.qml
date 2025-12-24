import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Trip Info Widget - Shows trip statistics with responsive layout
Item {
    id: root
    
    signal clicked()
    
    // Responsive size detection
    readonly property bool isCompact: width < 200 || height < 120
    readonly property bool isLarge: width >= 350 && height >= 180
    
    // Trip data (would come from VehicleService in production)
    property real tripDistance: VehicleService?.tripDistance ?? 127.4
    property real tripTime: VehicleService?.tripTime ?? 95  // minutes
    property real avgSpeed: VehicleService?.avgSpeed ?? 78.5
    property real fuelUsed: VehicleService?.fuelUsed ?? 12.3
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        clickable: true
        onClicked: root.clicked()
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: root.isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_3
            spacing: root.isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_3
            
            // Trip icon (Dynamic Scale) - hide in compact mode
            Rectangle {
                Layout.preferredWidth: Math.min(root.width * 0.18, 44)
                Layout.preferredHeight: Layout.preferredWidth
                radius: width / 2
                color: Theme.accent
                visible: !root.isCompact && root.width > 220
                
                NordicIcon {
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                    size: parent.width > 36 ? NordicIcon.Size.MD : NordicIcon.Size.SM
                    color: NordicTheme.colors.text.inverse
                }
            }
            
            // Stats grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                // Adaptive columns: 1 if very narrow, 2 normally
                columns: root.width < 200 ? 1 : 2
                rowSpacing: root.isCompact ? 2 : 4
                columnSpacing: root.isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_3
                
                // Distance
                ColumnLayout {
                    spacing: 0
                    Layout.fillWidth: true
                    NordicText {
                        text: root.tripDistance.toFixed(1) + " km"
                        type: root.isCompact ? NordicText.Type.BodyMedium : NordicText.Type.TitleMedium
                        color: NordicTheme.colors.text.primary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    NordicText {
                        text: qsTr("Distance")
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                        visible: !root.isCompact
                    }
                }
                
                // Time
                ColumnLayout {
                    spacing: 0
                    Layout.fillWidth: true
                    NordicText {
                        text: Math.floor(root.tripTime / 60) + "h " + (root.tripTime % 60) + "m"
                        type: root.isCompact ? NordicText.Type.BodyMedium : NordicText.Type.TitleMedium
                        color: NordicTheme.colors.text.primary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    NordicText {
                        text: qsTr("Duration")
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                        visible: !root.isCompact
                    }
                }
                
                // Avg Speed
                ColumnLayout {
                    spacing: 0
                    Layout.fillWidth: true
                    NordicText {
                        text: root.avgSpeed.toFixed(0) + " km/h"
                        type: root.isCompact ? NordicText.Type.BodyMedium : NordicText.Type.TitleMedium
                        color: NordicTheme.colors.text.primary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    NordicText {
                        text: qsTr("Avg")
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                        visible: !root.isCompact
                    }
                }
                
                // Fuel - only show if not compact
                ColumnLayout {
                    visible: !root.isCompact || root.height > 140
                    spacing: 0
                    Layout.fillWidth: true
                    NordicText {
                        text: root.fuelUsed.toFixed(1) + " L"
                        type: root.isCompact ? NordicText.Type.BodyMedium : NordicText.Type.TitleMedium
                        color: NordicTheme.colors.text.primary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    NordicText {
                        text: qsTr("Fuel")
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                        visible: !root.isCompact
                    }
                }
            }
        }
    }
}
