import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Sources View - System-Level Audio Source Switching
// Flat list, one tap switches and resumes
Item {
    id: root
    
    // Safe properties
    readonly property var sources: MediaService?.sources ?? []
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16
        
        // Header
        NordicText {
            text: "Audio Sources"
            type: NordicText.Type.TitleLarge
            color: Theme.textPrimary
        }
        
        NordicText {
            text: "Tap to switch source and resume playback"
            type: NordicText.Type.BodyMedium
            color: Theme.textTertiary
        }
        
        // Source List
        ListView {
            id: sourceList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            clip: true
            
            model: root.sources
            
            delegate: Rectangle {
                width: sourceList.width
                height: 80
                radius: 16
                color: modelData.active ? Theme.accent : 
                       sourceMouse.pressed ? Theme.surfaceAlt : NordicTheme.colors.bg.surface
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    // Source Icon
                    Rectangle {
                        width: 48; height: 48
                        radius: 12
                        color: modelData.active ? Qt.rgba(1,1,1,0.2) : Theme.surfaceAlt
                        
                        NordicIcon {
                            anchors.centerIn: parent
                            source: modelData.icon
                            size: NordicIcon.Size.MD
                            color: modelData.active ? "white" : Theme.textPrimary
                        }
                    }
                    
                    // Source Info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        NordicText {
                            text: modelData.name
                            type: NordicText.Type.TitleMedium
                            color: modelData.active ? "white" : Theme.textPrimary
                        }
                        
                        NordicText {
                            text: modelData.lastPlayed
                            type: NordicText.Type.BodyMedium
                            color: modelData.active ? Qt.rgba(1,1,1,0.7) : Theme.textTertiary
                        }
                    }
                    
                    // Active Indicator or Play Icon
                    Rectangle {
                        width: 12; height: 12
                        radius: 6
                        color: "white"
                        visible: modelData.active
                    }
                    
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/play_arrow.svg"
                        size: NordicIcon.Size.SM
                        color: Theme.textTertiary
                        visible: !modelData.active
                    }
                }
                
                MouseArea {
                    id: sourceMouse
                    anchors.fill: parent
                    onClicked: MediaService.setSource(modelData.name)
                }
            }
        }
    }
}
