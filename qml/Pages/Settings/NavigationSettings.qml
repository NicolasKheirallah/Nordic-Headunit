import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: "Navigation Preferences"
    
    SettingsToggle {
        title: "Voice Guidance"
        subtitle: "Spoken turn-by-turn directions"
        checked: true // TODO: Bind to SystemSettings.voiceGuidance
    }
    
    SettingsSlider {
        title: "Guidance Volume"
        value: 80
        from: 0; to: 100
        stepSize: 10
        unit: "%"
    }
    
    SettingsCategory {
        title: "Map Orientation"
        description: "North Up / Heads Up (3D)"
        // Placeholder for selector
    }
}
