pragma Singleton
import QtQuick

QtObject {
    id: theme
    
    property bool darkMode: SystemSettings.darkMode
    
    // -------------------------------------------------------------------------
    // Responsive Layout System
    // -------------------------------------------------------------------------
    
    // Core Layout Service Bridge
    // Note: LayoutService is injected from C++
    property QtObject layout: QtObject {
        property bool isCompact: LayoutService.isCompact
        property bool isLandscape: LayoutService.isLandscape
        property int widthClass: LayoutService.widthClass // 0=Compact, 1=Regular, 2=Expanded
        
        // Fixed Dimensions
        property int statusBarHeight: 48
        property int bottomBarHeight: 80
        property int contentHeight: LayoutService.screenSize.height - statusBarHeight - bottomBarHeight
    }
    
    // -------------------------------------------------------------------------
    // Color System
    // -------------------------------------------------------------------------
    
    property QtObject colors: QtObject {
        id: colorSystem
        
        // =====================================================================
        // SWEDISH DESIGN SYSTEM 2025 - Nordic Aurora Palette
        // Inspired by: Northern Lights, Swedish Forests, Arctic Ice, Midnight Sun
        // =====================================================================
        
        // Backgrounds - Deep Nordic night tones
        property color bg_primary: darkMode ? "#0A0E14" : "#FAFBFC"
        property color bg_secondary: darkMode ? "#12171E" : "#F0F2F5"
        property color bg_surface: darkMode ? "#1A2028" : "#FFFFFF"
        property color bg_elevated: darkMode ? "#242C38" : "#FFFFFF"
        property color bg_overlay: darkMode ? "rgba(10, 14, 20, 0.85)" : "rgba(0, 0, 0, 0.4)"
        
        // Glass effect background
        property color bg_glass: darkMode ? "rgba(26, 32, 40, 0.7)" : "rgba(255, 255, 255, 0.8)"
        
        // Text - High contrast, clean
        property color text_primary: darkMode ? "#F8FAFC" : "#0F172A"
        property color text_secondary: darkMode ? "#94A3B8" : "#64748B"
        property color text_tertiary: darkMode ? "#64748B" : "#94A3B8"
        property color text_inverse: darkMode ? "#0F172A" : "#F8FAFC"
        property color text_link: darkMode ? "#38BDF8" : "#0284C7"
        
        // Borders - Subtle, refined
        property color border_default: darkMode ? "#2D3748" : "#E2E8F0"
        property color border_muted: darkMode ? "#1E293B" : "#F1F5F9"
        property color border_emphasis: darkMode ? "#475569" : "#CBD5E1"
        
        // Primary Accent - Aurora Teal (signature color)
        property color accent_primary: darkMode ? "#00D4AA" : "#00A884"
        property color accent_secondary: darkMode ? "#38BDF8" : "#0EA5E9"
        property color accent_tertiary: darkMode ? "#67E8F9" : "#22D3EE"
        
        // Warm Accent - Swedish Gold / Amber
        property color accent_warm: darkMode ? "#FFB347" : "#F59E0B"
        
        // Semantic - Nature-inspired
        property color semantic_success: darkMode ? "#22C55E" : "#16A34A"
        property color semantic_warning: darkMode ? "#FBBF24" : "#D97706"
        property color semantic_error: darkMode ? "#EF4444" : "#DC2626"
        property color semantic_info: darkMode ? "#38BDF8" : "#0284C7"
        
        // Special Accents - Northern Lights
        property color special_purple: "#A78BFA"
        property color special_pink: "#F472B6"
        property color special_aurora: "#00D4AA"
        
        // Gradients (as start/end colors)
        property color gradient_aurora_start: "#00D4AA"
        property color gradient_aurora_end: "#7C5CFF"
        property color gradient_sunset_start: "#FFB347"
        property color gradient_sunset_end: "#FF6B6B"
        
        // Proxies (Using colorSystem ID for robustness)
        property QtObject bg: QtObject {
            property color primary: colorSystem.bg_primary
            property color secondary: colorSystem.bg_secondary
            property color surface: colorSystem.bg_surface
            property color elevated: colorSystem.bg_elevated
            property color overlay: colorSystem.bg_overlay
            property color glass: colorSystem.bg_glass
        }
        
        property QtObject text: QtObject {
            property color primary: colorSystem.text_primary
            property color secondary: colorSystem.text_secondary
            property color tertiary: colorSystem.text_tertiary
            property color inverse: colorSystem.text_inverse
            property color link: colorSystem.text_link
        }
        
        property QtObject special: QtObject {
            property color purple: colorSystem.special_purple
            property color pink: colorSystem.special_pink
            property color aurora: colorSystem.special_aurora
        }
        
        property QtObject accent: QtObject {
             property color primary: colorSystem.accent_primary
             property color secondary: colorSystem.accent_secondary
             property color tertiary: colorSystem.accent_tertiary
             property color warm: colorSystem.accent_warm
        }
        
        property QtObject semantic: QtObject {
             property color success: colorSystem.semantic_success
             property color warning: colorSystem.semantic_warning
             property color error: colorSystem.semantic_error
             property color info: colorSystem.semantic_info
        }
        
        property QtObject border: QtObject {
             property color default_color: colorSystem.border_default
             property color muted: colorSystem.border_muted
             property color emphasis: colorSystem.border_emphasis
        }
        
        property QtObject gradient: QtObject {
            property color aurora_start: colorSystem.gradient_aurora_start
            property color aurora_end: colorSystem.gradient_aurora_end
            property color sunset_start: colorSystem.gradient_sunset_start
            property color sunset_end: colorSystem.gradient_sunset_end
        }
    }
    
    // -------------------------------------------------------------------------
    // Elevation
    // -------------------------------------------------------------------------
    
    property QtObject elevation: QtObject {
        property color shadow_color_sm: darkMode ? Qt.rgba(0,0,0,0.4) : Qt.rgba(0,0,0,0.08)
        property color shadow_color_md: darkMode ? Qt.rgba(0,0,0,0.4) : Qt.rgba(0,0,0,0.1)
        property color shadow_color_lg: darkMode ? Qt.rgba(0,0,0,0.45) : Qt.rgba(0,0,0,0.12)
        property color shadow_color_xl: darkMode ? Qt.rgba(0,0,0,0.5) : Qt.rgba(0,0,0,0.15)
    }
    
    property QtObject blur: QtObject {
        property int sm: 8
        property int md: 16
        property int lg: 24
    }
    
    // -------------------------------------------------------------------------
    // Typography (Responsive)
    // -------------------------------------------------------------------------

    property QtObject typography: QtObject {
        // Base scale factor based on width class
        // Compact=0, Regular=1, Expanded=2
        property real scale: LayoutService.widthClass === 0 ? 0.9 : (LayoutService.widthClass === 2 ? 1.1 : 1.0)
        
        property font display_hero: Qt.font({
            family: "Helvetica", pixelSize: Math.round(128 * scale), weight: Font.Light, letterSpacing: -0.03 * 128
        })
        
        property font display_large: Qt.font({
            family: "Helvetica", pixelSize: Math.round(96 * scale), weight: Font.Light, letterSpacing: -0.02 * 96
        })
        
        property font display_medium: Qt.font({
            family: "Helvetica", pixelSize: Math.round(72 * scale), weight: Font.Light, letterSpacing: -0.02 * 72
        })
        
        property font display_small: Qt.font({
            family: "Helvetica", pixelSize: Math.round(48 * scale), weight: Font.Normal, letterSpacing: -0.01 * 48
        })
        
        property font headline_large: Qt.font({
            family: "Helvetica", pixelSize: Math.round(40 * scale), weight: Font.Bold, letterSpacing: -0.01 * 40
        })
        
        property font headline_medium: Qt.font({
            family: "Helvetica", pixelSize: Math.round(32 * scale), weight: Font.DemiBold, letterSpacing: -0.005 * 32
        })
        
        property font headline_small: Qt.font({
            family: "Helvetica", pixelSize: Math.round(28 * scale), weight: Font.DemiBold
        })

        property font title_large: Qt.font({
            family: "Helvetica", pixelSize: Math.round(24 * scale), weight: Font.Medium
        })
        
        property font title_medium: Qt.font({
            family: "Helvetica", pixelSize: Math.round(20 * scale), weight: Font.Medium
        })
        
        property font title_small: Qt.font({
            family: "Helvetica", pixelSize: Math.round(18 * scale), weight: Font.Medium
        })
        
        property font body_large: Qt.font({
             family: "Helvetica", pixelSize: Math.round(18 * scale), weight: Font.Normal
        })
        
        property font body_medium: Qt.font({
             family: "Helvetica", pixelSize: Math.round(16 * scale), weight: Font.Normal
        })
        
        property font body_small: Qt.font({
             family: "Helvetica", pixelSize: Math.round(14 * scale), weight: Font.Normal, letterSpacing: 0.005 * 14
        })
        
        property font caption: Qt.font({
             family: "Helvetica", pixelSize: Math.round(12 * scale), weight: Font.Normal, letterSpacing: 0.01 * 12
        })
        
        property font overline: Qt.font({
             family: "Helvetica", pixelSize: Math.round(11 * scale), weight: Font.DemiBold, letterSpacing: 0.08 * 11, capitalization: Font.AllUppercase
        })
    }
    
    // -------------------------------------------------------------------------
    // Spacing (Responsive)
    // -------------------------------------------------------------------------
    
    property QtObject spacing: QtObject {
        // Multiplier based on width class: Compact=0.8, Regular=1.0, Expanded=1.2
        property real factor: LayoutService.widthClass === 0 ? 0.8 : (LayoutService.widthClass === 2 ? 1.25 : 1.0)
        
        property int space_0: 0
        property int space_1: Math.max(4, 4 * factor)
        property int space_2: Math.max(6, 8 * factor)
        property int space_3: Math.max(10, 16 * factor) // Adjusted logic for Compact vs Regular jump
        property int space_4: Math.max(16, 24 * factor)
        property int space_5: Math.max(24, 32 * factor)
        property int space_6: Math.max(32, 48 * factor)
        property int space_7: Math.max(40, 64 * factor)
        property int space_8: Math.max(48, 80 * factor)
        property int space_9: Math.max(64, 96 * factor)
        property int space_10: Math.max(80, 128 * factor)
        property int space_11: Math.max(96, 160 * factor)
    }
    
    // -------------------------------------------------------------------------
    // Shape System
    // -------------------------------------------------------------------------
    
    property QtObject shapes: QtObject {
        property int radius_none: 0
        property int radius_xs: 4
        property int radius_sm: 8
        property int radius_md: 12
        property int radius_lg: 16
        property int radius_xl: 20
        property int radius_2xl: 28
        property int radius_3xl: 36
        property int radius_full: 9999
    }
    
    // -------------------------------------------------------------------------
    // Motion System
    // -------------------------------------------------------------------------
    
    property QtObject motion: QtObject {
        property int duration_instant: 0
        property int duration_fastest: 100
        property int duration_fast: 150
        property int duration_normal: 200
        property int duration_slow: 300
        property int duration_slower: 400
        property int duration_slowest: 500
        
        property var ease_linear: Easing.Linear
        property var ease_out: Easing.OutCubic
        property var ease_in: Easing.InCubic
        property var ease_in_out: Easing.InOutCubic
        property var ease_bounce: Easing.OutBack
    }
    
    // -------------------------------------------------------------------------
    // Helper Functions
    // -------------------------------------------------------------------------
    
    // PERFORMANCE: Centralized icon path to avoid repeated string concatenation
    function icon(name) {
        return "qrc:/qt/qml/NordicHeadunit/assets/icons/" + name + ".svg"
    }
}
