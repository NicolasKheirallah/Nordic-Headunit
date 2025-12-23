import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "Phone"

Page {
    id: root
    
    background: Rectangle { color: NordicTheme.colors.bg.primary }
    
    // -------------------------------------------------------------------------
    // Responsive State
    // -------------------------------------------------------------------------
    readonly property bool isCompact: NordicTheme.layout.isCompact
    
    // -------------------------------------------------------------------------
    // Phone State
    // -------------------------------------------------------------------------
    property bool inCall: PhoneService.callState !== "Idle"
    property int currentTab: 0 // 0: Keypad, 1: Recents, 2: Contacts, 3: Favorites
    
    // -------------------------------------------------------------------------
    // Main Content
    // -------------------------------------------------------------------------
    // Use RowLayout for Large (Rail + Content) or ColumnLayout for Compact (Content + TabBar)
    
    Item {
        anchors.fill: parent
        anchors.margins: isCompact ? 0 : NordicTheme.spacing.space_4
        
        // LARGE LAYOUT: Left Rail + Content
        RowLayout {
            anchors.fill: parent
            visible: !isCompact
            spacing: NordicTheme.spacing.space_4
            
            // Sidebar / Rail
            NordicCard {
                Layout.fillHeight: true
                Layout.preferredWidth: 280
                Layout.minimumWidth: 250
                variant: NordicCard.Variant.Glass
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: NordicTheme.spacing.space_3
                    spacing: NordicTheme.spacing.space_2
                    
                    // Header
                    NordicText {
                        text: qsTr("Phone")
                        type: NordicText.Type.HeadlineSmall
                        Layout.margins: NordicTheme.spacing.space_2
                    }
                    
                    // Navigation Items
                    NavButton { 
                        text: qsTr("Keypad")
                        icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/keypad.svg"
                        isActive: currentTab === 0
                        onClicked: currentTab = 0
                    }
                    NavButton { 
                        text: qsTr("Recents")
                        icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/clock.svg"
                        isActive: currentTab === 1
                        onClicked: currentTab = 1
                    }
                    NavButton { 
                        text: qsTr("Contacts")
                        icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/list.svg"
                        isActive: currentTab === 2
                        onClicked: currentTab = 2
                    }
                    NavButton { 
                        text: qsTr("Favorites")
                        icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/heart.svg"
                        isActive: currentTab === 3
                        onClicked: currentTab = 3
                    }
                    
                    Item { Layout.fillHeight: true }
                }
            }
            
            // Content Area (Shared)
            NordicCard {
                Layout.fillWidth: true
                Layout.fillHeight: true
                variant: NordicCard.Variant.Elevated
                
                StackLayout {
                    anchors.fill: parent
                    currentIndex: currentTab
                    
                    KeypadView { }
                    RecentsView { }
                    ContactsView { }
                    FavoritesView { }
                }
            }
        }
        
        // COMPACT LAYOUT: Content + Bottom Tabs
        ColumnLayout {
            anchors.fill: parent
            visible: isCompact
            spacing: 0
            
            // Screen Content
            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: currentTab
                
                KeypadView { }
                RecentsView { }
                ContactsView { }
                FavoritesView { }
            }
            
            // Bottom Tab Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                color: NordicTheme.colors.bg.elevated
                
                RowLayout {
                    anchors.fill: parent
                    spacing: 0
                    
                    TabButton { 
                        text: qsTr("Keypad")
                        icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/keypad.svg"
                        isActive: currentTab === 0
                        onClicked: currentTab = 0
                    }
                    TabButton { 
                        text: qsTr("Recents")
                        icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/clock.svg"
                        isActive: currentTab === 1
                        onClicked: currentTab = 1
                    }
                    TabButton { 
                        text: qsTr("Contacts")
                        icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/list.svg"
                        isActive: currentTab === 2
                        onClicked: currentTab = 2
                    }
                    TabButton { 
                        text: qsTr("Favorites")
                        icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/heart.svg"
                        isActive: currentTab === 3
                        onClicked: currentTab = 3
                    }
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // Helper Components (Inline)
    // -------------------------------------------------------------------------
    
    component NavButton : Rectangle {
        property string text
        property string icon
        property bool isActive
        signal clicked()
        
        Layout.fillWidth: true
        Layout.preferredHeight: 56
        radius: NordicTheme.shapes.radius_md
        color: isActive ? Theme.accent : 
               mouse.containsMouse ? NordicTheme.colors.bg.elevated : "transparent"
               
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            spacing: 16
            
            NordicIcon {
                source: icon
                color: isActive ? NordicTheme.colors.text.inverse : Theme.textSecondary
                size: NordicIcon.Size.SM
            }
            
            NordicText {
                text: parent.parent.text // Access outer text
                type: NordicText.Type.BodyLarge
                color: isActive ? NordicTheme.colors.text.inverse : Theme.textSecondary
                Layout.fillWidth: true
            }
        }
        
        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: parent.clicked()
        }
    }
    
    component TabButton : Rectangle {
        property string text
        property string icon
        property bool isActive
        signal clicked()
        
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: "transparent"
               
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 2
            
            NordicIcon {
                Layout.alignment: Qt.AlignHCenter
                source: icon
                color: isActive ? Theme.accent : Theme.textSecondary
                size: NordicIcon.Size.SM
            }
            
            NordicText {
                Layout.alignment: Qt.AlignHCenter
                text: parent.parent.text
                type: NordicText.Type.Caption
                color: isActive ? Theme.accent : Theme.textSecondary
            }
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: parent.clicked()
        }
    }
}
