import QtQuick

pragma Singleton

Item {
    id: root
    
    // Properties
    property bool wifiEnabled: true
    property bool wifiConnected: true
    property string wifiSsid: "Nordic_5G"
    property int wifiStrength: 3 // 0-4
    
    property bool bluetoothEnabled: true
    property bool bluetoothConnected: true
    property string deviceName: "Nicolas' iPhone"
    
    property bool lteEnabled: true
    property int lteBars: 4
    
    // Mock simulation
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            // Randomly fluctuate signal
            root.wifiStrength = Math.max(1, Math.min(4, root.wifiStrength + (Math.random() > 0.5 ? 1 : -1)))
        }
    }
    
    // ═══════════════════════════════════════════════════════════════════
    // PHASE 2: DEEP CONNECTIVITY MOCKS
    // ═══════════════════════════════════════════════════════════════════
    
    property bool scanningWifi: false
    property bool scanningBluetooth: false
    
    // WiFi Model
    ListModel {
        id: wifiNetworks
        ListElement { ssid: "Nordic_5G"; signal: 4; secured: true; connected: true }
        ListElement { ssid: "Nordic_Guest"; signal: 3; secured: true; connected: false }
        ListElement { ssid: "Neighbor_WiFi"; signal: 1; secured: true; connected: false }
        ListElement { ssid: "Free_Public"; signal: 2; secured: false; connected: false }
    }
    property alias wifiModel: wifiNetworks
    
    // Bluetooth Model
    ListModel {
        id: btDevices
        ListElement { name: "Nicolas' iPhone"; type: "phone"; connected: true }
        ListElement { name: "Nordic Headphones"; type: "audio"; connected: false }
    }
    property alias bluetoothModel: btDevices
    
    // Methods
    function startWifiScan() {
        scanningWifi = true
        scanTimerWifi.restart()
    }
    
    function startBluetoothScan() {
        scanningBluetooth = true
        scanTimerBt.restart()
    }
    
    Timer {
        id: scanTimerWifi
        interval: 2000
        onTriggered: {
            scanningWifi = false
            // Simulate finding a new network
            if (Math.random() > 0.7) {
                 wifiNetworks.append({ "ssid": "New_Network_" + Math.floor(Math.random()*100), "signal": 3, "secured": true, "connected": false })
            }
        }
    }
    
    Timer {
        id: scanTimerBt
        interval: 3000
        onTriggered: {
            scanningBluetooth = false
            // Simulate finding a device
            if (Math.random() > 0.7) {
                 btDevices.append({ "name": "Unknown Device", "type": "other", "connected": false })
            }
        }
    }
}
