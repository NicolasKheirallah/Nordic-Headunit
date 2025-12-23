import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

Item {
    id: root
    
    // -------------------------------------------------------------------------
    // Automotive Responsive Properties
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // Automotive Responsive Properties (Powered by LayoutService)
    // -------------------------------------------------------------------------
    readonly property bool isLandscape: NordicTheme.layout.isLandscape
    readonly property bool isCompact: NordicTheme.layout.isCompact
    
    // Control size: responsive to both width and height
    readonly property real controlSize: {
        var baseSize = Math.max(36, Math.min(56, height / 12))
        // Use widthClass from Theme
        if (NordicTheme.layout.widthClass === 0) return baseSize * 0.9 // Compact
        if (NordicTheme.layout.widthClass === 2) return baseSize * 1.25 // Expanded
        return baseSize
    }
    
    // Art size: limit to max 35% of height in landscape, 30% in portrait/compact
    readonly property real artSize: {
        var maxHeight = isCompact ? height * 0.22 : (isLandscape ? height * 0.40 : height * 0.28)
        var maxWidth = isLandscape ? width * 0.25 : width * 0.45
        return Math.min(maxHeight, maxWidth, 240)
    }
    
    property bool showLyrics: false
    focus: true
    
    // -------------------------------------------------------------------------
    // Safe MediaService bindings with fallbacks
    // -------------------------------------------------------------------------
    readonly property bool isPlaying: MediaService?.playing ?? false
    readonly property bool shuffleEnabled: MediaService?.shuffleEnabled ?? false
    readonly property bool repeatEnabled: MediaService?.repeatEnabled ?? false
    readonly property string trackTitle: MediaService?.title ?? qsTr("No Track Playing")
    readonly property string trackArtist: MediaService?.artist ?? qsTr("Unknown Artist")
    readonly property real trackPosition: MediaService?.position ?? 0
    readonly property real trackDuration: MediaService?.duration ?? 1
    readonly property bool hasTrack: MediaService?.title !== undefined && MediaService?.title !== ""
    readonly property string currentSource: MediaService?.currentSource ?? "Bluetooth"
    
    // Loading and Error States (I1: Error & Edge Case Handling)
    readonly property bool isLoading: MediaService?.isLoading ?? false
    readonly property bool hasError: MediaService?.hasError ?? false
    readonly property string errorMessage: MediaService?.errorMessage ?? ""
    readonly property bool isConnected: MediaService?.isConnected ?? true
    readonly property bool isRadioMode: MediaService?.isRadioMode ?? false
    
    // -------------------------------------------------------------------------
    // Visualizer Configuration
    // -------------------------------------------------------------------------
    readonly property real vizBarWidthRatio: 0.04
    readonly property real vizBarHeightRatio: 0.15
    readonly property real vizAnimMinHeightRatio: 0.08
    readonly property real vizAnimMaxHeightRatio: 0.1
    readonly property real vizAnimStepRatio: 0.04
    readonly property int vizAnimBaseDuration: 300
    readonly property int vizAnimStepDuration: 80
    
    // Note: Background blur is handled by MediaPage parent - no duplicate needed
    
    // -------------------------------------------------------------------------
    // Main Layout - Responsive
    // -------------------------------------------------------------------------
    RowLayout {
        anchors.fill: parent
        anchors.margins: isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_4
        spacing: isCompact ? NordicTheme.spacing.space_3 : NordicTheme.spacing.space_6
        
        // LEFT: Player (Full width in Compact/Regular, 60% in Expanded)
        ColumnLayout {
            Layout.fillHeight: true
            Layout.preferredWidth: NordicTheme.layout.widthClass === 2 ? parent.width * 0.6 : parent.width
            Layout.fillWidth: NordicTheme.layout.widthClass !== 2
            spacing: isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_4
            
            // Album Art - Hero Element
            Item {
                id: artContainer
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: root.artSize
                Layout.preferredHeight: root.artSize
                
                // Breathing Animation (Scale)
                ScaleAnimator {
                    target: artContainer
                    from: 1.0
                    to: 1.05
                    duration: 4000
                    running: root.isPlaying
                    loops: Animation.Infinite
                    easing.type: Easing.CosineCurve
                }
                
                // Return to normal when paused
                Behavior on scale { NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
                
                // 1. Deep Shadow (Glow behind)
                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * 0.9
                    height: parent.height * 0.9
                    radius: parent.width / 2 // Circular glow
                    color: Theme.accent
                    opacity: root.isPlaying ? 0.6 : 0 // Glow only when playing
                    
                    Behavior on opacity { NumberAnimation { duration: 600 } }
                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blurMax: 64
                        blur: 1.0
                    }
                }

                // 2. The Art itself
                Rectangle {
                    id: albumArt
                    anchors.fill: parent
                    radius: NordicTheme.shapes.radius_xl
                    
                    // Gradient background
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.accent }
                        GradientStop { position: 0.5; color: Qt.darker(Theme.accent, 1.3) }
                        GradientStop { position: 1.0; color: Theme.accentSecondary }
                    }
                    
                    // Music icon (default state)
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                        size: NordicIcon.Size.XXL
                        color: "white"
                        opacity: root.isPlaying ? 0 : 0.9
                        visible: !root.isLoading && root.isConnected
                        Behavior on opacity { NumberAnimation { duration: 300 } }
                    }
                    
                    // Loading Indicator (I1: Clear loading state)
                    Item {
                        anchors.centerIn: parent
                        width: 48; height: 48
                        visible: root.isLoading
                        
                        Rectangle {
                            anchors.fill: parent
                            radius: 24
                            color: "transparent"
                            border.width: 3
                            border.color: "white"
                            opacity: 0.3
                        }
                        
                        Rectangle {
                            id: loadingSpinner
                            width: 48; height: 48
                            radius: 24
                            color: "transparent"
                            border.width: 3
                            border.color: "white"
                            
                            // Arc effect via clip
                            Rectangle {
                                width: 24; height: 48
                                color: root.gradient ? Theme.accent : "transparent"
                                anchors.right: parent.right
                            }
                            
                            RotationAnimator {
                                target: loadingSpinner
                                from: 0; to: 360
                                duration: 1000
                                running: root.isLoading
                                loops: Animation.Infinite
                            }
                        }
                    }
                    
                    // Disconnected State (I1: Source unavailable)
                    ColumnLayout {
                        anchors.centerIn: parent
                        visible: !root.isConnected
                        spacing: 8
                        
                        NordicIcon {
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
                            size: NordicIcon.Size.XL
                            color: "white"
                            opacity: 0.6
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        NordicText {
                            text: qsTr("Not Connected")
                            type: NordicText.Type.BodyMedium
                            color: "white"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                    
                    // Visualizer (existing)
                    Row {
                        anchors.centerIn: parent
                        spacing: NordicTheme.spacing.space_1
                        visible: root.isPlaying && !root.isRadioMode
                        Repeater {
                            model: 5
                            Rectangle {
                                width: Math.max(6, root.artSize * root.vizBarWidthRatio)
                                height: root.artSize * root.vizBarHeightRatio
                                radius: width / 2
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                                SequentialAnimation on height {
                                    loops: Animation.Infinite
                                    running: parent.visible // Only run if parent row is visible
                                    NumberAnimation { 
                                        to: root.artSize * root.vizAnimMaxHeightRatio + (index + 1) * root.artSize * root.vizAnimStepRatio
                                        duration: root.vizAnimBaseDuration + index * root.vizAnimStepDuration
                                        easing.type: Easing.InOutSine
                                    }
                                    NumberAnimation { 
                                        to: root.artSize * root.vizAnimMinHeightRatio + index * (root.artSize * 0.03)
                                        duration: (root.vizAnimBaseDuration + 100) + index * (root.vizAnimStepDuration - 20)
                                        easing.type: Easing.InOutSine
                                    }
                                }
                            }
                        }
                    }
                }
                
                // 3. Reflection (Fake)
                Rectangle {
                    anchors.top: albumArt.bottom
                    anchors.topMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.9
                    height: 20
                    radius: width/2
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.2) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                    opacity: 0.3
                    scale: 0.9
                }
            }
            
            // Track Info - Large, readable with Like Button
            RowLayout {
                Layout.fillWidth: true
                Layout.maximumWidth: isLandscape ? parent.width * 0.8 : parent.width * 0.9
                Layout.alignment: Qt.AlignHCenter
                spacing: NordicTheme.spacing.space_4
                
                // Text Info with Source Indicator
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: NordicTheme.spacing.space_1
                    
                    // Source Indicator Chip (C5: Source Awareness)
                    Rectangle {
                        Layout.preferredHeight: 24
                        Layout.preferredWidth: sourceRow.width + 16
                        radius: 12
                        color: Theme.surfaceAlt
                        
                        Row {
                            id: sourceRow
                            anchors.centerIn: parent
                            spacing: 6
                            
                            NordicIcon {
                                source: {
                                    switch(root.currentSource) {
                                        case "Bluetooth": return "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
                                        case "Radio": return "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg"
                                        case "USB": return "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                                        default: return "qrc:/qt/qml/NordicHeadunit/assets/icons/bluetooth.svg"
                                    }
                                }
                                size: NordicIcon.Size.SM
                                color: Theme.textSecondary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            
                            NordicText {
                                text: root.currentSource
                                type: NordicText.Type.Caption
                                color: Theme.textSecondary
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                    
                    NordicText {
                        text: root.trackTitle
                        type: NordicText.Type.DisplayMedium
                        color: Theme.textPrimary
                        Layout.fillWidth: true
                    }
                    
                    NordicText {
                        text: root.trackArtist
                        type: NordicText.Type.TitleMedium
                        color: Theme.accent
                        Layout.fillWidth: true
                    }
                }
                
                // Like Button
                NordicButton {
                    id: likeBtn
                    
                    // Direct binding updates automatically when MediaService emits relevant change signals
                    // But isLiked() is a function, not a property. 
                    // So we must listen to signal.
                    property bool likedState: false

                    Connections {
                        target: MediaService
                        function onTrackChanged() { likeBtn.likedState = MediaService.isLiked() }
                    }
                    Component.onCompleted: likedState = MediaService.isLiked()

                    variant: NordicButton.Variant.Icon
                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/heart.svg"
                    
                    color: likedState ? Theme.accent : "transparent"
                    
                    onClicked: {
                        if (MediaService) { 
                            MediaService.toggleLike()
                            // Optimistic update
                            likedState = !likedState 
                        }
                    }
                }
            }
            
            // Progress Bar (Hidden in Radio mode)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.maximumWidth: isLandscape ? parent.width * 0.8 : parent.width * 0.9
                Layout.alignment: Qt.AlignHCenter
                spacing: NordicTheme.spacing.space_1
                visible: !root.isRadioMode  // Hide for Radio
                
                // Progress Timer function moved to Theme.formatTime
                
                NordicSlider {
                    id: progressSlider
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    from: 0
                    to: root.trackDuration > 0 ? root.trackDuration : 1
                    value: root.trackPosition
                    onMoved: MediaService?.seek(value)
                    Accessible.name: qsTr("Track progress")
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    NordicText {
                        text: Theme.formatTime(root.trackPosition)
                        type: NordicText.Type.Caption
                        color: Theme.textTertiary
                    }
                    Item { Layout.fillWidth: true }
                    NordicText {
                        text: Theme.formatTime(root.trackDuration)
                        type: NordicText.Type.Caption
                        color: Theme.textTertiary
                    }
                }
            }
            
                // Media Controls
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: root.width * 0.9
                    spacing: isCompact ? 6 : NordicTheme.spacing.space_2
                
                    // Shuffle (Hidden in Radio mode)
                    MediaControlButton {
                        size: root.controlSize * 0.75
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/shuffle.svg"
                        iconSize: NordicIcon.Size.SM
                        isActive: root.shuffleEnabled
                        accessibleName: root.shuffleEnabled ? qsTr("Shuffle on") : qsTr("Shuffle off")
                        onClicked: if (MediaService) MediaService.shuffleEnabled = !MediaService.shuffleEnabled
                        visible: !root.isRadioMode
                    }
                    
                    // Previous
                    MediaControlButton {
                        size: root.controlSize
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/skip_previous.svg" 
                        iconSize: NordicIcon.Size.MD
                        accessibleName: qsTr("Previous track")
                        onClicked: MediaService?.previous()
                    }
                    
                    // Play/Pause - Primary action (C2: Must dominate visually)
                    MediaControlButton {
                        size: root.controlSize * 1.3
                        iconSource: root.isPlaying ? "qrc:/qt/qml/NordicHeadunit/assets/icons/pause.svg" : "qrc:/qt/qml/NordicHeadunit/assets/icons/play.svg"
                        iconSize: NordicIcon.Size.LG
                        isPrimary: true
                        accessibleName: root.isPlaying ? qsTr("Pause") : qsTr("Play")
                        onClicked: MediaService?.togglePlayPause()
                    }
                    
                    // Next
                    MediaControlButton {
                        size: root.controlSize
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/skip_next.svg"
                        iconSize: NordicIcon.Size.MD
                        accessibleName: qsTr("Next track")
                        onClicked: MediaService?.next()
                    }
                    
                    // Repeat (Hidden in Radio mode)
                    MediaControlButton {
                        size: root.controlSize * 0.75
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/repeat.svg"
                        iconSize: NordicIcon.Size.SM
                        isActive: root.repeatEnabled
                        accessibleName: root.repeatEnabled ? qsTr("Repeat on") : qsTr("Repeat off")
                        onClicked: if (MediaService) MediaService.repeatEnabled = !MediaService.repeatEnabled
                        visible: !root.isRadioMode
                    }
                    
                    // Queue Button (Visible in compact/portrait when Up Next is hidden)
                    MediaControlButton {
                        size: root.controlSize * 0.75
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/list.svg"
                        iconSize: NordicIcon.Size.SM
                        accessibleName: qsTr("Open Queue")
                        onClicked: queueDrawer.open()
                        visible: !root.isRadioMode && (!isLandscape || NordicTheme.layout.widthClass !== 2)
                    }
                }
            
            Item { Layout.fillHeight: true }
        }
        
        // RIGHT: Up Next (Expanded Landscape only)
        ColumnLayout {
            visible: isLandscape && NordicTheme.layout.widthClass === 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.minimumWidth: 350
            spacing: NordicTheme.spacing.space_3
            
            RowLayout {
                Layout.fillWidth: true
                spacing: NordicTheme.spacing.space_2
                
                Rectangle { width: 3; height: 20; color: Theme.accent; radius: 1 }
                NordicText { text: qsTr("Up Next"); type: NordicText.Type.TitleMedium }
                Item { Layout.fillWidth: true }
            }
            
            ListView {
                id: upNextList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: NordicTheme.spacing.space_2
                model: MediaService.playlistModel
                
                delegate: Rectangle {
                    width: upNextList.width
                    height: 64
                    radius: NordicTheme.shapes.radius_md
                    color: index === 0 ? Theme.surfaceAlt :
                           trackMouse.containsMouse ? NordicTheme.colors.bg.surface : "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: NordicTheme.spacing.space_2
                        spacing: NordicTheme.spacing.space_3
                        
                        Rectangle {
                            width: 44
                            height: 44
                            radius: NordicTheme.shapes.radius_md
                            color: NordicTheme.colors.bg.surface
                            
                            NordicIcon {
                                anchors.centerIn: parent
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                                size: NordicIcon.Size.SM
                                color: index === 0 ? Theme.accent : Theme.textTertiary
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            NordicText {
                                text: model.title ?? "Unknown"
                                type: NordicText.Type.BodyMedium
                                color: index === 0 ? Theme.accent : Theme.textPrimary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            
                            NordicText {
                                text: model.artist ?? ""
                                type: NordicText.Type.Caption
                                color: Theme.textTertiary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                        
                        NordicText {
                            text: Theme.formatTime(model.duration ?? 0)
                            type: NordicText.Type.Caption
                            color: Theme.textTertiary
                        }
                    }
                    
                    MouseArea {
                        id: trackMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: MediaService.playTrack(index)
                    }
                }
            }
        }

    // -------------------------------------------------------------------------
    // Queue Overlay (Drawer)
    // -------------------------------------------------------------------------
    Drawer {
        id: queueDrawer
        width: parent.width
        height: parent.height * 0.7
        edge: Qt.BottomEdge
        interactive: true
        
        background: Rectangle {
            color: Theme.surfaceAlt
            radius: NordicTheme.shapes.radius_xl
            
            // Glass effect
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blurMax: 32
                blur: 1.0
            }
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_4
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                NordicText {
                    text: qsTr("Up Next")
                    type: NordicText.Type.HeadlineSmall
                    Layout.fillWidth: true
                }
                NordicButton {
                    text: qsTr("Close")
                    variant: NordicButton.Variant.Secondary
                    size: NordicButton.Size.Sm
                    onClicked: queueDrawer.close()
                }
            }
            
            // Queue List
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: MediaService.playlistModel
                spacing: Theme.spacingXs
                
                delegate: NordicListItem {
                    width: ListView.view.width
                    text: model.title ?? ("Track " + (index + 1))
                    secondaryText: model.artist ?? "Unknown Artist"
                    
                    leading: Component {
                        Rectangle {
                            width: 44; height: 44
                            radius: Theme.radiusSm
                            color: Theme.surfaceAlt
                            
                            NordicIcon {
                                anchors.centerIn: parent
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                                size: NordicIcon.Size.SM
                                color: Theme.accent
                            }
                        }
                    }
                }
            }
        }
    }
}
}
