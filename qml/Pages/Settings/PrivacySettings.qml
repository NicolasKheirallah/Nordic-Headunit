import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: "Privacy & Data"
    
    // Alert Block
    NordicCard {
        Layout.fillWidth: true
        variant: NordicCard.Variant.Outlined
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16
            
            NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/lock.svg"
                color: NordicTheme.colors.semantic.warning
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                NordicText { text: "Data Sharing Control"; type: NordicText.Type.BodyLarge }
                NordicText { text: "You are in control of what you share."; type: NordicText.Type.Caption; color: Theme.textSecondary }
            }
        }
    }
    
    SettingsToggle {
        title: "Location Services"
        subtitle: "Allow apps to access vehicle location"
        checked: true
    }
    
    SettingsToggle {
        title: "Improve Nordic AI"
        subtitle: "Share anonymous usage data"
        checked: false
    }
    
    SettingsToggle {
        title: "Traffic Data Sharing"
        subtitle: "Help others by sharing real-time speed"
        checked: true
    }
}
