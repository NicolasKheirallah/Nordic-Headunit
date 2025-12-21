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
    readonly property var radioStations: MediaService?.radioStations ?? []
    readonly property var library: MediaService?.library ?? []
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        
        // Recently Played Section (Combined Music + Radio)
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            
            NordicText {
                text: qsTr("Recently Played")
                type: NordicText.Type.TitleMedium
                color: NordicTheme.colors.text.secondary
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
                    color: recentMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12
                        
                        // Icon based on type
                        Rectangle {
                            width: 56; height: 56
                            radius: 10
                            color: modelData.type === "station" ? NordicTheme.colors.semantic.info : NordicTheme.colors.accent.primary
                            
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
                            
                            Text {
                                text: modelData.title
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                font.family: "Helvetica"
                                color: NordicTheme.colors.text.primary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                            
                            Text {
                                text: modelData.subtitle
                                font.pixelSize: 12
                                font.family: "Helvetica"
                                color: NordicTheme.colors.text.tertiary
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                            
                            // Type badge
                            Rectangle {
                                width: typeBadge.width + 8; height: 16
                                radius: 4
                                color: modelData.type === "station" ? Qt.rgba(NordicTheme.colors.semantic.info.r, NordicTheme.colors.semantic.info.g, NordicTheme.colors.semantic.info.b, 0.2) 
                                     : Qt.rgba(NordicTheme.colors.accent.primary.r, NordicTheme.colors.accent.primary.g, NordicTheme.colors.accent.primary.b, 0.2)
                                
                                Text {
                                    id: typeBadge
                                    anchors.centerIn: parent
                                    text: modelData.type === "station" ? "Radio" : "Music"
                                    font.pixelSize: 9
                                    font.weight: Font.Medium
                                    font.family: "Helvetica"
                                    color: modelData.type === "station" ? NordicTheme.colors.semantic.info : NordicTheme.colors.accent.primary
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
                    color: NordicTheme.colors.text.secondary
                    Layout.fillWidth: true
                }
                
                Rectangle {
                    width: seeAllText.width + 16
                    height: 24
                    radius: 12
                    color: seeAllMouse.pressed ? NordicTheme.colors.bg.elevated : "transparent"
                    
                    Text {
                        id: seeAllText
                        anchors.centerIn: parent
                        text: qsTr("See All")
                        font.pixelSize: 13
                        font.family: "Helvetica"
                        color: NordicTheme.colors.accent.primary
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
                
                model: root.radioStations
                
                delegate: Rectangle {
                    width: 140
                    height: 64
                    radius: 10
                    color: modelData.active ? NordicTheme.colors.accent.primary :
                           stationMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.frequency + " " + modelData.band
                            font.pixelSize: 16
                            font.weight: Font.Medium
                            font.family: "Helvetica"
                            color: modelData.active ? "white" : NordicTheme.colors.text.primary
                        }
                        
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData.name
                            font.pixelSize: 12
                            font.family: "Helvetica"
                            color: modelData.active ? Qt.rgba(1,1,1,0.7) : NordicTheme.colors.text.tertiary
                        }
                    }
                    
                    MouseArea {
                        id: stationMouse
                        anchors.fill: parent
                        onClicked: MediaService.tuneRadioByIndex(modelData.index)
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
                color: NordicTheme.colors.text.secondary
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
                        color: libMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                        
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
                                
                                Text {
                                    text: modelData.name
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                    font.family: "Helvetica"
                                    color: NordicTheme.colors.text.primary
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                
                                Text {
                                    text: modelData.count
                                    font.pixelSize: 11
                                    font.family: "Helvetica"
                                    color: NordicTheme.colors.text.tertiary
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
