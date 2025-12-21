import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Now Playing Widget - Fully Responsive Refactor
// Adapts to any resolution by prioritizing Text compression (elision)
// while preserving Art and Controls visibility.

Item {
    id: root
    
    signal clicked()
    
    // Size detection
    // Compact: Minimalist view (Play button only, small text)
    readonly property bool isCompact: width < 220 || height < 120
    // Large: Full Player view (Progress bar, timestamps)
    readonly property bool isLarge: width >= 300 && height >= 150
    
    // Media Bindings
    readonly property bool isPlaying: MediaService?.isPlaying ?? false
    readonly property real position: MediaService?.position ?? 0
    readonly property real duration: MediaService?.duration ?? 1
    readonly property string currentTrack: MediaService?.currentTrack ?? "Blinding Lights"
    readonly property string currentArtist: MediaService?.currentArtist ?? "The Weeknd"
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_3
            spacing: NordicTheme.spacing.space_2
            
            // Top Row: Art + Info + Controls
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true // Fill remaining height if Progress Bar is hidden
                spacing: NordicTheme.spacing.space_3
                
                // 1. Album Art (Fixed/Ratio)
                Rectangle {
                    id: albumArt
                    Layout.preferredHeight: root.isCompact ? 40 : 56
                    Layout.preferredWidth: Layout.preferredHeight
                    Layout.minimumWidth: Layout.preferredHeight // Prevent shrinking
                    
                    radius: NordicTheme.shapes.radius_md
                    color: NordicTheme.colors.accent.primary
                    
                    // Pulse Animation
                    SequentialAnimation on scale {
                        running: root.isPlaying
                        loops: Animation.Infinite
                        NumberAnimation { to: 1.05; duration: 600; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                    }
                    
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                        color: NordicTheme.colors.text.inverse
                        size: root.isCompact ? NordicIcon.Size.SM : NordicIcon.Size.MD
                    }
                }
                
                // 2. Track Info (Flexible)
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 2
                    
                    // Center vertically
                    Item { Layout.fillHeight: true }
                    
                    NordicText {
                        text: root.currentTrack
                        type: root.isCompact ? NordicText.Type.BodySmall : NordicText.Type.TitleSmall
                        color: NordicTheme.colors.text.primary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    
                    NordicText {
                        text: root.currentArtist
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.secondary
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        visible: !root.isCompact // Hide artist in very compact mode
                    }
                    
                    Item { Layout.fillHeight: true }
                }
                
                // 3. Controls (Fixed/Content Adaptive)
                RowLayout {
                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 2
                    
                    // Skip Previous
                    NordicButton {
                        visible: !root.isCompact
                        variant: NordicButton.Variant.Tertiary
                        size: NordicButton.Size.Sm
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/skip_previous.svg"
                        onClicked: MediaService?.previous()
                    }
                    
                    // Play/Pause
                    NordicButton {
                        variant: NordicButton.Variant.Primary
                        size: NordicButton.Size.Sm
                        iconSource: root.isPlaying ? "qrc:/qt/qml/NordicHeadunit/assets/icons/pause.svg" : "qrc:/qt/qml/NordicHeadunit/assets/icons/play.svg"
                        onClicked: MediaService?.togglePlayPause()
                    }
                    
                    // Skip Next
                    NordicButton {
                        visible: !root.isCompact
                        variant: NordicButton.Variant.Tertiary
                        size: NordicButton.Size.Sm
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/skip_next.svg"
                        onClicked: MediaService?.next()
                    }
                }
            }
            
            // Bottom Row: Progress Bar (Only in Large Mode)
            ColumnLayout {
                visible: root.isLarge
                Layout.fillWidth: true
                spacing: 4
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 4
                    radius: 2
                    color: NordicTheme.colors.bg.elevated
                    
                    Rectangle {
                        width: parent.width * (root.position / Math.max(1, root.duration))
                        height: parent.height
                        radius: 2
                        color: NordicTheme.colors.accent.primary
                        
                        Behavior on width { NumberAnimation { duration: 200 } }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    NordicText {
                        text: formatTime(root.position)
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                    }
                    Item { Layout.fillWidth: true }
                    NordicText {
                        text: formatTime(root.duration)
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.tertiary
                    }
                }
            }
        }
    }
    
    function formatTime(ms) {
        var secs = Math.floor(ms / 1000)
        var mins = Math.floor(secs / 60)
        secs = secs % 60
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }
}
