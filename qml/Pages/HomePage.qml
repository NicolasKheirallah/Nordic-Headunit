import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import NordicHeadunit
import "../Components"
import "../Components/Maps"
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
            
            NordicCard {
                anchors.fill: parent
                variant: NordicCard.Variant.Filled
                padding: 0 // Full bleed
                
                // Live Map Background
                MapSurface {
                    id: homeMap
                    anchors.fill: parent
                    zoomLevel: 12.5
                    tilt: 45.0
                    bearing: 20.0
                    // Disable interactions for "Ambient" mode
                    enabled: false 
                }
                
                // Interaction Layer (Go to Full Map)
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                         // Traverse up to find MainLayout
                         var appLayout = root.parent
                         while (appLayout && !appLayout.currentTab) appLayout = appLayout.parent
                         if (appLayout) appLayout.currentTab = 1 // Switch to Maps
                    }
                }
                
                // Hero Text Overlay
                ColumnLayout {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.margins: 24
                    spacing: 4
                    
                    NordicText { 
                        text: "Explore" 
                        type: NordicText.Type.HeadlineLarge 
                        color: NordicTheme.colors.text.inverse
                        style: Text.Outline; styleColor: "black"
                    }
                    NordicText { 
                        text: "Tap to navigate" 
                        type: NordicText.Type.BodyMedium 
                        color: NordicTheme.colors.text.inverse 
                        opacity: 0.8
                        style: Text.Outline; styleColor: "black"
                    }
                }
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
