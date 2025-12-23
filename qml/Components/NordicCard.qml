import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

Item {
    id: root
    
    default property alias content: container.data
    
    // API
    // Variants: elevated, outlined, filled, interactive, media, glass, custom
    enum Variant { Elevated, Outlined, Filled, Interactive, Media, Glass, Custom }
    property int variant: NordicCard.Variant.Elevated
    
    // Style Aliases
    property alias border: bgRect.border
    property alias radius: bgRect.radius
    property alias color: bgRect.color // Override standard color logic if needed
    
    // Media Source (only for Media variant)
    property string mediaSource: ""
    
    property bool clickable: variant === NordicCard.Variant.Interactive
    signal clicked()
    
    implicitWidth: 300
    implicitHeight: 200
    
    // State
    property bool hovered: false
    property bool pressed: false
    
    // -------------------------------------------------------------------------
    // Elevation & Style Logic
    // -------------------------------------------------------------------------
    
    readonly property color bgColor: {
        // Glass: handled by NordicGlass component background
        if (variant === NordicCard.Variant.Glass) {
            return "transparent"
        }
        
        if (variant === NordicCard.Variant.Filled || variant === NordicCard.Variant.Media) {
            return Theme.surfaceAlt
        }
        
        if (Theme.isDark) {
            // Dark mode: Elevation via surface lightness
            // Base: Surface. Interactive hover: Elevated.
            if (clickable && (hovered || pressed)) return Theme.surfaceAlt
            return Theme.surface
        } else {
            // Light mode: Unified surface, shadows do the work
            return Theme.surface
        }
    }
    
    readonly property color borderColor: {
        // Glass: handled by NordicGlass component
        if (variant === NordicCard.Variant.Glass) {
            return "transparent"
        }
        
        if (variant === NordicCard.Variant.Outlined) {
            return (clickable && hovered) ? Theme.borderEmphasis : Theme.border
        }
        // Subtle border for Filled cards in Dark Mode
        if (Theme.isDark && (variant === NordicCard.Variant.Filled || variant === NordicCard.Variant.Media)) {
            return Theme.borderMuted
        }
        return "transparent"
    }
    
    // Shadow Logic (Light mode or specific Dark mode requirement)
    // V2.0 Spec: Light mode uses shadows. Dark mode uses surface colors (mostly).
    // Elevated/Interactive/Media get shadow in Light mode.
    readonly property bool showShadow: !Theme.isDark && (variant === NordicCard.Variant.Elevated || variant === NordicCard.Variant.Interactive || variant === NordicCard.Variant.Media)
    
    // Scale Logic
    scale: pressed ? 0.99 : (hovered && clickable ? 1.01 : 1.0)
    Behavior on scale { NumberAnimation { duration: Theme.durationFast; easing.type: Easing.OutCubic } }

    // -------------------------------------------------------------------------
    // Implementation
    // -------------------------------------------------------------------------

    // Unified Glass Background
    NordicGlass {
        id: glassBg
        anchors.fill: parent
        radius: bgRect.radius
        // Pass the standard glass color
        color: Theme.withAlpha(Theme.surface, 0.7)
        // Pass the standard glass border
        borderColor: Theme.withAlpha(Theme.accent, 0.3)
        
        visible: variant === NordicCard.Variant.Glass
    }

    // Shadow Layer (Behind background)
    Rectangle {
        id: shadowLayer
        anchors.fill: bgRect
        color: "transparent"
        visible: root.showShadow
        radius: bgRect.radius
        
        layer.enabled: root.showShadow
        layer.effect: MultiEffect {
            shadowEnabled: true
            // Modern Swedish shadows - softer and larger
            shadowColor: Theme.shadowColor
            shadowBlur: hovered ? 32 : 16
            shadowVerticalOffset: hovered ? 8 : 4
            shadowHorizontalOffset: 0
        }
    }

    // Main Background
    Rectangle {
        id: bgRect
        anchors.fill: parent
        color: root.bgColor
        radius: Theme.radiusXl
        
        border.width: (variant === NordicCard.Variant.Outlined || variant === NordicCard.Variant.Glass) ? 1 : 0
        // Use 'root.borderColor' unless overridden
        border.color: root.borderColor
        
        clip: true // Click effects and media clipped to radius
        
        Behavior on color { ColorAnimation { duration: Theme.durationFast } }
        
        // Media Image (For Media Variant)
        // Uses top half or cover? Spec says "Note: Media area (image, video, map)... Image fills top with top corners rounded"
        // Let's implement a top image area if mediaSource is set.
        Image {
            id: mediaImg
            visible: variant === NordicCard.Variant.Media && root.mediaSource !== ""
            source: root.mediaSource
            width: parent.width
            height: parent.height / 2 // Simple split for now, or use aspect ratio
            fillMode: Image.PreserveAspectCrop
            mipmap: true
            
            // Allow custom height override via property? For now default 50%
        }
        
        // Content Container
        Item {
            id: container
            anchors.fill: parent
            anchors.topMargin: (variant === NordicCard.Variant.Media && root.mediaSource !== "") ? (parent.height / 2) + root.padding : root.padding
            anchors.margins: root.padding
        }

        // Focus Ring
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            color: "transparent"
            border.color: Theme.accent
            border.width: 2
            radius: parent.radius + 2
            visible: root.activeFocus
        }
    }
    
    // Layout
    property int padding: Theme.spacingSm


    
    // Interaction
    MouseArea {
        anchors.fill: parent
        enabled: root.clickable
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onPressed: root.pressed = true
        onReleased: root.pressed = false
        onClicked: root.clicked()
    }
}
