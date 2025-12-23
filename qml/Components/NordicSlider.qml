import QtQuick
import QtQuick.Controls
import NordicHeadunit

Slider {
    id: control
    
    implicitWidth: 200
    implicitHeight: 32
    
    // Background (Track)
    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 8
        width: control.availableWidth
        height: implicitHeight
        radius: 4
        color: Theme.withAlpha(Theme.textPrimary, 0.2)
        
        // Filled/Active portion
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: Theme.accent
            radius: 4
        }
    }
    
    // Handle (Thumb)
    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 24
        implicitHeight: 24
        radius: 12
        color: Theme.accent
        border.color: Theme.background
        border.width: 2
        
        // Shadow for thumb
        layer.enabled: true
        layer.effect: ShaderEffectSource {
             // Simple visual, skipping shadow effect for simplicity unless needed, 
             // but handle usually pops.
        }
        
        // Tooltip logic
        ToolTip {
            parent: control.handle
            visible: control.pressed
            text: Math.round(control.value) + "%"
            y: -30
        }
        
        Behavior on x { 
            enabled: !control.pressed
            NumberAnimation { duration: Theme.durationFast } 
        }
    }
}
