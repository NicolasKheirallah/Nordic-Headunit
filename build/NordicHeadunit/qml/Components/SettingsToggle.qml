import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Rectangle {
    property string title: ""
    property string subtitle: ""
    property bool checked: false
    property bool locked: false  // Epic 5: Driving lockout
    property string lockedReason: "Not available while driving"
    signal toggled(bool checked)
    
    Layout.fillWidth: true
    Layout.preferredHeight: 80
    Layout.leftMargin: NordicTheme.spacing.space_4
    Layout.rightMargin: NordicTheme.spacing.space_4
    
    color: NordicTheme.colors.bg.surface
    radius: NordicTheme.shapes.radius_md
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: NordicTheme.spacing.space_5
        anchors.rightMargin: NordicTheme.spacing.space_5
        spacing: NordicTheme.spacing.space_4
        
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: NordicTheme.spacing.space_1
            
            NordicText {
                text: title
                type: NordicText.Type.TitleSmall
                color: NordicTheme.colors.text.primary
            }
            NordicText {
                text: subtitle
                type: NordicText.Type.BodySmall
                color: NordicTheme.colors.text.tertiary
                visible: subtitle !== ""
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
        
        Switch {
            checked: parent.parent.checked
            enabled: !parent.parent.locked
            opacity: parent.parent.locked ? 0.5 : 1.0
            onToggled: {
                parent.parent.checked = checked
                parent.parent.toggled(checked)
            }
        }
    }
    
    // Locked Overlay
    Rectangle {
        visible: locked
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.3)
        radius: parent.radius
        
        NordicText {
            anchors.centerIn: parent
            text: lockedReason
            type: NordicText.Type.Caption
            color: NordicTheme.colors.text.secondary
        }
    }
}
