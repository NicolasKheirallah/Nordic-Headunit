import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import NordicHeadunit
import "../Components"
import "../Widgets"

Page {
    id: root
    
    // 1. Visual Depth: Radial Gradient Background
    background: Rectangle {
        color: NordicTheme.colors.bg.primary
        
        // Subtle radial glow from bottom-center
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 1.5
            height: parent.width * 1.5
            radius: width / 2
            
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: Qt.rgba(NordicTheme.colors.accent.primary.r, NordicTheme.colors.accent.primary.g, NordicTheme.colors.accent.primary.b, 0.05) }
                GradientStop { position: 1.0; color: "transparent" }
            }
            opacity: 0.5
        }
    }
    
    // Ignition Sequence Animation
    SequentialAnimation {
        id: ignitionAnimation
        running: true
        
        // Initial delay
        PauseAnimation { duration: 100 }
        
        // 1. Hero Zone (Map) Fade In
        ParallelAnimation {
            NumberAnimation { target: heroZone; property: "opacity"; from: 0; to: 1; duration: 800; easing.type: Easing.OutCubic }
            NumberAnimation { target: heroZone; property: "scale"; from: 0.95; to: 1; duration: 800; easing.type: Easing.OutCubic }
        }
        
        // 2. Widget Stack Slide In
        ParallelAnimation {
            NumberAnimation { target: stackZone; property: "opacity"; from: 0; to: 1; duration: 600; easing.type: Easing.OutQuad }
            NumberAnimation { target: stackZone; property: "Layout.preferredWidth"; from: 0; to: root.width * 0.35; duration: 600; easing.type: Easing.OutBack }
        }
    }

    // Main Cockpit Layout
    RowLayout {
        anchors.fill: parent
        anchors.margins: NordicTheme.spacing.space_4
        spacing: NordicTheme.spacing.space_4
        
        // ZONE 1: HERO (Navigation)
        Item {
            id: heroZone
            Layout.fillHeight: true
            Layout.fillWidth: true
            opacity: 0 // Start hidden for animation
            
            NavigationWidget {
                anchors.fill: parent
                // Mock properties for display if needed, or rely on internal service bindings
            }
        }
        
        // ZONE 2: WIDGET STACK
        Item {
            id: stackZone
            Layout.fillHeight: true
            Layout.preferredWidth: root.width * 0.35
            opacity: 0 // Start hidden for animation
            
            // Constrain WidgetGrid to single column stack
            WidgetGrid {
                id: widgetGrid
                anchors.fill: parent
                
                // Force specialized layout behavior for stack
                // NOTE: We might need to modify WidgetGrid to respect this parent constraint gracefully
                
                // Bindings propogation
                drivingMode: {
                   let appLayout = root.parent
                   while (appLayout && !appLayout.currentTab) appLayout = appLayout.parent
                   if (typeof window !== "undefined" && window.drivingMode !== undefined) return window.drivingMode
                   return false
                }
                
                onNavigateTo: (tabIndex) => {
                    let appLayout = root.parent
                    while (appLayout && !appLayout.currentTab) appLayout = appLayout.parent
                    if (appLayout) appLayout.currentTab = tabIndex
                }
                
                onShowToast: (message, toastType) => {
                    let win = root.parent
                    while (win && !win.showToast) win = win.parent
                    if (win && win.showToast) win.showToast(message, toastType)
                }
            }
        }
    }
}
