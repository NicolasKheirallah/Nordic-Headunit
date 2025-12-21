import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NordicHeadunit

StackView {
    id: root
    
    // API
    function navigate(url, properties) {
        // Push with default animation
        push(url, properties !== undefined ? properties : {})
    }
    
    function navigateBack() {
        if (depth > 1) {
            pop()
        }
    }
    
    // Replace current view - clear entire stack and show new page
    function replace(url, properties) {
        // Clear entire stack and push new page
        clear()
        push(url, properties !== undefined ? properties : {}, StackView.Immediate)
    }

    // Default to first item
    initialItem: null 

    // Background (transparent to let AppLayout bg show)
    background: Item {}

    // Transitions (V2.0 Spec: Motion System)
    // push_forward: Incoming slide from right 100%, fade in. Outgoing fade to 50%, slide left 30%.
    // push_back: Incoming slide from left 30%, fade to full. Outgoing slide right 30%, fade to 50%.
    
    pushEnter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: NordicTheme.motion.duration_slow; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: root.width; to: 0; duration: NordicTheme.motion.duration_slow; easing.type: Easing.OutCubic }
        }
    }

    pushExit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1; to: 0.5; duration: NordicTheme.motion.duration_slow; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: 0; to: -root.width * 0.3; duration: NordicTheme.motion.duration_slow; easing.type: Easing.OutCubic }
        }
    }

    popEnter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0.5; to: 1; duration: NordicTheme.motion.duration_slow; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: -root.width * 0.3; to: 0; duration: NordicTheme.motion.duration_slow; easing.type: Easing.OutCubic }
        }
    }

    popExit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: NordicTheme.motion.duration_slow; easing.type: Easing.OutCubic }
            NumberAnimation { property: "x"; from: 0; to: root.width; duration: NordicTheme.motion.duration_slow; easing.type: Easing.OutCubic }
        }
    }
    
    replaceEnter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: NordicTheme.motion.duration_normal }
        }
    }
    
    replaceExit: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: NordicTheme.motion.duration_normal }
        }
    }
}
