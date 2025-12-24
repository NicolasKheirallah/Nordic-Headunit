import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Dynamic Dock Bar - Production-Grade, Configurable via SystemSettings
// Features: Dynamic items, screen-size adaptive, hover/pressed/focus states,
//           keyboard navigation, selection animation, badge indicators
Rectangle {
    id: root
    color: Theme.surface
    
    property int currentIndex: 0
    
    // Accessibility
    readonly property bool reducedMotion: SystemSettings.reducedMotion ?? false
    
    // Dynamic configuration from SystemSettings
    readonly property var itemsConfig: SystemSettings.bottomBarItems.split(",").filter(i => i.length > 0)
    readonly property int barHeight: SystemSettings.bottomBarHeight
    
    // Screen-size dependent max items
    readonly property int maxItems: {
        if (width < 600) return 4
        if (width < 900) return 5
        if (width < 1200) return 6
        return 7
    }
    readonly property var visibleItems: itemsConfig.slice(0, maxItems)
    
    // Badge data (would come from services in real implementation)
    readonly property var badgeCounts: ({
        "phone": 3,      // Missed calls
        "media": 0,
        "apps": 0,
        "settings": 0
    })
    
    // Icon mapping
    function getItemIcon(key) {
        const icons = {
            "home": "home.svg",
            "map": "map.svg",
            "media": "music.svg",
            "phone": "phone.svg",
            "apps": "apps.svg",
            "vehicle": "car.svg",
            "settings": "settings.svg",
            "climate": "fan.svg",
            "camera": "camera.svg",
            "charging": "charge.svg",
            "heated_seat": "heated-front-seat.svg",
            "cooled_seat": "ventilated-front-seat.svg",
            "defrost": "windscreen_defrost.svg",
            "bluetooth": "bluetooth.svg"
        }
        return "qrc:/qt/qml/NordicHeadunit/assets/icons/" + (icons[key] || "apps.svg")
    }
    
    // Label mapping
    function getItemLabel(key) {
        const labels = {
            "home": qsTr("Home"),
            "map": qsTr("Map"),
            "media": qsTr("Media"),
            "phone": qsTr("Phone"),
            "apps": qsTr("Apps"),
            "vehicle": qsTr("Vehicle"),
            "settings": qsTr("Settings"),
            "climate": qsTr("Climate"),
            "camera": qsTr("Camera"),
            "charging": qsTr("Charging"),
            "heated_seat": qsTr("Heat"),
            "cooled_seat": qsTr("Cool"),
            "defrost": qsTr("Defrost"),
            "bluetooth": qsTr("BT")
        }
        return labels[key] || key
    }
    
    // Index mapping for navigation
    function getItemIndex(key) {
        const indices = {
            "home": 0, "map": 1, "media": 2, "phone": 3,
            "apps": 4, "vehicle": 5, "settings": 6, "climate": 7,
            "heated_seat": 8, "cooled_seat": 9, "defrost": 10, "bluetooth": 11
        }
        return indices[key] || 0
    }
    
    implicitHeight: barHeight
    
    // Top border
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: NordicTheme.colors.border.muted
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: NordicTheme.spacing.space_2
        spacing: NordicTheme.spacing.space_2
        
        // Dynamic Dock Items
        Repeater {
            id: dockRepeater
            model: root.visibleItems
            
            Item {
                id: itemRoot
                property string itemKey: modelData
                property bool active: root.getItemIndex(itemKey) === root.currentIndex
                property int badgeCount: root.badgeCounts[itemKey] ?? 0
                
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                // Focus handling
                focus: index === 0
                activeFocusOnTab: true
                Keys.onLeftPressed: {
                    if (index > 0) dockRepeater.itemAt(index - 1).forceActiveFocus()
                }
                Keys.onRightPressed: {
                    if (index < dockRepeater.count - 1) dockRepeater.itemAt(index + 1).forceActiveFocus()
                }
                Keys.onReturnPressed: root.currentIndex = root.getItemIndex(itemKey)
                Keys.onSpacePressed: root.currentIndex = root.getItemIndex(itemKey)
                
                Rectangle {
                    id: itemBg
                    anchors.centerIn: parent
                    width: 80
                    height: Math.min(56, root.barHeight - 8)
                    radius: NordicTheme.shapes.radius_lg
                    
                    // Background color with states
                    color: {
                        if (itemMouse.pressed) return Qt.darker(Theme.surfaceAlt, 1.15)
                        if (active) return Theme.surfaceAlt
                        if (itemMouse.containsMouse || itemRoot.activeFocus) return Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.05)
                        return "transparent"
                    }
                    
                    // Active border
                    border.color: active ? Theme.accent : "transparent"
                    border.width: active ? 2 : 0
                    
                    // Focus ring
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -3
                        radius: parent.radius + 3
                        color: "transparent"
                        border.width: itemRoot.activeFocus ? 2 : 0
                        border.color: Theme.accent
                        opacity: 0.6
                        visible: itemRoot.activeFocus && !active
                    }
                    
                    // Selection animation
                    Behavior on color {
                        enabled: !root.reducedMotion
                        ColorAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                    
                    Behavior on border.width {
                        enabled: !root.reducedMotion
                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                    }
                    
                    // Scale on press
                    scale: itemMouse.pressed ? 0.95 : 1.0
                    Behavior on scale {
                        enabled: !root.reducedMotion
                        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                    }
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        // Icon with badge
                        Item {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            Layout.alignment: Qt.AlignHCenter
                            
                            NordicIcon {
                                id: itemIcon
                                anchors.centerIn: parent
                                source: root.getItemIcon(itemRoot.itemKey)
                                size: NordicIcon.Size.MD
                                color: {
                                    if (itemMouse.pressed) return Theme.accent
                                    if (itemRoot.active) return Theme.accent
                                    if (itemMouse.containsMouse) return Theme.textPrimary
                                    return Theme.textSecondary
                                }
                                
                                Behavior on color {
                                    enabled: !root.reducedMotion
                                    ColorAnimation { duration: 150 }
                                }
                            }
                            
                            // Badge indicator
                            Rectangle {
                                visible: itemRoot.badgeCount > 0
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.topMargin: -4
                                anchors.rightMargin: -6
                                width: badgeText.width + 8
                                height: 16
                                radius: 8
                                color: NordicTheme.colors.semantic.error
                                
                                Text {
                                    id: badgeText
                                    anchors.centerIn: parent
                                    text: itemRoot.badgeCount > 9 ? "9+" : itemRoot.badgeCount
                                    font.pixelSize: 10
                                    font.weight: Font.Bold
                                    font.family: "Helvetica"
                                    color: "white"
                                }
                            }
                        }
                        
                        NordicText {
                            text: root.getItemLabel(itemRoot.itemKey)
                            type: NordicText.Type.Caption
                            color: {
                                if (itemMouse.pressed) return Theme.accent
                                if (itemRoot.active) return NordicTheme.colors.text.primary
                                if (itemMouse.containsMouse) return Theme.textPrimary
                                return Theme.textSecondary
                            }
                            Layout.alignment: Qt.AlignHCenter
                            
                            Behavior on color {
                                enabled: !root.reducedMotion
                                ColorAnimation { duration: 150 }
                            }
                        }
                    }
                    
                    // Active indicator line
                    Rectangle {
                        visible: itemRoot.active
                        anchors.top: parent.top
                        anchors.topMargin: -2
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 32
                        height: 3
                        radius: 1.5
                        color: Theme.accent
                        
                        // Animate in
                        scale: itemRoot.active ? 1.0 : 0.0
                        Behavior on scale {
                            enabled: !root.reducedMotion
                            NumberAnimation { duration: 200; easing.type: Easing.OutBack }
                        }
                    }
                    
                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.currentIndex = root.getItemIndex(itemRoot.itemKey)
                            itemRoot.forceActiveFocus()
                        }
                    }
                }
            }
        }
    }
}
