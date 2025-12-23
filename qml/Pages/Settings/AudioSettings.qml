import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: "Advanced Audio"
    
    // 1. Interactive Fader / Balance
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 320
        Layout.leftMargin: NordicTheme.spacing.space_4
        Layout.rightMargin: NordicTheme.spacing.space_4
        Layout.topMargin: NordicTheme.spacing.space_4
        color: NordicTheme.colors.bg.surface
        radius: NordicTheme.shapes.radius_lg
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_4
            
            NordicText {
                text: "Balance & Fader"
                type: NordicText.Type.TitleSmall
                color: Theme.textSecondary
            }
            
            BalanceFader {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                // Bind to C++
                balanceX: SystemSettings.faderX
                balanceY: SystemSettings.faderY
                
                onPositionChanged: (x, y) => {
                    SystemSettings.faderX = x
                    SystemSettings.faderY = y
                }
            }
        }
    }
    
    // 2. 3-Band Equalizer
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 280
        Layout.leftMargin: NordicTheme.spacing.space_4
        Layout.rightMargin: NordicTheme.spacing.space_4
        color: NordicTheme.colors.bg.surface
        radius: NordicTheme.shapes.radius_lg
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_4
            
            NordicText {
                text: "Equalizer"
                type: NordicText.Type.TitleSmall
                color: Theme.textSecondary
            }
            
            Equalizer {
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                // Bind to C++
                bass: SystemSettings.eqBass
                mid: SystemSettings.eqMid
                treble: SystemSettings.eqTreble
                
                onBassModified: (val) => SystemSettings.eqBass = val
                onMidModified: (val) => SystemSettings.eqMid = val
                onTrebleModified: (val) => SystemSettings.eqTreble = val
            }
        }
    }
    
    // 3. Reset Button
    NordicButton {
        Layout.alignment: Qt.AlignHCenter
        text: "Reset Audio Settings"
        variant: NordicButton.Variant.Secondary
        onClicked: {
            SystemSettings.eqBass = 0
            SystemSettings.eqMid = 0
            SystemSettings.eqTreble = 0
            SystemSettings.faderX = 0.0
            SystemSettings.faderY = 0.0
        }
    }
}
