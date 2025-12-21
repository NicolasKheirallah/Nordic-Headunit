import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Favorite Contacts Widget - Quick call favorites (BMW style)
Item {
    id: root
    
    // Favorite contacts (would come from PhoneService)
    property var favorites: [
        { name: "Home", initial: "H", color: "#4CAF50" },
        { name: "Work", initial: "W", color: "#2196F3" },
        { name: "Mom", initial: "M", color: "#E91E63" },
        { name: "Dad", initial: "D", color: "#FF9800" }
    ]
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_3
            spacing: NordicTheme.spacing.space_2
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg"
                    size: NordicIcon.Size.SM
                    color: NordicTheme.colors.text.secondary
                }
                
                NordicText {
                    text: qsTr("Favorites")
                    type: NordicText.Type.TitleSmall
                    color: NordicTheme.colors.text.primary
                }
            }
            
            // Favorites grid
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: NordicTheme.spacing.space_2
                columnSpacing: NordicTheme.spacing.space_2
                
                Repeater {
                    model: root.favorites
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        radius: NordicTheme.shapes.radius_sm
                        color: contactMa.containsMouse ? NordicTheme.colors.bg.elevated : "transparent"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8
                            
                            // Avatar
                            Rectangle {
                                width: 32; height: 32
                                radius: 16
                                color: modelData.color
                                
                                NordicText {
                                    anchors.centerIn: parent
                                    text: modelData.initial
                                    type: NordicText.Type.TitleSmall
                                    color: "white"
                                }
                            }
                            
                            NordicText {
                                text: modelData.name
                                type: NordicText.Type.BodySmall
                                color: NordicTheme.colors.text.primary
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                        
                        MouseArea {
                            id: contactMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (typeof PhoneService !== "undefined") {
                                    PhoneService.callFavorite(index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
