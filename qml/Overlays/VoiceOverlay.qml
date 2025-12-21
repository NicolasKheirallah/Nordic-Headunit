import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Item {
    id: root
    
    visible: false
    function show() { visible = true }
    function hide() { visible = false }
    
    // Bottom Sheet Style
    Rectangle {
        width: parent.width
        height: 200
        anchors.bottom: parent.bottom
        color: NordicTheme.colors.bg.elevated
        
        // Visualizer
        RowLayout {
            anchors.centerIn: parent
            spacing: 10
            Repeater {
                model: 5
                Rectangle {
                    width: 8
                    height: 40 + Math.random() * 40 // Mock waveform
                    radius: 4
                    color: NordicTheme.colors.accent.primary
                    
                    SequentialAnimation on height {
                        loops: Animation.Infinite
                        running: root.visible
                        NumberAnimation { from: 40; to: 80; duration: 200; easing.type: Easing.InOutQuad }
                        NumberAnimation { from: 80; to: 40; duration: 200; easing.type: Easing.InOutQuad }
                    }
                }
            }
        }
        
        NordicText {
            anchors.bottom: parent.bottom
            anchors.margins: 40
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Listening..."
            type: NordicText.Type.TitleMedium
        }
        
        MouseArea { anchors.fill: parent; onClicked: root.hide() }
    }
}
