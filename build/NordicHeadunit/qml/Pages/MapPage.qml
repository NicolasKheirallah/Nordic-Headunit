import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtPositioning
import NordicHeadunit
import "."
import "../Components/Maps" // Import new Module

Page {
    id: root
    
    // -------------------------------------------------------------------------
    // 1. Logic & State Machine
    // -------------------------------------------------------------------------
    enum NavState {
        Idle,       // Map browsing
        Searching,  // Sheet open
        Preview,    // Route selected
        Active,     // Guidance
        Error       // No GPS/Network (Overlay)
    }
    
    property int navState: MapPage.NavState.Idle
    property bool isNavigating: navState === MapPage.NavState.Active
    property string destination: ""
    property var selectedRoute: null
    
    // Responsive
    readonly property bool isCompact: NordicTheme.layout.isCompact
    
    // -------------------------------------------------------------------------
    // 2. Map Surface (Engine)
    // -------------------------------------------------------------------------
    // -------------------------------------------------------------------------
    // 2. Map Surface (MapLibre Vector)
    // -------------------------------------------------------------------------
    MapSurface {
        id: mapSurface 
        anchors.fill: parent
        
        // Camera Controller Logic (State Machine)
        // Transitions handled by MapSurface Behaviors
        
        // Helper: Speed-based zoom calculation for Active navigation
        function getNavigationZoom() {
            var speed = VehicleService.speed || 0
            if (speed > 100) return 15.5      // Highway: Wide view
            if (speed > 50) return 16.5       // Urban arterial
            return 17.5                        // Local streets: Tight view
        }
        
        // 1. Zoom
        zoomLevel: {
            if (navState === MapPage.NavState.Active) return getNavigationZoom()
            if (navState === MapPage.NavState.Preview) return 11.5 // Fit Route view
            return 14.5 // Idle
        }
        
        // 2. Tilt
        tilt: {
            if (navState === MapPage.NavState.Active) return 60.0 // Driving View
            if (navState === MapPage.NavState.Preview) return 30.0 // ISO View
            return 0.0 // Overhead
        }
        
        // 3. Bearing
        // If HeadingUp AND Active, follow car. Else 0 (North Up).
        bearing: {
            if (navState === MapPage.NavState.Active && SystemSettings.mapOrientation === 1) 
                return NavigationService.vehicleBearing
            return 0.0
        }
    }

    // -------------------------------------------------------------------------
    // 3. UI Layer (Z-Ordered)
    // -------------------------------------------------------------------------
    
    // A. Guidance Banner (Top)
    GuidanceBanner {
        id: guidanceBanner
        // Anchors cannot be animated easily with Behaviors if they are creating dependencies.
        // Let's use 'y' positioning relative to top.
        width: isCompact ? parent.width * 0.9 : 360
        anchors.top: parent.top
        anchors.topMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        
        isActive: navState === MapPage.NavState.Active
        
        // Slide Down Animation
        y: isActive ? 24 : -height - 20
        Behavior on y { NumberAnimation { duration: 600; easing.type: Easing.OutExpo } }

        maneuverIcon: "qrc:/qt/qml/NordicHeadunit/assets/icons/turn_right.svg" // Bound to Service later
        distance: NavigationService.distanceToManeuver
        instruction: NavigationService.nextManeuver
        roadName: NavigationService.currentRoadName || "Unknown Road"
    }
    
    // State for muting guidance
    property bool isGuidanceMuted: false
    
    // B. Floating Controls (Bottom Right)
    FloatingMapControls {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 24
        
        showTraffic: mapSurface.showTraffic // Two-way binding visual sync
        showRange: mapSurface.showRange
        isNavigating: root.isNavigating
        isGuidanceMuted: root.isGuidanceMuted
        
        onZoomIn:   mapSurface.setZoom(mapSurface.zoomLevel + 1)
        onZoomOut:  mapSurface.setZoom(mapSurface.zoomLevel - 1)
        onToggleTraffic: mapSurface.showTraffic = !mapSurface.showTraffic
        onToggleRange:   mapSurface.showRange = !mapSurface.showRange
        onRecenter: mapSurface.center = NavigationService.vehiclePosition
        onToggleMute: root.isGuidanceMuted = !root.isGuidanceMuted
    }
    
    // C. Search Sheet (Bottom Sheet)
    SearchSheet {
        id: searchSheet
        // Responsive Width
        width: isCompact ? parent.width : 380
        height: isCompact ? parent.height * 0.4 : 600
        
        // Position Logic using standard States or simple Y
        property bool isOpen: navState === MapPage.NavState.Idle || navState === MapPage.NavState.Searching
        
        // x: isCompact ? 0 : 24
        // If compact, center horizontally or fill width.
        anchors.left: isCompact ? parent.left : undefined
        anchors.leftMargin: isCompact ? 0 : 36 // Increased margin from left
        x: isCompact ? 0 : 36
        
        // Fix: Simplified Y calculation to prevent cutoff
        // Idle: Show top 180px (Input + Handle + Margins)
        // Searching: Show full height (height)
        y: isOpen ? (parent.height - (navState === MapPage.NavState.Searching ? height : 180) - (isCompact?0:36)) : parent.height + 20
        
        visible: y < parent.height // Optimization: Hide when offscreen
        
        onIsOpenChanged: console.log("SearchSheet isOpen changed: " + isOpen + " (NavState: " + navState + ")")
        Component.onCompleted: console.log("SearchSheet Init. NavState: " + navState)
        
        Behavior on y { NumberAnimation { duration: 500; easing.type: Easing.OutQuint } }
        
        resultsModel: ListModel { id: searchResultsModel }
        
        onSearchRequested: (query) => {
            if (query.length > 2) NavigationService.searchPlaces(query)
        }
        
        onResultSelected: (result) => {
            navState = MapPage.NavState.Preview
            mapSurface.routePath = []
            // Fix: Construct coordinate from raw lat/lon properties
            var destCoord = QtPositioning.coordinate(result.lat, result.lon)
            NavigationService.calculateRoute(mapSurface.userLocation, destCoord)
            routePreview.destinationName = result.name
            routePreview.travelTime = "12 min" // Mock
            routePreview.distance = "4.2 km" // Mock
        }
        
        onClosed: {
            NavigationService.searchPlaces("") 
        }
    }
    

    
    // D. Route Preview Sheet
    RoutePreviewSheet {
        id: routePreview
        visible: navState === MapPage.NavState.Preview
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 24
        anchors.bottomMargin: 24
        
        timeText: root.selectedRoute?.time || "--"
        distText: root.selectedRoute?.dist || "--"
        
        onStartClicked: {
            NavigationService.startNavigation(root.destination)
            navState = MapPage.NavState.Active
        }
        
        onCancelClicked: {
            NavigationService.stopNavigation() // Clear route line
            navState = MapPage.NavState.Idle
            mapSurface.routePath = [] // Clear line
        }
    }
    
    // E. Voice Toast
    Loader {
        id: voiceToastLoader
        active: false
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 160 
        z: 900
        property string messageText: ""
        sourceComponent: NordicToast {
            message: voiceToastLoader.messageText
            onDismissed: voiceToastLoader.active = false
        }
    }
    
    // Connections
    Connections {
        target: NavigationService
        
        function onSearchResultReceived(results) {
            searchResultsModel.clear()
            for (var i = 0; i < results.length; i++) searchResultsModel.append(results[i])
        }
        
        function onRouteCalculated(routeData) {
             mapSurface.routePath = routeData.path
             var distKm = (routeData.distance / 1000).toFixed(1) + " km"
             var timeMin = Math.round(routeData.duration / 60) + " min"
             root.selectedRoute = { time: timeMin, dist: distKm }
        }
        
        function onVoiceInstruction(text) {
            voiceToastLoader.active = false
            voiceToastLoader.messageText = text
            voiceToastLoader.active = true
        }
        
        function onErrorOccurred(msg) {
            console.error(msg)
            // Show error toast
        }
    }
}
