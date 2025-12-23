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
        onTextChanged: PhoneService.contactsModel.setFilter(text)
    }
    
    // Contacts List
    ListView {
        id: contactsList
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 1 
        model: PhoneService.contactsModel
        
        delegate: NordicListItem {
            width: ListView.view.width
            text: model.name // ContactsModel roles are set: name, number, avatar
            secondaryText: PhoneService.formatNumber(model.number)
            
            // Avatar Placeholder
            leading: Component {
                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: Theme.accentSecondary
                    NordicText {
                        anchors.centerIn: parent
                        text: (model.name && model.name.length > 0) ? model.name.charAt(0) : "?"
                        type: NordicText.Type.TitleMedium
                        color: Theme.textPrimary
                    }
                }
            }
            
            onClicked: PhoneService.dial(model.number)
        }
        
        NordicText {
            anchors.centerIn: parent
            text: qsTr("No contacts found")
            visible: contactsList.count === 0
            type: NordicText.Type.BodyLarge
            color: Theme.textSecondary
        }
    }
}
