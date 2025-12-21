import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

Rectangle {
    id: root
    
    // API
    property real balanceX: 0.0 // -1.0 (Left) to 1.0 (Right)
    property real balanceY: 0.0 // -1.0 (Front) to 1.0 (Rear)
    
    // Output
    signal positionChanged(real x, real y)
    
    // Props
    color: NordicTheme.colors.bg.surface
    radius: NordicTheme.shapes.radius_lg
    border.color: NordicTheme.colors.border.muted
    border.width: 1
    
    // The "Car" or "Seat Map" Visualization
    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * 0.8
        height: width * 1.4
        opacity: 0.3
        
        // Abstract Car Body
        Rectangle {
            anchors.fill: parent
            radius: width * 0.2
            color: NordicTheme.colors.text.tertiary
        }
        
        // Seats
        Repeater {
            model: [
                {x: 0.15, y: 0.25}, // Driver
                {x: 0.55, y: 0.25}, // Passenger
                {x: 0.15, y: 0.65}, // Rear L
                {x: 0.55, y: 0.65}  // Rear R
            ]
            delegate: Rectangle {
                x: parent.width * modelData.x
                y: parent.height * modelData.y
                width: parent.width * 0.3
                height: width
                radius: 4
                color: NordicTheme.colors.bg.primary
            }
        }
    }
    
    // Crosshairs
    Rectangle {
        anchors.centerIn: parent
        width: parent.width - 32
        height: 1
        color: NordicTheme.colors.border.muted
        opacity: 0.5
    }
    Rectangle {
        anchors.centerIn: parent
        height: parent.height - 32
        width: 1
        color: NordicTheme.colors.border.muted
        opacity: 0.5
    }
    
    // The Draggable Puck
    Rectangle {
        id: puck
        width: 48
        height: 48
        radius: 24
        color: NordicTheme.colors.accent.primary
        border.color: "white"
        border.width: 3
        
        // Shadow
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#80000000"
            shadowBlur: 1
            shadowVerticalOffset: 2
        }
        
        // Bind position to state
        x: (root.width - width) / 2 + (root.balanceX * (root.width - width) / 2)
        y: (root.height - height) / 2 + (root.balanceY * (root.height - height) / 2)
        
        NordicIcon {
            anchors.centerIn: parent
            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
            size: NordicIcon.Size.SM
            color: "white"
        }
    }
    
    // Touch Logic
    MouseArea {
        anchors.fill: parent
        
        onPositionChanged: (mouse) => {
            updatePosition(mouse.x, mouse.y)
        }
        onPressed: (mouse) => {
            updatePosition(mouse.x, mouse.y)
        }
        
        function updatePosition(tx, ty) {
            // Clamp to bounds (taking puck size into account)
            let halfW = puck.width / 2
            let halfH = puck.height / 2
            let maxX = root.width - halfW
            let maxY = root.height - halfH
            
            // Normalize to -1.0 to 1.0
            let normX = (tx - root.width/2) / (root.width/2 - halfW)
            let normY = (ty - root.height/2) / (root.height/2 - halfH)
            
            // Clamp
            normX = Math.max(-1.0, Math.min(1.0, normX))
            normY = Math.max(-1.0, Math.min(1.0, normY))
            
            // Update
            root.positionChanged(normX, normY)
        }
    }
    
    // Label
    NordicText {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: NordicTheme.spacing.space_4
        text: "Drag to adjust focus"
        type: NordicText.Type.Caption
        color: NordicTheme.colors.text.tertiary
    }
}
