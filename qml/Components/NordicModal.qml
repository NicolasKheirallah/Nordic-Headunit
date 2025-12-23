import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import NordicHeadunit

Popup {
    id: root
    
    // API
    property string title: "Modal Title"
    property string message: "Description"
    property alias actions: actionLayout.data
    default property alias content: contentWrapper.data
    
    // Variants
    enum Variant { Dialog, BottomSheet }
    property int variant: NordicModal.Variant.Dialog
    
    // Type
    enum Type { Info, Confirmation, Alert }
    property int type: NordicModal.Type.Info
    
    parent: Overlay.overlay
    
    // Positioning
    x: variant === NordicModal.Variant.BottomSheet ? Math.round((parent.width - width) / 2) : Math.round((parent.width - width) / 2)
    y: variant === NordicModal.Variant.BottomSheet ? parent.height - height : Math.round((parent.height - height) / 2)
    
    implicitWidth: variant === NordicModal.Variant.BottomSheet ? parent.width : 480
    implicitHeight: layout.implicitHeight + 48
    
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    Overlay.modal: Rectangle {
        color: Theme.withAlpha(Theme.background, 0.7)
    }
    
    enter: Transition {
        NumberAnimation { 
            property: "opacity"; from: 0.0; to: 1.0; 
            duration: Theme.durationFast 
        }
        NumberAnimation { 
            property: variant === NordicModal.Variant.BottomSheet ? "y" : "scale"
            from: variant === NordicModal.Variant.BottomSheet ? parent.height : 0.95
            to: variant === NordicModal.Variant.BottomSheet ? parent.height - root.height : 1.0
            duration: Theme.durationFast
            easing.type: Easing.OutCubic 
        }
    }
    
    exit: Transition {
        NumberAnimation { 
            property: "opacity"; from: 1.0; to: 0.0; 
            duration: Theme.durationFast 
        }
        NumberAnimation { 
            property: variant === NordicModal.Variant.BottomSheet ? "y" : "scale"
            from: variant === NordicModal.Variant.BottomSheet ? parent.height - root.height : 1.0
            to: variant === NordicModal.Variant.BottomSheet ? parent.height : 0.95
            duration: Theme.durationFast 
        }
    }
    
    background: Rectangle {
        color: Theme.surfaceAlt
        radius: Theme.radiusXl
        
        Rectangle {
            // Mask bottom corners for BottomSheet 
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.radius
            color: parent.color
            visible: root.variant === NordicModal.Variant.BottomSheet
        }
        
        border.color: Theme.border
        border.width: 1
        
        // PERFORMANCE: Only enable layer when popup is visible
        layer.enabled: root.visible && root.opened
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowBlur: 24
        }
    }
    
    contentItem: ColumnLayout {
        id: layout
        spacing: Theme.spacingSm
        
        // Handle (for BottomSheet)
        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: -8
            Layout.bottomMargin: 8
            width: 40
            height: 4
            visible: root.variant === NordicModal.Variant.BottomSheet
            Rectangle {
                anchors.fill: parent
                color: Theme.borderEmphasis
                radius: 2
            }
        }
        
        NordicIcon {
            Layout.alignment: Qt.AlignHCenter
            size: NordicIcon.Size.XL
            source: {
                switch(root.type) {
                    case NordicModal.Type.Alert: return "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" 
                    case NordicModal.Type.Confirmation: return "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                    default: return "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                }
            }
        }
        
        NordicText {
            text: root.title
            type: NordicText.Type.HeadlineSmall
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }
        
        NordicText {
            text: root.message
            type: NordicText.Type.BodyLarge
            color: Theme.textSecondary
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.maximumWidth: 600
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }
        
        ColumnLayout {
            id: contentWrapper
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
        }
        
        RowLayout {
            id: actionLayout
            Layout.topMargin: Theme.spacingSm
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.spacingSm
        }
    }
}
