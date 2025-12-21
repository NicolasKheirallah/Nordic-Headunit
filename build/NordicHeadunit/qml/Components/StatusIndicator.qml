import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// StatusIndicator - Reusable status icon with text label and animations
Row {
    id: root
    
    property string iconSource: ""
    property string text: ""
    property color color: NordicTheme.colors.text.primary
    property color iconColor: root.color
    property bool active: true
    property int size: NordicIcon.Size.SM
    property bool showPulse: false
    
    spacing: NordicTheme.spacing.space_1
    visible: active // Simple visibility toggle, but we animate opacity below
    
    // Animate appearance
    opacity: active ? 1.0 : 0.0
    Behavior on opacity { NumberAnimation { duration: 300 } }
    
    NordicIcon { 
        source: root.iconSource
        color: root.iconColor
        size: root.size
        anchors.verticalCenter: parent.verticalCenter
        
        // Pulse animation (e.g. for media playing)
        SequentialAnimation on opacity {
            running: root.showPulse && root.active
            loops: Animation.Infinite
            NumberAnimation { to: 0.6; duration: 800 }
            NumberAnimation { to: 1.0; duration: 800 }
        }
    }
    
    NordicText { 
        text: root.text
        type: NordicText.Type.BodySmall
        color: root.color
        visible: text !== ""
        anchors.verticalCenter: parent.verticalCenter
    }
}
