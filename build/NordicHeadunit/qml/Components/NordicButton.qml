import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NordicHeadunit

AbstractButton {
    id: root
    
    // -------------------------------------------------------------------------
    // API
    // -------------------------------------------------------------------------
    
    // Text and Icon are inherited from AbstractButton
    property string iconSource: "" // Map to AbstractButton icon.source or use custom

    // Keyboard Support
    Keys.onReturnPressed: clicked()
    Keys.onEnterPressed: clicked()
    
    // Variants: primary, secondary, tertiary, danger, icon, glass, success
    enum Variant { Primary, Secondary, Tertiary, Danger, Icon, Glass, Success }
    property int variant: NordicButton.Variant.Primary
    
    // Sizes: sm, md, lg, xl
    enum Size { Sm, Md, Lg, Xl }
    property int size: NordicButton.Size.Md
    
    property bool loading: false
    property bool round: false
    
    // -------------------------------------------------------------------------
    // Config
    // -------------------------------------------------------------------------
    
    readonly property int targetHeight: {
        switch (size) {
            case NordicButton.Size.Sm: return 36
            case NordicButton.Size.Md: return 44
            case NordicButton.Size.Lg: return 56
            case NordicButton.Size.Xl: return 64
            default: return 44
        }
    }
    
    readonly property int sidePadding: {
        switch (size) {
            case NordicButton.Size.Sm: return 16
            case NordicButton.Size.Md: return 20
            case NordicButton.Size.Lg: return 24
            case NordicButton.Size.Xl: return 32
            default: return 20
        }
    }
    
    readonly property font btnFont: {
        switch (size) {
            case NordicButton.Size.Sm: return NordicTheme.typography.title_small
            case NordicButton.Size.Md: return NordicTheme.typography.title_medium
            case NordicButton.Size.Lg: return NordicTheme.typography.title_large
            case NordicButton.Size.Xl: return NordicTheme.typography.title_large
            default: return NordicTheme.typography.title_medium
        }
    }
    
    readonly property int iconDimension: {
        switch (size) {
            case NordicButton.Size.Sm: return 16
            case NordicButton.Size.Md: return 20
            case NordicButton.Size.Lg: return 24
            case NordicButton.Size.Xl: return 28
            default: return 20
        }
    }
    
    // -------------------------------------------------------------------------
    // Styling Logic
    // -------------------------------------------------------------------------
    
    readonly property color bgColor: {
        if (!enabled || loading) return variant === NordicButton.Variant.Tertiary ? "transparent" : Qt.rgba(NordicTheme.colors.text.tertiary.r, NordicTheme.colors.text.tertiary.g, NordicTheme.colors.text.tertiary.b, 0.2)
        
        switch (variant) {
            case NordicButton.Variant.Primary:
                // Aurora teal with subtle brightness changes
                return root.down ? Qt.darker(NordicTheme.colors.accent.primary, 1.15) : 
                       root.hovered ? Qt.lighter(NordicTheme.colors.accent.primary, 1.08) : 
                       NordicTheme.colors.accent.primary
            case NordicButton.Variant.Secondary:
                // Glass-like surface
                return root.hovered ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
            case NordicButton.Variant.Tertiary:
                return root.hovered ? Qt.rgba(NordicTheme.colors.accent.primary.r, NordicTheme.colors.accent.primary.g, NordicTheme.colors.accent.primary.b, 0.12) : "transparent"
            case NordicButton.Variant.Danger:
                return root.down ? Qt.darker(NordicTheme.colors.semantic.error, 1.15) : 
                       root.hovered ? Qt.lighter(NordicTheme.colors.semantic.error, 1.08) : 
                       NordicTheme.colors.semantic.error
            case NordicButton.Variant.Icon:
                 return "transparent"
            case NordicButton.Variant.Glass:
                // Frosted glass effect - subtle translucent bg
                return root.hovered ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.1)
            case NordicButton.Variant.Success:
                return root.down ? Qt.darker(NordicTheme.colors.semantic.success, 1.15) : 
                       root.hovered ? Qt.lighter(NordicTheme.colors.semantic.success, 1.08) : 
                       NordicTheme.colors.semantic.success
            default: return NordicTheme.colors.accent.primary
        }
    }
    
    // Custom Color Override
    property color color: "transparent"

    readonly property color contentColor: {
        if (!enabled) return NordicTheme.colors.text.tertiary
        
        // Check if custom color is set (has non-zero alpha)
        if (root.color.a > 0) return root.color
        
        // Return color based on variant
        switch (variant) {
            case NordicButton.Variant.Primary:
            case NordicButton.Variant.Danger:
            case NordicButton.Variant.Success:
                return NordicTheme.colors.text.inverse
            case NordicButton.Variant.Secondary:
                return NordicTheme.colors.text.primary
            case NordicButton.Variant.Tertiary:
                return NordicTheme.colors.accent.primary
            case NordicButton.Variant.Icon:
                return NordicTheme.colors.text.primary
            case NordicButton.Variant.Glass:
                return "white"  // White text on translucent glass
            default:
                return NordicTheme.colors.text.inverse
        }
    }
    
    readonly property color borderColor: {
        if (variant === NordicButton.Variant.Secondary) {
             return root.hovered ? NordicTheme.colors.border.emphasis : NordicTheme.colors.border.default_color
        }
        return "transparent"
    }
    
    // -------------------------------------------------------------------------
    // Dimensions & Layout
    // -------------------------------------------------------------------------
    
    implicitWidth: Math.max(48, contentRow.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(48, targetHeight)
    
    padding: 0
    leftPadding: variant === NordicButton.Variant.Icon ? 0 : sidePadding
    rightPadding: variant === NordicButton.Variant.Icon ? 0 : sidePadding
    
    // Background
    background: Rectangle {
        implicitWidth: 100
        implicitHeight: root.targetHeight
        anchors.centerIn: parent
        width: parent.width
        height: root.targetHeight
        
        color: root.bgColor
        
        radius: (variant === NordicButton.Variant.Icon || root.round) ? NordicTheme.shapes.radius_full : NordicTheme.shapes.radius_lg
        
        border.width: variant === NordicButton.Variant.Secondary ? 1 : 0
        border.color: root.borderColor
        
        // Focus Indicator
        Rectangle {
            anchors.fill: parent
            anchors.margins: -2
            color: "transparent"
            border.color: NordicTheme.colors.accent.primary
            border.width: 2
            radius: parent.radius + 2
            visible: root.activeFocus
        }
        
        // Scale Animation
        scale: root.down ? 0.97 : 1.0
        Behavior on scale { NumberAnimation { duration: NordicTheme.motion.duration_fastest; easing.type: Easing.OutQuad } }
        Behavior on color { ColorAnimation { duration: NordicTheme.motion.duration_fast } }
    }
    
    // Content - Simple centered row
    contentItem: Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: NordicTheme.spacing.space_2
        
        // Loading indicator
        Text {
            visible: root.loading
            text: "..."
            color: root.contentColor
            font: root.btnFont
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Icon (when iconSource is provided)
        NordicIcon {
            visible: root.iconSource !== "" && !root.loading
            size: {
                if (root.size === NordicButton.Size.Sm) return NordicIcon.Size.XS
                if (root.size === NordicButton.Size.Md) return NordicIcon.Size.SM
                if (root.size === NordicButton.Size.Lg) return NordicIcon.Size.MD
                return NordicIcon.Size.MD
            }
            source: root.iconSource
            color: root.contentColor
            anchors.verticalCenter: parent.verticalCenter
        }
        
        // Text label
        Text {
            id: buttonText
            visible: root.text !== "" && !root.loading
            text: root.text
            font: root.btnFont
            color: root.contentColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    // Tactile Feedback
    ScaleAnimator {
        target: root
        from: 1.0
        to: 0.96
        duration: 50
        running: root.pressed
    }
    ScaleAnimator {
        target: root
        from: 0.96
        to: 1.0
        duration: 100
        running: !root.pressed
    }
}
