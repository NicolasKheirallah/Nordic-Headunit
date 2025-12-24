import QtQuick
import QtQuick.Layouts
import NordicHeadunit
import "../Components"

// Navigation Widget - Large hero card for map navigation
Item {
    id: root
    
    signal clicked()
    
    // Safe NavigationService bindings with fallbacks
    readonly property bool isNavigating: NavigationService?.isNavigating ?? false
    readonly property string distanceToDestination: NavigationService?.distanceToDestination ?? ""
    
    // Grid Spans (Injected by DraggableWidget)
    property int spanX: 1
    property int spanY: 1
    
    // Layout Classes
    readonly property bool isWide: spanX >= 2
    readonly property bool isLarge: spanX >= 2 && spanY >= 2
    
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        clickable: true
        onClicked: root.clicked()
        
        Rectangle {
            anchors.fill: parent
            radius: NordicTheme.shapes.radius_xl
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: NordicTheme.colors.bg.secondary }
                GradientStop { position: 1.0; color: NordicTheme.colors.bg.elevated }
            }
        }
        
        Rectangle {
            anchors.fill: parent
            radius: NordicTheme.shapes.radius_xl
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.15) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: Math.min(root.height * 0.05, NordicTheme.spacing.space_4)
            
            // Scalable icon
            Item {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: Math.min(root.width * 0.4, root.height * 0.4)
                Layout.preferredHeight: Layout.preferredWidth
                
                NordicIcon { 
                    anchors.centerIn: parent
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg"
                    width: parent.width
                    height: parent.height
                    color: Theme.accent
                }
            }
            
            NordicText { 
                text: qsTr("Navigation")
                type: isLarge ? NordicText.Type.HeadlineMedium : NordicText.Type.TitleMedium
                color: Theme.accent
                Layout.alignment: Qt.AlignHCenter
            }
            
            NordicText { 
                text: root.isNavigating ? root.distanceToDestination : qsTr("Tap to navigate")
                type: NordicText.Type.BodyMedium
                color: NordicTheme.colors.text.secondary
                Layout.alignment: Qt.AlignHCenter
                visible: root.height > 150 // Still need pixels for absolute space checks until we have spanHeight logic fully mapped
            }
            
            // "Go Home" Quick Action (Principal Feature Gap: Empty space usage)
            NordicButton {
                visible: root.isLarge && !root.isNavigating
                text: "Go Home"
                variant: NordicButton.Variant.Tertiary
                size: NordicButton.Size.Sm
                Layout.alignment: Qt.AlignHCenter
                onClicked: NavigationService.startNavigation("Home") // Mock
            }
        }
    }
}
