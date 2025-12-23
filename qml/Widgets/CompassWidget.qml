import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Compass Widget - Shows heading direction
Item {
    id: root
    
    signal clicked()
    
    // Heading in degrees (would come from GPS/sensor)
    property real heading: 45
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
    
    // Simulate heading change for demo
    Timer {
        interval: 3000
        running: true
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
            spacing: NordicTheme.spacing.space_2
            
            // Compass circle
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: Math.min(parent.parent.width, parent.parent.height) * 0.5
                height: width
                radius: width / 2
                color: "transparent"
                border.width: 2
                border.color: NordicTheme.colors.border.default_color
                
                // Compass needle
                Rectangle {
                    id: needle
                    anchors.centerIn: parent
                    width: 4
                    height: parent.height * 0.35
                    radius: 2
                    color: Theme.accent
                    transformOrigin: Item.Bottom
                    rotation: -root.heading
                    y: parent.height / 2 - height
                    
                    Behavior on rotation {
                        NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                    }
                }
                
                // North indicator
                NordicText {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    text: "N"
                    type: NordicText.Type.Caption
                    color: Theme.accent
                }
            }
            
            // Heading text
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: NordicTheme.spacing.space_2
                
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
