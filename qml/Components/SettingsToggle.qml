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
    Layout.leftMargin: Theme.spacingSm
    Layout.rightMargin: Theme.spacingSm
    
    color: Theme.surface
    radius: Theme.radiusMd
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingMd
        anchors.rightMargin: Theme.spacingMd
        spacing: Theme.spacingSm
        
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: Theme.spacingXs
            
            NordicText {
                text: title
                type: NordicText.Type.TitleSmall
                color: Theme.textPrimary
            }
            NordicText {
                text: subtitle
                type: NordicText.Type.BodySmall
                color: Theme.textTertiary
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
            color: Theme.textSecondary
        }
    }
}
