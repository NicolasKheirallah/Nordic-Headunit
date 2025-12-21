import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

Rectangle {
    id: root
    
    // Properties
    // Binding to C++
    property string title: MediaService.title
    property string artist: MediaService.artist
    property string coverSource: MediaService.coverSource
    property bool playing: MediaService.playing
    property real progress: MediaService.progress
    property real duckingVolume: 1.0
    
    // Mock volume effect
    opacity: duckingVolume < 1.0 ? 0.7 : 1.0
    
    signal playPauseClicked()
    signal nextClicked()
    signal previousClicked()
    signal barClicked()
    
    implicitWidth: 600
    implicitHeight: 64
    
    // Style
    color: NordicTheme.colors.bg.elevated
    radius: NordicTheme.shapes.radius_full // Pill shape
    border.color: NordicTheme.colors.border.muted
    border.width: 1
    
    // Shadow
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: NordicTheme.elevation.shadow_color_lg
        shadowBlur: 24
        shadowVerticalOffset: 8
    }
    
    // Interaction
    MouseArea {
        anchors.fill: parent
        onClicked: root.barClicked()
        cursorShape: Qt.PointingHandCursor
    }
    
    // Content
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: NordicTheme.spacing.space_2
        anchors.rightMargin: NordicTheme.spacing.space_4
        spacing: NordicTheme.spacing.space_3
        
        // Album Art (Round)
        Rectangle {
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            radius: NordicTheme.shapes.radius_full
            color: NordicTheme.colors.bg.surface
            clip: true
            
            NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                size: NordicIcon.Size.LG
                anchors.centerIn: parent
                color: NordicTheme.colors.accent.primary
            }
        }
        
        // Metadata
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            
            NordicText {
                text: root.title
                type: NordicText.Type.TitleSmall
                Layout.fillWidth: true
                autoScroll: true
            }
            
            NordicText {
                text: root.artist
                type: NordicText.Type.BodySmall
                color: NordicTheme.colors.text.secondary
                Layout.fillWidth: true
                autoScroll: true
            }
        }
        
        RowLayout {
            spacing: NordicTheme.spacing.space_2
            
            // Previous Track
            NordicButton {
                variant: NordicButton.Variant.Icon
                iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                onClicked: {
                    MediaService.previous()
                    root.previousClicked()
                }
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
            }
            
            // Play/Pause
            NordicButton {
                variant: NordicButton.Variant.Primary
                round: true
                iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                onClicked: {
                    MediaService.togglePlayPause()
                    root.playPauseClicked()
                }
                Layout.preferredHeight: 48
                Layout.preferredWidth: 48
            }
            
            // Next Track
            NordicButton {
                variant: NordicButton.Variant.Icon
                iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                onClicked: {
                    MediaService.next()
                    root.nextClicked()
                }
                Layout.preferredHeight: 40
                Layout.preferredWidth: 40
            }
        }
    }
    
    // Progress Bar (Bottom Line)
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        anchors.bottomMargin: 1 
        height: 2
        radius: 1
        color: NordicTheme.colors.bg.surface
        
        Rectangle {
            width: parent.width * root.progress
            height: parent.height
            radius: parent.radius
            color: NordicTheme.colors.accent.primary
        }
    }
}
