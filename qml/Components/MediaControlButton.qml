import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// MediaControlButton - Reusable playback control button for design system consistency
// Eliminates duplication across shuffle, previous, play/pause, next, repeat buttons
Rectangle {
    id: root
    
    // Required properties
    required property string iconSource
    required property string accessibleName
    
    // Optional properties
    property bool isActive: false           // Toggle state (shuffle on, repeat on)
    property bool isPrimary: false          // Primary action gets accent color fill
    property real size: 48                  // Button size (touch target)
    property real iconSize: NordicIcon.Size.MD
    
    // Signals
    signal clicked()
    
    // Sizing - ensures minimum 44px touch target
    width: Math.max(44, size)
    height: Math.max(44, size)
    radius: width / 2
    
    // Colors based on state - improved dark mode visibility
    color: {
        if (isPrimary) {
            return mouseArea.pressed ? Theme.accentPressed :
                   mouseArea.containsMouse ? Theme.accentHover :
                   Theme.accent
        }
        if (isActive) {
            return Theme.accent
        }
        if (mouseArea.pressed) {
            return Theme.surfaceAlt
        }
        if (mouseArea.containsMouse) {
            return Theme.surface
        }
        // Semi-transparent background for better visibility in dark mode
        return Qt.rgba(255, 255, 255, 0.08)
    }
    
    border.width: isPrimary || isActive ? 0 : 1
    border.color: mouseArea.containsMouse ? Theme.accent : 
                  Qt.rgba(255, 255, 255, 0.15)
    
    // Press animation for primary button
    Behavior on scale { NumberAnimation { duration: Theme.durationFast } }
    scale: isPrimary && mouseArea.pressed ? 0.95 : 1.0
    
    // Icon
    NordicIcon {
        anchors.centerIn: parent
        source: root.iconSource
        size: root.iconSize
        color: {
            if (isPrimary) return Theme.textInverse
            if (isActive) return Theme.textInverse
            return Theme.textPrimary
        }
    }
    
    // Interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
    
    // Accessibility
    Accessible.role: Accessible.Button
    Accessible.name: root.accessibleName
}
