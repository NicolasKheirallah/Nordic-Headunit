import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Control {
    id: root
    
    property string text: ""
    property string secondaryText: ""
    property Component leading: null
    property Component trailing: null
    
    signal clicked()
    
    // Sizes: compact, standard, comfortable, expanded
    enum Size { Compact, Standard, Comfortable, Expanded }
    property int size: NordicListItem.Size.Standard
    
    implicitWidth: parent ? parent.width : 400
    implicitHeight: {
        switch (size) {
            case NordicListItem.Size.Compact: return 48
            case NordicListItem.Size.Standard: return 64
            case NordicListItem.Size.Comfortable: return 72
            case NordicListItem.Size.Expanded: return 88
            default: return 64
        }
    }
    
    // Custom Background Color
    property color color: "transparent"

    background: Rectangle {
        color: root.color !== "transparent" ? root.color :
               root.down ? NordicTheme.colors.bg.elevated : 
               root.hovered ? NordicTheme.colors.bg.surface : "transparent"
        Behavior on color { ColorAnimation { duration: NordicTheme.motion.duration_fast } }
    }
    
    contentItem: RowLayout {
        spacing: NordicTheme.spacing.space_4
        
        // Leading Slot
        Loader {
            sourceComponent: root.leading
            Layout.alignment: Qt.AlignVCenter
            visible: root.leading !== null
        }
        
        // Content
        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: NordicTheme.spacing.space_1
            
            NordicText {
                text: root.text
                type: NordicText.Type.TitleMedium
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
            
            NordicText {
                visible: root.secondaryText !== "" && root.size !== NordicListItem.Size.Compact
                text: root.secondaryText
                type: NordicText.Type.BodySmall
                color: NordicTheme.colors.text.secondary
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
        
        // Trailing Slot
        Loader {
            sourceComponent: root.trailing
            Layout.alignment: Qt.AlignVCenter
            visible: root.trailing !== null
        }
    }
    
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: root.leading ? 64 : NordicTheme.spacing.space_4 // Approx inset
        height: 1
        color: NordicTheme.colors.border.muted
        visible: true // Or property to control
    }
    
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        cursorShape: Qt.PointingHandCursor
    }
}
