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
            text: model.name
            secondaryText: model.number + " • " + model.time
            
            leading: NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" // Could define specific arrow icons for in/out/missed
                color: model.callType === "missed" ? NordicTheme.colors.semantic.error : 
                       model.callType === "incoming" ? NordicTheme.colors.semantic.success :
                       NordicTheme.colors.text.secondary
            }
            
            trailing: NordicButton {
                variant: NordicButton.Variant.Icon
                iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg"
                onClicked: PhoneService.dial(model.number)
            }
        }
        
        NordicText {
            anchors.centerIn: parent
            text: qsTr("No calls found")
            visible: recentsList.count === 0
            type: NordicText.Type.BodyLarge
            color: NordicTheme.colors.text.secondary
        }
    }
}
