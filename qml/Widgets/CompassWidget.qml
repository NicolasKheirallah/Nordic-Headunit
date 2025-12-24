import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Compass Widget - Shows heading direction with responsive design
Item {
    id: root
    
    signal clicked()
    
    // Responsive size detection
    readonly property bool isCompact: width < 160 || height < 130
    readonly property bool isLarge: width >= 280 && height >= 250
    
    // Heading in degrees (would come from GPS/sensor)
    property real heading: VehicleService?.heading ?? 45
    property string headingText: {
        var h = heading % 360
        if (h < 0) h += 360
        if (h >= 337.5 || h < 22.5) return "N"
        if (h >= 22.5 && h < 67.5) return "NE"
        if (h >= 67.5 && h < 112.5) return "E"
        if (h >= 112.5 && h < 157.5) return "SE"
        if (h >= 157.5 && h < 202.5) return "S"
        if (h >= 202.5 && h < 247.5) return "SW"
        if (h >= 247.5 && h < 292.5) return "W"
        return "NW"
    }
    
    // Simulate heading change for demo (only if no VehicleService)
    Timer {
        interval: 3000
        running: typeof VehicleService === "undefined"
        repeat: true
        onTriggered: {
            root.heading = (root.heading + Math.random() * 20 - 10) % 360
        }
    }
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        clickable: true
        onClicked: root.clicked()
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: root.isCompact ? NordicTheme.spacing.space_1 : NordicTheme.spacing.space_2
            
            // Compass circle - scales with widget size
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: Math.min(root.width * 0.6, root.height * 0.55, 100)
                height: width
                radius: width / 2
                color: "transparent"
                border.width: root.isCompact ? 1.5 : 2
                border.color: NordicTheme.colors.border.default_color
                
                // Compass needle
                Rectangle {
                    id: needle
                    anchors.centerIn: parent
                    width: root.isCompact ? 3 : 4
                    height: parent.height * 0.42
                    radius: 2
                    color: Theme.accent
                    transformOrigin: Item.Bottom
                    rotation: -root.heading
                    y: parent.height / 2 - height
                    
                    Behavior on rotation {
                        NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                    }
                }
                
                // N indicator - hide in very compact mode
                NordicText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: root.isCompact ? 2 : 4
                    text: "N"
                    type: root.isCompact ? NordicText.Type.Caption : NordicText.Type.BodySmall
                    color: Theme.accent
                    font.bold: true
                }
            }
            
            // Heading text - hide in compact mode
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: root.isCompact ? 4 : NordicTheme.spacing.space_2
                visible: !root.isCompact
                
                NordicText {
                    text: root.headingText
                    type: NordicText.Type.TitleLarge
                    color: NordicTheme.colors.text.primary
                }
                
                NordicText {
                    text: Math.round(root.heading) + "°"
                    type: NordicText.Type.BodyMedium
                    color: NordicTheme.colors.text.secondary
                }
            }
        }
    }
}
