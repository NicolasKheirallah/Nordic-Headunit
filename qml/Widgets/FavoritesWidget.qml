import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Favorite Contacts Widget - Quick call favorites (BMW style)
Item {
    id: root
    
    // Responsive size detection
    readonly property bool isCompact: width < 180 || height < 130
    readonly property bool isLarge: width >= 300 && height >= 200
    
    // Favorite contacts (would come from PhoneService)
    property var favorites: PhoneService?.favorites ?? [
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
            anchors.margins: root.isCompact ? NordicTheme.spacing.space_2 : NordicTheme.spacing.space_3
            spacing: root.isCompact ? NordicTheme.spacing.space_1 : NordicTheme.spacing.space_2
            
            // Header - hide in compact mode
            RowLayout {
                Layout.fillWidth: true
                visible: !root.isCompact
                
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
            
            // Favorites grid - adaptive columns based on size
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: root.width < 240 ? 2 : (root.isLarge ? 4 : 2)
                rowSpacing: root.isCompact ? 4 : NordicTheme.spacing.space_2
                columnSpacing: root.isCompact ? 4 : NordicTheme.spacing.space_2
                
                Repeater {
                    model: root.favorites
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: root.isCompact ? 36 : 44
                        radius: NordicTheme.shapes.radius_sm
                        color: contactMa.containsMouse ? NordicTheme.colors.bg.elevated : "transparent"
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: root.isCompact ? 4 : 6
                            spacing: root.isCompact ? 4 : 6
                            
                            // Avatar - scales with size
                            Rectangle {
                                width: root.isCompact ? 24 : 28
                                height: width
                                radius: width / 2
                                color: modelData.color
                                
                                NordicText {
                                    anchors.centerIn: parent
                                    text: modelData.initial
                                    type: root.isCompact ? NordicText.Type.Caption : NordicText.Type.BodySmall
                                    color: "white"
                                    font.bold: true
                                }
                            }
                            
                            // Name - hide in very compact mode
                            NordicText {
                                visible: root.width > 160
                                text: modelData.name
                                type: root.isCompact ? NordicText.Type.Caption : NordicText.Type.BodySmall
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
