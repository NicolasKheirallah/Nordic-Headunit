import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Clock Widget - Large time display with date
Item {
    id: root
    
    // Responsive size detection
    readonly property bool isCompact: width < 160 || height < 90
    readonly property bool isLarge: width >= 250 && height >= 150
    
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
            var format = "HH:mm"
            if (typeof SystemSettings !== "undefined") {
                format = SystemSettings.use24HourFormat ? "HH:mm" : "h:mm AP"
            }
            root.currentTime = Qt.formatTime(now, format)
            root.currentSeconds = Qt.formatTime(now, "ss")
            root.currentDate = Qt.formatDate(now, "dddd, MMMM d")
        }
    }
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: root.isCompact ? 0 : NordicTheme.spacing.space_1
            
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                
                NordicText {
                    text: root.currentTime
                    type: NordicText.Type.DisplayLarge
                    color: NordicTheme.colors.text.primary
                    fontSizeMode: Text.Fit
                    minimumPixelSize: 18
                    // Scale font based on smaller dimension
                    font.pixelSize: Math.min(root.width * 0.32, root.height * 0.5, 72)
                }
                
                // Seconds - hide in compact mode
                NordicText {
                    text: root.currentSeconds
                    type: NordicText.Type.TitleMedium
                    color: NordicTheme.colors.text.tertiary
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: root.isCompact ? 2 : 6
                    visible: !root.isCompact
                }
            }
            
            // Date - hide if too short
            NordicText {
                text: root.currentDate
                type: root.isCompact ? NordicText.Type.Caption : NordicText.Type.BodyMedium
                color: NordicTheme.colors.text.secondary
                Layout.alignment: Qt.AlignHCenter
                visible: root.height > 100
            }
        }
    }
}
