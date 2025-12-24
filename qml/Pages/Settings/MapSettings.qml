import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: "Navigation"
    
    ColumnLayout {
        width: parent.width
        spacing: 32 // Increased spacing for clear separation
        
        // ---------------------------------------------------------------------
        // Section 1: Map Appearance
        // ---------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16
            
            // Explicit Section Header
            NordicText {
                text: "Map Appearance"
                type: NordicText.Type.TitleMedium
                color: Theme.textSecondary
                Layout.leftMargin: 8
            }
            
            // Helper Component for Style Card
            component StyleCard : Item {
                property string label
                property int styleIndex
                property string previewColor
                property bool isSelected: SystemSettings.mapStyle === styleIndex
                
                Layout.fillWidth: true
                Layout.preferredHeight: 100 // Tighter height
                
                NordicCard {
                    anchors.fill: parent
                    variant: isSelected ? NordicCard.Variant.Outlined : NordicCard.Variant.Elevated
                    clickable: true
                    onClicked: SystemSettings.mapStyle = styleIndex
                    
                    // Highlight border if selected
                    border.color: isSelected ? Theme.accent : "transparent"
                    border.width: 2
                    
                    // Preview Rect
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        radius: NordicTheme.shapes.radius_md - 4
                        color: previewColor
                        
                        // Label Overlay
                        NordicText {
                            anchors.centerIn: parent
                            text: label
                            type: NordicText.Type.BodyLarge
                            // Determine text color based on preview brightness
                            color: (styleIndex === 1 || styleIndex === 2) ? "white" : "black"
                        }
                        
                        // Checkmark Badge
                        Rectangle {
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.margins: 8
                            width: 24; height: 24
                            radius: 12
                            color: Theme.accent
                            visible: isSelected
                            
                            NordicIcon {
                                anchors.centerIn: parent
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/check.svg"
                                size: NordicIcon.Size.XS
                                color: "white"
                            }
                        }
                    }
                }
            }
            
            // Layout: 2x2 Grid
            GridLayout {
                Layout.fillWidth: true
                columns: 2
                columnSpacing: 16
                rowSpacing: 16
                
                StyleCard { label: "Standard"; styleIndex: 0; previewColor: "#E0E0E0" }
                StyleCard { label: "Dark"; styleIndex: 1; previewColor: "#1A2028" }
                StyleCard { label: "Satellite"; styleIndex: 2; previewColor: "#0A2410" }
                StyleCard { label: "Light"; styleIndex: 3; previewColor: "#FFFFFF" }
            }
        }
        
        // ---------------------------------------------------------------------
        // Section 2: Guidance & Routing
        // ---------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8 // Toggles are list items, closer spacing
            
            NordicText {
                text: "Guidance & Routing"
                type: NordicText.Type.TitleMedium
                color: Theme.textSecondary
                Layout.leftMargin: 8
                Layout.bottomMargin: 8
            }
            
            // Toggles
            SettingsToggle {
                title: "Voice Guidance"
                subtitle: "Turn-by-turn spoken instructions"
                checked: SystemSettings.voiceGuidance
                onToggled: (checked) => SystemSettings.voiceGuidance = checked
            }
            
            SettingsToggle {
                title: "Real-time Traffic"
                subtitle: "Show congestion on map"
                checked: SystemSettings.realTimeTraffic
                onToggled: (checked) => SystemSettings.realTimeTraffic = checked
            }
            
            SettingsToggle {
                title: "Avoid Highways"
                checked: SystemSettings.avoidHighways
                onToggled: (checked) => SystemSettings.avoidHighways = checked
            }
            
            SettingsToggle {
                title: "Avoid Tolls"
                checked: SystemSettings.avoidTolls
                onToggled: (checked) => SystemSettings.avoidTolls = checked
            }
        }
        
        // ---------------------------------------------------------------------
        // Section 3: Display Preferences
        // ---------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            
            NordicText {
                text: "Display"
                type: NordicText.Type.TitleMedium
                color: Theme.textSecondary
                Layout.leftMargin: 8
                Layout.bottomMargin: 8
            }
            
            // Orientation Toggle (North Up vs Heading Up)
            SettingsToggle {
                id: orientationToggle
                title: "Heading Up"
                subtitle: "Rotate map to follow direction of travel"
                checked: SystemSettings.mapOrientation === 1 // 0=NorthUp, 1=HeadingUp
                onCheckedChanged: SystemSettings.mapOrientation = checked ? 1 : 0
            }
        }
        
        // ---------------------------------------------------------------------
        // Section 4: Cache Management
        // ---------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12
            
            NordicText {
                text: "Cache"
                type: NordicText.Type.TitleMedium
                color: Theme.textSecondary
                Layout.leftMargin: 8
                Layout.bottomMargin: 8
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 16
                
                NordicText {
                    text: "Map tiles are cached for offline use"
                    type: NordicText.Type.BodyMedium
                    color: Theme.textSecondary
                    Layout.fillWidth: true
                }
                
                NordicButton {
                    text: "Clear Cache"
                    variant: NordicButton.Variant.Secondary
                    size: NordicButton.Size.Sm
                    onClicked: {
                        // TODO: Call SystemSettings.clearMapCache() when implemented
                        console.log("Clear Map Cache requested")
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true } // Spacer
    }
}
