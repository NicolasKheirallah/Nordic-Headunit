import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

ColumnLayout {
    spacing: NordicTheme.spacing.space_4
    
    // Search Bar
    NordicTextField {
        Layout.fillWidth: true
        placeholderText: qsTr("Search Contacts")
        // icon: "search" (if supported)
        onTextChanged: PhoneService.searchQuery = text
    }
    
    // Contacts List
    ListView {
        id: contactsList
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 1 // Separator line style or minimal spacing
        model: PhoneService.filteredContacts
        
        delegate: NordicListItem {
            width: ListView.view.width
            text: model.name
            secondaryText: model.number
            
            // Avatar Placeholder
            leading: Rectangle {
                width: 40
                height: 40
                radius: 20
                color: NordicTheme.colors.accent.secondary
                NordicText {
                    anchors.centerIn: parent
                    text: model.name.charAt(0)
                    type: NordicText.Type.TitleMedium
                    color: NordicTheme.colors.text.primary
                }
            }
            
            onClicked: PhoneService.dial(model.number)
        }
        
        NordicText {
            anchors.centerIn: parent
            text: qsTr("No contacts found")
            visible: contactsList.count === 0
            type: NordicText.Type.BodyLarge
            color: NordicTheme.colors.text.secondary
        }
    }
}
