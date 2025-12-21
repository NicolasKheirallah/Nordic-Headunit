import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: "Vehicle"
    

    
    // -------------------------------------------------------------------------
    // Lights Card
    // -------------------------------------------------------------------------
    NordicCard {
        Layout.fillWidth: true
        Layout.leftMargin: NordicTheme.spacing.space_4
        Layout.rightMargin: NordicTheme.spacing.space_4
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_3
            
            NordicText { text: "Exterior Lights"; type: NordicText.Type.TitleMedium }
            
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                spacing: 4
                Repeater {
                    model: ["Auto", "Park", "On", "Off"]
                    delegate: Rectangle {
                        Layout.fillWidth: true; Layout.fillHeight: true
                        color: SystemSettings.lightsMode === index ? NordicTheme.colors.accent.primary : NordicTheme.colors.bg.elevated
                        radius: 8
                        NordicText {
                            anchors.centerIn: parent
                            text: modelData
                            color: SystemSettings.lightsMode === index ? "white" : NordicTheme.colors.text.secondary
                        }
                        MouseArea { anchors.fill: parent; onClicked: SystemSettings.lightsMode = index }
                    }
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // Settings Toggles
    // -------------------------------------------------------------------------
    SettingsToggle {
        title: "Walk-Away Lock"
        subtitle: "Lock doors when key leaves range"
        checked: SystemSettings.walkAwayLock
        onToggled: (checked) => SystemSettings.walkAwayLock = checked
    }
    
    SettingsToggle {
        title: "Child Lock"
        subtitle: "Rear doors & windows locked"
        checked: SystemSettings.childLock
        onToggled: (checked) => SystemSettings.childLock = checked
    }
    
    SettingsToggle {
        title: "Auto-Fold Mirrors"
        subtitle: "Fold when locked"
        checked: SystemSettings.autoFoldMirrors
        onToggled: (checked) => SystemSettings.autoFoldMirrors = checked
    }
    
    SettingsToggle {
        title: "Rain Sensing Wipers"
        subtitle: "Auto-adjust speed"
        checked: SystemSettings.rainSensingWipers
        onToggled: (checked) => SystemSettings.rainSensingWipers = checked
    }
}
