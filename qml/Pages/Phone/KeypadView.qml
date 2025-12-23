import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Item {
    id: root
    
    // Automotive-optimized sizing - LARGE touch targets for driving safety
    property real buttonSize: Math.max(70, Math.min(parent.height / 6, 90))
    property string currentNumber: PhoneService.activeNumber ?? ""
    
    function appendDigit(digit) {
        if (PhoneService.callState === "Idle" && currentNumber.length < 15) {
             currentNumber += digit
             PhoneService.activeNumber = currentNumber
        } else if (PhoneService.callState === "Connected") {
             console.log("DTMF: " + digit)
             PhoneService.sendDtmf(digit)
        }
    }
    
    function backspace() {
        if (currentNumber.length > 0) {
            currentNumber = currentNumber.substring(0, currentNumber.length - 1)
            PhoneService.activeNumber = currentNumber
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: NordicTheme.spacing.space_3
        
        // Number Display - Large and readable
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(80, root.height * 0.15)
            
            RowLayout {
                anchors.centerIn: parent
                spacing: NordicTheme.spacing.space_4
                
                Text {
                    text: PhoneService.formatNumber(currentNumber) || qsTr("Enter Number")
                    font.pixelSize: Math.min(48, root.height * 0.1)
                    font.weight: Font.Medium
                    color: currentNumber ? NordicTheme.colors.text.primary : NordicTheme.colors.text.tertiary
                    Layout.maximumWidth: root.width - 80
                    elide: Text.ElideLeft
                    horizontalAlignment: Text.AlignHCenter
                }
                
                // Backspace - Large touch target
                Rectangle {
                    visible: currentNumber.length > 0
                    width: 48
                    height: 48
                    radius: 24
                    color: backspaceMouse.pressed ? NordicTheme.colors.bg.surface : "transparent"
                    
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/delete.svg"
                        size: NordicIcon.Size.MD
                        color: NordicTheme.colors.text.secondary
                    }
                    
                    MouseArea {
                        id: backspaceMouse
                        anchors.fill: parent
                        onClicked: backspace()
                    }
                }
            }
        }
        
        // Keypad Grid - LARGE buttons for automotive
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            GridLayout {
                anchors.centerIn: parent
                columns: 3
                rowSpacing: NordicTheme.spacing.space_2
                columnSpacing: NordicTheme.spacing.space_3
                
                Repeater {
                    model: [
                        {digit: "1", sub: ""},
                        {digit: "2", sub: "ABC"},
                        {digit: "3", sub: "DEF"},
                        {digit: "4", sub: "GHI"},
                        {digit: "5", sub: "JKL"},
                        {digit: "6", sub: "MNO"},
                        {digit: "7", sub: "PQRS"},
                        {digit: "8", sub: "TUV"},
                        {digit: "9", sub: "WXYZ"},
                        {digit: "*", sub: ""},
                        {digit: "0", sub: "+"},
                        {digit: "#", sub: ""}
                    ]
                    delegate: Rectangle {
                        id: keyButton
                        width: root.buttonSize
                        height: root.buttonSize
                        radius: root.buttonSize / 2
                        color: keyMouse.pressed ? NordicTheme.colors.accent.primary : 
                               keyMouse.containsMouse ? NordicTheme.colors.bg.elevated : 
                               NordicTheme.colors.bg.secondary
                        border.width: keyMouse.containsMouse ? 2 : 0
                        border.color: keyMouse.containsMouse ? NordicTheme.colors.accent.primary : "transparent"
                        
                        Behavior on color { ColorAnimation { duration: 100 } }
                        Behavior on border.color { ColorAnimation { duration: 100 } }
                        Behavior on scale { NumberAnimation { duration: 80 } }
                        
                        scale: keyMouse.pressed ? 0.95 : 1.0
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2
                            
                            Text {
                                text: modelData.digit
                                font.pixelSize: root.buttonSize * 0.4
                                font.weight: Font.Medium
                                color: keyMouse.pressed ? NordicTheme.colors.text.inverse : NordicTheme.colors.text.primary
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Text {
                                visible: modelData.sub !== ""
                                text: modelData.sub
                                font.pixelSize: root.buttonSize * 0.14
                                font.weight: Font.Normal
                                font.letterSpacing: 2
                                color: keyMouse.pressed ? NordicTheme.colors.text.inverse : NordicTheme.colors.text.tertiary
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                        
                        MouseArea {
                            id: keyMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: appendDigit(modelData.digit)
                        }
                    }
                }
            }
        }
        
        // Call Button - Extra large for easy access while driving
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.buttonSize + NordicTheme.spacing.space_4
            
            Rectangle {
                id: callButton
                anchors.centerIn: parent
                width: root.buttonSize * 1.5
                height: root.buttonSize
                radius: height / 2
                color: callMouse.pressed ? Qt.darker(NordicTheme.colors.accent.primary, 1.2) :
                       callMouse.containsMouse ? Qt.lighter(NordicTheme.colors.accent.primary, 1.1) :
                       NordicTheme.colors.accent.primary
                opacity: currentNumber.length > 0 ? 1.0 : 0.5
                
                Behavior on color { ColorAnimation { duration: 100 } }
                scale: callMouse.pressed ? 0.95 : 1.0
                Behavior on scale { NumberAnimation { duration: 80 } }
                
                NordicIcon {
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg"
                    size: NordicIcon.Size.LG
                    color: NordicTheme.colors.text.inverse
                }
                
                MouseArea {
                    id: callMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: currentNumber.length > 0
                    onClicked: PhoneService.dial(currentNumber)
                }
            }
        }
    }
}
