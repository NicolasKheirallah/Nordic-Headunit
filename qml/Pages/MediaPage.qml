import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit
import "Media"

// Media Page - Left Rail Navigation
// Fixed rail + dynamic content area
// Driver-safe, OEM-feel design
Page {
    id: root
    
    property int currentView: 0  // 0=NowPlaying, 1=Browse, 2=Radio, 3=Sources
    
    background: Rectangle {
        color: NordicTheme.colors.bg.primary
        
        // Blurred background art
        Rectangle {
            id: bgArt
            anchors.fill: parent
            color: Theme.surface
            visible: false
        }
        
        MultiEffect {
            source: bgArt
            anchors.fill: parent
            blurEnabled: true
            blurMax: 64
            blur: 1.0
            saturation: 1.2
            brightness: NordicTheme.darkMode ? 0.1 : 0.0
        }
        
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: NordicTheme.darkMode ? "#cc000000" : "#ccffffff" }
                GradientStop { position: 0.5; color: NordicTheme.darkMode ? "#aa000000" : "#aaffffff" }
                GradientStop { position: 1.0; color: NordicTheme.darkMode ? "#ee000000" : "#eeffffff" }
            }
        }
    }
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // =====================================================================
        // LEFT RAIL - Fixed Navigation
        // =====================================================================
        Rectangle {
            id: mediaRail
            Layout.fillHeight: true
            Layout.preferredWidth: 90
            color: NordicTheme.colors.bg.surface
            
            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 16
                anchors.bottomMargin: 16
                spacing: 8
                
                // Now Playing
                RailItem {
                    Layout.fillWidth: true
                    active: root.currentView === 0
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                    label: "Playing"
                    onClicked: root.currentView = 0
                }
                
                // Browse
                RailItem {
                    Layout.fillWidth: true
                    active: root.currentView === 1
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/list.svg"
                    label: "Browse"
                    onClicked: root.currentView = 1
                }
                
                // Radio
                RailItem {
                    Layout.fillWidth: true
                    active: root.currentView === 2
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg"
                    label: "Radio"
                    onClicked: root.currentView = 2
                }
                
                // Sources
                RailItem {
                    Layout.fillWidth: true
                    active: root.currentView === 3
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
                    label: "Sources"
                    onClicked: root.currentView = 3
                }
                
                Item { Layout.fillHeight: true }
            }
        }
        
        // Rail separator
        Rectangle {
            Layout.fillHeight: true
            width: 1
            color: NordicTheme.colors.border.muted
        }
        
        // =====================================================================
        // MAIN CONTENT AREA
        // =====================================================================
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Use Loader for efficient view switching
            Loader {
                id: contentLoader
                anchors.fill: parent
                
                sourceComponent: {
                    switch (root.currentView) {
                        case 0: return nowPlayingComponent
                        case 1: return browseComponent
                        case 2: return radioComponent
                        case 3: return sourcesComponent
                        default: return nowPlayingComponent
                    }
                }
            }
            
            Component {
                id: nowPlayingComponent
                PlayerView {}
            }
            
            Component {
                id: browseComponent
                BrowseView {
                    onRequestSourceTab: root.currentView = 3
                }
            }
            
            Component {
                id: radioComponent
                RadioView {}
            }
            
            Component {
                id: sourcesComponent
                SourcesView {}
            }
        }
    }
    
    // =========================================================================
    // RAIL ITEM COMPONENT
    // =========================================================================
    component RailItem: Rectangle {
        id: railItem
        
        property bool active: false
        property string icon: ""
        property string label: ""
        
        signal clicked()
        
        height: 70
        radius: 12
        color: active ? Theme.accent :
               railMouse.pressed ? Theme.surfaceAlt : "transparent"
        
        Column {
            anchors.centerIn: parent
            spacing: 6
            
            NordicIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                source: railItem.icon
                size: NordicIcon.Size.MD
                color: railItem.active ? "white" : Theme.textSecondary
            }
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: railItem.label
                font.pixelSize: 11
                font.weight: Font.Medium
                font.family: "Helvetica"
                color: railItem.active ? "white" : Theme.textSecondary
            }
        }
        
        MouseArea {
            id: railMouse
            anchors.fill: parent
            onClicked: railItem.clicked()
        }
    }
}
