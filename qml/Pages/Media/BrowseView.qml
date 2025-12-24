import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Browse View - Unified Recents with Music and Radio
// No empty states, always shows content
Item {
    id: root
    
    signal requestSourceTab()
    
    // Accessibility
    readonly property bool reducedMotion: SystemSettings.reducedMotion
    
    // Search state
    readonly property bool isSearching: MediaService?.library?.isSearching ?? false
    readonly property bool hasSearchResults: MediaService?.library?.hasSearchResults ?? false
    readonly property int searchResultsCount: MediaService?.library?.searchResultsCount ?? 0
    
    // Safe property access
    readonly property var recentItems: MediaService?.recentItems ?? []
    readonly property var library: MediaService?.libraryCategories ?? []
    
    // Source/Library management
    property string currentSource: "Local"
    readonly property var availableSources: [
        { id: "local", name: qsTr("Local Music"), icon: "music.svg", path: "" },
        { id: "usb", name: qsTr("USB Drive"), icon: "heart.svg", path: "/Volumes" },
        { id: "network", name: qsTr("Network"), icon: "wifi.svg", path: "" }
    ]
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        
        // Header: Search + Source Selector
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            
            NordicTextField {
                id: searchField
                Layout.fillWidth: true
                placeholderText: qsTr("Search Library...")
                onTextChanged: {
                    searchDebounce.restart()
                }
            }
            
            // Clear button
            Rectangle {
                width: 40; height: 40
                radius: 20
                visible: searchField.text.length > 0
                color: clearMouse.pressed ? Theme.surfaceAlt : Theme.surfaceAlt
                
                NordicIcon {
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/close.svg"
                    size: NordicIcon.Size.SM
                    color: Theme.textSecondary
                }
                
                MouseArea {
                    id: clearMouse
                    anchors.fill: parent
                    onClicked: {
                        searchField.text = ""
                        if (MediaService && MediaService.library) {
                            MediaService.library.clearSearch()
                        }
                        root.state = ""
                    }
                }
            }
            
            // Source Selector Button
            Rectangle {
                Layout.preferredWidth: sourceRow.width + 24
                Layout.preferredHeight: 40
                radius: 20
                color: sourceMouse.pressed ? Qt.darker(Theme.surfaceAlt, 1.1) : Theme.surfaceAlt
                
                Row {
                    id: sourceRow
                    anchors.centerIn: parent
                    spacing: 6
                    
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                        size: NordicIcon.Size.SM
                        color: Theme.accent
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    NordicText {
                        text: root.currentSource
                        type: NordicText.Type.BodySmall
                        color: Theme.textPrimary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/chevron_down.svg"
                        size: NordicIcon.Size.XS
                        color: Theme.textTertiary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    id: sourceMouse
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sourceDrawer.open()
                }
            }
        }
        
        // Search debounce timer
        Timer {
            id: searchDebounce
            interval: 150
            onTriggered: {
                if (MediaService && MediaService.library && searchField.text.length > 0) {
                    MediaService.library.search(searchField.text)
                    root.state = "SEARCH"
                } else {
                    root.state = ""
                }
            }
        }

        // Search Results View with loading and empty states
        Item {
            visible: root.state === "SEARCH"
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Loading State
            ColumnLayout {
                anchors.centerIn: parent
                visible: root.isSearching
                spacing: 12
                
                BusyIndicator {
                    Layout.alignment: Qt.AlignHCenter
                    running: root.isSearching && !root.reducedMotion
                }
                
                NordicText {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Searching...")
                    type: NordicText.Type.BodyMedium
                    color: Theme.textSecondary
                }
            }
            
            // Empty State
            ColumnLayout {
                anchors.centerIn: parent
                visible: !root.isSearching && !root.hasSearchResults && searchField.text.length > 0
                spacing: 12
                
                NordicIcon {
                    Layout.alignment: Qt.AlignHCenter
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/search.svg"
                    size: NordicIcon.Size.XXL
                    color: Theme.textTertiary
                }
                
                NordicText {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("No results for \"%1\"").arg(searchField.text)
                    type: NordicText.Type.TitleMedium
                    color: Theme.textSecondary
                }
                
                NordicButton {
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Clear Search")
                    variant: NordicButton.Variant.Secondary
                    onClicked: searchField.text = ""
                }
            }
            
            // Results List
            ListView {
                anchors.fill: parent
                visible: !root.isSearching && root.hasSearchResults
                model: MediaService.library ? MediaService.library.searchResultsModel : null
                clip: true
                spacing: 4
                
                header: NordicText {
                    width: parent.width
                    text: qsTr("%1 results").arg(root.searchResultsCount)
                    type: NordicText.Type.Caption
                    color: Theme.textTertiary
                    bottomPadding: 8
                }
                
                delegate: NordicListItem {
                    width: ListView.view ? ListView.view.width : implicitWidth
                    text: model.title ?? "Unknown"
                    secondaryText: model.artist ?? ""
                    onClicked: {
                        if (MediaService && MediaService.library) {
                            MediaService.library.playFromSearchResult(index)
                            searchField.text = ""
                            root.state = ""
                        }
                    }
                }
            }
        }

        // Recently Played Section (Combined Music + Radio)
        ColumnLayout {
            visible: root.state !== "SEARCH"
            Layout.fillWidth: true
            spacing: 8
            
            NordicText {
                text: qsTr("Recently Played")
                type: NordicText.Type.TitleMedium
                color: Theme.textSecondary
            }
            
            ListView {
                id: recentsList
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                orientation: ListView.Horizontal
                spacing: 12
                clip: true
                
                model: root.recentItems
                
                delegate: Rectangle {
                    width: 200
                    height: 88
                    radius: 12
                    color: recentMouse.pressed ? Theme.surfaceAlt : NordicTheme.colors.bg.surface
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12
                        
                        // Icon based on type
                        Rectangle {
                            width: 56; height: 56
                            radius: 10
                            color: modelData.type === "station" ? Theme.info : Theme.accent
                            
                            NordicIcon {
                                anchors.centerIn: parent
                                source: modelData.icon
                                size: NordicIcon.Size.MD
                                color: "white"
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            NordicText {
                                text: modelData.title
                                type: NordicText.Type.BodyMedium
                                color: Theme.textPrimary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                            
                            NordicText {
                                text: modelData.subtitle
                                type: NordicText.Type.Caption
                                color: Theme.textTertiary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                            
                            // Type badge
                            Rectangle {
                                width: typeBadge.width + 8; height: 16
                                radius: 4
                                color: modelData.type === "station" ? Qt.rgba(Theme.info.r, Theme.info.g, Theme.info.b, 0.2) 
                                     : Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.2)
                                
                                NordicText {
                                    id: typeBadge
                                    anchors.centerIn: parent
                                    text: modelData.type === "station" ? "Radio" : "Music"
                                    type: NordicText.Type.Caption
                                    font.weight: Font.Medium
                                    color: modelData.type === "station" ? Theme.info : Theme.accent
                                }
                            }
                        }
                    }
                    
                    MouseArea {
                        id: recentMouse
                        anchors.fill: parent
                        onClicked: MediaService.playFromRecent(index)
                    }
                }
            }
        }
        
        // Radio Stations Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            
            RowLayout {
                Layout.fillWidth: true
                
                NordicText {
                    text: qsTr("Radio Stations")
                    type: NordicText.Type.TitleMedium
                    color: Theme.textSecondary
                    Layout.fillWidth: true
                }
                
                Rectangle {
                    width: seeAllText.width + 16
                    height: 24
                    radius: 12
                    color: seeAllMouse.pressed ? Theme.surfaceAlt : "transparent"
                    
                    NordicText {
                        id: seeAllText
                        anchors.centerIn: parent
                        text: qsTr("See All")
                        type: NordicText.Type.BodySmall
                        color: Theme.accent
                    }
                    
                    MouseArea {
                        id: seeAllMouse
                        anchors.fill: parent
                        onClicked: root.requestSourceTab()
                    }
                }
            }
            
            ListView {
                id: stationsList
                Layout.fillWidth: true
                Layout.preferredHeight: 72
                orientation: ListView.Horizontal
                spacing: 12
                clip: true
                
                model: MediaService.radioModel
                
                delegate: Rectangle {
                    width: 140
                    height: 64
                    radius: 10
                    color: model.active ? Theme.accent :
                           stationMouse.pressed ? Theme.surfaceAlt : NordicTheme.colors.bg.surface
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        NordicText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: model.frequency + " " + model.band
                            type: NordicText.Type.TitleMedium
                            color: model.active ? "white" : Theme.textPrimary
                        }
                        
                        NordicText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: model.name
                            type: NordicText.Type.Caption
                            color: model.active ? Qt.rgba(1,1,1,0.7) : Theme.textTertiary
                        }
                    }
                    
                    MouseArea {
                        id: stationMouse
                        anchors.fill: parent
                        onClicked: MediaService.tuneRadioByIndex(index)
                    }
                }
            }
        }
        
        // Playlists / Library Section
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 8
            
            NordicText {
                text: qsTr("Your Music")
                type: NordicText.Type.TitleMedium
                color: Theme.textSecondary
            }
            
            GridView {
                id: libraryGrid
                Layout.fillWidth: true
                Layout.fillHeight: true
                cellWidth: width / Math.max(2, Math.floor(width / 180))
                cellHeight: 80
                clip: true
                
                model: root.library
                
                delegate: Item {
                    width: libraryGrid.cellWidth
                    height: libraryGrid.cellHeight
                    
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 6
                        radius: 10
                        color: libMouse.pressed ? Theme.surfaceAlt : NordicTheme.colors.bg.surface
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 10
                            
                            Rectangle {
                                width: 48; height: 48
                                radius: 8
                                color: modelData.color
                                
                                NordicIcon {
                                    anchors.centerIn: parent
                                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                                    size: NordicIcon.Size.SM
                                    color: "white"
                                }
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                
                                NordicText {
                                    text: modelData.name
                                    type: NordicText.Type.BodyMedium
                                    color: Theme.textPrimary
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                
                                NordicText {
                                    text: modelData.count
                                    type: NordicText.Type.Caption
                                    color: Theme.textTertiary
                                }
                            }
                        }
                        
                        MouseArea {
                            id: libMouse
                            anchors.fill: parent
                            onClicked: MediaService.play()
                        }
                    }
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // Source Selector Drawer (File Manager)
    // -------------------------------------------------------------------------
    Drawer {
        id: sourceDrawer
        width: Math.min(parent.width * 0.9, 480)
        height: parent.height
        edge: Qt.RightEdge
        
        background: Rectangle {
            color: Theme.surfaceAlt
            radius: NordicTheme.shapes.radius_xl
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_4
            spacing: NordicTheme.spacing.space_4
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                
                NordicText {
                    text: qsTr("Select Source")
                    type: NordicText.Type.HeadlineSmall
                    Layout.fillWidth: true
                }
                
                NordicButton {
                    variant: NordicButton.Variant.Icon
                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/close.svg"
                    onClicked: sourceDrawer.close()
                }
            }
            
            // Source List
            ListView {
                id: sourceList
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                clip: true
                spacing: 8
                
                model: root.availableSources
                
                delegate: Rectangle {
                    width: sourceList.width
                    height: 64
                    radius: NordicTheme.shapes.radius_md
                    color: modelData.name === root.currentSource 
                        ? Theme.accent 
                        : sourceDelegateMouse.containsMouse ? Theme.surfaceAlt : "transparent"
                    border.width: modelData.name === root.currentSource ? 0 : 1
                    border.color: Theme.surfaceAlt
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12
                        
                        Rectangle {
                            width: 40; height: 40
                            radius: 20
                            color: modelData.name === root.currentSource ? "white" : Theme.accent
                            opacity: modelData.name === root.currentSource ? 0.2 : 0.1
                            
                            NordicIcon {
                                anchors.centerIn: parent
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/" + modelData.icon
                                size: NordicIcon.Size.MD
                                color: modelData.name === root.currentSource ? "white" : Theme.accent
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            NordicText {
                                text: modelData.name
                                type: NordicText.Type.BodyMedium
                                color: modelData.name === root.currentSource ? "white" : Theme.textPrimary
                            }
                            
                            NordicText {
                                text: modelData.id === "usb" ? qsTr("External storage") : 
                                      modelData.id === "network" ? qsTr("Stream from network") :
                                      qsTr("Device storage")
                                type: NordicText.Type.Caption
                                color: modelData.name === root.currentSource ? Qt.rgba(1,1,1,0.7) : Theme.textTertiary
                            }
                        }
                        
                        NordicIcon {
                            visible: modelData.name === root.currentSource
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/check.svg"
                            size: NordicIcon.Size.SM
                            color: "white"
                        }
                    }
                    
                    MouseArea {
                        id: sourceDelegateMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            root.currentSource = modelData.name
                            // TODO: MediaLibrary.setSourcePath not implemented
                            console.log("Source selected:", modelData.path)
                            sourceDrawer.close()
                        }
                    }
                }
            }
            
            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: NordicTheme.colors.border.muted
            }
            
            // Browse Folders Section
            RowLayout {
                Layout.fillWidth: true
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                    size: NordicIcon.Size.SM
                    color: Theme.textSecondary
                }
                
                NordicText {
                    text: qsTr("Library Folders")
                    type: NordicText.Type.TitleSmall
                    color: Theme.textSecondary
                    Layout.fillWidth: true
                }
                
                NordicButton {
                    text: qsTr("Add Folder")
                    variant: NordicButton.Variant.Secondary
                    size: NordicButton.Size.Sm
                    onClicked: {
                        // TODO: MediaLibrary.addMusicFolder not implemented
                        console.log("Add folder clicked")
                    }
                }
            }
            
            // Folder List
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 4
                
                model: MediaService?.library?.musicFolders ?? []
                
                delegate: Rectangle {
                    width: parent.width
                    height: 48
                    radius: NordicTheme.shapes.radius_sm
                    color: folderMouse.containsMouse ? Theme.surfaceAlt : "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8
                        
                        NordicIcon {
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                            size: NordicIcon.Size.SM
                            color: Theme.textSecondary
                        }
                        
                        NordicText {
                            text: modelData.split("/").pop() || modelData
                            type: NordicText.Type.BodySmall
                            color: Theme.textPrimary
                            elide: Text.ElideMiddle
                            Layout.fillWidth: true
                        }
                        
                        NordicButton {
                            variant: NordicButton.Variant.Icon
                            iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/close.svg"
                            onClicked: {
                                if (MediaService && MediaService.library) {
                                    MediaService.library.removeMusicFolder(modelData)
                                }
                            }
                        }
                    }
                    
                    MouseArea {
                        id: folderMouse
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
                
                // Empty state
                ColumnLayout {
                    anchors.centerIn: parent
                    visible: parent.count === 0
                    spacing: 8
                    
                    NordicIcon {
                        Layout.alignment: Qt.AlignHCenter
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
                        size: NordicIcon.Size.XL
                        color: Theme.textTertiary
                    }
                    
                    NordicText {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("No folders added")
                        type: NordicText.Type.BodyMedium
                        color: Theme.textSecondary
                    }
                    
                    NordicText {
                        Layout.alignment: Qt.AlignHCenter
                        text: qsTr("Add folders to scan for music")
                        type: NordicText.Type.Caption
                        color: Theme.textTertiary
                    }
                }
            }
            
            // Rescan Button
            NordicButton {
                Layout.fillWidth: true
                text: qsTr("Rescan Library")
                variant: NordicButton.Variant.Primary
                onClicked: {
                    if (MediaService && MediaService.library) {
                        MediaService.library.scan()
                    }
                }
            }
        }
    }
}
