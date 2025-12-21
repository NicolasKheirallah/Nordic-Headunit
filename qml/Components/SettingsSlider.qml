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
    Layout.leftMargin: NordicTheme.spacing.space_4
    Layout.rightMargin: NordicTheme.spacing.space_4
    
    color: NordicTheme.colors.bg.surface
    radius: NordicTheme.shapes.radius_md
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: NordicTheme.spacing.space_5
        spacing: NordicTheme.spacing.space_2
        
        RowLayout {
            Layout.fillWidth: true
            
            NordicText {
                text: title
                type: NordicText.Type.TitleSmall
                color: NordicTheme.colors.text.primary
                Layout.fillWidth: true
            }
            NordicText {
                text: Math.round(sliderControl.value) + unit
                type: NordicText.Type.TitleSmall
                color: NordicTheme.colors.accent.primary
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
            color: NordicTheme.colors.semantic.warning
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
