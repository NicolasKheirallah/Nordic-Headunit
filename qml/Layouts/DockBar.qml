import QtQuick
import QtQuick.Layouts
import NordicHeadunit

Rectangle {
    id: root
    color: NordicTheme.colors.bg.secondary
    
    property int currentIndex: 0
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: NordicTheme.spacing.space_2
        spacing: NordicTheme.spacing.space_4
        
        // Helper component for Dock Items
        component DockItem : Item {
            id: itemRoot
            property string label
            property string icon
            property bool active: index === root.currentIndex
            property int index
            
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            Rectangle {
                anchors.centerIn: parent
                width: 72
                height: 56
                radius: NordicTheme.shapes.radius_lg
                color: active ? NordicTheme.colors.bg.elevated : "transparent"
                border.color: active ? NordicTheme.colors.accent.primary : "transparent"
                border.width: active ? 1 : 0
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    
                    NordicIcon {
                        source: itemRoot.icon
                        size: NordicIcon.Size.MD
                        color: active ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.secondary
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    NordicText {
                        text: itemRoot.label
                        type: NordicText.Type.BodySmall
                        color: active ? NordicTheme.colors.text.primary : NordicTheme.colors.text.secondary
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.currentIndex = itemRoot.index
                }
            }
        }
        
        // 6 Navigation Items
        DockItem { index: 0; label: "Home"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/home.svg" }
        DockItem { index: 1; label: "Map"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg" }
        DockItem { index: 2; label: "Media"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg" }
        DockItem { index: 3; label: "Phone"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" }
        DockItem { index: 4; label: "Vehicle"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg" }
        DockItem { index: 5; label: "Settings"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg" }
    }
}
