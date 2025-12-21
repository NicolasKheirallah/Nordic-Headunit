import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Item {
    id: root
    
    visible: false
    
    function show() { visible = true }
    function hide() { visible = false }
    
    // Black Background (Modal)
    Rectangle {
        anchors.fill: parent
        color: "black"
        
        // Placeholder Camera Feed (Noise)
        Rectangle {
            anchors.fill: parent
            color: "#222"
        }
        
        NordicText {
            anchors.centerIn: parent
            text: "Rear Camera Feed"
            color: "white"
            type: NordicText.Type.DisplayMedium
        }
        
        // Parking Lines (Mock)
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.lineWidth = 6;
                ctx.strokeStyle = "yellow";
                
                // Left Line
                ctx.beginPath();
                ctx.moveTo(width * 0.3, height);
                ctx.lineTo(width * 0.4, height * 0.6);
                ctx.stroke();
                
                // Right Line
                ctx.beginPath();
                ctx.moveTo(width * 0.7, height);
                ctx.lineTo(width * 0.6, height * 0.6);
                ctx.stroke();
                
                 // Stop Line
                ctx.strokeStyle = "red";
                ctx.beginPath();
                ctx.moveTo(width * 0.35, height * 0.9);
                ctx.lineTo(width * 0.65, height * 0.9);
                ctx.stroke();
            }
        }
        
        // Close hint
        NordicText {
            anchors.bottom: parent.bottom
            anchors.margins: 40
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Press R to exit"
            color: "white"
            type: NordicText.Type.BodySmall
        }
    }
}
