import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NordicHeadunit

Item {
    id: root
    
    // API
    property alias model: historyModel
    
    ListModel { id: toastModel }   // Active transients
    ListModel { id: historyModel } // Persistent history
    
    function show(message, type, duration) {
        if (duration === undefined) duration = 3000
        if (type === undefined) type = NordicToast.Type.Info
        
        // Add to active (transient)
        toastModel.insert(0, { "message": message, "type": type, "duration": duration })
        if (toastModel.count > 2) toastModel.remove(2, toastModel.count - 2)
        
        // Add to history (persistent)
        historyModel.insert(0, { "title": "System Alert", "body": message, "icon": "car.svg", "type": type })
        if (historyModel.count > 20) historyModel.remove(20, historyModel.count - 20)
    }
    
    ListView {
        id: view
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 100 // Above DockBar (80px) + margin
        width: 480
        height: contentItem.height
        clip: false // Allow animations to fly in/out
        spacing: 8
        interactive: false
        verticalLayoutDirection: ListView.BottomToTop
        
        model: toastModel
        
        delegate: Item {
            width: view.width
            height: toastLoader.height
            
            // Animation for insert
            ListView.onAdd: SequentialAnimation {
                NumberAnimation { target: toastLoader; property: "opacity"; from: 0; to: 1; duration: NordicTheme.motion.duration_fast }
                NumberAnimation { target: toastLoader; property: "y"; from: 20; to: 0; duration: NordicTheme.motion.duration_fast; easing.type: Easing.OutCubic }
            }
            
            // Animation for remove
            ListView.onRemove: SequentialAnimation {
                NumberAnimation { target: toastLoader; property: "opacity"; to: 0; duration: NordicTheme.motion.duration_fastest }
                ScriptAction { script: toastLoader.destroy() } // Optional cleanup if we manual
            }
            
            Loader {
                id: toastLoader
                sourceComponent: toastComponent
                width: parent.width
                
                property string msg: model.message
                property int typeCode: model.type
                property int dur: model.duration
            }
            
            Component {
                id: toastComponent
                NordicToast {
                    width: 480
                    message: msg
                    type: typeCode
                    duration: dur
                     
                    onDismissed: {
                        if (index >= 0 && index < toastModel.count) {
                            toastModel.remove(index)
                        }
                    }
                }
            }
        }
    }
}
