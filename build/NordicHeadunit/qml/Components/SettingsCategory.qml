import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Rectangle {
    property string title: ""
    property string icon: "settings"
    property string description: ""
    signal clicked()
    
    Layout.fillWidth: true
    Layout.preferredHeight: 90 // Touch friendly
    Layout.leftMargin: NordicTheme.spacing.space_4
    Layout.rightMargin: NordicTheme.spacing.space_4
    Layout.topMargin: NordicTheme.spacing.space_2
    
    color: ma.containsMouse ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
    radius: NordicTheme.shapes.radius_lg
    
    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: parent.clicked()
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: NordicTheme.spacing.space_4
        spacing: NordicTheme.spacing.space_4
        
        Rectangle {
            Layout.preferredWidth: 56
            Layout.preferredHeight: 56
            radius: NordicTheme.shapes.radius_md
            color: NordicTheme.colors.accent.primary
            opacity: 0.15
            
            NordicIcon {
                anchors.centerIn: parent
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/" + icon + ".svg"
                color: NordicTheme.colors.accent.primary
                size: NordicIcon.Size.LG
            }
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: NordicTheme.spacing.space_1
            
            NordicText {
                text: title
                type: NordicText.Type.TitleMedium
                color: NordicTheme.colors.text.primary
            }
            NordicText {
                text: description
                type: NordicText.Type.BodySmall
                color: NordicTheme.colors.text.tertiary
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
        
        NordicText {
            text: "›"
            type: NordicText.Type.HeadlineMedium
            color: NordicTheme.colors.text.tertiary
        }
    }
}
