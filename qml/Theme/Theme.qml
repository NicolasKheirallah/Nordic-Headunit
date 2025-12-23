pragma Singleton
import QtQuick
import NordicHeadunit

// ═══════════════════════════════════════════════════════════════════════════
// THEME MANAGER - Single source of truth for all UI styling
// ═══════════════════════════════════════════════════════════════════════════
// 
// Usage:
//   import Theme 1.0
//   Rectangle { color: Theme.background }
//   Text { color: Theme.textPrimary }
//
// Theme switching:
//   Theme.setTheme("ocean")
//   Theme.toggleMode()
//
// ═══════════════════════════════════════════════════════════════════════════

QtObject {
    id: theme
    
    // -------------------------------------------------------------------------
    // THEME STATE
    // -------------------------------------------------------------------------
    
    // Current theme key from SystemSettings
    readonly property string themeKey: SystemSettings.themeKey
    
    // Dark/Light mode from SystemSettings
    readonly property bool isDark: SystemSettings.darkMode
    
    // Theme switching API
    function setTheme(key) { SystemSettings.themeKey = key }
    function toggleMode() { SystemSettings.darkMode = !SystemSettings.darkMode }
    
    // -------------------------------------------------------------------------
    // THEME REGISTRY - All available themes
    // -------------------------------------------------------------------------
    
    readonly property var themes: ({
        "nordic": {
            name: "Nordic Aurora",
            accent: "#00D4AA",
            secondary: "#38BDF8",
            description: "Signature teal inspired by Northern Lights"
        },
        "ocean": {
            name: "Ocean Blue", 
            accent: "#3B82F6",
            secondary: "#06B6D4",
            description: "Deep blue for focused driving"
        },
        "sunset": {
            name: "Sunset Orange",
            accent: "#F97316",
            secondary: "#FBBF24",
            description: "Warm amber tones"
        },
        "forest": {
            name: "Forest Green",
            accent: "#22C55E",
            secondary: "#84CC16",
            description: "Natural green palette"
        },
        "custom": {
            name: "Custom",
            accent: SystemSettings.customAccentColor,
            secondary: SystemSettings.customSecondaryColor,
            description: "Your personalized colors"
        }
    })
    
    // Get current theme object
    readonly property var currentTheme: themes[themeKey] ?? themes["nordic"]
    
    // -------------------------------------------------------------------------
    // COLOR TOKENS - Semantic color system
    // -------------------------------------------------------------------------
    
    // --- Backgrounds ---
    readonly property color background: isDark ? "#0A0E14" : "#FAFBFC"
    readonly property color surface: isDark ? "#1A2028" : "#FFFFFF"
    readonly property color surfaceAlt: isDark ? "#242C38" : "#F0F2F5"
    readonly property color overlay: isDark ? Qt.rgba(0.04, 0.055, 0.078, 0.85) : Qt.rgba(0, 0, 0, 0.4)
    readonly property color glass: isDark ? Qt.rgba(0.102, 0.125, 0.157, 0.7) : Qt.rgba(1, 1, 1, 0.8)
    
    // --- Text ---
    readonly property color textPrimary: isDark ? "#F8FAFC" : "#0F172A"
    readonly property color textSecondary: isDark ? "#94A3B8" : "#64748B"
    readonly property color textTertiary: isDark ? "#64748B" : "#94A3B8"
    readonly property color textDisabled: isDark ? "#475569" : "#CBD5E1"
    readonly property color textInverse: isDark ? "#0F172A" : "#F8FAFC"
    readonly property color textLink: isDark ? "#38BDF8" : "#0284C7"
    
    // --- Accent Colors (theme-dependent) ---
    readonly property color accent: currentTheme.accent
    readonly property color accentSecondary: currentTheme.secondary
    readonly property color accentHover: Qt.lighter(accent, 1.1)
    readonly property color accentPressed: Qt.darker(accent, 1.15)
    readonly property color accentMuted: Qt.rgba(accent.r, accent.g, accent.b, 0.15)
    
    // --- Semantic States ---
    readonly property color danger: isDark ? "#EF4444" : "#DC2626"
    readonly property color dangerMuted: Qt.rgba(danger.r, danger.g, danger.b, 0.15)
    readonly property color warning: isDark ? "#FBBF24" : "#D97706"
    readonly property color warningMuted: Qt.rgba(warning.r, warning.g, warning.b, 0.15)
    readonly property color success: isDark ? "#22C55E" : "#16A34A"
    readonly property color successMuted: Qt.rgba(success.r, success.g, success.b, 0.15)
    readonly property color info: isDark ? "#38BDF8" : "#0284C7"
    
    // --- Interactive States ---
    readonly property color focus: accent
    readonly property color focusRing: Qt.rgba(accent.r, accent.g, accent.b, 0.5)
    readonly property color selection: Qt.rgba(accent.r, accent.g, accent.b, 0.2)
    readonly property color toggleOn: accent
    readonly property color toggleOff: isDark ? "#475569" : "#CBD5E1"
    
    // --- Borders ---
    readonly property color border: isDark ? "#2D3748" : "#E2E8F0"
    readonly property color borderMuted: isDark ? "#1E293B" : "#F1F5F9"
    readonly property color borderEmphasis: isDark ? "#475569" : "#CBD5E1"
    readonly property color divider: borderMuted
    
    // --- Shadows ---
    readonly property color shadowColor: isDark ? Qt.rgba(0, 0, 0, 0.4) : Qt.rgba(0, 0, 0, 0.1)
    
    // -------------------------------------------------------------------------
    // SPACING TOKENS
    // -------------------------------------------------------------------------
    
    readonly property int spacingXs: 4
    readonly property int spacingSm: 8
    readonly property int spacingMd: 16
    readonly property int spacingLg: 24
    readonly property int spacingXl: 32
    readonly property int spacing2xl: 48
    
    // -------------------------------------------------------------------------
    // RADIUS TOKENS
    // -------------------------------------------------------------------------
    
    readonly property int radiusSm: 8
    readonly property int radiusMd: 12
    readonly property int radiusLg: 16
    readonly property int radiusXl: 24
    readonly property int radiusFull: 9999
    
    // -------------------------------------------------------------------------
    // ANIMATION TOKENS
    // -------------------------------------------------------------------------
    
    readonly property int durationFast: 100
    readonly property int durationNormal: 200
    readonly property int durationSlow: 300
    
    // -------------------------------------------------------------------------
    // HELPER FUNCTIONS
    // -------------------------------------------------------------------------
    
    function formatTime(seconds) {
        if (!seconds && seconds !== 0) return "--:--"
        let m = Math.floor(seconds / 60)
        let s = Math.floor(seconds % 60)
        return m + ":" + (s < 10 ? "0" + s : s)
    }

    // Apply alpha to any color
    function withAlpha(baseColor, alpha) {
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, alpha)
    }
    
    // Get theme info by key
    function getThemeInfo(key) {
        return themes[key] ?? themes["nordic"]
    }
    
    // Get available theme keys
    function getThemeKeys() {
        return Object.keys(themes)
    }
}
