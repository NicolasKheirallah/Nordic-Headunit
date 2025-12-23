import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "Settings"

// Unified Settings Page Controller
// Handles resolution switching between Stack Navigation (Compact) and Split View (Regular/Expanded)
Page {
    id: root
    
    background: Rectangle { color: NordicTheme.colors.bg.primary }
    
    // -------------------------------------------------------------------------
    // Responsive State
    // -------------------------------------------------------------------------
    readonly property bool isCompact: NordicTheme.layout.isCompact
    
    // Shared State to persist across layout switches
    property int currentCategoryIndex: 0
    
    // -------------------------------------------------------------------------
    // Page Registry
    // -------------------------------------------------------------------------
    property var pageComponents: [
        displayPage,        // 0 - Display
        connectivityPage,   // 1 - Connectivity (NEW)
        vehiclePage,        // 2 - Vehicle
        navigationPage,     // 3 - Navigation
        privacyPage,        // 4 - Privacy
        dateTimePage,       // 5 - Date & Time
        systemPage          // 6 - System
    ]
    
    // -------------------------------------------------------------------------
    // Navigation Logic
    // -------------------------------------------------------------------------
    function openCategory(index) {
        currentCategoryIndex = index
        var page = pageComponents[index]
        
        if (isCompact) {
            stackView.push(page)
        } else {
            contentLoader.sourceComponent = page
        }
    }
    
    // -------------------------------------------------------------------------
    // Layouts
    // -------------------------------------------------------------------------
    
    // MODE A: Split View (Regular & Expanded)
    RowLayout {
        anchors.fill: parent
        visible: !isCompact
        spacing: 0
        
        // Sidebar (Persistent)
        SettingsSidebar {
            id: splitSidebar
            Layout.fillHeight: true
            Layout.preferredWidth: 280
            Layout.minimumWidth: 250
            Layout.maximumWidth: 320
            
            // Sync State
            selectedIndex: root.currentCategoryIndex
            onCategorySelected: (index) => root.openCategory(index)
        }
        
        // Vertical Divider
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            color: NordicTheme.colors.border.muted
        }
        
        // Content Area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            Loader {
                id: contentLoader
                anchors.fill: parent
                anchors.margins: NordicTheme.spacing.space_4
                
                // Transition
                NumberAnimation on opacity {
                    id: fadeIn
                    from: 0; to: 1; duration: 200
                    running: false
                }
                onSourceComponentChanged: {
                    fadeIn.running = true
                }
            }
        }
        
        // Initial Load for Split View
        Component.onCompleted: {
            if (!isCompact && contentLoader.sourceComponent === null) {
                contentLoader.sourceComponent = pageComponents[currentCategoryIndex]
            }
        }
    }
    
    // MODE B: Stack View (Compact)
    StackView {
        id: stackView
        anchors.fill: parent
        visible: isCompact
        
        initialItem: SettingsSidebar {
            id: stackSidebar
            // Sidebar takes full screen in stack mode
            selectedIndex: root.currentCategoryIndex
            onCategorySelected: (index) => root.openCategory(index)
        }
        
        // Transitions
        pushEnter: Transition {
            PropertyAnimation { property: "x"; from: stackView.width; to: 0; duration: 300; easing.type: Easing.OutQuart }
        }
        pushExit: Transition {
            PropertyAnimation { property: "x"; from: 0; to: -stackView.width * 0.3; duration: 300; easing.type: Easing.OutQuart }
        }
        popEnter: Transition {
            PropertyAnimation { property: "x"; from: -stackView.width * 0.3; to: 0; duration: 300; easing.type: Easing.OutQuart }
        }
        popExit: Transition {
            PropertyAnimation { property: "x"; from: 0; to: stackView.width; duration: 300; easing.type: Easing.OutQuart }
        }
    }
    
    // -------------------------------------------------------------------------
    // Component Definitions (Lazy)
    // -------------------------------------------------------------------------
    
    Component { id: vehiclePage; VehicleSettings {} }
    Component { 
        id: displayPage
        DisplaySettings {
            onThemePlaygroundClicked: root.openContent(themePlaygroundPage)
        }
    }
    Component { id: themePlaygroundPage; ThemePlayground {} }
    Component { id: navigationPage; MapSettings {} }
    
    Component { 
        id: soundPage
        SettingsSubPage {
            title: qsTr("Sound")
            SettingsSlider {
                title: qsTr("Master Volume")
                value: SystemSettings.masterVolume
                from: 0; to: 100; stepSize: 5; unit: "%"
                onMoved: () => SystemSettings.masterVolume = value
            }
            SettingsItem {
                title: qsTr("Advanced Audio")
                subtitle: qsTr("Equalizer, Fader & Balance")
                showChevron: true
                onClicked: {
                    if (isCompact) stackView.push(audioSettingsPage)
                    else contentLoader.sourceComponent = audioSettingsPage
                }
            }
            SettingsSlider {
                title: qsTr("Navigation Volume")
                value: 80; from: 0; to: 100; unit: "%"
            }
        }
    }
    
    Component { id: audioSettingsPage; AudioSettings {} }
    
    Component { 
        id: connectivityPage
        ConnectivitySettings {
            onWifiClicked: root.openContent(wifiSettingsPage)
            onBluetoothClicked: root.openContent(bluetoothSettingsPage)
        } 
    }
    
    // Sub-pages for Connectivity
    Component { id: wifiSettingsPage; WifiSettings {} }
    Component { id: bluetoothSettingsPage; BluetoothSettings {} }
    
    // -------------------------------------------------------------------------
    // Navigation Helper
    // -------------------------------------------------------------------------
    function openContent(page) {
        if (isCompact) {
            stackView.push(page)
        } else {
            contentLoader.sourceComponent = page
        }
    }

    Component { id: dateTimePage; DateTimeSettings {} }
    
    Component { 
        id: systemPage
        SystemSettingsPage {
            onLanguageClicked: root.openContent(languagePage)
        }
    }
    
    Component { id: privacyPage; PrivacySettings {} }
    
    // Sub-Pages
    Component { id: languagePage; LanguageSettings {} }
}
