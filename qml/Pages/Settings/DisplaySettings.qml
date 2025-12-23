import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    id: root
    title: "Display & Appearance"
    
    // Signal for navigation to ThemePlayground
    signal themePlaygroundClicked()
    
    // Theme Section
    SettingsCategory {
        title: "Theme"
        
        SettingsItem {
            title: "Color Theme"
            subtitle: Theme.currentTheme.name
            showChevron: true
            onClicked: root.themePlaygroundClicked()
            
            // Theme preview dot as right component
            rightComponent: Component {
                Rectangle {
                    width: 24
                    height: 24
                    radius: 12
                    color: Theme.accent
                }
            }
        }
    }
    
    // Appearance Section
    SettingsCategory {
        title: "Appearance"
        
        SettingsToggle {
            title: "Dark Mode"
            subtitle: Theme.isDark ? "Nordic Night" : "Nordic Day"
            checked: Theme.isDark
            onToggled: Theme.toggleMode()
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
    }
    
    // Layout Section
    SettingsCategory {
        title: "Layout"
        
        SettingsToggle {
            title: "Bottom Bar"
            subtitle: SystemSettings.bottomBarEnabled ? "Always visible" : "Hidden"
            checked: SystemSettings.bottomBarEnabled
            onToggled: (isChecked) => SystemSettings.bottomBarEnabled = isChecked
        }
    }
}
