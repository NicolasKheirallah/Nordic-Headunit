import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Floating Action Buttons (Zoom, Traffic, Recenter, Mute)
ColumnLayout {
    id: root
    
    signal zoomIn()
    signal zoomOut()
    signal toggleTraffic()
    signal toggleRange() // EV
    signal toggleMute()  // Voice Guidance
    signal recenter()
    
    property bool showTraffic: false
    property bool showRange: false
    property bool isGuidanceMuted: false
    property bool isNavigating: false // Show mute only when navigating
    
    spacing: 12
    
    // Recenter (Focus on User Location)
    NordicButton {
        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/focus.svg"
        variant: NordicButton.Variant.Glass
        size: NordicButton.Size.Md
        round: true
        onClicked: root.recenter()
    }
    
    // Mute Guidance (Only visible while navigating)
    NordicButton {
        visible: root.isNavigating
        iconSource: root.isGuidanceMuted 
            ? "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_off.svg"
            : "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_up.svg"
        variant: root.isGuidanceMuted ? NordicButton.Variant.Primary : NordicButton.Variant.Glass
        size: NordicButton.Size.Md
        round: true
        onClicked: root.toggleMute()
    }
    
    // Traffic Toggle
    NordicButton {
        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
        variant: root.showTraffic ? NordicButton.Variant.Primary : NordicButton.Variant.Glass
        size: NordicButton.Size.Md
        round: true
        onClicked: root.toggleTraffic()
    }
    
    // EV Range Toggle
    NordicButton {
        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/battery.svg"
        variant: root.showRange ? NordicButton.Variant.Primary : NordicButton.Variant.Glass
        size: NordicButton.Size.Md
        round: true
        onClicked: root.toggleRange()
    }
    
    // Zoom In
    NordicButton {
        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/search.svg" // Using search as magnify placeholder
        text: "+"
        variant: NordicButton.Variant.Glass
        size: NordicButton.Size.Md
        round: true
        onClicked: root.zoomIn()
    }
    
    // Zoom Out
    NordicButton {
        text: "-"
        variant: NordicButton.Variant.Glass
        size: NordicButton.Size.Md
        round: true
        onClicked: root.zoomOut()
    }
}
