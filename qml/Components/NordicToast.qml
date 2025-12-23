import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import NordicHeadunit

Rectangle {
    id: root
    
    property string message: "Notification"
    property int type: NordicToast.Type.Info
    property int duration: 3000
    
    signal closed()
    
    enum Type { Info, Success, Warning, Error }
    
    implicitWidth: Math.min(row.implicitWidth + 32, 600)
    implicitHeight: 48
    
    radius: Theme.radiusFull
    color: {
        switch (type) {
            case NordicToast.Type.Error: return Theme.danger
            case NordicToast.Type.Success: return Theme.success
            case NordicToast.Type.Warning: return Theme.warning
            default: return Theme.isDark ? Theme.surface : Theme.surfaceAlt
        }
    }
    
    
    // PERFORMANCE: Only enable shadow when toast is visible
    layer.enabled: root.opacity > 0 && root.visible
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Theme.shadowColor
        shadowBlur: 12
        shadowVerticalOffset: 4
    }
    
    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Theme.spacingXs
        
        NordicText {
            text: root.message
            type: NordicText.Type.BodyMedium
            color: Theme.textInverse
        }
    }
    
    // Animation
    opacity: 0
    y: 20 // Offset
    
    // For Manager: Expose signal dismissed()
    signal dismissed()
    
    // Internal timer: Only auto-start if NOT managed (optional logic, or just let manager handle lifetime)
    // Actually, if we use ToastManager, we don't want this internal timer to destroy the object!
    // The Manager uses a Model. If we destroy() internally, Model gets confused or segfaults?
    // Correct pattern: Emit signal, let Manager remove from Model.
    
    // Modified Timer
    Timer {
        id: dismissTimer
        interval: root.duration
        running: false 
        onTriggered: {
             animOut.start()
        }
    }
    
    // Public API for Manager
    function startLegacy() {
         animIn.start()
         dismissTimer.start()
    }
    
    // Legacy support for Component.onCompleted if used standalone
    Component.onCompleted: {
        // We assume if it has a parent that is NOT the ToastManager (by checking if we are a delegate?), we run.
        // But simpler: Default to running, allow stopping?
        // Let's just run. The Manager handles the Model removal on 'dismissed'.
        
        animIn.start()
        if (root.duration > 0) dismissTimer.start()
    }

    ParallelAnimation {
        id: animIn
        NumberAnimation { target: root; property: "opacity"; to: 1.0; duration: 300; easing.type: Easing.OutCubic }
        NumberAnimation { target: root; property: "y"; to: 0; duration: 300; easing.type: Easing.OutCubic }
    }
    
    SequentialAnimation {
        id: animOut
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0.0; duration: 200 }
            NumberAnimation { target: root; property: "y"; to: 20; duration: 200 }
        }
        ScriptAction { script: { 
            root.visible = false; 
            root.dismissed(); // Signal manager
            root.closed(); 
            // Do NOT destroy if managed by Loader/Model, let Loader handle it?
            // If we are in a Loader in ListView, disabling Loader source or model remove destroys it.
            // So we just signal.
        } }
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            dismissTimer.stop()
            animOut.start()
        }
    }
}
