import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: "Connectivity"
    
    // Signals for sub-page navigation
    signal wifiClicked()
    signal bluetoothClicked()
    
    // WiFi Page Link
    SettingsItem {
        title: "WiFi"
        subtitle: SystemSettings.wifiEnabled ? "Connected to Nordic_5G" : "Off"
        showChevron: true
        onClicked: wifiClicked()
        
        // Small indicator if off
        rightComponent: StatusIndicator {
            active: SystemSettings.wifiEnabled
            color: active ? NordicTheme.colors.semantic.success : NordicTheme.colors.text.tertiary
            iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/wifi.svg"
            width: 24; height: 24
        }
    }
    
    // Bluetooth Page Link
    SettingsItem {
        title: "Bluetooth"
        subtitle: SystemSettings.bluetoothEnabled ? "Nicolas' iPhone Connected" : "Off"
        showChevron: true
        onClicked: bluetoothClicked()
        
        rightComponent: StatusIndicator {
            active: SystemSettings.bluetoothEnabled
            color: active ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.tertiary
            iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
            width: 24; height: 24
        }
    }
    
    SettingsItem {
        title: "Hotspot"
        subtitle: "Off"
        showChevron: true
    }
}
