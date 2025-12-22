import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

// Top Guidance Banner (Tesla-style)
NordicCard {
    id: root
    
    // Properties
    property string maneuverIcon: "qrc:/qt/qml/NordicHeadunit/assets/icons/turn_right.svg"
    property string distance: "200 m"
    property string instruction: "Turn Right"
    property string roadName: "Main Street"
    property bool isActive: false // Animation control
    
    // Layout Props
    width: 420 // Wider for better road name visibility
    
    // Use unified NordicGlass system
    variant: NordicCard.Variant.Glass
    
    // Main Content
    ColumnLayout {
        width: parent.width
        spacing: 0
        
        // Green Instruction Block (Sleeker height)
        Rectangle {
            Layout.fillWidth: true
            height: 100 // Reduced from 120 for sleeker look
            
            gradient: Gradient {
                GradientStop { position: 0.0; color: NordicTheme.colors.semantic.success }
                GradientStop { position: 1.0; color: Qt.darker(NordicTheme.colors.semantic.success, 1.2) }
            }
            
            topLeftRadius: 16
            topRightRadius: 16
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                
                // Icon
                NordicIcon { 
                    source: root.maneuverIcon
                    size: NordicIcon.Size.XXL
                    color: "white"
                }
                
                // Text Column
                ColumnLayout {
                    spacing: 0
                    NordicText { 
                        text: root.distance
                        type: NordicText.Type.DisplayMedium
                        color: "white"
                    }
                    NordicText { 
                        text: root.instruction
                        type: NordicText.Type.TitleMedium
                        color: "white"
                        opacity: 0.95
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }
        }
        
        // Next Road Name & Speed Limit Block (Compact)
        Item {
            Layout.fillWidth: true
            height: 60
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                
                // Road Name
                NordicText {
                    Layout.fillWidth: true
                    text: root.roadName
                    type: NordicText.Type.HeadlineMedium
                    color: NordicTheme.colors.text.primary
                    elide: Text.ElideMiddle // Better handling of long names
                    horizontalAlignment: Text.AlignLeft // Align left looks better with limit on right
                }
                
                // Speed Limit Sign
                Rectangle {
                    width: 48; height: 48
                    radius: 24
                    color: "white"
                    border.color: "#D32F2F" // Red
                    border.width: 4
                    visible: NavigationService.speedLimit > 0
                    
                    NordicText {
                        anchors.centerIn: parent
                        text: NavigationService.speedLimit
                        type: NordicText.Type.TitleMedium
                        color: "black"
                        font.bold: true
                    }
                }
            }
        }
    }
}
