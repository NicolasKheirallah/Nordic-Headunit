import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Bottom Bar Settings - Configure dock items and appearance
Item {
    id: root
    
    // Current items (parsed from CSV)
    property var currentItems: SystemSettings.bottomBarItems.split(",").filter(i => i.length > 0)
    
    // Available items from SystemSettings
    readonly property var allItems: SystemSettings.availableBottomBarItems
    
    // Icon and label helpers
    function getIcon(key) {
        const icons = {
            "home": "home.svg", "map": "map.svg", "media": "music.svg",
            "phone": "phone.svg", "apps": "apps.svg", "vehicle": "car.svg",
            "settings": "settings.svg", "climate": "fan.svg",
            "camera": "camera.svg", "charging": "charge.svg"
        }
        return "qrc:/qt/qml/NordicHeadunit/assets/icons/" + (icons[key] || "apps.svg")
    }
    
    function getLabel(key) {
        const labels = {
            "home": qsTr("Home"), "map": qsTr("Map"), "media": qsTr("Media"),
            "phone": qsTr("Phone"), "apps": qsTr("Apps"), "vehicle": qsTr("Vehicle"),
            "settings": qsTr("Settings"), "climate": qsTr("Climate"),
            "camera": qsTr("Camera"), "charging": qsTr("Charging")
        }
        return labels[key] || key
    }
    
    function saveItems() {
        SystemSettings.bottomBarItems = currentItems.join(",")
    }
    
    function addItem(key) {
        if (!currentItems.includes(key)) {
            currentItems.push(key)
            currentItems = currentItems.slice() // Trigger binding update
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
    
    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        
        ColumnLayout {
            width: parent.width
            spacing: NordicTheme.spacing.space_4
            
            // Header
            NordicText {
                text: qsTr("Bottom Bar Settings")
                type: NordicText.Type.HeadlineSmall
                color: Theme.textPrimary
            }
            
            // ─────────────────────────────────────────────────────────────
            // Height Slider
            // ─────────────────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 80
                radius: NordicTheme.shapes.radius_md
                color: Theme.surfaceAlt
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 8
                    
                    RowLayout {
                        Layout.fillWidth: true
                        
                        NordicText {
                            text: qsTr("Bar Height")
                            type: NordicText.Type.BodyMedium
                            color: Theme.textPrimary
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        NordicText {
                            text: SystemSettings.bottomBarHeight + "px"
                            type: NordicText.Type.BodyMedium
                            color: Theme.accent
                        }
                    }
                    
                    Slider {
                        Layout.fillWidth: true
                        from: 48
                        to: 96
                        stepSize: 8
                        value: SystemSettings.bottomBarHeight
                        onMoved: SystemSettings.bottomBarHeight = value
                    }
                }
            }
            
            // ─────────────────────────────────────────────────────────────
            // Current Items (Active in dock)
            // ─────────────────────────────────────────────────────────────
            NordicText {
                text: qsTr("Active Items (%1)").arg(root.currentItems.length)
                type: NordicText.Type.TitleSmall
                color: Theme.textSecondary
            }
            
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: activeItemsCol.implicitHeight + 24
                radius: NordicTheme.shapes.radius_md
                color: Theme.surfaceAlt
                
                Column {
                    id: activeItemsCol
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4
                    
                    Repeater {
                        model: root.currentItems
                        
                        Rectangle {
                            width: parent.width
                            height: 56
                            radius: NordicTheme.shapes.radius_sm
                            color: itemMouse.containsMouse ? Qt.darker(Theme.surfaceAlt, 1.1) : "transparent"
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 8
                                spacing: 12
                                
                                // Drag handle
                                NordicText {
                                    text: "⋮⋮"
                                    type: NordicText.Type.BodyMedium
                                    color: Theme.textTertiary
                                }
                                
                                // Icon
                                Rectangle {
                                    width: 40; height: 40
                                    radius: 8
                                    color: Theme.accent
                                    opacity: 0.1
                                    
                                    NordicIcon {
                                        anchors.centerIn: parent
                                        source: root.getIcon(modelData)
                                        size: NordicIcon.Size.MD
                                        color: Theme.accent
                                    }
                                }
                                
                                // Label
                                NordicText {
                                    text: root.getLabel(modelData)
                                    type: NordicText.Type.BodyMedium
                                    color: Theme.textPrimary
                                    Layout.fillWidth: true
                                }
                                
                                // Move Up
                                NordicButton {
                                    visible: index > 0
                                    variant: NordicButton.Variant.Icon
                                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/chevron_up.svg"
                                    onClicked: root.moveItem(index, index - 1)
                                }
                                
                                // Move Down
                                NordicButton {
                                    visible: index < root.currentItems.length - 1
                                    variant: NordicButton.Variant.Icon
                                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/chevron_down.svg"
                                    onClicked: root.moveItem(index, index + 1)
                                }
                                
                                // Remove
                                NordicButton {
                                    variant: NordicButton.Variant.Icon
                                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/close.svg"
                                    onClicked: root.removeItem(modelData)
                                }
                            }
                            
                            MouseArea {
                                id: itemMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                // Note: Full drag-and-drop would require more complex implementation
                            }
                        }
                    }
                }
            }
            
            // ─────────────────────────────────────────────────────────────
            // Available Items (Not yet added)
            // ─────────────────────────────────────────────────────────────
            NordicText {
                text: qsTr("Available Items")
                type: NordicText.Type.TitleSmall
                color: Theme.textSecondary
            }
            
            Flow {
                Layout.fillWidth: true
                spacing: 8
                
                Repeater {
                    model: root.allItems.filter(item => !root.currentItems.includes(item))
                    
                    Rectangle {
                        width: itemRow.width + 24
                        height: 44
                        radius: 22
                        color: addMouse.pressed ? Qt.darker(Theme.surfaceAlt, 1.1) : Theme.surfaceAlt
                        
                        Row {
                            id: itemRow
                            anchors.centerIn: parent
                            spacing: 8
                            
                            NordicIcon {
                                source: root.getIcon(modelData)
                                size: NordicIcon.Size.SM
                                color: Theme.textSecondary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            NordicText {
                                text: root.getLabel(modelData)
                                type: NordicText.Type.BodySmall
                                color: Theme.textSecondary
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
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.addItem(modelData)
                        }
                    }
                }
            }
            
            // ─────────────────────────────────────────────────────────────
            // Info Note
            // ─────────────────────────────────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: infoCol.implicitHeight + 24
                radius: NordicTheme.shapes.radius_md
                color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.1)
                
                ColumnLayout {
                    id: infoCol
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4
                    
                    NordicText {
                        text: qsTr("Screen Size Limit")
                        type: NordicText.Type.BodyMedium
                        color: Theme.accent
                    }
                    
                    NordicText {
                        text: qsTr("The bottom bar will show a maximum of 4-7 items depending on screen width. Items beyond the limit will be hidden.")
                        type: NordicText.Type.Caption
                        color: Theme.textSecondary
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }
            
            Item { height: 20 } // Bottom spacing
        }
    }
}
