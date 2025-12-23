import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Route Preview & Start
NordicCard {
    id: root
    
    signal startClicked()
    signal cancelClicked()
    
    property string timeText: "--"
    property string distText: "--"
    property string destinationName: "Destination"
    
    // Sheet Props
    width: 360
    height: 600 // Increased for list
    variant: NordicCard.Variant.Elevated
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16
        
        // Header (Time/Dist)
        RowLayout {
            Layout.fillWidth: true
            NordicText { text: root.timeText; type: NordicText.Type.HeadlineLarge; color: NordicTheme.colors.semantic.success }
            NordicText { text: "(" + root.distText + ")"; type: NordicText.Type.BodyLarge; color: NordicTheme.colors.text.secondary }
            Item { Layout.fillWidth: true }
        }
        
        NordicText { 
            text: "To " + root.destinationName
            type: NordicText.Type.BodyMedium
            color: NordicTheme.colors.text.secondary
        }
        
        // Scrollable Directions List
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: NavigationService.routeSteps
            spacing: 12
            
            delegate: RowLayout {
                width: parent.width
                spacing: 12
                
                NordicIcon {
                    source: modelData.icon
                    size: NordicIcon.Size.Md
                    color: NordicTheme.colors.text.primary
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    
                    NordicText { 
                        text: modelData.instruction
                        type: NordicText.Type.BodyMedium
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    NordicText { 
                        text: modelData.distance + " m"
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.secondary
                    }
                }
            }
        }
        
        // Actions
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            NordicButton {
                text: "Cancel"
                variant: NordicButton.Variant.Secondary
                Layout.preferredWidth: 100
                onClicked: root.cancelClicked()
            }
            
            NordicButton {
                text: "Start Navigation"
                variant: NordicButton.Variant.Primary
                Layout.fillWidth: true
                onClicked: root.startClicked()
            }
        }
    }
}
