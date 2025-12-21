import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: "Display & Appearance"
    
    SettingsToggle {
        title: "Dark Mode"
        subtitle: SystemSettings.darkMode ? "Nordic Night" : "Nordic Day"
        checked: SystemSettings.darkMode
        onToggled: SystemSettings.darkMode = checked
    }
    
    SettingsSlider {
        title: "Brightness"
        value: SystemSettings.brightness
        from: 10
        to: 100
        stepSize: 10
        unit: "%"
        onMoved: () => SystemSettings.brightness = value
    }
    
    SettingsToggle {
        title: "Bottom Bar"
        subtitle: SystemSettings.bottomBarEnabled ? "Always visible" : "Hidden"
        checked: SystemSettings.bottomBarEnabled
        onToggled: (isChecked) => SystemSettings.bottomBarEnabled = isChecked
    }
}
