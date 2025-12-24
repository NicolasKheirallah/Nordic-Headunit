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
    property string icon: ""
    
    // Accessibility
    readonly property bool reducedMotion: SystemSettings.reducedMotion ?? false
    
    signal clicked()
    
    Layout.fillWidth: true
    Layout.preferredHeight: 80
    Layout.leftMargin: Theme.spacingSm
    Layout.rightMargin: Theme.spacingSm
    
    // Visual State
    color: {
        if (itemMa.pressed) return Theme.surfaceAlt
        if (itemMa.containsMouse || activeFocus) return Theme.surfaceAlt
        return Theme.surface
    }
    
    radius: Theme.radiusMd
    
    // Focus Ring
    border.width: activeFocus ? 2 : 0
    border.color: Theme.accent
    
    Behavior on color { 
        enabled: !reducedMotion
        ColorAnimation { duration: 100 } 
    }
    
    // Keyboard Navigation
    activeFocusOnTab: (showChevron || icon !== "") && !locked
    Keys.onReturnPressed: if ((showChevron || icon !== "") && !locked) parent.clicked()
    Keys.onSpacePressed: if ((showChevron || icon !== "") && !locked) parent.clicked()
    
    MouseArea {
        id: itemMa
        anchors.fill: parent
        hoverEnabled: true
        enabled: !locked
        cursorShape: (showChevron && !locked) ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            parent.forceActiveFocus()
            if (showChevron && !locked) parent.clicked()
        }
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingMd
        anchors.rightMargin: Theme.spacingMd
        spacing: Theme.spacingSm
        
        // Optional Icon
        NordicIcon {
            visible: icon !== ""
            source: icon
            size: NordicIcon.Size.MD
            color: Theme.textSecondary
            Layout.alignment: Qt.AlignVCenter
        }
        
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
