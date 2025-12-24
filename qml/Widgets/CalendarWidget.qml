import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Calendar Widget - Size-aware events display
Item {
    id: root
    
    signal clicked()
    
    // Size detection for adaptive content
    readonly property bool isCompact: width < 180 || height < 150
    readonly property bool isLarge: width >= 280 && height >= 250
    
    // Calendar data (would come from CalendarService)
    property var nextEvent: ({
        title: "Team Meeting",
        time: "14:30",
        location: "Conference Room B",
        duration: "1h"
    })
    
    property int upcomingCount: 3
    
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
                spacing: 8
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg"
                    size: NordicIcon.Size.SM
                    color: Theme.accent
                }
                
                NordicText {
                    text: qsTr("Next Event")
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.secondary
                    visible: root.width > 160
                }
                
                Item { Layout.fillWidth: true }
                
                Rectangle {
                    width: 20; height: 20
                    radius: 10
                    color: Theme.accent
                    visible: root.width > 200
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: root.upcomingCount.toString()
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.inverse
                        font.bold: true
                    }
                }
            }
            
            // Event time
            NordicText {
                text: root.nextEvent.time
                type: NordicText.Type.DisplaySmall
                color: NordicTheme.colors.text.primary
                fontSizeMode: Text.Fit
                minimumPixelSize: 24
                Layout.fillWidth: true
            }
            
            // Event title
            NordicText {
                text: root.nextEvent.title
                type: NordicText.Type.TitleSmall
                color: NordicTheme.colors.text.primary
                elide: Text.ElideRight
                Layout.fillWidth: true
                maximumLineCount: root.height < 150 ? 1 : 2
            }
            
            // Location
            RowLayout {
                spacing: 4
                visible: root.height > 180 // Hide if short
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg"
                    size: NordicIcon.Size.XS
                    color: NordicTheme.colors.text.tertiary
                }
                
                NordicText {
                    text: root.nextEvent.location
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.tertiary
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
            
            Item { Layout.fillHeight: true }
            
            // Navigate button
            NordicButton {
                Layout.fillWidth: true
                variant: NordicButton.Variant.Secondary
                size: NordicButton.Size.Sm
                text: qsTr("Navigate")
                onClicked: root.clicked()
                visible: root.height > 140
            }
        }
    }
}
