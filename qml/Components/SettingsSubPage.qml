import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Flickable {
    id: root
    
    property string title: ""
    default property alias content: contentArea.data
    property bool showBackButton: NordicTheme.layout.isCompact
    
    signal backClicked()
    
    contentHeight: mainColumn.height + 40
    contentWidth: width
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    
    ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
    
    ColumnLayout {
        id: mainColumn
        width: parent.width
        spacing: Theme.spacingXs
        
        // Back header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"
            Layout.topMargin: 10
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.spacingSm
                anchors.rightMargin: Theme.spacingSm
                spacing: Theme.spacingSm
                
                NordicButton {
                    id: backButton
                    visible: root.showBackButton
                    variant: NordicButton.Variant.Secondary
                    size: NordicButton.Size.Sm
                    text: qsTr("Back")
                    onClicked: {
                        root.backClicked() // Signal for external handling
                        var stack = root.StackView.view
                        if (stack) {
                            stack.pop()
                        }
                    }
                }
                
                NordicText {
                    text: root.title
                    type: NordicText.Type.HeadlineSmall
                    color: Theme.textPrimary
                    Layout.fillWidth: true
                }
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.borderMuted
            Layout.bottomMargin: Theme.spacingSm
        }
        
        // Content area - children go here
        ColumnLayout {
            id: contentArea
            Layout.fillWidth: true
            Layout.leftMargin: Theme.spacingSm
            Layout.rightMargin: Theme.spacingSm
            spacing: Theme.spacingXs
        }
    }
}
