import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// ResponsiveText - Standardized typography that adapts to widget size
Text {
    id: root

    // API
    property int type: NordicText.Type.BodyMedium // Default style
    property bool fit: false // If true, scales down to fit width
    property real minPixelSize: 12
    property real maxPixelSize: 100
    
    // Automatic properties based on NordicTheme
    color: NordicTheme.colors.text.primary
    font.family: "Helvetica" // Standardize on system font
    
    // Logic from NordicText
    font.pixelSize: {
        var baseSize = 16
        switch(type) {
            case NordicText.Type.DisplayLarge: baseSize = 48; break;
            case NordicText.Type.DisplayMedium: baseSize = 36; break;
            case NordicText.Type.DisplaySmall: baseSize = 28; break;
            case NordicText.Type.HeadlineLarge: baseSize = 24; break;
            case NordicText.Type.HeadlineMedium: baseSize = 20; break;
            case NordicText.Type.TitleLarge: baseSize = 18; break;
            case NordicText.Type.TitleMedium: baseSize = 16; break;
            case NordicText.Type.TitleSmall: baseSize = 14; break;
            case NordicText.Type.BodyLarge: baseSize = 16; break;
            case NordicText.Type.BodyMedium: baseSize = 14; break;
            case NordicText.Type.BodySmall: baseSize = 12; break;
            case NordicText.Type.Caption: baseSize = 12; break;
        }
        
        // Dynamic scaling if 'fit' is enabled
        if (fit && parent) {
             // Rough constraint-based scaling
             // We don't want to layout-loop, so we use extensive 'min' logic
             // But Text.Fit mode is native in QtQuick.
             return baseSize // Delegate to fontSizeMode if standard
        }
        return baseSize
    }
    
    // Enforce Fit Mode if requested
    fontSizeMode: fit ? Text.Fit : Text.FixedSize
    minimumPixelSize: fit ? minPixelSize : 0
    
    // Weight mapping
    font.weight: {
        switch(type) {
            case NordicText.Type.DisplayLarge: 
            case NordicText.Type.DisplayMedium: 
            case NordicText.Type.DisplaySmall: return Font.Light;
            case NordicText.Type.HeadlineLarge:
            case NordicText.Type.HeadlineMedium: return Font.Bold;
            case NordicText.Type.TitleLarge:
            case NordicText.Type.TitleMedium:
            case NordicText.Type.TitleSmall: return Font.DemiBold;
            default: return Font.Normal;
        }
    }
}
