import QtQuick
import NordicHeadunit

// Loading Spinner Component
Item {
    id: root
    
    property int size: 48
    property color color: Theme.accent
    property bool running: true
    
    implicitWidth: size
    implicitHeight: size
    
    visible: running
    
    // Spinning arc
    Canvas {
        id: canvas
        anchors.fill: parent
        
        property real angle: 0
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.strokeStyle = root.color
            ctx.lineWidth = 4
            ctx.lineCap = "round"
            
            var centerX = width / 2
            var centerY = height / 2
            var radius = Math.min(width, height) / 2 - 4
            
            ctx.beginPath()
            var startAngle = angle * Math.PI / 180
            var endAngle = (angle + 270) * Math.PI / 180
            ctx.arc(centerX, centerY, radius, startAngle, endAngle)
            ctx.stroke()
        }
        
        NumberAnimation on angle {
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
            running: root.running
        }
        
        onAngleChanged: requestPaint()
    }
}
