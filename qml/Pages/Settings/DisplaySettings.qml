import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    id: root
    title: "Display & Appearance"
    
    signal themePlaygroundClicked()
    
    // Default items for reset
    readonly property string defaultItems: "home,map,media,phone,apps,vehicle,settings"
    
    // Bottom Bar item management
    property var currentItems: SystemSettings.bottomBarItems.split(",").filter(i => i.length > 0)
    readonly property var allItems: SystemSettings.availableBottomBarItems
    
    // Screen-size based max items (mirrors DockBar logic)
    readonly property int maxVisibleItems: {
        // Estimate based on typical screen widths
        if (width < 600) return 4
        if (width < 900) return 5
        if (width < 1200) return 6
        return 7
    }
    readonly property bool hasExcessItems: currentItems.length > maxVisibleItems
    
    function getIcon(key) {
        const icons = {
            "home": "home.svg", "map": "map.svg", "media": "music.svg",
            "phone": "phone.svg", "apps": "apps.svg", "vehicle": "car.svg",
            "settings": "settings.svg", "climate": "fan.svg",
            "camera": "camera.svg", "charging": "charge.svg",
            "heated_seat": "heated-front-seat.svg", "cooled_seat": "ventilated-front-seat.svg",
            "defrost": "windscreen_defrost.svg", "bluetooth": "bluetooth.svg"
        }
        return "qrc:/qt/qml/NordicHeadunit/assets/icons/" + (icons[key] || "apps.svg")
    }
    
    function getLabel(key) {
        const labels = {
            "home": qsTr("Home"), "map": qsTr("Map"), "media": qsTr("Media"),
            "phone": qsTr("Phone"), "apps": qsTr("Apps"), "vehicle": qsTr("Vehicle"),
            "settings": qsTr("Settings"), "climate": qsTr("Climate"),
            "camera": qsTr("Camera"), "charging": qsTr("Charging"),
            "heated_seat": qsTr("Heated Seat"), "cooled_seat": qsTr("Cooled Seat"),
            "defrost": qsTr("Defrost"), "bluetooth": qsTr("Bluetooth")
        }
        return labels[key] || key
    }
    
    function saveItems() {
        SystemSettings.bottomBarItems = currentItems.join(",")
    }
    
    function addItem(key) {
        if (!currentItems.includes(key)) {
            currentItems.push(key)
            currentItems = currentItems.slice()
            saveItems()
        }
    }
    
    function removeItem(key) {
        currentItems = currentItems.filter(i => i !== key)
        saveItems()
    }
    
    function moveItem(fromIndex, toIndex) {
        let items = currentItems.slice()
        const [item] = items.splice(fromIndex, 1)
        items.splice(toIndex, 0, item)
        currentItems = items
        saveItems()
    }
    
    function resetToDefaults() {
        currentItems = defaultItems.split(",")
        SystemSettings.bottomBarItems = defaultItems
        SystemSettings.bottomBarHeight = 64
    }
    
    // Theme Section
    SettingsCategory {
        title: "Theme"
        
        SettingsItem {
            title: "Color Theme"
            subtitle: Theme.currentTheme.name
            showChevron: true
            onClicked: root.themePlaygroundClicked()
            
            rightComponent: Component {
                Rectangle {
                    width: 24; height: 24; radius: 12
                    color: Theme.accent
                }
            }
        }
    }
    
    // Appearance Section
    SettingsCategory {
        title: "Appearance"
        
        SettingsToggle {
            title: "Dark Mode"
            subtitle: Theme.isDark ? "Nordic Night" : "Nordic Day"
            checked: Theme.isDark
            onToggled: Theme.toggleMode()
        }
        
        SettingsSlider {
            title: "Brightness"
            value: SystemSettings.brightness
            from: 10; to: 100; stepSize: 10; unit: "%"
            onMoved: () => SystemSettings.brightness = value
        }
    }
    
    // Bottom Bar Section
    SettingsCategory {
        title: "Bottom Bar"
        
        SettingsToggle {
            title: "Show Bottom Bar"
            subtitle: SystemSettings.bottomBarEnabled ? "Always visible" : "Hidden"
            checked: SystemSettings.bottomBarEnabled
            onToggled: (isChecked) => SystemSettings.bottomBarEnabled = isChecked
        }
        
        SettingsSlider {
            title: "Bar Height"
            value: SystemSettings.bottomBarHeight
            from: 48; to: 96; stepSize: 8; unit: "px"
            onMoved: () => SystemSettings.bottomBarHeight = value
        }
        
        // Reset to Defaults
        SettingsItem {
            title: "Reset to Defaults"
            subtitle: "Restore original items and height"
            icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/refresh.svg"
            showChevron: false
            onClicked: root.resetToDefaults()
        }
    }
    
    // Max Items Warning
    Rectangle {
        visible: root.hasExcessItems
        Layout.fillWidth: true
        height: warningCol.implicitHeight + 24
        radius: NordicTheme.shapes.radius_md
        color: Qt.rgba(NordicTheme.colors.semantic.warning.r, NordicTheme.colors.semantic.warning.g, NordicTheme.colors.semantic.warning.b, 0.15)
        
        ColumnLayout {
            id: warningCol
            anchors.fill: parent
            anchors.margins: 12
            spacing: 4
            
            RowLayout {
                spacing: 8
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/warning.svg"
                    size: NordicIcon.Size.SM
                    color: NordicTheme.colors.semantic.warning
                }
                
                NordicText {
                    text: qsTr("Too Many Items")
                    type: NordicText.Type.BodyMedium
                    color: NordicTheme.colors.semantic.warning
                }
            }
            
            NordicText {
                text: qsTr("You have %1 items but only %2 will be visible on this screen size. Consider removing %3 item(s).")
                    .arg(root.currentItems.length)
                    .arg(root.maxVisibleItems)
                    .arg(root.currentItems.length - root.maxVisibleItems)
                type: NordicText.Type.Caption
                color: Theme.textSecondary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
    
    // Bottom Bar Items
    SettingsCategory {
        title: "Active Items (" + root.currentItems.length + "/" + root.maxVisibleItems + " visible)"
        
        Repeater {
            model: root.currentItems
            
            SettingsItem {
                id: activeItemDelegate
                title: root.getLabel(modelData)
                icon: root.getIcon(modelData)
                showChevron: false
                
                // Indicate if item won't be visible
                subtitle: index >= root.maxVisibleItems ? qsTr("Hidden on this screen") : ""
                
                // Add entrance animation
                opacity: 0
                Component.onCompleted: {
                    opacity = 1
                }
                Behavior on opacity {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }
                
                rightComponent: Component {
                    Row {
                        spacing: 8
                        
                        // Move Up
                        Rectangle {
                            visible: index > 0
                            width: 36; height: 36; radius: 18
                            color: upMouse.containsMouse ? Theme.surfaceAlt : (upMouse.pressed ? Qt.darker(Theme.surfaceAlt, 1.15) : "transparent")
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                            
                            NordicIcon {
                                anchors.centerIn: parent
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/chevron_up.svg"
                                size: NordicIcon.Size.SM
                                color: upMouse.containsMouse ? Theme.textPrimary : Theme.textSecondary
                            }
                            
                            MouseArea {
                                id: upMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.moveItem(index, index - 1)
                            }
                        }
                        
                        // Move Down
                        Rectangle {
                            visible: index < root.currentItems.length - 1
                            width: 36; height: 36; radius: 18
                            color: downMouse.containsMouse ? Theme.surfaceAlt : (downMouse.pressed ? Qt.darker(Theme.surfaceAlt, 1.15) : "transparent")
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                            
                            NordicIcon {
                                anchors.centerIn: parent
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/chevron_down.svg"
                                size: NordicIcon.Size.SM
                                color: downMouse.containsMouse ? Theme.textPrimary : Theme.textSecondary
                            }
                            
                            MouseArea {
                                id: downMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.moveItem(index, index + 1)
                            }
                        }
                        
                        // Remove
                        Rectangle {
                            width: 36; height: 36; radius: 18
                            color: removeMouse.pressed ? NordicTheme.colors.semantic.error : (removeMouse.containsMouse ? Qt.rgba(NordicTheme.colors.semantic.error.r, NordicTheme.colors.semantic.error.g, NordicTheme.colors.semantic.error.b, 0.15) : Theme.surfaceAlt)
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }
                            
                            NordicIcon {
                                anchors.centerIn: parent
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/close.svg"
                                size: NordicIcon.Size.SM
                                color: removeMouse.pressed ? "white" : (removeMouse.containsMouse ? NordicTheme.colors.semantic.error : Theme.textSecondary)
                            }
                            
                            MouseArea {
                                id: removeMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: root.removeItem(modelData)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Available Items to Add
    SettingsCategory {
        title: "Add Items"
        
        Flow {
            Layout.fillWidth: true
            spacing: 8
            
            Repeater {
                model: root.allItems.filter(item => !root.currentItems.includes(item))
                
                Rectangle {
                    id: addChip
                    width: addRow.width + 24
                    height: 44
                    radius: 22
                    color: addMouse.pressed ? Qt.darker(Theme.surfaceAlt, 1.1) : (addMouse.containsMouse ? Theme.surfaceAlt : Qt.rgba(Theme.surfaceAlt.r, Theme.surfaceAlt.g, Theme.surfaceAlt.b, 0.6))
                    border.width: addMouse.containsMouse ? 1 : 0
                    border.color: Theme.accent
                    
                    // Entrance animation
                    opacity: 0
                    scale: 0.9
                    Component.onCompleted: {
                        opacity = 1
                        scale = 1.0
                    }
                    Behavior on opacity {
                        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                    }
                    Behavior on scale {
                        NumberAnimation { duration: 200; easing.type: Easing.OutBack }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                    
                    Row {
                        id: addRow
                        anchors.centerIn: parent
                        spacing: 8
                        
                        NordicIcon {
                            source: root.getIcon(modelData)
                            size: NordicIcon.Size.SM
                            color: addMouse.containsMouse ? Theme.textPrimary : Theme.textSecondary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        NordicText {
                            text: root.getLabel(modelData)
                            type: NordicText.Type.BodySmall
                            color: addMouse.containsMouse ? Theme.textPrimary : Theme.textSecondary
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        NordicIcon {
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/plus.svg"
                            size: NordicIcon.Size.XS
                            color: Theme.accent
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    MouseArea {
                        id: addMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.addItem(modelData)
                    }
                }
            }
        }
    }
    
    // Accessibility Section
    SettingsCategory {
        title: "Accessibility"
        
        SettingsToggle {
            title: "Reduce Motion"
            subtitle: SystemSettings.reducedMotion ? "Animations minimized" : "Standard animations"
            checked: SystemSettings.reducedMotion
            onToggled: (isChecked) => SystemSettings.reducedMotion = isChecked
        }
    }
}
