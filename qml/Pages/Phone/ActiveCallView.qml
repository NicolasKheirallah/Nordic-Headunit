import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Item {
    id: root
    
    // Properties to bind to service
    property bool isMuted: PhoneService.muted
    property int audioRoute: PhoneService.audioRoute
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: NordicTheme.spacing.space_4
        
        // Caller Info
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: NordicTheme.spacing.space_2
            
            // Avatar / Placeholder
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 120
                height: 120
                radius: 60
                color: Theme.accentSecondary
                
                NordicText {
                    anchors.centerIn: parent
                    text: (PhoneService.callerName && PhoneService.callerName.length > 0) ? PhoneService.callerName.charAt(0) : "?"
                    type: NordicText.Type.DisplayLarge
                    color: Theme.textPrimary
                }
            }
            
            // Name/Number
            NordicText {
                text: (PhoneService.callerName ?? "") !== "" ? PhoneService.callerName : PhoneService.formatNumber(PhoneService.callerNumber ?? "Unknown")
                type: NordicText.Type.DisplayMedium
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Status / Duration
            NordicText {
                text: PhoneService.callState === "Connected" ? PhoneService.callDuration : qsTr("Calling...")
                type: NordicText.Type.BodyLarge
                color: Theme.textSecondary
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
        // Controls
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: NordicTheme.spacing.space_4
            
            // Mute
            NordicButton {
                variant: root.isMuted ? NordicButton.Variant.Primary : NordicButton.Variant.Secondary
                iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/mic.svg" // Active state indicates Muted
                onClicked: PhoneService.muted = !PhoneService.muted
            }
            
            // Keypad (Toggle) - For sending DTMF
            NordicButton {
                variant: NordicButton.Variant.Secondary
                iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/keypad.svg"
                onClicked: {
                    // Logic to show Keypad overlay or switch tab? 
                    // For now, maybe just consistent navigation
                }
            }
            
            // Audio Route
            NordicButton {
                variant: NordicButton.Variant.Secondary
                iconSource: (root.audioRoute === 2) ? "qrc:/qt/qml/NordicHeadunit/assets/icons/speaker.svg" : 
                            (root.audioRoute === 1) ? "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" :
                            "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                            
                onClicked: {
                     // Cycle routes: 0->1->2->0
                     var next = (PhoneService.audioRoute + 1) % 3
                     PhoneService.audioRoute = next
                }
            }
        }
        
        // End Call Action (Distinct/Large)
        NordicButton {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 200
            text: qsTr("End Call")
            variant: NordicButton.Variant.Danger
            iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" // hangup icon usually phone-down
            onClicked: PhoneService.endCall()
        }
    }
}
