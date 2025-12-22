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
    
    // Sheet Props
    width: 360
    height: 200
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
            text: "Via Fastest Route"
            type: NordicText.Type.BodyMedium
            color: NordicTheme.colors.text.secondary
        }
        
        Item { Layout.fillHeight: true } // Spacer
        
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
