import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: qsTr("System")
    
    signal languageClicked()
    
    SettingsItem {
        title: qsTr("Language")
        subtitle: TranslationService.currentLanguage
        showChevron: true
        onClicked: languageClicked()
    }
    
    SettingsToggle {
        title: qsTr("Use Metric Units")
        subtitle: SystemSettings.useMetric ? "km, °C, kg" : "mi, °F, lb"
        checked: SystemSettings.useMetric
        onToggled: (checked) => SystemSettings.useMetric = checked
    }
    
    SettingsItem {
        title: qsTr("Software Update")
        subtitle: qsTr("Check for updates")
        showChevron: true
    }
    
    // Storage Visualization - Cleaned up
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 90
        color: "transparent"
        Layout.leftMargin: NordicTheme.spacing.space_4
        Layout.rightMargin: NordicTheme.spacing.space_4
        
        ColumnLayout {
            anchors.fill: parent
            spacing: NordicTheme.spacing.space_2
            
            RowLayout {
                Layout.fillWidth: true
                NordicText { 
                    text: qsTr("Storage")
                    type: NordicText.Type.BodyMedium 
                    color: Theme.textPrimary
                }
                Item { Layout.fillWidth: true }
                NordicText { 
                    text: "32 GB " + qsTr("used") + " / 64 GB " + qsTr("total")
                    type: NordicText.Type.Caption 
                    color: Theme.textTertiary
                }
            }
            
            // Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 12
                radius: 6
                color: Theme.surfaceAlt
                clip: true
                
                Row {
                    anchors.fill: parent
                    // Music (50%)
                    Rectangle { width: parent.width * 0.5; height: parent.height; color: Theme.accent }
                    // Maps (25%)
                    Rectangle { width: parent.width * 0.25; height: parent.height; color: NordicTheme.colors.semantic.info }
                    // System (15%)
                    Rectangle { width: parent.width * 0.15; height: parent.height; color: Theme.textTertiary }
                }
            }
            
            // Legend
            Row {
                spacing: 16
                Repeater {
                    model: [ 
                        {l: qsTr("Music"), c: Theme.accent},
                        {l: qsTr("Maps"), c: NordicTheme.colors.semantic.info},
                        {l: qsTr("System"), c: Theme.textTertiary}
                    ]
                    delegate: Row {
                        spacing: 6
                        Rectangle { width: 8; height: 8; radius: 4; color: modelData.c; anchors.verticalCenter: parent.verticalCenter }
                        NordicText { text: modelData.l; type: NordicText.Type.Caption; color: Theme.textTertiary }
                    }
                }
            }
        }
    }
    
    SettingsItem {
        title: qsTr("About")
        subtitle: "Nordic HU-1 v" + SystemSettings.version
        showChevron: true
    }
    
    // Factory Reset
    NordicButton {
        Layout.fillWidth: true
        Layout.margins: NordicTheme.spacing.space_4
        text: qsTr("Factory Reset")
        variant: NordicButton.Variant.Danger
        onClicked: resetConfirmationModal.open()
    }
    
    NordicModal {
        id: resetConfirmationModal
        title: qsTr("Factory Reset")
        message: qsTr("Are you sure you want to erase all data and restore settings to default? This cannot be undone.")
        type: NordicModal.Type.Alert
        actions: [
            { label: qsTr("Cancel"), primary: false, triggered: () => console.log("Cancelled") },
            { label: qsTr("Reset"), primary: true, destructive: true, triggered: () => {
                SystemSettings.factoryReset()
                showToast(qsTr("System Reset Complete"), NordicToast.Type.Success)
            }}
        ]
    }
}
