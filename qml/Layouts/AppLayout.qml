import QtQuick
import QtQuick.Layouts
import NordicHeadunit

Item {
    id: root
    
    default property alias content: contentArea.data
    property alias title: statusBar.title
    
    // Status Bar Control
    property alias showStatusBar: statusBar.visible
    
    // Bottom Bar Control (unified bar)
    property alias showBottomBar: bottomBar.visible
    property alias currentTab: bottomBar.currentIndex
    property var audioPolicy: null
    
    // Legacy alias for backwards compatibility
    property alias showDockBar: bottomBar.visible
    
    signal settingsRequested()
    signal notificationRequested()
    
    // Page titles for status bar
    readonly property var pageTitles: ["Home", "Map", "Media", "Phone", "Vehicle", "Settings"]
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Status Bar (Top)
        StatusBar {
            id: statusBar
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            title: root.pageTitles[bottomBar.currentIndex] || "Home"
            
            // StatusBar now gets connectivity state directly from SystemSettings
            
            // Allow status bar to be hidden (e.g. fullscreen map)
            visible: true 
            
            onSettingsClicked: root.settingsRequested()
            onNotificationClicked: root.notificationRequested()
        }
        
        // Main Content Area
        Item {
            id: contentAreaContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true  // Clip content to prevent overflow
            
            // Content uses ColumnLayout so Layout.fill* properties work
            ColumnLayout {
                id: contentArea
                anchors.fill: parent
                spacing: 0
                // User content (SwipeView) goes here via default property alias
            }
        }
        
        // Persistent Bottom Bar (Unified Navigation + Climate + Comfort)
        // Per HMI spec: Always visible, fixed height, never changes position
        PersistentBottomBar {
            id: bottomBar
            Layout.fillWidth: true
            Layout.preferredHeight: 72
            
            // Visibility controlled by settings
            visible: typeof SystemSettings !== "undefined" ? SystemSettings.bottomBarEnabled : true
        }
    }
}

