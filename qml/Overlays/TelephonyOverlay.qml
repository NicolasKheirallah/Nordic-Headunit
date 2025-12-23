import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import QtQuick.Effects

Item {
    id: root
    
    // Visibility controlled by OverlayManager or Bindings
    visible: PhoneService.callState !== "Idle"
    
    // State: "Full" or "Mini"
    property string viewMode: "Full"
    property bool showKeypad: false
    
    // Reset to Full on new call
    onVisibleChanged: {
        if (visible) {
            viewMode = "Full"
        }
    }
    
    // -------------------------------------------------------------------------
    // Full Screen Mode
    // -------------------------------------------------------------------------
    Rectangle {
        id: fullView
        anchors.fill: parent
        color: Theme.background
        visible: root.viewMode === "Full"
        
        // Minimize Button (Top Right)
        NordicButton {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Theme.spacingSm
            text: "Minimize"
            variant: NordicButton.Variant.Tertiary
            onClicked: root.viewMode = "Mini"
            z: 10
            visible: PhoneService.callState === "Connected"
        }
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Theme.spacingXl
            
            // Avatar / Icon
            Rectangle {
                width: 160
                height: 160
                radius: 80
                color: Theme.surfaceAlt
                border.color: Theme.accent
                border.width: 3
                Layout.alignment: Qt.AlignHCenter
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg"
                    size: NordicIcon.Size.XXL
                    anchors.centerIn: parent
                    color: Theme.accent
                    scale: 1.5
                }
                
                // Pulsing animation for incoming
                SequentialAnimation on border.color {
                    running: PhoneService.callState === "Incoming Call"
                    loops: Animation.Infinite
                    ColorAnimation { to: Theme.success; duration: 800 }
                    ColorAnimation { to: Theme.accent; duration: 800 }
                }
            }
            
            // Info
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacingXs
                
                NordicText {
                    text: (PhoneService.callerName ?? "") !== "" ? PhoneService.callerName : (PhoneService.callerNumber ?? "Unknown")
                    type: NordicText.Type.DisplayMedium
                    Layout.alignment: Qt.AlignHCenter
                }
                
                NordicText {
                    text: PhoneService.callState === "Connected" ? qsTr("Connected") + " • " + PhoneService.callDuration : PhoneService.callState
                    type: NordicText.Type.HeadlineMedium
                    color: PhoneService.callState === "Connected" ? Theme.success : Theme.textSecondary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            // Controls Container
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacingLg
                
                // Secondary Controls (Grid)
                GridLayout {
                    columns: 4
                    columnSpacing: Theme.spacingLg
                    rowSpacing: Theme.spacingSm
                    visible: PhoneService.callState === "Connected"
                    
                    // Keypad
                    NordicButton {
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/keypad.svg"
                        text: "Keypad"
                        variant: NordicButton.Variant.Secondary
                        size: NordicButton.Size.Lg
                        round: true
                        onClicked: root.showKeypad = !root.showKeypad
                    }
                    
                    // Audio Route
                    NordicButton {
                        property int route: 0
                        iconSource: route === 0 ? "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg" : 
                                  route === 1 ? "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" : 
                                  "qrc:/qt/qml/NordicHeadunit/assets/icons/speaker.svg"
                        text: route === 0 ? "Vehicle" : route === 1 ? "Handset" : "Speaker"
                        variant: route === 0 ? NordicButton.Variant.Primary : NordicButton.Variant.Secondary
                        size: NordicButton.Size.Lg
                        round: true
                        onClicked: {
                            route = (route + 1) % 3
                        }
                    }
                    
                    // Add Call
                    NordicButton {
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/add_call.svg"
                        text: "Add Call"
                        variant: NordicButton.Variant.Secondary
                        size: NordicButton.Size.Lg
                        round: true
                        onClicked: { /* Mock Add Call */ }
                    }
                    
                    // Mute (placeholder - PhoneService doesn't have mute property yet)
                    NordicButton {
                        property bool isMuted: false
                        iconSource: isMuted ? "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_off.svg" : "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_up.svg"
                        text: isMuted ? "Unmute" : "Mute"
                        variant: isMuted ? NordicButton.Variant.Accent : NordicButton.Variant.Secondary
                        size: NordicButton.Size.Lg
                        round: true
                        onClicked: isMuted = !isMuted
                    }
                }
                
                // Primary Action: Answer / End
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Theme.spacingLg
                    
                    // Answer (Incoming Only)
                    NordicButton {
                        visible: PhoneService.callState === "Incoming Call"
                        text: qsTr("Answer")
                        variant: NordicButton.Variant.Success
                        size: NordicButton.Size.Xl
                        round: true
                        onClicked: PhoneService.answerCall()
                    }
                    
                    // End Call (Always visible if not idle)
                    NordicButton {
                        text: PhoneService.callState === "Incoming Call" ? "Decline" : "End Call"
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" 
                        variant: NordicButton.Variant.Danger
                        size: NordicButton.Size.Xl
                        round: true
                        onClicked: PhoneService.endCall()
                    }
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // Mini Mode (Floating Bar)
    // -------------------------------------------------------------------------
    Rectangle {
        id: miniView
        visible: root.viewMode === "Mini"
        width: 500
        height: 80
        radius: 40
        color: Theme.surfaceAlt
        border.width: 1
        border.color: Theme.borderEmphasis
        
        // Position: Bottom center, above Dock
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        
        // Shadow
        layer.enabled: true
        
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 10
            spacing: 16
            
            // Tap to Expand
            MouseArea {
                Layout.fillWidth: true
                Layout.fillHeight: true
                onClicked: root.viewMode = "Full"
                
                RowLayout {
                    anchors.fill: parent
                    spacing: 12
                    
                    // Pulse Icon
                    Rectangle {
                        width: 12; height: 12; radius: 6
                        color: Theme.success
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation { from: 1; to: 0.3; duration: 1000 }
                            NumberAnimation { from: 0.3; to: 1; duration: 1000 }
                        }
                    }
                    
                    ColumnLayout {
                        spacing: 0
                        NordicText {
                            text: (PhoneService.callerName ?? "") !== "" ? PhoneService.callerName : (PhoneService.callerNumber ?? "Unknown")
                            type: NordicText.Type.BodyLarge
                            font.weight: Font.Bold
                        }
                        NordicText {
                            text: PhoneService.callDuration
                            type: NordicText.Type.Caption
                            color: Theme.success
                        }
                    }
                }
            }
            
            // Mini Controls
            NordicButton {
                property bool isMuted: false
                variant: isMuted ? NordicButton.Variant.Primary : NordicButton.Variant.Secondary
                text: isMuted ? "🔇" : "🔊"
                size: NordicButton.Size.Sm
                round: true
                onClicked: isMuted = !isMuted
            }
            
            NordicButton {
                variant: NordicButton.Variant.Danger
                iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg"
                size: NordicButton.Size.Sm
                round: true
                onClicked: PhoneService.endCall()
            }
        }
    }
}
