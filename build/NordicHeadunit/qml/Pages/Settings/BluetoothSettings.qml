import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"
import "../../Services"

SettingsSubPage {
    title: "Bluetooth"
    
    // Header Control
    RowLayout {
        Layout.fillWidth: true
        Layout.margins: NordicTheme.spacing.space_4
        spacing: NordicTheme.spacing.space_4
        
        NordicText {
            text: "Bluetooth"
            type: NordicText.Type.TitleSmall
            Layout.fillWidth: true
        }
        
        Switch {
            checked: SystemSettings.bluetoothEnabled
            onToggled: SystemSettings.bluetoothEnabled = checked
        }
    }
    
    // Actions
    RowLayout {
        visible: SystemSettings.bluetoothEnabled
        Layout.fillWidth: true
        Layout.margins: NordicTheme.spacing.space_4
        
        NordicButton {
            text: ConnectivityService.scanningBluetooth ? "Scanning..." : "Pair New Device"
            variant: NordicButton.Variant.Secondary
            Layout.fillWidth: true
            enabled: !ConnectivityService.scanningBluetooth
            onClicked: ConnectivityService.startBluetoothScan()
            
            iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/plus.svg" // If plus exists? Or use generic
        }
    }
    
    // Device List
    ListView {
        visible: SystemSettings.bluetoothEnabled
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: NordicTheme.spacing.space_4
        clip: true
        spacing: NordicTheme.spacing.space_2
        
        model: ConnectivityService.bluetoothModel
        
        delegate: MouseArea {
            width: ListView.view.width
            height: 72
            
            Rectangle {
                anchors.fill: parent
                color: parent.containsMouse ? NordicTheme.colors.bg.elevated : "transparent"
                radius: NordicTheme.shapes.radius_md
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: NordicTheme.spacing.space_3
                spacing: NordicTheme.spacing.space_3
                
                // Device Icon
                Rectangle {
                    width: 40; height: 40
                    radius: 20
                    color: NordicTheme.colors.bg.elevated
                    
                    NordicIcon {
                        anchors.centerIn: parent
                        source: model.type === "phone" ? "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" : "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
                        size: NordicIcon.Size.SM
                        color: model.connected ? "white" : NordicTheme.colors.text.secondary
                    }
                    
                    // Active indicator
                    Rectangle {
                        visible: model.connected
                        anchors.fill: parent
                        radius: 20
                        color: NordicTheme.colors.accent.primary
                        opacity: 0.2
                    }
                }
                
                // Name
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    
                    NordicText {
                        text: model.name
                        type: NordicText.Type.BodyMedium
                        color: model.connected ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.primary
                    }
                    
                    NordicText {
                        text: model.connected ? "Connected for Audio & Calls" : "Not Connected"
                        type: NordicText.Type.Caption
                        color: model.connected ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.tertiary
                    }
                }
                
                // Settings/Forget
                NordicButton {
                    variant: NordicButton.Variant.Icon
                    size: NordicButton.Size.Sm
                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg" // Use generic settings
                    onClicked: console.log("Manage device: " + model.name)
                }
            }
        }
    }
    
     // Empty State (Off)
    ColumnLayout {
        visible: !SystemSettings.bluetoothEnabled
        anchors.centerIn: parent
        spacing: NordicTheme.spacing.space_4
        
        NordicIcon {
            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
            size: NordicIcon.Size.XL
            color: NordicTheme.colors.text.tertiary
            Layout.alignment: Qt.AlignHCenter
        }
        
        NordicText {
            text: "Bluetooth is Off"
            type: NordicText.Type.BodyLarge
            color: NordicTheme.colors.text.secondary
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
