import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

Item {
    id: root
    
    // Properties
    property alias currentItem: contentLoader.sourceComponent
    
    default property alias content: contentLoader.sourceComponent
    
    // Signals
    signal categorySelected(int index)

    // Layout State
    readonly property bool isExpanded: !NordicTheme.layout.isCompact
    
    // API to show content (handles both modes)
    function showPage(component) {
        if (isExpanded) {
            contentLoader.sourceComponent = component
        } else {
            stackView.push(component)
        }
    }

    // -------------------------------------------------------------------------
    // Mode 1: Split View (Expanded)
    // -------------------------------------------------------------------------
    RowLayout {
        id: splitView
        anchors.fill: parent
        spacing: 0
        visible: isExpanded
        
        // Left Sidebar
        SettingsSidebar {
            id: splitSidebar
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width * 0.28
            Layout.maximumWidth: 350
            Layout.minimumWidth: 280
            
            onCategorySelected: (index) => root.categorySelected(index)
        }
        
        // Divider
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 1
            color: NordicTheme.colors.border.muted
            opacity: 0.5
        }
        
        // Right Content Area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            Rectangle {
                anchors.fill: parent
                color: NordicTheme.colors.bg.primary
                opacity: 0.8
            }

            Loader {
                id: contentLoader
                anchors.fill: parent
                anchors.margins: NordicTheme.spacing.space_5
                
                Behavior on opacity { NumberAnimation { duration: 200 } }
                onSourceComponentChanged: { opacity = 0; opacityAnimation.start() }
                
                NumberAnimation {
                    id: opacityAnimation
                    target: contentLoader; property: "opacity"; to: 1.0; duration: 300; easing.type: Easing.OutQuad
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // Mode 2: Stack View (Compact / Regular)
    // -------------------------------------------------------------------------
    StackView {
        id: stackView
        anchors.fill: parent
        visible: !isExpanded
        
        initialItem: SettingsSidebar {
            id: stackSidebar
            // Full width in stack mode
            width: parent ? parent.width : 0
            height: parent ? parent.height : 0
            
            onCategorySelected: (index) => root.categorySelected(index)
        }
        
        // Custom Push/Pop Transitions
        pushEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: stackView.width
                to: 0
                duration: 250
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 250
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: -stackView.width * 0.3
                duration: 250
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 250
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: -stackView.width * 0.3
                to: 0
                duration: 250
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 250
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: stackView.width
                duration: 250
                easing.type: Easing.OutCubic
            }
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 250
            }
        }
    }
}
