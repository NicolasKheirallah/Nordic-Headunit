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
        color: NordicTheme.colors.bg.elevated
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
                color: (index === root.selectedIndex) ? Qt.rgba(NordicTheme.colors.accent.primary.r, NordicTheme.colors.accent.primary.g, NordicTheme.colors.accent.primary.b, 0.15) : "transparent"
                
                // Hover effect
                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(NordicTheme.colors.text.primary.r, NordicTheme.colors.text.primary.g, NordicTheme.colors.text.primary.b, 0.1)
                    visible: mouseArea.containsMouse && index !== root.selectedIndex
                }
                
                // Selection Indicator line
                Rectangle {
                    width: 4; height: 32
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: NordicTheme.colors.accent.primary
                    visible: index === root.selectedIndex
                    radius: 2
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 16
                    spacing: 16
                    
                    NordicIcon {
                        source: modelData.icon // Access via modelData for JS array
                        size: NordicIcon.Size.MD
                        color: (index === root.selectedIndex) ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.secondary
                    }
                    
                    NordicText {
                        text: modelData.title // Access via modelData for JS array
                        Layout.fillWidth: true
                        color: (index === root.selectedIndex) ? NordicTheme.colors.text.primary : NordicTheme.colors.text.secondary
                        type: NordicText.Type.BodyLarge
                    }
                }
                
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
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
