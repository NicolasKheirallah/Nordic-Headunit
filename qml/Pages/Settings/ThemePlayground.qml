import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

// ═══════════════════════════════════════════════════════════════════════════
// THEME PLAYGROUND - Visual testing page for all theme tokens
// ═══════════════════════════════════════════════════════════════════════════

SettingsSubPage {
    id: root
    title: "Color Theme"
    showBackButton: true  // Always show back button for sub-pages
    
    // Theme Selector Grid
    SettingsCategory {
        title: "Select Theme"
        
        GridLayout {
            columns: 3
            columnSpacing: Theme.spacingMd
            rowSpacing: Theme.spacingMd
            Layout.fillWidth: true
            
            Repeater {
                model: Theme.getThemeKeys()
                
                // Theme Card
                Rectangle {
                    id: themeCard
                    property string themeKey: modelData
                    property var themeInfo: Theme.getThemeInfo(themeKey)
                    property bool isSelected: Theme.themeKey === themeKey
                    property bool hovered: cardMouseArea.containsMouse
                    property bool pressed: cardMouseArea.pressed
                    
                    width: 140
                    height: 100
                    radius: Theme.radiusMd
                    color: pressed ? Theme.surfaceAlt : hovered ? Qt.lighter(Theme.surface, 1.05) : Theme.surface
                    border.width: isSelected ? 2 : 1
                    border.color: isSelected ? Theme.accent : hovered ? Theme.borderEmphasis : Theme.border
                    
                    // Smooth transitions
                    Behavior on color { ColorAnimation { duration: Theme.durationFast } }
                    Behavior on border.color { ColorAnimation { duration: Theme.durationFast } }
                    
                    // Mini preview
                    Column {
                        anchors.fill: parent
                        anchors.margins: Theme.spacingSm
                        spacing: Theme.spacingXs
                        
                        // Color preview row
                        Row {
                            spacing: 4
                            Rectangle {
                                width: 24; height: 24
                                radius: 4
                                color: themeInfo.accent
                            }
                            Rectangle {
                                width: 24; height: 24
                                radius: 4
                                color: themeInfo.secondary
                            }
                        }
                        
                        // Theme name
                        NordicText {
                            text: themeInfo.name
                            type: NordicText.Type.TitleSmall
                            color: Theme.textPrimary
                        }
                        
                        // Selected indicator
                        NordicText {
                            text: isSelected ? "✓ Active" : ""
                            type: NordicText.Type.Caption
                            color: Theme.accent
                        }
                    }
                    
                    MouseArea {
                        id: cardMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Theme.setTheme(themeCard.themeKey)
                    }
                }
            }
        }
    }
    
    // Custom Color Picker (visible when custom theme selected)
    SettingsCategory {
        title: "Custom Colors"
        visible: Theme.themeKey === "custom"
        
        ColumnLayout {
            spacing: Theme.spacingMd
            Layout.fillWidth: true
            
            // Accent Color Swatches
            NordicText {
                text: "Accent Color"
                type: NordicText.Type.TitleSmall
            }
            
            Flow {
                spacing: Theme.spacingSm
                Layout.fillWidth: true
                
                Repeater {
                    model: ["#EF4444", "#F97316", "#FBBF24", "#22C55E", "#14B8A6", "#06B6D4", "#3B82F6", "#8B5CF6", "#EC4899", "#00D4AA"]
                    
                    Rectangle {
                        id: accentSwatch
                        property bool isSelected: Qt.colorEqual(SystemSettings.customAccentColor, modelData)
                        property bool hovered: accentSwatchMouse.containsMouse
                        
                        width: 48; height: 48  // Increased for accessibility
                        radius: 24
                        color: modelData
                        border.width: isSelected ? 3 : hovered ? 2 : 0
                        border.color: Theme.textPrimary
                        scale: hovered ? 1.1 : 1.0
                        
                        Behavior on scale { NumberAnimation { duration: Theme.durationFast } }
                        
                        MouseArea {
                            id: accentSwatchMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: SystemSettings.customAccentColor = modelData
                        }
                    }
                }
            }
            
            // Secondary Color Swatches
            NordicText {
                text: "Secondary Color"
                type: NordicText.Type.TitleSmall
                topPadding: Theme.spacingMd
            }
            
            Flow {
                spacing: Theme.spacingSm
                Layout.fillWidth: true
                
                Repeater {
                    model: ["#94A3B8", "#64748B", "#38BDF8", "#06B6D4", "#84CC16", "#FBBF24", "#F472B6", "#A78BFA"]
                    
                    Rectangle {
                        id: secondarySwatch
                        property bool isSelected: Qt.colorEqual(SystemSettings.customSecondaryColor, modelData)
                        property bool hovered: secondarySwatchMouse.containsMouse
                        
                        width: 48; height: 48  // Increased for accessibility
                        radius: 24
                        color: modelData
                        border.width: isSelected ? 3 : hovered ? 2 : 0
                        border.color: Theme.textPrimary
                        scale: hovered ? 1.1 : 1.0
                        
                        Behavior on scale { NumberAnimation { duration: Theme.durationFast } }
                        
                        MouseArea {
                            id: secondarySwatchMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: SystemSettings.customSecondaryColor = modelData
                        }
                    }
                }
            }
        }
    }
    
    // Token Preview
    SettingsCategory {
        title: "Color Tokens Preview"
        
        GridLayout {
            columns: 4
            columnSpacing: Theme.spacingSm
            rowSpacing: Theme.spacingSm
            Layout.fillWidth: true
            
            // Background colors
            TokenSwatch { name: "background"; color: Theme.background }
            TokenSwatch { name: "surface"; color: Theme.surface }
            TokenSwatch { name: "surfaceAlt"; color: Theme.surfaceAlt }
            TokenSwatch { name: "overlay"; color: Theme.overlay }
            
            // Accent colors
            TokenSwatch { name: "accent"; color: Theme.accent }
            TokenSwatch { name: "accentSecondary"; color: Theme.accentSecondary }
            TokenSwatch { name: "accentHover"; color: Theme.accentHover }
            TokenSwatch { name: "accentPressed"; color: Theme.accentPressed }
            
            // Semantic colors
            TokenSwatch { name: "danger"; color: Theme.danger }
            TokenSwatch { name: "warning"; color: Theme.warning }
            TokenSwatch { name: "success"; color: Theme.success }
            TokenSwatch { name: "info"; color: Theme.info }
            
            // Text colors
            TokenSwatch { name: "textPrimary"; color: Theme.textPrimary; textColor: Theme.background }
            TokenSwatch { name: "textSecondary"; color: Theme.textSecondary; textColor: Theme.background }
            TokenSwatch { name: "textDisabled"; color: Theme.textDisabled; textColor: Theme.background }
            TokenSwatch { name: "border"; color: Theme.border }
        }
    }
    
    // Component Preview
    SettingsCategory {
        title: "Component States"
        
        RowLayout {
            spacing: Theme.spacingMd
            
            // Button states
            NordicButton {
                text: "Primary"
                variant: NordicButton.Variant.Primary
            }
            NordicButton {
                text: "Secondary"
                variant: NordicButton.Variant.Secondary
            }
            NordicButton {
                text: "Danger"
                variant: NordicButton.Variant.Danger
            }
            NordicButton {
                text: "Disabled"
                enabled: false
            }
        }
    }
    
    // Dark Mode Toggle
    SettingsToggle {
        title: "Dark Mode"
        subtitle: Theme.isDark ? "Nordic Night" : "Nordic Day"
        checked: Theme.isDark
        onToggled: Theme.toggleMode()
    }
    
    // Token Swatch Component
    component TokenSwatch: Rectangle {
        property string name: ""
        property color textColor: Theme.textPrimary
        
        width: 100
        height: 60
        radius: Theme.radiusSm
        border.width: 1
        border.color: Theme.border
        
        NordicText {
            anchors.centerIn: parent
            text: parent.name
            type: NordicText.Type.Caption
            color: parent.textColor
        }
    }
}
