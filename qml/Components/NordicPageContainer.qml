import QtQuick
import QtQuick.Controls
import NordicHeadunit

// SwipeView-based page container for tab navigation
// Unlike StackView, pages stay alive and switching is instant
SwipeView {
    id: root
    
    // Disable swipe gestures - navigation only via DockBar
    interactive: false
    
    // Smooth transition
    contentItem: ListView {
        model: root.contentModel
        interactive: root.interactive
        currentIndex: root.currentIndex
        
        spacing: 0
        orientation: Qt.Horizontal
        snapMode: ListView.SnapOneItem
        boundsBehavior: Flickable.StopAtBounds
        
        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: 0
        preferredHighlightEnd: 0
        highlightMoveDuration: NordicTheme.motion.duration_normal
    }
    
    // Background (transparent to let AppLayout bg show)
    background: Item {}
}
