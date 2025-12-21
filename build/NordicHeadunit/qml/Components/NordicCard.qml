import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

Item {
    id: root
    
    default property alias content: container.data
    
    // API
    // Variants: elevated, outlined, filled, interactive, media, glass
    enum Variant { Elevated, Outlined, Filled, Interactive, Media, Glass }
    property int variant: NordicCard.Variant.Elevated
    
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
        // Glass: Semi-transparent for blur effect
        if (variant === NordicCard.Variant.Glass) {
            return Qt.rgba(NordicTheme.colors.bg.surface.r, NordicTheme.colors.bg.surface.g, NordicTheme.colors.bg.surface.b, 0.7)
        }
        
        if (variant === NordicCard.Variant.Filled || variant === NordicCard.Variant.Media) {
            return NordicTheme.colors.bg.elevated
        }
        
        if (NordicTheme.darkMode) {
            // Dark mode: Elevation via surface lightness
            // Base: Surface. Interactive hover: Elevated.
            if (clickable && (hovered || pressed)) return NordicTheme.colors.bg.elevated
            return NordicTheme.colors.bg.surface
        } else {
            // Light mode: Unified surface, shadows do the work
            return NordicTheme.colors.bg.surface
        }
    }
    
    readonly property color borderColor: {
        // Glass: Subtle accent glow border
        if (variant === NordicCard.Variant.Glass) {
            return Qt.rgba(NordicTheme.colors.accent.primary.r, NordicTheme.colors.accent.primary.g, NordicTheme.colors.accent.primary.b, 0.3)
        }
        
        if (variant === NordicCard.Variant.Outlined) {
            return (clickable && hovered) ? NordicTheme.colors.border.emphasis : NordicTheme.colors.border.default_color
        }
        // Subtle border for Filled cards in Dark Mode
        if (NordicTheme.darkMode && (variant === NordicCard.Variant.Filled || variant === NordicCard.Variant.Media)) {
            return NordicTheme.colors.border.muted
        }
        return "transparent"
    }
    
    // Shadow Logic (Light mode or specific Dark mode requirement)
    // V2.0 Spec: Light mode uses shadows. Dark mode uses surface colors (mostly).
    // Elevated/Interactive/Media get shadow in Light mode.
    readonly property bool showShadow: !NordicTheme.darkMode && (variant === NordicCard.Variant.Elevated || variant === NordicCard.Variant.Interactive || variant === NordicCard.Variant.Media)
    
    // Scale Logic
    scale: pressed ? 0.99 : (hovered && clickable ? 1.01 : 1.0)
    Behavior on scale { NumberAnimation { duration: NordicTheme.motion.duration_fastest; easing.type: Easing.OutCubic } }

    // -------------------------------------------------------------------------
    // Implementation
    // -------------------------------------------------------------------------

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
            shadowColor: NordicTheme.elevation.shadow_color_lg
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
        radius: NordicTheme.shapes.radius_xl
        
        border.width: (variant === NordicCard.Variant.Outlined || variant === NordicCard.Variant.Glass) ? 1 : 0
        border.color: root.borderColor
        
        clip: true // Click effects and media clipped to radius
        
        Behavior on color { ColorAnimation { duration: NordicTheme.motion.duration_fast } }
        
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
            border.color: NordicTheme.colors.accent.primary
            border.width: 2
            radius: parent.radius + 2
            visible: root.activeFocus
        }
    }
    
    // Layout
    property int padding: NordicTheme.spacing.space_4


    
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
