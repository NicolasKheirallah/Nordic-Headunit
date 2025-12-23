import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

Item {
    id: root
    
    property bool open: false
    property var historyModel: null
    
    function toggle() { open = !open }
    
    // Dim Background (Click outside to close, transparent as requested)
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        MouseArea { anchors.fill: parent; enabled: root.open; onClicked: root.open = false }
    }
    
    // Panel (Slide from Top)
    Rectangle {
        id: panel
        width: 500
        height: parent.height - 40
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.margins: 20
        anchors.topMargin: root.open ? 20 : -height - 20
        
        color: Theme.surfaceAlt
        radius: Theme.radiusXl
        
        // PERFORMANCE: Only enable shadow effect when panel is open
        layer.enabled: root.open
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.shadowColor
            shadowVerticalOffset: 6
            shadowHorizontalOffset: 0
            shadowBlur: 1.0
            shadowOpacity: 0.2
        }
        
        Behavior on anchors.topMargin { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.spacingLg
            spacing: Theme.spacingSm
            
            // Header
            RowLayout {
                NordicText { 
                    text: "Notifications"
                    type: NordicText.Type.HeadlineMedium
                    Layout.fillWidth: true
                }
                NordicButton {
                    text: "Clear All"
                    variant: NordicButton.Variant.Tertiary
                    size: NordicButton.Size.Sm
                }
            }
            
            // List
            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: Theme.spacingXs
                
                model: (root.historyModel && root.historyModel.count > 0) ? root.historyModel : defaultModel
                
                ListModel {
                    id: defaultModel
                    ListElement { title: "No Notifications"; body: "You are all caught up."; icon: "home.svg"; type: 0 }
                }
                
                delegate: NordicCard {
                    id: notificationCard
                    width: ListView.view ? ListView.view.width : 400
                    height: 80
                    variant: NordicCard.Variant.Filled
                    
                    // Safe property resolution with fallbacks
                    property string dTitle: model.title !== undefined ? model.title : (model.message !== undefined ? "Notification" : "System Alert")
                    property string dBody: model.body !== undefined ? model.body : (model.message !== undefined ? model.message : "")
                    property string dIcon: model.icon !== undefined && model.icon !== "" ? model.icon : "car.svg"
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Theme.spacingSm
                        spacing: Theme.spacingSm
                        
                        NordicIcon {
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/" + notificationCard.dIcon
                            size: NordicIcon.Size.MD
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            NordicText { text: notificationCard.dTitle; type: NordicText.Type.TitleSmall }
                            NordicText { text: notificationCard.dBody; type: NordicText.Type.BodySmall; color: Theme.textSecondary }
                        }
                        
                         NordicButton {
                             variant: NordicButton.Variant.Icon
                             iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                             size: NordicButton.Size.Sm
                             onClicked: {
                                if (root.historyModel && index < root.historyModel.count) root.historyModel.remove(index)
                             }
                         }
                    }
                }
            }
        }
    }
}
