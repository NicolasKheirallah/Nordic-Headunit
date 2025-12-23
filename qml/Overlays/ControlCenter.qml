import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import NordicHeadunit

// Control Panel (Quick Settings) - OEM-Grade Fast Access
// Zone 1: Primary Toggles | Zone 2: Secondary Controls | Zone 3: Settings Link
// Compact, one-tap, no sliders, no bounce
Item {
    id: root
    
    property bool open: false
    
    function toggle() { open = !open }
    
    signal openSettings()
    
    // Background scrim (tap to dismiss)
    Rectangle {
        anchors.fill: parent
        color: open ? Qt.rgba(0, 0, 0, 0.4) : "transparent"
        opacity: open ? 1 : 0
        
        Behavior on opacity { NumberAnimation { duration: 150 } }
        
        MouseArea { 
            anchors.fill: parent
            enabled: root.open
            onClicked: root.open = false
        }
    }
    
    // Panel
    Rectangle {
        id: panel
        width: Math.min(480, parent.width - 32)
        height: contentHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: open ? 8 : -height
        
        property int contentHeight: 280  // Capped height
        
        color: NordicTheme.colors.bg.surface
        radius: 16
        
        // PERFORMANCE: Only enable layer effect when panel is open
        layer.enabled: root.open && root.visible
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowVerticalOffset: 4
            shadowBlur: 0.8
            shadowOpacity: 0.15
        }
        
        // Subtle slide animation (no bounce)
        Behavior on anchors.topMargin { 
            NumberAnimation { 
                duration: 200
                easing.type: Easing.OutCubic 
            } 
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12
            visible: root.open
            
            // ═══════════════════════════════════════════════════════════════
            // ZONE 1: Primary Toggles
            // ═══════════════════════════════════════════════════════════════
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                rowSpacing: 16
                columnSpacing: 16
                
                // Toggle component
                component QuickToggle : Rectangle {
                    id: toggleRoot
                    property string label
                    property string icon
                    property bool active: false
                    property bool available: true
                    
                    signal clicked()
                    
                    Layout.fillWidth: true
                    Layout.preferredHeight: 56
                    radius: 10
                    color: !available ? NordicTheme.colors.bg.elevated :
                           active ? NordicTheme.colors.accent.primary : 
                           toggleMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.secondary
                    opacity: available ? 1 : 0.5
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        NordicIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: toggleRoot.icon
                            size: NordicIcon.Size.SM
                            color: toggleRoot.active ? "white" : NordicTheme.colors.text.secondary
                        }
                        
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: toggleRoot.label
                            font.pixelSize: 11
                            font.family: "Helvetica"
                            color: toggleRoot.active ? "white" : NordicTheme.colors.text.tertiary
                        }
                    }
                    
                    MouseArea {
                        id: toggleMouse
                        anchors.fill: parent
                        enabled: toggleRoot.available
                        onClicked: toggleRoot.clicked()
                    }
                }
                
                // WiFi
                QuickToggle {
                    label: "Wi-Fi"
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/wifi.svg"
                    active: SystemSettings.wifiEnabled
                    onClicked: SystemSettings.wifiEnabled = !SystemSettings.wifiEnabled
                }
                
                // Bluetooth  
                QuickToggle {
                    label: "Bluetooth"
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
                    active: SystemSettings.bluetoothEnabled
                    onClicked: SystemSettings.bluetoothEnabled = !SystemSettings.bluetoothEnabled
                }
                
                // Mute
                QuickToggle {
                    label: "Mute"
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
                    label: SystemSettings.darkMode ? "Dark" : "Light"
                    icon: SystemSettings.darkMode 
                        ? "qrc:/qt/qml/NordicHeadunit/assets/icons/weather_cloudy.svg"
                        : "qrc:/qt/qml/NordicHeadunit/assets/icons/weather_sunny.svg"
                    active: SystemSettings.darkMode
                    onClicked: SystemSettings.darkMode = !SystemSettings.darkMode
                }
                
            // Volume Slider
            RowLayout {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                spacing: 12
                
                NordicIcon {
                    source: SystemSettings.masterVolume === 0 
                        ? "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_off.svg" 
                        : "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_up.svg"
                    size: NordicIcon.Size.MD
                    color: NordicTheme.colors.text.secondary
                }
                
                NordicSlider {
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: SystemSettings.masterVolume
                    onMoved: SystemSettings.masterVolume = value
                }
                
                Text {
                    text: SystemSettings.masterVolume + "%"
                    font.pixelSize: 14
                    font.family: "Helvetica"
                    color: NordicTheme.colors.text.primary
                    Layout.preferredWidth: 35
                }
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
                
                // Step control component
                component StepControl : RowLayout {
                    id: stepRoot
                    property string label
                    property int value: 0
                    property int minValue: 0
                    property int maxValue: 100
                    property int step: 10
                    
                    signal decrease()
                    signal increase()
                    
                    spacing: 6
                    
                    Text {
                        text: stepRoot.label
                        font.pixelSize: 12
                        font.family: "Helvetica"
                        color: NordicTheme.colors.text.secondary
                        Layout.preferredWidth: 70
                    }
                    
                    Rectangle {
                        width: 28; height: 28
                        radius: 6
                        color: stepMinus.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.secondary
                        
                        Text {
                            anchors.centerIn: parent
                            text: "−"
                            font.pixelSize: 16
                            font.family: "Helvetica"
                            color: NordicTheme.colors.text.secondary
                        }
                        
                        MouseArea {
                            id: stepMinus
                            anchors.fill: parent
                            onClicked: stepRoot.decrease()
                        }
                    }
                    
                    // Value bar
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 6
                        radius: 3
                        color: NordicTheme.colors.bg.elevated
                        
                        Rectangle {
                            width: parent.width * (stepRoot.value / stepRoot.maxValue)
                            height: parent.height
                            radius: 3
                            color: NordicTheme.colors.accent.primary
                        }
                    }
                    
                    Text {
                        text: stepRoot.value + "%"
                        font.pixelSize: 11
                        font.family: "Helvetica"
                        color: NordicTheme.colors.text.tertiary
                        Layout.preferredWidth: 32
                    }
                    
                    Rectangle {
                        width: 28; height: 28
                        radius: 6
                        color: stepPlus.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.secondary
                        
                        Text {
                            anchors.centerIn: parent
                            text: "+"
                            font.pixelSize: 16
                            font.family: "Helvetica"
                            color: NordicTheme.colors.text.secondary
                        }
                        
                        MouseArea {
                            id: stepPlus
                            anchors.fill: parent
                            onClicked: stepRoot.increase()
                        }
                    }
                }
                
                StepControl {
                    label: "Brightness"
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
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                // Settings link
                Rectangle {
                    Layout.fillWidth: true
                    height: 44
                    radius: 8
                    color: settingsMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.secondary
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        NordicIcon {
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg"
                            size: NordicIcon.Size.SM
                            color: NordicTheme.colors.text.secondary
                        }
                        
                        Text {
                            text: "All Settings"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            font.family: "Helvetica"
                            color: NordicTheme.colors.text.primary
                        }
                    }
                    
                    MouseArea {
                        id: settingsMouse
                        anchors.fill: parent
                        onClicked: {
                            root.open = false
                            root.openSettings()
                        }
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
