import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"
import "../../Services" // For ConnectivityService Singleton

SettingsSubPage {
    title: "WiFi"
    
    // Header Control (Master Toggle)
    RowLayout {
        Layout.fillWidth: true
        Layout.margins: NordicTheme.spacing.space_4
        spacing: NordicTheme.spacing.space_4
        
        NordicText {
            text: "WiFi"
            type: NordicText.Type.TitleSmall
            Layout.fillWidth: true
        }
        
        Switch {
            checked: SystemSettings.wifiEnabled
            onToggled: SystemSettings.wifiEnabled = checked
        }
    }
    
    // Scanning Indicator
    RowLayout {
        visible: SystemSettings.wifiEnabled && ConnectivityService.scanningWifi
        Layout.fillWidth: true
        Layout.margins: NordicTheme.spacing.space_4
        spacing: NordicTheme.spacing.space_2
        
        NordicSpinner {
            running: true
            width: 20; height: 20
        }
        
        NordicText {
            text: "Searching for networks..."
            type: NordicText.Type.Caption
            color: NordicTheme.colors.text.tertiary
        }
    }
    
    // Network List
    ListView {
        visible: SystemSettings.wifiEnabled
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: NordicTheme.spacing.space_4
        clip: true
        spacing: NordicTheme.spacing.space_2
        
        model: ConnectivityService.wifiModel
        
        delegate: MouseArea {
            width: ListView.view.width
            height: 64
            
            // Hover effect
            Rectangle {
                anchors.fill: parent
                color: parent.containsMouse ? NordicTheme.colors.bg.elevated : "transparent"
                radius: NordicTheme.shapes.radius_md
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: NordicTheme.spacing.space_3
                spacing: NordicTheme.spacing.space_3
                
                // Signal Icon
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/wifi.svg"
                    size: NordicIcon.Size.MD
                    color: model.connected ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.secondary
                    opacity: model.signal / 4.0
                }
                
                // SSID
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    
                    NordicText {
                        text: model.ssid
                        type: NordicText.Type.BodyMedium
                        color: model.connected ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.primary
                    }
                    
                    NordicText {
                        text: model.connected ? "Connected" : (model.secured ? "Secured" : "Open")
                        type: NordicText.Type.Caption
                        color: model.connected ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.tertiary
                    }
                }
                
                // Lock Icon
                NordicIcon {
                    visible: model.secured && !model.connected
                    source: model.connected ? "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg" : "qrc:/qt/qml/NordicHeadunit/assets/icons/lock.svg"
                    size: NordicIcon.Size.SM
                    color: NordicTheme.colors.text.tertiary
                }
            }
            
            onClicked: {
                if (!model.connected) {
                    // Simulate Connect
                    // In real app, open password modal
                    console.log("Connecting to " + model.ssid)
                    // Mock connection logic could be in ConnectivityService, but for now just UI feedback
                }
            }
        }
        
    }
    
    // Empty State (Off)
    ColumnLayout {
        visible: !SystemSettings.wifiEnabled
        anchors.centerIn: parent
        spacing: NordicTheme.spacing.space_4
        
        NordicIcon {
            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/wifi.svg"
            size: NordicIcon.Size.XL
            color: NordicTheme.colors.text.tertiary
            Layout.alignment: Qt.AlignHCenter
        }
        
        NordicText {
            text: "WiFi is Off"
            type: NordicText.Type.BodyLarge
            color: NordicTheme.colors.text.secondary
            Layout.alignment: Qt.AlignHCenter
        }
        
        NordicText {
            text: "Turn on WiFi to see available networks"
            type: NordicText.Type.Caption
            color: NordicTheme.colors.text.tertiary
            Layout.alignment: Qt.AlignHCenter
        }
    }
    
    // Auto Scan on Open
    Component.onCompleted: {
        if (SystemSettings.wifiEnabled) {
            ConnectivityService.startWifiScan()
        }
    }
}
