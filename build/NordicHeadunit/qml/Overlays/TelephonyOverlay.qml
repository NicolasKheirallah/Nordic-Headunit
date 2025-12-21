import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import QtQuick.Effects

Item {
    id: root
    
    // Visibility controlled by OverlayManager or Bindings
    // But we also self-manage based on call state?
    // Better to let OverlayManager/Bindings manage 'visible' property if possible,
    // OR we bind visible to PhoneService state directly for robustness.
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
        color: NordicTheme.colors.bg.primary
        visible: root.viewMode === "Full"
        
        // Minimize Button (Top Right)
        NordicButton {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: NordicTheme.spacing.space_4
            text: "Minimize"
            variant: NordicButton.Variant.Tertiary
            onClicked: root.viewMode = "Mini"
            z: 10
            visible: PhoneService.callState === "Connected" // Only minimize connected calls
        }
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_8
            
            // Avatar / Icon
            Rectangle {
                width: 160
                height: 160
                radius: 80
                color: NordicTheme.colors.bg.elevated
                border.color: NordicTheme.colors.accent.primary
                border.width: 3
                Layout.alignment: Qt.AlignHCenter
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg"
                    size: NordicIcon.Size.XXL
                    anchors.centerIn: parent
                    color: NordicTheme.colors.accent.primary
                    scale: 1.5
                }
                
                // Pulsing animation for incoming
                SequentialAnimation on border.color {
                    running: PhoneService.callState === "Incoming Call"
                    loops: Animation.Infinite
                    ColorAnimation { to: NordicTheme.colors.semantic.success; duration: 800 }
                    ColorAnimation { to: NordicTheme.colors.accent.primary; duration: 800 }
                }
            }
            
            // Info
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: NordicTheme.spacing.space_2
                
                NordicText {
                    text: (PhoneService.activeContactName ?? "") !== "" ? PhoneService.activeContactName : (PhoneService.activeNumber ?? "Unknown")
                    type: NordicText.Type.DisplayMedium
                    Layout.alignment: Qt.AlignHCenter
                }
                
                NordicText {
                    text: PhoneService.callState === "Connected" ? qsTr("Connected") + " • " + PhoneService.callDuration : PhoneService.callState
                    type: NordicText.Type.HeadlineMedium
                    color: PhoneService.callState === "Connected" ? NordicTheme.colors.semantic.success : NordicTheme.colors.text.secondary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            // Controls Container
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: NordicTheme.spacing.space_6
                
                // Secondary Controls (Grid)
                GridLayout {
                    columns: 4
                    columnSpacing: NordicTheme.spacing.space_6
                    rowSpacing: NordicTheme.spacing.space_4
                    visible: PhoneService.callState === "Connected"
                    
                    // Keypad
                    NordicButton {
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/keypad.svg"
                        text: "Keypad"
                        variant: NordicButton.Variant.Secondary
                        size: NordicButton.Size.Lg
                        round: true
                        onClicked: root.showKeypad = !root.showKeypad // Toggle keypad
                    }
                    
                    // Audio Route
                    NordicButton {
                        property int route: 0 // 0=Car, 1=Phone, 2=BT
                        iconSource: route === 0 ? "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg" : 
                                  route === 1 ? "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" : 
                                  "qrc:/qt/qml/NordicHeadunit/assets/icons/speaker.svg"
                        text: route === 0 ? "Vehicle" : route === 1 ? "Handset" : "Speaker"
                        variant: route === 0 ? NordicButton.Variant.Primary : NordicButton.Variant.Secondary
                        size: NordicButton.Size.Lg
                        round: true
                        onClicked: {
                            route = (route + 1) % 3
                            // Mock toast or logic here
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
                    
                    // Mute
                    NordicButton {
                        iconSource: PhoneService.muted ? "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_off.svg" : "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_up.svg"
                        text: PhoneService.muted ? "Unmute" : "Mute"
                        variant: PhoneService.muted ? NordicButton.Variant.Accent : NordicButton.Variant.Secondary
                        size: NordicButton.Size.Lg
                        round: true
                        onClicked: PhoneService.muted = !PhoneService.muted
                    }
                }
                
                // Primary Action: Answer / End
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: NordicTheme.spacing.space_6
                    
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
        color: NordicTheme.colors.bg.elevated
        border.width: 1
        border.color: NordicTheme.colors.border.emphasis
        
        // Position: Bottom center, above Dock
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 100 // Leave space for Dock
        anchors.horizontalCenter: parent.horizontalCenter
        
        // Shadow
        layer.enabled: true
        /*
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 16
            shadowOpacity: 0.4
            shadowVerticalOffset: 4
        }
        */
        
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
                        color: NordicTheme.colors.semantic.success
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            NumberAnimation { from: 1; to: 0.3; duration: 1000 }
                            NumberAnimation { from: 0.3; to: 1; duration: 1000 }
                        }
                    }
                    
                    ColumnLayout {
                        spacing: 0
                        NordicText {
                            text: (PhoneService?.activeContactName || PhoneService?.activeNumber || "Unknown Object")
                            type: NordicText.Type.BodyLarge
                            font.weight: Font.Bold
                        }
                        NordicText {
                            text: PhoneService.callDuration
                            type: NordicText.Type.Caption
                            color: NordicTheme.colors.semantic.success
                        }
                    }
                }
            }
            
            // Mini Controls
            NordicButton {
                variant: PhoneService.muted ? NordicButton.Variant.Primary : NordicButton.Variant.Secondary
                text: PhoneService.muted ? "🔇" : "🔊"
                size: NordicButton.Size.Sm
                round: true
                onClicked: PhoneService.muted = !PhoneService.muted
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
