import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

ColumnLayout {
    spacing: NordicTheme.spacing.space_4
    
    // Filter Tabs (Segmented Control style)
    RowLayout {
        Layout.fillWidth: true
        spacing: NordicTheme.spacing.space_4
        
        NordicButton {
            text: qsTr("All")
            variant: PhoneService.recentsFilter === "All" ? NordicButton.Variant.Primary : NordicButton.Variant.Secondary
            Layout.fillWidth: true
            onClicked: PhoneService.recentsFilter = "All"
        }
        
        NordicButton {
            text: qsTr("Missed")
            variant: PhoneService.recentsFilter === "Missed" ? NordicButton.Variant.Primary : NordicButton.Variant.Secondary
            Layout.fillWidth: true
            onClicked: PhoneService.recentsFilter = "Missed"
        }
    }
    
    // Recents List
    ListView {
        id: recentsList
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: NordicTheme.spacing.space_2
        model: PhoneService.filteredRecents
        
        delegate: NordicListItem {
            width: ListView.view.width
            text: modelData.name
            secondaryText: PhoneService.formatNumber(modelData.number) + " • " + modelData.time
            
            leading: Component {
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg"
                    color: modelData.callType === "missed" ? Theme.danger : 
                           modelData.callType === "incoming" ? Theme.success :
                           Theme.textSecondary
                }
            }
            
            trailing: Component {
                NordicButton {
                    variant: NordicButton.Variant.Icon
                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg"
                    onClicked: PhoneService.dial(modelData.number)
                }
            }
        }
        
        NordicText {
            anchors.centerIn: parent
            text: qsTr("No calls found")
            visible: recentsList.count === 0
            type: NordicText.Type.BodyLarge
            color: Theme.textSecondary
        }
    }
}
