import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import NordicHeadunit

// Control Center (Quick Settings) - Production-Grade, 50/50
// Features: Hover states, focus ring, keyboard nav, NordicText, animations
Item {
    id: root
    
    property bool open: false
    
    function toggle() { open = !open }
    
    signal openSettings()
    
    // Accessibility
    readonly property bool reducedMotion: SystemSettings.reducedMotion ?? false
    
    // Background scrim (tap to dismiss)
    Rectangle {
        anchors.fill: parent
        color: open ? Qt.rgba(0, 0, 0, 0.4) : "transparent"
        opacity: open ? 1 : 0
        
        Behavior on opacity { 
            enabled: !root.reducedMotion
            NumberAnimation { duration: 150 } 
        }
        
        MouseArea { 
            anchors.fill: parent
            enabled: root.open
            onClicked: root.open = false
        }
    }
    
    // Panel
    Rectangle {
        id: panel
        width: Math.min(520, parent.width - 32)
        height: contentHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: open ? 8 : -height
        
        property int contentHeight: column.implicitHeight + 32
        
        color: Theme.surface
        radius: NordicTheme.shapes.radius_xl
        border.width: 1
        border.color: NordicTheme.colors.border.muted
        
        layer.enabled: root.open && root.visible
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowVerticalOffset: 8
            shadowBlur: 1.0
            shadowOpacity: 0.2
        }
        
        Behavior on anchors.topMargin { 
            enabled: !root.reducedMotion
            NumberAnimation { 
                duration: 250
                easing.type: Easing.OutCubic 
            } 
        }
        
        ColumnLayout {
            id: column
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16
            visible: root.open
            
            // ═══════════════════════════════════════════════════════════════
            // ZONE 1: Primary Toggles
            // ═══════════════════════════════════════════════════════════════
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 12
                columnSpacing: 12
                
                // Toggle component with full states
                component QuickToggle : Rectangle {
                    id: toggleRoot
                    property string label
                    property string icon
                    property bool active: false
                    property bool available: true
                    
                    signal clicked()
                    
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    radius: NordicTheme.shapes.radius_lg
                    
                    // State-based color
                    color: {
                        if (!available) return Theme.surfaceAlt
                        if (toggleMouse.pressed) return active ? Qt.darker(Theme.accent, 1.15) : Qt.darker(Theme.surfaceAlt, 1.1)
                        if (toggleMouse.containsMouse || toggleRoot.activeFocus) return active ? Theme.accent : Theme.surfaceAlt
                        return active ? Theme.accent : Theme.surface
                    }
                    
                    border.width: toggleRoot.activeFocus ? 2 : (toggleMouse.containsMouse && !active ? 1 : 0)
                    border.color: toggleRoot.activeFocus ? Theme.accent : NordicTheme.colors.border.muted
                    
                    opacity: available ? 1 : 0.5
                    
                    // Scale on press
                    scale: toggleMouse.pressed ? 0.97 : 1.0
                    Behavior on scale {
                        enabled: !root.reducedMotion
                        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
                    }
                    
                    Behavior on color {
                        enabled: !root.reducedMotion
                        ColorAnimation { duration: 150 }
                    }
                    
                    // Keyboard support
                    activeFocusOnTab: true
                    Keys.onReturnPressed: if (available) clicked()
                    Keys.onSpacePressed: if (available) clicked()
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        
                        NordicIcon {
                            Layout.alignment: Qt.AlignHCenter
                            source: toggleRoot.icon
                            size: NordicIcon.Size.MD
                            color: toggleRoot.active ? "white" : Theme.textSecondary
                            
                            Behavior on color {
                                enabled: !root.reducedMotion
                                ColorAnimation { duration: 150 }
                            }
                        }
                        
                        NordicText {
                            Layout.alignment: Qt.AlignHCenter
                            text: toggleRoot.label
                            type: NordicText.Type.Caption
                            color: toggleRoot.active ? "white" : Theme.textTertiary
                        }
                    }
                    
                    MouseArea {
                        id: toggleMouse
                        anchors.fill: parent
                        enabled: toggleRoot.available
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            toggleRoot.forceActiveFocus()
                            toggleRoot.clicked()
                        }
                    }
                }
                
                // WiFi
                QuickToggle {
                    label: qsTr("Wi-Fi")
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/wifi.svg"
                    active: SystemSettings.wifiEnabled
                    onClicked: SystemSettings.wifiEnabled = !SystemSettings.wifiEnabled
                }
                
                // Bluetooth  
                QuickToggle {
                    label: qsTr("Bluetooth")
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
                    active: SystemSettings.bluetoothEnabled
                    onClicked: SystemSettings.bluetoothEnabled = !SystemSettings.bluetoothEnabled
                }
                
                // Mute
                QuickToggle {
                    label: SystemSettings.masterVolume === 0 ? qsTr("Unmute") : qsTr("Mute")
                    icon: SystemSettings.masterVolume === 0 
                        ? "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_off.svg"
                        : "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_up.svg"
                    active: SystemSettings.masterVolume === 0
                    onClicked: {
                        if (SystemSettings.masterVolume === 0) {
                            SystemSettings.masterVolume = internal.lastVolume
                        } else {
                            internal.lastVolume = SystemSettings.masterVolume
                            SystemSettings.masterVolume = 0
                        }
                    }
                }
                
                // Dark Mode
                QuickToggle {
                    label: SystemSettings.darkMode ? qsTr("Dark") : qsTr("Light")
                    icon: SystemSettings.darkMode 
                        ? "qrc:/qt/qml/NordicHeadunit/assets/icons/weather_cloudy.svg"
                        : "qrc:/qt/qml/NordicHeadunit/assets/icons/weather_sunny.svg"
                    active: SystemSettings.darkMode
                    onClicked: SystemSettings.darkMode = !SystemSettings.darkMode
                }
            }
            
            // Volume Slider
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                NordicIcon {
                    source: SystemSettings.masterVolume === 0 
                        ? "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_off.svg" 
                        : "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_up.svg"
                    size: NordicIcon.Size.MD
                    color: Theme.textSecondary
                }
                
                NordicSlider {
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: SystemSettings.masterVolume
                    onMoved: SystemSettings.masterVolume = value
                }
                
                NordicText {
                    text: SystemSettings.masterVolume + "%"
                    type: NordicText.Type.BodySmall
                    color: Theme.textPrimary
                    Layout.preferredWidth: 40
                }
            }
            
            // Separator
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: NordicTheme.colors.border.muted
            }
            
            // ═══════════════════════════════════════════════════════════════
            // ZONE 2: Secondary Controls (Step-based)
            // ═══════════════════════════════════════════════════════════════
            RowLayout {
                Layout.fillWidth: true
                spacing: 16
                
                // Step control component with larger buttons
                component StepControl : RowLayout {
                    id: stepRoot
                    property string label
                    property string icon
                    property int value: 0
                    property int minValue: 0
                    property int maxValue: 100
                    property int step: 10
                    
                    signal decrease()
                    signal increase()
                    
                    spacing: 8
                    
                    NordicIcon {
                        source: stepRoot.icon
                        size: NordicIcon.Size.SM
                        color: Theme.textSecondary
                    }
                    
                    NordicText {
                        text: stepRoot.label
                        type: NordicText.Type.Caption
                        color: Theme.textSecondary
                        Layout.preferredWidth: 70
                    }
                    
                    // Decrease button
                    Rectangle {
                        width: 36; height: 36
                        radius: NordicTheme.shapes.radius_md
                        color: stepMinus.pressed ? Qt.darker(Theme.surfaceAlt, 1.15) : (stepMinus.containsMouse ? Theme.surfaceAlt : "transparent")
                        border.width: stepMinus.containsMouse ? 1 : 0
                        border.color: NordicTheme.colors.border.muted
                        
                        Behavior on color {
                            enabled: !root.reducedMotion
                            ColorAnimation { duration: 100 }
                        }
                        
                        NordicText {
                            anchors.centerIn: parent
                            text: "−"
                            type: NordicText.Type.TitleMedium
                            color: stepMinus.containsMouse ? Theme.textPrimary : Theme.textSecondary
                        }
                        
                        MouseArea {
                            id: stepMinus
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stepRoot.decrease()
                        }
                    }
                    
                    // Value bar
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 8
                        radius: 4
                        color: Theme.surfaceAlt
                        
                        Rectangle {
                            width: parent.width * (stepRoot.value / stepRoot.maxValue)
                            height: parent.height
                            radius: 4
                            color: Theme.accent
                            
                            Behavior on width {
                                enabled: !root.reducedMotion
                                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                            }
                        }
                    }
                    
                    NordicText {
                        text: stepRoot.value + "%"
                        type: NordicText.Type.Caption
                        color: Theme.textTertiary
                        Layout.preferredWidth: 36
                        horizontalAlignment: Text.AlignRight
                    }
                    
                    // Increase button
                    Rectangle {
                        width: 36; height: 36
                        radius: NordicTheme.shapes.radius_md
                        color: stepPlus.pressed ? Qt.darker(Theme.surfaceAlt, 1.15) : (stepPlus.containsMouse ? Theme.surfaceAlt : "transparent")
                        border.width: stepPlus.containsMouse ? 1 : 0
                        border.color: NordicTheme.colors.border.muted
                        
                        Behavior on color {
                            enabled: !root.reducedMotion
                            ColorAnimation { duration: 100 }
                        }
                        
                        NordicText {
                            anchors.centerIn: parent
                            text: "+"
                            type: NordicText.Type.TitleMedium
                            color: stepPlus.containsMouse ? Theme.textPrimary : Theme.textSecondary
                        }
                        
                        MouseArea {
                            id: stepPlus
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stepRoot.increase()
                        }
                    }
                }
                
                StepControl {
                    label: qsTr("Brightness")
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/weather_sunny.svg"
                    value: SystemSettings.brightness
                    Layout.fillWidth: true
                    onDecrease: SystemSettings.brightness = Math.max(10, SystemSettings.brightness - 10)
                    onIncrease: SystemSettings.brightness = Math.min(100, SystemSettings.brightness + 10)
                }
            }
            
            // Separator
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: NordicTheme.colors.border.muted
            }
            
            // ═══════════════════════════════════════════════════════════════
            // ZONE 3: System Access
            // ═══════════════════════════════════════════════════════════════
            Rectangle {
                id: settingsBtn
                Layout.fillWidth: true
                height: 48
                radius: NordicTheme.shapes.radius_md
                color: settingsMouse.pressed ? Qt.darker(Theme.surfaceAlt, 1.1) : (settingsMouse.containsMouse ? Theme.surfaceAlt : "transparent")
                border.width: settingsMouse.containsMouse || settingsBtn.activeFocus ? 1 : 0
                border.color: settingsBtn.activeFocus ? Theme.accent : NordicTheme.colors.border.muted
                
                Behavior on color {
                    enabled: !root.reducedMotion
                    ColorAnimation { duration: 150 }
                }
                
                activeFocusOnTab: true
                Keys.onReturnPressed: settingsMouse.clicked(null)
                Keys.onSpacePressed: settingsMouse.clicked(null)
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 10
                    
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg"
                        size: NordicIcon.Size.SM
                        color: settingsMouse.containsMouse ? Theme.textPrimary : Theme.textSecondary
                    }
                    
                    NordicText {
                        text: qsTr("All Settings")
                        type: NordicText.Type.BodyMedium
                        color: settingsMouse.containsMouse ? Theme.textPrimary : Theme.textSecondary
                    }
                    
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/right.svg"
                        size: NordicIcon.Size.XS
                        color: Theme.textTertiary
                    }
                }
                
                MouseArea {
                    id: settingsMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.open = false
                        root.openSettings()
                    }
                }
            }
        }
    }
    
    QtObject {
        id: internal
        property int lastVolume: 50
    }
}
