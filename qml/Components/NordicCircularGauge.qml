import QtQuick
import QtQuick.Shapes
import NordicHeadunit

Item {
    id: root
    
    // API
    property real value: 0
    property real from: 0
    property real to: 100
    property string unit: "%"
    property string label: ""
    
    // Colors
    property color accentColor: Theme.accent
    
    implicitWidth: 200
    implicitHeight: 200
    
    // Internal Logic
    readonly property real range: to - from
    readonly property real normalizedValue: (value - from) / range
    readonly property real startAngle: -225 // Starts at 7-ish o'clock
    readonly property real sweepAngle: 270 // Ends at 5-ish o'clock
    
    // Gauge Background
    Shape {
        anchors.fill: parent
        // Anti-aliasing
        layer.enabled: true
        layer.samples: 4
        
        ShapePath {
            strokeColor: Theme.surfaceAlt
            strokeWidth: 16
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: (root.width / 2) - 16
                radiusY: (root.height / 2) - 16
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle
            }
        }
        
        // Value Arc
        ShapePath {
            strokeColor: root.accentColor
            strokeWidth: 16
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            
            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height / 2
                radiusX: (root.width / 2) - 16
                radiusY: (root.height / 2) - 16
                startAngle: root.startAngle
                sweepAngle: root.sweepAngle * root.normalizedValue
            }
        }
    }
    
    // Text Info
    Column {
        anchors.centerIn: parent
        spacing: 4
        
        NordicText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(root.value)
            type: NordicText.Type.HeadlineLarge
            color: Theme.textPrimary
        }
        
        NordicText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.unit
            type: NordicText.Type.BodyMedium
            color: Theme.textSecondary
        }
        
        NordicText {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            type: NordicText.Type.BodySmall
            color: Theme.textTertiary
            visible: root.label !== ""
        }
    }
}
