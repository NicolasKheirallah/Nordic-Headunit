import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

GridView {
    id: grid
    cellWidth: width / Math.floor(width / 160)
    cellHeight: 180
    clip: true
    model: PhoneService.favorites
    
    delegate: Item {
        width: grid.cellWidth
        height: grid.cellHeight
        
        NordicCard {
            anchors.fill: parent
            anchors.margins: Theme.spacingSm
            variant: NordicCard.Variant.Elevated
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: Theme.spacingSm
                
                Rectangle {
                    width: 60
                    height: 60
                    radius: 30
                    color: Theme.accent
                    Layout.alignment: Qt.AlignHCenter
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: (modelData.name && modelData.name.length > 0) ? modelData.name.charAt(0) : "?"
                        type: NordicText.Type.DisplaySmall
                        color: Theme.textInverse
                    }
                }
                
                NordicText {
                    text: modelData.name
                    type: NordicText.Type.TitleMedium
                    Layout.alignment: Qt.AlignHCenter
                }
                
                NordicText {
                    text: PhoneService.formatNumber(modelData.number)
                    type: NordicText.Type.BodySmall
                    color: Theme.textSecondary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: PhoneService.dial(modelData.number)
            }
        }
    }
}
