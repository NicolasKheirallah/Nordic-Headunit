import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: "Date & Time"
    
    SettingsToggle {
        title: qsTr("Automatic Date & Time")
        subtitle: qsTr("Use network-provided time")
        checked: SystemSettings.autoTime
        onCheckedChanged: SystemSettings.autoTime = checked
    }
    
    SettingsToggle {
        title: qsTr("24-Hour Format")
        subtitle: qsTr("Display time in 24-hour format")
        checked: SystemSettings.use24HourFormat
        onCheckedChanged: SystemSettings.use24HourFormat = checked
    }
    
    SettingsItem {
        title: qsTr("Time Zone")
        subtitle: SystemSettings.timeZone + " (UTC+1)"
        showChevron: true
        enabled: !SystemSettings.autoTime
        opacity: enabled ? 1.0 : 0.5
        onClicked: timeZoneDialog.open()
    }
    
    SettingsItem {
        title: qsTr("Set Date")
        subtitle: Qt.formatDate(new Date(), "ddd, MMM d, yyyy")
        showChevron: true
        enabled: !SystemSettings.autoTime
        opacity: enabled ? 1.0 : 0.5
        onClicked: dateDialog.open()
    }
    
    SettingsItem {
        title: qsTr("Set Time")
        subtitle: Qt.formatTime(new Date(), SystemSettings.use24HourFormat ? "HH:mm" : "h:mm AP")
        showChevron: true
        enabled: !SystemSettings.autoTime
        opacity: enabled ? 1.0 : 0.5
        onClicked: timeDialog.open()
    }
    
    // -------------------------------------------------------------------------
    // Dialogs
    // -------------------------------------------------------------------------
    
    // Time Zone Picker
    NordicModal {
        id: timeZoneDialog
        title: qsTr("Select Time Zone")
        message: qsTr("Select your local time zone")
        
        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            Layout.maximumHeight: 400
            clip: true
            model: SystemSettings.availableTimeZones
            
            // ScrollBar
            ScrollBar.vertical: ScrollBar { active: true }
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 56
                color: "transparent"
                
                property bool isSelected: modelData === SystemSettings.timeZone
                
                NordicText {
                    anchors.centerIn: parent
                    text: modelData
                    type: NordicText.Type.BodyLarge
                    color: isSelected ? Theme.accent : Theme.textPrimary
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        SystemSettings.timeZone = modelData
                        timeZoneDialog.close()
                    }
                }
                
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: NordicTheme.colors.border.muted
                    visible: ListView.view ? index < ListView.view.count - 1 : false
                }
            }
        }
        
        actions: [
            NordicButton { 
                text: qsTr("Cancel")
                variant: NordicButton.Variant.Secondary
                Layout.fillWidth: true
                onClicked: timeZoneDialog.close() 
            }
        ]
    }
    
    // Date Picker (Tumblers)
    NordicModal {
        id: dateDialog
        title: qsTr("Set Date")
        message: ""
        
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: NordicTheme.spacing.space_4
            
            Component {
                id: tumblerDelegate
                Text {
                    text: modelData
                    color: Tumbler.displacement === 0 ? Theme.accent : Theme.textSecondary
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                }
            }

            // Day
            Tumbler {
                id: dayTumbler
                model: 31
                visibleItemCount: 3
                delegate: tumblerDelegate
                // Adjust model to 1-based index (logic in save)
            }
            
            // Month
            Tumbler {
                id: monthTumbler
                model: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                visibleItemCount: 3
                delegate: tumblerDelegate
            }
            
            // Year
            Tumbler {
                id: yearTumbler
                model: [2024, 2025, 2026, 2027, 2028, 2029, 2030]
                visibleItemCount: 3
                delegate: tumblerDelegate
            }
        }
        
        actions: [
            NordicButton {
                text: qsTr("Save")
                Layout.fillWidth: true
                onClicked: {
                    // +1 for Day (model is 0-30), +1 for Month (0-11)
                    // Year model is array, so get value
                    var y = 2024 + yearTumbler.currentIndex
                    SystemSettings.setDate(y, monthTumbler.currentIndex + 1, dayTumbler.currentIndex + 1)
                    dateDialog.close()
                }
            },
            NordicButton {
                text: qsTr("Cancel")
                variant: NordicButton.Variant.Secondary
                Layout.fillWidth: true
                onClicked: dateDialog.close()
            }
        ]
    }
    
    // Time Picker
    NordicModal {
        id: timeDialog
        title: qsTr("Set Time")
        message: ""
        
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: NordicTheme.spacing.space_4
            
            Tumbler {
                id: hourTumbler
                model: 24
                visibleItemCount: 3
                delegate: tumblerDelegate
            }
            
            NordicText { text: ":" }
            
            Tumbler {
                id: minuteTumbler
                model: 60
                visibleItemCount: 3
                delegate: tumblerDelegate
            }
        }
        
        actions: [
            NordicButton {
                text: qsTr("Save")
                Layout.fillWidth: true
                onClicked: {
                    SystemSettings.setTime(hourTumbler.currentIndex, minuteTumbler.currentIndex)
                    timeDialog.close()
                }
            },
            NordicButton {
                text: qsTr("Cancel")
                variant: NordicButton.Variant.Secondary
                Layout.fillWidth: true
                onClicked: timeDialog.close()
            }
        ]
    }
}
