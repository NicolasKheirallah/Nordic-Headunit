import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NordicHeadunit
import "Pages"
import "Overlays"

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    visible: true
    title: "Nordic HU-1"
    color: NordicTheme.colors.bg.primary  // Prevent white background showing
    
    // Core Layout
    AppLayout {
        id: appLayout
        anchors.fill: parent
        
        // Inject Services
        audioPolicy: audioPolicy
        
        onSettingsRequested: {
            overlayManager.toggleControlCenter()
        }
        onNotificationRequested: {
            overlayManager.toggleNotifications()
        }
        
        // Content Area using SwipeView with LAZY LOADING
        // PERFORMANCE FIX: Only load current + adjacent pages instead of all 6
        SwipeView {
            id: pageView
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: appLayout.currentTab
            interactive: false  // Disable swipe gestures, use DockBar only
            clip: true
            
            // Helper to determine if page should be loaded (current or adjacent)
            function shouldLoad(index) {
                return Math.abs(currentIndex - index) <= 1
            }
            
            // Page 0: Home
            Loader {
                active: pageView.shouldLoad(0)
                sourceComponent: Component { HomePage {} }
                // Keep loaded after first activation for instant re-access
                onActiveChanged: if (active) active = true
            }
            // Page 1: Map (heavy - benefits most from lazy loading)
            Loader {
                active: pageView.shouldLoad(1)
                sourceComponent: Component { MapPage {} }
                onActiveChanged: if (active) active = true
            }
            // Page 2: Media
            Loader {
                active: pageView.shouldLoad(2)
                sourceComponent: Component { MediaPage {} }
                onActiveChanged: if (active) active = true
            }
            // Page 3: Phone
            Loader {
                active: pageView.shouldLoad(3)
                sourceComponent: Component { PhonePage {} }
                onActiveChanged: if (active) active = true
            }
            // Page 4: Apps
            Loader {
                active: pageView.shouldLoad(4)
                sourceComponent: Component { AppsPage {} }
                onActiveChanged: if (active) active = true
            }
            // Page 5: Vehicle
            Loader {
                active: pageView.shouldLoad(5)
                sourceComponent: Component { VehiclePage {} }
                onActiveChanged: if (active) active = true
            }
            // Page 6: Settings
            Loader {
                active: pageView.shouldLoad(6)
                sourceComponent: Component { SettingsPage {} }
                onActiveChanged: if (active) active = true
            }
        }
    }
    
    // Global Components
    
    NordicModal {
        id: demoModal
        title: "System Update"
        message: "A new software version (v2.1) is available. content includes performance improvements and new map data. Install now?"
        type: NordicModal.Type.Confirmation
        actions: [
            { label: "Cancel", primary: false, triggered: function() { console.log("Cancelled") } },
            { label: "Install", primary: true, triggered: function() { showToast("Installing update...", NordicToast.Type.Success) } }
        ]
    }
    
    // Global Toast Manager (Overlay)
    // Global Toast Manager (Overlay)
    
    // -------------------------------------------------------------------------
    // Overlay Manager (Centralized)
    // -------------------------------------------------------------------------
    
    OverlayManager {
        id: overlayManager
        z: 2000
        
        // Connect Signals
        // Connect Signals
        onOpenSettings: appLayout.currentTab = 6 // Switch to Settings Tab
        
        // Bind Voice State to Audio Policy
        onIsVoiceVisibleChanged: audioPolicy.voiceAssistantActive = isVoiceVisible
        
        // Link History
        notificationModel: toastManager.model
    }

    ToastManager {
        id: toastManager
        anchors.fill: parent
        z: 3000 // Toasts always on top of even the overlays? Or below RearCam? 
        // Typically Toasts are high, but RearCam is critical. 
        // Let's keep Toast high for now.
    }
    
    // Services
    AudioPolicy { id: audioPolicy }
    
    // Hardware Keys
    Item {
        focus: true
        anchors.fill: parent
        Keys.onPressed: (event) => {
             if (event.key === Qt.Key_VolumeUp || event.key === Qt.Key_Plus || event.key === Qt.Key_Equal) {
                 overlayManager.showVolume(overlayManager.volume + 5)
                 event.accepted = true
             } else if (event.key === Qt.Key_VolumeDown || event.key === Qt.Key_Minus) {
                 overlayManager.showVolume(overlayManager.volume - 5)
                 event.accepted = true
             } else if (event.key === Qt.Key_T) {
                 overlayManager.showClimate(overlayManager.climateTemp + 1)
                 event.accepted = true
             } else if (event.key === Qt.Key_R) {
                 overlayManager.toggleRearCamera()
                 event.accepted = true
             } else if (event.key === Qt.Key_N) {
                 overlayManager.toggleNotifications()
                 event.accepted = true
             } else if (event.key === Qt.Key_V) {
                 overlayManager.toggleVoice()
                 event.accepted = true
             }
        }
    }
    
    // Boot Splash
    Rectangle {
        id: splashScreen
        anchors.fill: parent
        z: 5000
        color: NordicTheme.colors.bg.primary
        visible: true
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_6
            
            NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg" // Logo placeholder
                size: NordicIcon.Size.XL
                Layout.alignment: Qt.AlignHCenter
                color: Theme.accent
                
                // Pulse Animation
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.5; to: 1.0; duration: 1000 }
                    NumberAnimation { from: 1.0; to: 0.5; duration: 1000 }
                }
            }
            
            NordicText {
                text: "NORDIC HU-1"
                type: NordicText.Type.DisplayMedium
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
        Timer {
            interval: 1500  // Fast automotive startup
            running: true
            onTriggered: {
                 // Fade out
                 splashFade.start()
            }
        }
        
        NumberAnimation {
            id: splashFade
            target: splashScreen
            property: "opacity"
            to: 0
            duration: 400  // Quick fade
            easing.type: Easing.InOutQuad
            onFinished: splashScreen.visible = false
        }
    }
    
    function showToast(message, type) {
        toastManager.show(message, type)
    }
}
