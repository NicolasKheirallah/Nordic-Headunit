import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

Item {
    id: root
    
    // Signals
    signal categorySelected(var component)
    
    // Properties
    property int selectedIndex: 0
    
    // Background (Glassmorphism Sidebar)
    Rectangle {
        anchors.fill: parent
        color: Theme.surfaceAlt
        // opacity: 0.8 // Can be tuned for glass effect
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        

        
        // ---------------------------------------------------------------------
        // 2. Navigation Categories
        // ---------------------------------------------------------------------
        ListView {
            id: navList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: settingsData // Use JS array
            spacing: 2
            
            delegate: Rectangle {
                id: itemDelegate
                width: navList.width
                height: 64
                
                // Visual State
                color: {
                    if (mouseArea.pressed) return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.1)
                    if (index === root.selectedIndex) return Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15)
                    return "transparent"
                }

                // Focus Ring
                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 2
                    color: "transparent"
                    border.color: Theme.accent
                    border.width: itemDelegate.activeFocus ? 2 : 0
                    radius: 2
                    visible: itemDelegate.activeFocus
                }
                
                // Hover effect
                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.05)
                    visible: mouseArea.containsMouse && index !== root.selectedIndex && !itemDelegate.activeFocus
                }
                
                // Selection Indicator line
                Rectangle {
                    width: 4; height: 32
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: Theme.accent
                    visible: index === root.selectedIndex
                    radius: 2
                }
                
                // Keyboard Support
                activeFocusOnTab: true
                Keys.onReturnPressed: {
                    root.selectedIndex = index
                    root.categorySelected(index)
                }
                Keys.onSpacePressed: {
                    root.selectedIndex = index
                    root.categorySelected(index)
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 16
                    spacing: 16
                    
                    NordicIcon {
                        source: modelData.icon // Access via modelData for JS array
                        size: NordicIcon.Size.MD
                        color: (index === root.selectedIndex || itemDelegate.activeFocus) ? Theme.accent : Theme.textSecondary
                    }
                    
                    NordicText {
                        text: modelData.title // Access via modelData for JS array
                        Layout.fillWidth: true
                        color: (index === root.selectedIndex || itemDelegate.activeFocus) ? Theme.textPrimary : Theme.textSecondary
                        type: NordicText.Type.BodyLarge
                    }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        itemDelegate.forceActiveFocus()
                        root.selectedIndex = index
                        root.categorySelected(index)
                    }
                }
            }
            
            // Initial selection
            Component.onCompleted: {
                if (settingsData.length > 0) {
                    root.categorySelected(0)
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------
    // 3. Settings Model (JS Array for qsTr support)
    // ---------------------------------------------------------------------
    property var settingsData: [
        { title: qsTr("Display"), icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg" },
        { title: qsTr("Connectivity"), icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/wifi.svg" },
        { title: qsTr("Vehicle"), icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg" },
        { title: qsTr("Navigation"), icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg" },
        { title: qsTr("Privacy"), icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/lock.svg" },
        { title: qsTr("Date & Time"), icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/clock.svg" },
        { title: qsTr("System"), icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg" }
    ]
}
