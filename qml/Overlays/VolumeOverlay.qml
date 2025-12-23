import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Item {
    id: root
    
    property int volume: SystemSettings.masterVolume
    property bool visibleState: false
    
    // Auto-hide timer
    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.visibleState = false
    }
    
    function show(newVolume) {
        var clampedVolume = Math.max(0, Math.min(100, newVolume))
        SystemSettings.masterVolume = clampedVolume
        root.visibleState = true
        hideTimer.restart()
    }
    
    // Overlay Container
    Rectangle {
        id: panel
        width: 300
        height: 80
        radius: Theme.radiusXl
        color: Theme.withAlpha(Theme.background, 0.9)
        border.color: Theme.borderMuted
        border.width: 1
        
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: visibleState ? Theme.spacingLg : -height - 20
        
        Behavior on anchors.topMargin { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
        
        // PERFORMANCE: Only enable layer when visible
        layer.enabled: root.visibleState
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacingSm
            spacing: Theme.spacingSm
            
            NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                size: NordicIcon.Size.MD
            }
            
            // Volume Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 8
                radius: 4
                color: Theme.surface
                
                Rectangle {
                    width: parent.width * (root.volume / 100)
                    height: parent.height
                    radius: 4
                    color: Theme.accent
                }
            }
            
            NordicText {
                text: root.volume + "%"
                type: NordicText.Type.TitleSmall
                Layout.preferredWidth: 40
                horizontalAlignment: Text.AlignRight
            }
        }
    }
}
