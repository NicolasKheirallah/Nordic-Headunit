import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Navigation Widget - Large hero card for map navigation
Item {
    id: root
    
    signal clicked()
    
    // Safe NavigationService bindings with fallbacks
    readonly property bool isNavigating: NavigationService?.isNavigating ?? false
    readonly property string distanceToDestination: NavigationService?.distanceToDestination ?? ""
    
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
            spacing: NordicTheme.spacing.space_4
            
            NordicIcon { 
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg"
                size: NordicIcon.Size.XXL
                color: Theme.accent
                Layout.alignment: Qt.AlignHCenter
            }
            NordicText { 
                text: qsTr("Navigation")
                type: NordicText.Type.HeadlineMedium
                color: Theme.accent
                Layout.alignment: Qt.AlignHCenter
            }
            NordicText { 
                text: root.isNavigating ? root.distanceToDestination : qsTr("Tap to navigate")
                type: NordicText.Type.BodyMedium
                color: NordicTheme.colors.text.secondary
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
