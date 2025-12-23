import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Settings Category - A titled section that groups related settings
// Usage:
//   SettingsCategory {
//       title: "Theme"
//       SettingsItem { ... }
//       SettingsToggle { ... }
//   }

ColumnLayout {
    id: root
    
    property string title: ""
    default property alias content: contentColumn.data
    
    Layout.fillWidth: true
    spacing: Theme.spacingXs
    Layout.bottomMargin: Theme.spacingMd
    
    // Section Header
    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: Theme.spacingSm
        spacing: Theme.spacingXs
        
        Rectangle {
            width: 4
            height: 20
            radius: 2
            color: Theme.accent
        }
        
        NordicText {
            text: root.title
            type: NordicText.Type.TitleSmall
            color: Theme.textSecondary
            Layout.fillWidth: true
        }
    }
    
    // Content area for child items
    ColumnLayout {
        id: contentColumn
        Layout.fillWidth: true
        spacing: Theme.spacingXs
    }
}
