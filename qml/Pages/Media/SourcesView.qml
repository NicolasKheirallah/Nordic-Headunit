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
        Text {
            text: "Audio Sources"
            font.pixelSize: 20
            font.weight: Font.Bold
            font.family: "Helvetica"
            color: NordicTheme.colors.text.primary
        }
        
        Text {
            text: "Tap to switch source and resume playback"
            font.pixelSize: 14
            font.family: "Helvetica"
            color: NordicTheme.colors.text.tertiary
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
                color: modelData.active ? NordicTheme.colors.accent.primary : 
                       sourceMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20
                    
                    // Source Icon
                    Rectangle {
                        width: 48; height: 48
                        radius: 12
                        color: modelData.active ? Qt.rgba(1,1,1,0.2) : NordicTheme.colors.bg.elevated
                        
                        NordicIcon {
                            anchors.centerIn: parent
                            source: modelData.icon
                            size: NordicIcon.Size.MD
                            color: modelData.active ? "white" : NordicTheme.colors.text.primary
                        }
                    }
                    
                    // Source Info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        Text {
                            text: modelData.name
                            font.pixelSize: 18
                            font.weight: Font.Medium
                            font.family: "Helvetica"
                            color: modelData.active ? "white" : NordicTheme.colors.text.primary
                        }
                        
                        Text {
                            text: modelData.lastPlayed
                            font.pixelSize: 14
                            font.family: "Helvetica"
                            color: modelData.active ? Qt.rgba(1,1,1,0.7) : NordicTheme.colors.text.tertiary
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
                        color: NordicTheme.colors.text.tertiary
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
