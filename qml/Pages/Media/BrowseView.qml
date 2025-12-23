import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Browse View - Unified Recents with Music and Radio
// No empty states, always shows content
Item {
    id: root
    
    signal requestSourceTab()
    
    // Safe property access
    readonly property var recentItems: MediaService?.recentItems ?? []
    // radioStations removed (using radioModel)
    readonly property var library: MediaService?.libraryCategories ?? []
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        
        // Search Bar (New Feature)
        NordicTextField {
            Layout.fillWidth: true
            placeholderText: qsTr("Search Library...")
            onTextChanged: {
                if (MediaService && MediaService.library) {
                    MediaService.library.search(text)
                    // Logic to swap view to search results if text > 0
                    root.state = text.length > 0 ? "SEARCH" : "BROWSE"
                }
            }
        }

        // Search Results View (Conditionally visible)
        ListView {
            visible: root.state === "SEARCH"
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: MediaService.library.searchResultsModel
            clip: true
            delegate: NordicListItem {
                text: model.title
                secondaryText: model.artist
                onClicked: {
                     // Need way to play from search result index... 
                     // For now, limitation: Search just filters
                     console.log("Playing from search result pending implementation")
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
}
