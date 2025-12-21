import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Clock Widget - Large time display with date
Item {
    id: root
    
    // Live updating time
    property string currentTime: Qt.formatTime(new Date(), "HH:mm")
    property string currentSeconds: Qt.formatTime(new Date(), "ss")
    property string currentDate: Qt.formatDate(new Date(), "dddd, MMMM d")
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            var now = new Date()
            root.currentTime = Qt.formatTime(now, "HH:mm")
            root.currentSeconds = Qt.formatTime(now, "ss")
            root.currentDate = Qt.formatDate(now, "dddd, MMMM d")
        }
    }
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_1
            
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                
                NordicText {
                    text: root.currentTime
                    type: NordicText.Type.DisplayLarge
                    color: NordicTheme.colors.text.primary
                }
                
                NordicText {
                    text: root.currentSeconds
                    type: NordicText.Type.TitleMedium
                    color: NordicTheme.colors.text.tertiary
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 8
                }
            }
            
            NordicText {
                text: root.currentDate
                type: NordicText.Type.BodyMedium
                color: NordicTheme.colors.text.secondary
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
