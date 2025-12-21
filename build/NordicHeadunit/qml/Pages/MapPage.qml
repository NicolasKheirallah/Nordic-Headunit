import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Effects
import NordicHeadunit

Page {
    id: root
    
    // -------------------------------------------------------------------------
    // 1. Map Canvas (The Hero)
    // -------------------------------------------------------------------------
    // Responsive Layout props
    readonly property bool isExpanded: NordicTheme.layout.widthClass === 2
    readonly property bool isCompact: NordicTheme.layout.isCompact
    
    // Map Interaction State
    property real zoomLevel: 1.0
    property bool showTraffic: false
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // Map Container (Takes full width unless Expanded)
        Rectangle {
            id: mapContainer
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "#18181F" // Premium Dark Map BG
            clip: true
            
            // Transform for Zoom/Pan
            // Note: moved scale to content item to avoid scaling the container
            // Actually, applying scale to the whole map container rectangle works if it's clipped
            
            Item {
                id: mapContent
                anchors.fill: parent
                scale: root.zoomLevel
                Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                
                // Mock Map Data - Faint Roads
                Item {
                    anchors.fill: parent
                    opacity: 0.2
        
                    
                    // Random "Roads"
                    Repeater {
                        model: 8
                        Rectangle {
                            x: Math.random() * parent.width
                            width: Math.random() > 0.5 ? 4 : 8
                            height: parent.height
                            color: "#3F3F46"
                        }
                    }
                    Repeater {
                        model: 8
                        Rectangle {
                            y: Math.random() * parent.height
                            height: Math.random() > 0.5 ? 4 : 8
                            width: parent.width
                            color: "#3F3F46"
                        }
                    }
                }
                
                // Active Route Line
                // Simulated nicely curved path for demo
                Shape {
                    anchors.fill: parent
                    visible: isNavigating
                    opacity: 0.8
                    
                    ShapePath {
                        strokeWidth: 12
                        strokeColor: NordicTheme.colors.accent.primary
                        fillColor: "transparent"
                        strokeStyle: ShapePath.SolidLine
                        capStyle: ShapePath.RoundCap
                        joinStyle: ShapePath.RoundJoin
                        
                        startX: parent.width * 0.5
                        startY: parent.height * 0.8
                        
                        PathQuad { x: parent.width * 0.5; y: parent.height * 0.4; controlX: parent.width * 0.4; controlY: parent.height * 0.6 }
                        PathQuad { x: parent.width * 0.8; y: parent.height * 0.1; controlX: parent.width * 0.6; controlY: parent.height * 0.2 }
                    }
                    
                    // Traffic Layer (Epic 6) - Overlay on route
                    ShapePath {
                        strokeColor: showTraffic ? "#EF4444" : "transparent" // Heavy Traffic Red or Hidden
                        fillColor: "transparent"
                        strokeStyle: ShapePath.SolidLine
                        capStyle: ShapePath.FlatCap
                        
                        startX: parent.width * 0.5
                        startY: parent.height * 0.8
                        PathLine { x: parent.width * 0.5; y: parent.height * 0.6 } // Jam at start
                    }
                    
                    // Glow Effect for Route
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        shadowEnabled: true
                        shadowColor: NordicTheme.colors.accent.primary
                        shadowBlur: 16
                        shadowOpacity: 0.6
                    }
                }
                
                // Vehicle Cursor with Headlights
                Item {
                    id: vehicleCursor
                    x: parent.width * 0.5 - width/2
                    y: parent.height * 0.7 - height/2
                    width: 48
                    height: 48
                    z: 2
                    
                    // Headlights (Beam effect)
                    Item {
                        width: 200; height: 300
                        anchors.bottom: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        rotation: 0
                        opacity: 0.3
                        
                        Rectangle {
                             width: 40; height: 160
                             x: 40
                             gradient: Gradient {
                                 GradientStop { position: 0.0; color: "transparent" }
                                 GradientStop { position: 1.0; color: "#FFFFFF" }
                             }
                             transform: Rotation { origin.x: 20; origin.y: 160; angle: -15 }
                        }
                         Rectangle {
                             width: 40; height: 160
                             x: 120
                             gradient: Gradient {
                                 GradientStop { position: 0.0; color: "transparent" }
                                 GradientStop { position: 1.0; color: "#FFFFFF" }
                             }
                             transform: Rotation { origin.x: 20; origin.y: 160; angle: 15 }
                        }
                    }
                    
                    // Car Icon
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                        size: NordicIcon.Size.XL
                        color: NordicTheme.colors.accent.primary
                        
                        // Pulse Animation
                        SequentialAnimation on scale {
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 1.1; duration: 2000; easing.type: Easing.InOutSine }
                            NumberAnimation { from: 1.1; to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                        }
                    }
                }
                }
            
            // -------------------------------------------------------------------------
            // 2. Floating UI Layer (Inside Map Container)
            // -------------------------------------------------------------------------
            
            // Top Left: Search Pill
            NordicCard {
                id: searchPill
                visible: navState === MapPage.NavState.Idle || navState === MapPage.NavState.Searching || navState === MapPage.NavState.Preview
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: NordicTheme.spacing.space_4
                width: isCompact ? 300 : 380
                height: 56
                variant: NordicCard.Variant.Elevated

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 6
                    spacing: 12
                    
                    NordicIcon { 
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/search.svg" 
                        size: NordicIcon.Size.MD
                        color: NordicTheme.colors.text.secondary
                    }
                    
                    NordicText {
                        text: root.destination !== "" ? root.destination : qsTr("Where to?")
                        color: NordicTheme.colors.text.primary 
                        type: NordicText.Type.BodyLarge
                        Layout.fillWidth: true
                    }
                    
                    // Clear / Back Button
                    NordicButton {
                        visible: root.destination !== ""
                        variant: NordicButton.Variant.Tertiary
                        text: "✕"
                        size: NordicButton.Size.Sm
                        round: true
                        onClicked: { destination = ""; navState = MapPage.NavState.Idle }
                    }
                    
                    // Voice Button
                    NordicButton {
                        visible: root.destination === ""
                        variant: NordicButton.Variant.Tertiary
                        iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/mic.svg"
                        size: NordicButton.Size.Sm
                        round: true
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    z: -1
                    onClicked: root.showSearch()
                }
            }
            
            // Search Results Dropdown
            NordicCard {
                visible: navState === MapPage.NavState.Searching
                anchors.top: searchPill.bottom
                anchors.left: searchPill.left
                anchors.right: searchPill.right
                anchors.topMargin: 8
                height: 300
                variant: NordicCard.Variant.Elevated
                
                ListView {
                    anchors.fill: parent
                    clip: true
                    model: ListModel {
                        ListElement { name: "Home"; address: "123 Nordic Way" }
                        ListElement { name: "Office"; address: "Tech Hub Plaza" }
                        ListElement { name: "Airport"; address: "Terminal 1" }
                        ListElement { name: "Gym"; address: "Fitness Blvd" }
                    }
                    delegate: NordicListItem {
                        width: parent.width
                        text: model.name
                        secondaryText: model.address
                        leading: NordicIcon { source: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg" }
                        onClicked: root.previewRoute(model)
                    }
                }
            }
            
            // Route Preview Card
            NordicCard {
                visible: navState === MapPage.NavState.Preview
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: NordicTheme.spacing.space_4
                anchors.bottomMargin: 24
                width: isCompact ? 300 : 360
                variant: NordicCard.Variant.Elevated
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    RowLayout {
                        Layout.fillWidth: true
                        NordicText { text: selectedRoute?.time || ""; type: NordicText.Type.HeadlineLarge; color: NordicTheme.colors.semantic.success }
                        NordicText { text: "(" + (selectedRoute?.dist || "") + ")"; type: NordicText.Type.BodyLarge; color: NordicTheme.colors.text.secondary }
                        Item { Layout.fillWidth: true }
                    }
                    
                    NordicText { 
                        text: "Via " + (selectedRoute?.via || "Fastest Route")
                        type: NordicText.Type.BodyMedium
                        color: NordicTheme.colors.text.secondary
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        NordicButton {
                            text: "Cancel"
                            variant: NordicButton.Variant.Secondary
                            Layout.preferredWidth: 100
                            onClicked: root.navState = MapPage.NavState.Idle
                        }
                        
                        NordicButton {
                            text: "Start Navigation"
                            variant: NordicButton.Variant.Primary
                            Layout.fillWidth: true
                            onClicked: root.startNavigation()
                        }
                    }
                }
            }
            
            // Top Left: Guidance Panel
            NordicCard {
                id: guidancePanel
                visible: isNavigating
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: NordicTheme.spacing.space_4
                width: isCompact ? 300 : 360
                variant: NordicCard.Variant.Filled
                
                ColumnLayout {
                    width: parent.width
                    spacing: 0
                    
                    // Instruction
                    Rectangle {
                        Layout.fillWidth: true
                        height: 120
                        color: NordicTheme.colors.semantic.success
                        topLeftRadius: 16
                        topRightRadius: 16
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 20
                            
                            NordicIcon { 
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/turn_right.svg"
                                size: NordicIcon.Size.XXL
                                color: "white"
                            }
                            
                            ColumnLayout {
                                spacing: 0
                                NordicText { 
                                    text: "200 m"
                                    type: NordicText.Type.DisplayMedium
                                    color: "white"
                                }
                                NordicText { 
                                    text: "Turn Right"
                                    type: NordicText.Type.TitleMedium
                                    color: "white"
                                    opacity: 0.9
                                }
                            }
                        }
                    }
                    
                    // Street Name
                    Item {
                        Layout.fillWidth: true
                        height: 70
                        
                        NordicText {
                            anchors.centerIn: parent
                            text: "Main Street"
                            type: NordicText.Type.HeadlineMedium
                            color: NordicTheme.colors.text.primary
                        }
                    }
                }
            }
            
            // Bottom Left: Trip Info
            NordicCard {
                visible: isNavigating && !isExpanded
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: NordicTheme.spacing.space_4
                anchors.bottomMargin: 24
                width: 240
                variant: NordicCard.Variant.Glass
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    RowLayout {
                        spacing: 4
                        NordicText { text: "15 min"; type: NordicText.Type.HeadlineSmall; color: NordicTheme.colors.semantic.success }
                        NordicText { text: "• 12:45 ETA"; type: NordicText.Type.BodyMedium; color: NordicTheme.colors.text.secondary }
                    }
                    
                    NordicButton {
                        Layout.fillWidth: true
                        text: "End Trip"
                        variant: NordicButton.Variant.Danger
                        size: NordicButton.Size.Sm
                        onClicked: root.cancelNavigation()
                    }
                }
            }
            
            // Bottom Right: Map Controls
            ColumnLayout {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: NordicTheme.spacing.space_4
                anchors.bottomMargin: 24
                spacing: 12
                
                NordicButton {
                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_up.svg"
                    variant: NordicButton.Variant.Glass
                    size: NordicButton.Size.Md
                    round: true
                }
                
                NordicButton {
                    iconSource: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg"
                    variant: showTraffic ? NordicButton.Variant.Primary : NordicButton.Variant.Glass
                    size: NordicButton.Size.Md
                    round: true
                    onClicked: showTraffic = !showTraffic
                }
                
                NordicButton {
                    text: "+"
                    variant: NordicButton.Variant.Glass
                    size: NordicButton.Size.Md
                    round: true
                    onClicked: zoomLevel = Math.min(zoomLevel + 0.5, 3.0)
                }
                
                NordicButton {
                    text: "-"
                    variant: NordicButton.Variant.Glass
                    size: NordicButton.Size.Md
                    round: true
                    onClicked: zoomLevel = Math.max(zoomLevel - 0.5, 0.5)
                }
            }
        } // End mapContainer
        
        // Responsive Side Panel (Expanded Mode)
        // Shows Route Overview, ETA Details, or Search Results permanently
        Rectangle {
            visible: isExpanded
            Layout.fillHeight: true
            Layout.preferredWidth: 400
            color: NordicTheme.colors.bg.elevated
            
            // Side Panel Content
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: NordicTheme.spacing.space_4
                spacing: NordicTheme.spacing.space_4
                
                NordicText {
                    text: isNavigating ? qsTr("Route Overview") : qsTr("Explore")
                    type: NordicText.Type.HeadlineMedium
                }
                
                // Dynamic Content based on state
                Loader {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    sourceComponent: isNavigating ? routeStatsComponent : searchSuggestionsComponent
                    
                    Component {
                        id: routeStatsComponent
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: NordicTheme.spacing.space_4
                            
                            // ETA Big
                            NordicCard {
                                Layout.fillWidth: true
                                height: 120
                                variant: NordicCard.Variant.Filled
                                
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    NordicText { text: "15 min"; type: NordicText.Type.DisplayMedium; color: NordicTheme.colors.semantic.success }
                                    NordicText { text: "12:45 ETA • 12 km"; type: NordicText.Type.BodyLarge; color: NordicTheme.colors.text.secondary }
                                }
                            }
                            
                            // Next Maneuver List (Mock)
                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: 5
                                delegate: NordicListItem {
                                    width: ListView.view.width
                                    text: "Turn Right on Main St"
                                    secondaryText: "2 km"
                                    leading: NordicIcon { source: "qrc:/qt/qml/NordicHeadunit/assets/icons/turn_right.svg" }
                                }
                            }
                        }
                    }
                    
                    Component {
                        id: searchSuggestionsComponent
                        ListView {
                            anchors.fill: parent
                            clip: true
                            model: ListModel {
                                ListElement { name: "Home"; address: "123 Nordic Way" }
                                ListElement { name: "Office"; address: "Tech Hub Plaza" }
                                ListElement { name: "Coffee"; address: "Main St" }
                            }
                            delegate: NordicListItem {
                                width: ListView.view.width
                                text: model.name
                                secondaryText: model.address
                                leading: NordicIcon { source: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg" }
                            }
                        }
                    }
                }
            }
        }
    } // End RowLayout
    
    // Logic
    // Epic 1.2: Defined Navigation UI State Model
    enum NavState {
        Idle,       // Map browsing, Search visible
        Searching,  // Search Dropdown open
        Preview,    // Route calculated, "Start" button visible
        Active,     // Turn-by-turn guidance
        Rerouting,  // (Visual state only for now)
        Arrival,    // Destination reached summary
        Error       // No GPS/Network
    }
    
    property int navState: MapPage.NavState.Idle
    property bool isNavigating: navState === MapPage.NavState.Active || navState === MapPage.NavState.Rerouting
    
    property string destination: ""
    property var selectedRoute: null // Metadata for preview
    
    // Commands
    function showSearch() { navState = MapPage.NavState.Searching }
    function closeSearch() { navState = MapPage.NavState.Idle }
    
    function previewRoute(destData) {
        destination = destData.name
        // Mock route data
        selectedRoute = {
            time: "15 min",
            dist: "12 km",
            eta: "13:45",
            via: "Highway 101"
        }
        navState = MapPage.NavState.Preview
    }
    
    function startNavigation() {
        NavigationService.startNavigation(destination)
        navState = MapPage.NavState.Active
    }
    
    function cancelNavigation() {
        NavigationService.stopNavigation()
        navState = MapPage.NavState.Idle
    }
    
    // Click-outside handler
    MouseArea {
        anchors.fill: parent
        enabled: navState === MapPage.NavState.Searching
        onClicked: closeSearch()
        z: 90
    }
    
    // Epic 9: Error Handling Overlay
    Rectangle {
        anchors.fill: parent
        color: "#AA000000" // Dim background
        visible: navState === MapPage.NavState.Error
        z: 1000 // Topmost
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: NordicTheme.spacing.space_6
            
            NordicIcon {
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg" // Generic warning/settings icon
                size: NordicIcon.Size.XXL
                color: NordicTheme.colors.semantic.error
            }
            
            NordicText {
                Layout.alignment: Qt.AlignHCenter
                text: "GPS Signal Lost"
                type: NordicText.Type.DisplaySmall
                color: "white"
            }
            
            NordicText {
                Layout.alignment: Qt.AlignHCenter
                text: "Please check your antenna connection or drive to an open area."
                type: NordicText.Type.BodyLarge
                color: NordicTheme.colors.text.secondary
            }
            
            NordicButton {
                Layout.alignment: Qt.AlignHCenter
                text: "Dismiss"
                variant: NordicButton.Variant.Secondary
                onClicked: navState = MapPage.NavState.Idle
            }
        }
    }
}
