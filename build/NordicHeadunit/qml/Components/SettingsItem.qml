import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Rectangle {
    property string title: ""
    property string subtitle: ""
    property bool showChevron: false
    property Component rightComponent: null
    property bool locked: false  // Epic 5: Driving lockout
    property string lockedReason: "Not available while driving"
    
    signal clicked()
    
    Layout.fillWidth: true
    Layout.preferredHeight: 80
    Layout.leftMargin: NordicTheme.spacing.space_4
    Layout.rightMargin: NordicTheme.spacing.space_4
    
    color: itemMa.containsMouse ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
    radius: NordicTheme.shapes.radius_md
    
    MouseArea {
        id: itemMa
        anchors.fill: parent
        hoverEnabled: true
        enabled: !locked
        cursorShape: (showChevron && !locked) ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: if (showChevron && !locked) parent.clicked()
    }
    
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
        
        // Right component loader (e.g. StatusIndicator)
        Loader {
            sourceComponent: rightComponent
            visible: rightComponent !== null
            Layout.alignment: Qt.AlignVCenter
        }
        
        NordicText {
            visible: showChevron
            text: "›"
            type: NordicText.Type.HeadlineMedium
            color: NordicTheme.colors.text.tertiary
        }
    }
}
