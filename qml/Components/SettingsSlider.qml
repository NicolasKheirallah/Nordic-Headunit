import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Rectangle {
    property string title: ""
    property real value: 50
    property real from: 0
    property real to: 100
    property real stepSize: 1
    property string unit: ""
    property bool locked: false  // Epic 5: Driving lockout
    property string lockedReason: "Not available while driving"
    signal moved(real value)
    
    Layout.fillWidth: true
    Layout.preferredHeight: 100 // Taller for touch
    Layout.leftMargin: Theme.spacingSm
    Layout.rightMargin: Theme.spacingSm
    
    color: Theme.surface
    radius: Theme.radiusMd
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.spacingMd
        spacing: Theme.spacingXs
        
        RowLayout {
            Layout.fillWidth: true
            
            NordicText {
                text: title
                type: NordicText.Type.TitleSmall
                color: Theme.textPrimary
                Layout.fillWidth: true
            }
            NordicText {
                text: Math.round(sliderControl.value) + unit
                type: NordicText.Type.TitleSmall
                color: Theme.accent
            }
        }
        
        NordicSlider {
            id: sliderControl
            Layout.fillWidth: true
            from: parent.parent.from
            to: parent.parent.to
            value: parent.parent.value
            stepSize: parent.parent.stepSize
            enabled: !parent.parent.locked
            opacity: parent.parent.locked ? 0.5 : 1.0
            onMoved: () => parent.parent.moved(value)
        }
        
        // Locked indicator
        NordicText {
            visible: locked
            text: lockedReason
            type: NordicText.Type.Caption
            color: Theme.warning
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
