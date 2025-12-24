import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// ═══════════════════════════════════════════════════════════════════════════
// App Tile - Single app icon with label for the launcher grid
// ═══════════════════════════════════════════════════════════════════════════
Item {
    id: root
    
    // Properties
    property string appId: ""
    property string displayName: ""
    property string iconUrl: ""
    property bool isEnabled: true
    property bool isPinned: false
    property int iconSize: 72
    
    // Accessibility
    readonly property bool reducedMotion: SystemSettings.reducedMotion
    
    // Signals
    signal clicked()
    signal pinToggled()
    
    // States
    readonly property bool isHovered: mouseArea.containsMouse
    readonly property bool isPressed: mouseArea.pressed
    readonly property bool isFocused: activeFocus
    
    // Focus handling
    activeFocusOnTab: true
    Keys.onReturnPressed: if (isEnabled) clicked()
    Keys.onSpacePressed: if (isEnabled) clicked()
    
    // -------------------------------------------------------------------------
    // Content
    // -------------------------------------------------------------------------
    Column {
        anchors.centerIn: parent
        spacing: 8
        
        // Icon Container
        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.iconSize
            height: root.iconSize
            
            // Focus Ring
            Rectangle {
                anchors.centerIn: parent
                width: parent.width + 12
                height: parent.height + 12
                radius: NordicTheme.shapes.radius_lg + 4
                color: "transparent"
                border.width: 3
                border.color: Theme.accent
                visible: root.isFocused
                opacity: 0.8
            }
            
            // Icon Background
            Rectangle {
                id: iconBg
                anchors.fill: parent
                radius: NordicTheme.shapes.radius_lg
                color: root.isHovered && root.isEnabled 
                    ? Theme.surfaceAlt 
                    : "transparent"
                
                scale: root.isPressed ? 0.92 : 1.0
                Behavior on scale { 
                    enabled: !root.reducedMotion
                    NumberAnimation { duration: 100 } 
                }
                Behavior on color { 
                    enabled: !root.reducedMotion
                    ColorAnimation { duration: 150 } 
                }
                
                // Icon
                NordicIcon {
                    anchors.centerIn: parent
                    source: root.iconUrl
                    size: NordicIcon.Size.XL
                    color: root.isEnabled ? Theme.textPrimary : Theme.textTertiary
                    
                    // Fallback letter if icon fails
                    visible: root.iconUrl !== ""
                }
                
                // Fallback: First letter placeholder
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: Theme.accent
                    visible: root.iconUrl === ""
                    opacity: root.isEnabled ? 1.0 : 0.4
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: root.displayName.charAt(0).toUpperCase()
                        type: NordicText.Type.HeadlineLarge
                        color: "white"
                    }
                }
                
                // Disabled Overlay
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: Qt.rgba(0, 0, 0, 0.5)
                    visible: !root.isEnabled
                    
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/lock.svg"
                        size: NordicIcon.Size.MD
                        color: "white"
                        opacity: 0.8
                    }
                }
                
                // Pin Badge
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: -4
                    width: 20
                    height: 20
                    radius: 10
                    color: Theme.accent
                    visible: root.isPinned
                    
                    // Subtle entrance animation
                    scale: visible ? 1.0 : 0.5
                    Behavior on scale {
                        enabled: !root.reducedMotion
                        NumberAnimation { duration: 200; easing.type: Easing.OutBack }
                    }
                    
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/heart.svg"
                        size: NordicIcon.Size.XS
                        color: "white"
                    }
                }
            }
        }
        
        // Label
        NordicText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.displayName
            type: NordicText.Type.Caption
            color: root.isEnabled ? Theme.textPrimary : Theme.textTertiary
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            width: Math.min(implicitWidth, root.width - 16)
        }
    }
    
    // -------------------------------------------------------------------------
    // Mouse Interaction
    // -------------------------------------------------------------------------
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        // Tap to launch
        onClicked: {
            if (root.isEnabled) {
                root.clicked()
            }
        }
        
        // Long press to pin/unpin
        onPressAndHold: {
            root.pinToggled()
        }
    }
    
    // -------------------------------------------------------------------------
    // Tooltip for disabled apps
    // -------------------------------------------------------------------------
    ToolTip {
        visible: !root.isEnabled && root.isHovered
        text: qsTr("Available when parked")
        delay: 500
    }
}
