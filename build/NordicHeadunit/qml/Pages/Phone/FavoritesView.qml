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
            anchors.margins: NordicTheme.spacing.space_4
            variant: NordicCard.Variant.Elevated
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: NordicTheme.spacing.space_4
                
                Rectangle {
                    width: 60
                    height: 60
                    radius: 30
                    color: NordicTheme.colors.accent.primary
                    Layout.alignment: Qt.AlignHCenter
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: model.name.charAt(0)
                        type: NordicText.Type.DisplaySmall
                        color: NordicTheme.colors.text.primary
                    }
                }
                
                NordicText {
                    text: model.name
                    type: NordicText.Type.TitleMedium
                    Layout.alignment: Qt.AlignHCenter
                }
                
                NordicText {
                    text: model.number
                    type: NordicText.Type.BodySmall
                    color: NordicTheme.colors.text.secondary
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: PhoneService.dial(model.number)
            }
        }
    }
}
