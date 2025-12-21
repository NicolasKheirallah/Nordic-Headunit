import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Quick Action Widget - Single action button (Call, Media, Vehicle, Settings)
Item {
    id: root
    
    property string icon: "settings"
    property string label: "Action"
    property bool isWide: false
    
    signal clicked()
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        clickable: true
        onClicked: root.clicked()
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_2
            
            NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/" + root.icon + ".svg"
                size: root.isWide ? NordicIcon.Size.LG : NordicIcon.Size.MD
                color: NordicTheme.colors.text.primary
                Layout.alignment: Qt.AlignHCenter
            }
            NordicText {
                text: root.label
                type: root.isWide ? NordicText.Type.TitleSmall : NordicText.Type.BodySmall
                color: NordicTheme.colors.text.primary
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
