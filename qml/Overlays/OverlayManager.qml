import QtQuick
import "qrc:/qt/qml/NordicHeadunit/qml/Services" // For AudioPolicy if needed, or pass in
// Actually we import services in Main, so they are available via injection or id execution if passed.
// We will use signals/functions to control them.

Item {
    id: root
    
    // Z-Order Definitions
    // 100: Content Modals (Dialogs)
    // 200: System UI (Dock, Status) - Handled in AppLayout
    // 300: Standard Overlays (Notif, Volume)
    // 400: Interactive Overlays (Control Center)
    // 500: Critical Overlays (Rear Cam)
    // 600: Boot Splash
    
    // Public API
    function showVolume(val) { volumeOverlay.show(val) }
    function showClimate(val) { climateOverlay.show(val) }
    function toggleRearCamera() { if (rearCamera.visible) rearCamera.hide(); else rearCamera.show() }
    function toggleNotifications() { notificationCenter.toggle() }
    function toggleControlCenter() { controlCenter.toggle() }
    function toggleVoice() { if (voiceOverlay.visible) voiceOverlay.hide(); else voiceOverlay.show() }
    
    // Properties to expose states
    property alias volume: volumeOverlay.volume
    property alias climateTemp: climateOverlay.temperature
    property alias isRearCameraVisible: rearCamera.visible
    property alias isVoiceVisible: voiceOverlay.visible
    property var notificationModel: null
    
    anchors.fill: parent
    // Transparent to events unless hitting an overlay
    
    // -------------------------------------------------------------------------
    // Layer 1: Informational (Transient)
    // -------------------------------------------------------------------------
    
    ClimateOverlay {
        id: climateOverlay
        z: 300
        anchors.fill: parent
    }
    
    VolumeOverlay {
        id: volumeOverlay
        z: 301
        anchors.fill: parent
    }
    
    // -------------------------------------------------------------------------
    // Layer 2: Interactive Panels
    // -------------------------------------------------------------------------
    
    NotificationCenter {
        id: notificationCenter
        z: 400
        anchors.fill: parent
        // Bind to external model if provided
        historyModel: root.notificationModel 
    }
    
    ControlCenter {
        id: controlCenter
        z: 401
        anchors.fill: parent
        onOpenSettings: Qt.openUrlExternally("settings") // Signal up
    }
    
    // -------------------------------------------------------------------------
    // Layer 3: Assistant / Critical
    // -------------------------------------------------------------------------
    
    VoiceOverlay {
        id: voiceOverlay
        z: 500
        anchors.fill: parent
    }
    
    TelephonyOverlay {
        id: telephonyOverlay
        z: 501
        anchors.fill: parent
    }
    
    RearCameraOverlay {
        id: rearCamera
        z: 600
        anchors.fill: parent
    }
    
    // Signal Re-emission
    signal openSettings()
    Component.onCompleted: {
        controlCenter.onOpenSettings.connect(root.openSettings)
    }
}
