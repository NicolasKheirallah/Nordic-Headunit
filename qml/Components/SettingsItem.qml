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
    Layout.leftMargin: Theme.spacingSm
    Layout.rightMargin: Theme.spacingSm
    
    color: itemMa.containsMouse ? Theme.surfaceAlt : Theme.surface
    radius: Theme.radiusMd
    
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
            color: Theme.textTertiary
        }
    }
}
