import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../Services"
import QtQuick.Effects

// DraggableWidget - Wrapper that adds drag, delete, and edit mode features
Item {
    id: root
    
    // Widget configuration
    property string widgetId: ""
    property int gridWidth: 1
    property int gridHeight: 1
    property bool editMode: false
    property int modelIndex: -1
    
    // Safety Configuration
    property bool isComplex: false
    
    // Grid properties for resize calculation
    property real cellWidth: 100
    property real cellHeight: 100
    property real spacing: 10
    property int maxGridWidth: 3
    property int maxGridHeight: 3
    
    // Content
    default property alias content: contentContainer.children
    
    // Signals
    signal deleteRequested()
    signal dragStarted()
    signal dragEnded(real newX, real newY)
    signal positionChanged(real x, real y)
    signal resizeRequested(int newGridW, int newGridH)
    
    // Random wobble offset for natural feel
    property real wobbleOffset: Math.random() * 0.5
    
    // Entrance animation
    opacity: 0
    scale: 0.8
    Component.onCompleted: entranceAnim.start()
    
    ParallelAnimation {
        id: entranceAnim
        NumberAnimation { target: root; property: "opacity"; to: 1; duration: 300; easing.type: Easing.OutCubic }
        NumberAnimation { target: root; property: "scale"; to: 1; duration: 350; easing.type: Easing.OutBack }
    }
    
    // Interaction state for wobble stabilization
    property bool isInteracting: dragArea.pressed || resizeArea.pressed
    property bool isHovered: dragArea.containsMouse || (typeof resizeArea !== "undefined" && resizeArea.containsMouse)
    property bool shouldWobble: root.editMode && !isInteracting && !isHovered && !(NordicTheme.reducedMotion ?? false)
    
    // Edit mode wobble animation - gentler, stops on hover for precision
    SequentialAnimation on rotation {
        id: wobbleAnim
        running: root.shouldWobble
        loops: Animation.Infinite
        NumberAnimation { to: 1.0 + root.wobbleOffset * 0.3; duration: 120 + root.wobbleOffset * 30; easing.type: Easing.InOutSine }
        NumberAnimation { to: -1.0 - root.wobbleOffset * 0.3; duration: 120 + root.wobbleOffset * 30; easing.type: Easing.InOutSine }
    }
    
    // Smooth stabilization when interaction starts or edit mode exits
    Behavior on rotation {
        enabled: !root.shouldWobble
        NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
    }
    
    // Reset rotation when stabilizing
    onIsInteractingChanged: if (isInteracting) rotation = 0
    onIsHoveredChanged: if (isHovered && editMode) rotation = 0
    
    onEditModeChanged: {
        if (!editMode) rotation = 0
    }
    
    // Fix Z-Index during drag
    z: dragArea.pressed ? 9999 : 1
    
    // Main container
    Item {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: root.editMode ? 4 : 0
        opacity: (dragArea.pressed || resizeArea.pressed) ? 0.0 : 1.0 // Hide content during drag/resize (ghost shows instead)
        
        Behavior on anchors.margins {
            NumberAnimation { duration: 150 }
        }
    }
    
    // Safety Veil (Driving Lockout)
    // Overlays content when driving speed > limit AND widget is complex
    Rectangle {
        id: safetyVeil
        anchors.fill: contentContainer
        color: NordicTheme.colors.bg.glass
        radius: NordicTheme.shapes.radius_md
        visible: !root.editMode && root.isComplex && DrivingSafety.isRestricted
        z: 50 // Above content, below drag handles
        
        // Blur effect to obscure complex content
        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blurMax: 32
            blur: 1.0
        }
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 8
            
            NordicIcon {
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg" // Use lock or car icon
                size: NordicIcon.Size.MD
                color: NordicTheme.colors.text.secondary
                Layout.alignment: Qt.AlignHCenter
            }
            
            NordicText {
                text: qsTr("Unavailable")
                type: NordicText.Type.Caption
                color: NordicTheme.colors.text.secondary
                Layout.alignment: Qt.AlignHCenter
            }
        }
        
        // Absorb clicks
        MouseArea {
            anchors.fill: parent
            onClicked: DrivingSafety.checkAction("complex", (msg) => {
                 // Find parent showToast. Traverse up.
                 var p = root
                 while (p && !p.showToast) p = p.parent
                 if (p) p.showToast(msg, 0)
            })
        }
    }
    
    // Ghost overlay (Visual feedback during drag/resize)
    Rectangle {
        id: ghost
        visible: dragArea.pressed || resizeArea.pressed
        x: resizeArea.pressed ? 0 : 0 // Relative to root
        y: resizeArea.pressed ? 0 : 0
        // ... (rest of ghost properties unchanged)
        
    // Fix Animation Fighting (Improvement: Enable on release for snap)
    // Only disable during actual drag interaction
    Behavior on x { enabled: !dragArea.pressed && !resizeArea.pressed; NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
    Behavior on y { enabled: !dragArea.pressed && !resizeArea.pressed; NumberAnimation { duration: 250; easing.type: Easing.OutBack } }
    Behavior on width { enabled: !resizeArea.pressed; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on height { enabled: !resizeArea.pressed; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        width: resizeArea.pressed ? resizeArea.currentWidth : root.width
        height: resizeArea.pressed ? resizeArea.currentHeight : root.height
        color: NordicTheme.colors.bg.elevated
        radius: NordicTheme.shapes.radius_md
        opacity: 0.9
        z: 1000
        border.color: isValidSize ? Theme.accent : Theme.danger
        border.width: 2
        
        property bool isValidSize: true
        
        // Clone content visuals roughly (icon/text)
        NordicIcon {
            anchors.centerIn: parent
            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg" // Generic fallback
            size: NordicIcon.Size.XL
            color: NordicTheme.colors.text.tertiary
        }
    }
    
    // Delete button
    Rectangle {
        id: deleteButton
        visible: root.editMode && !dragArea.pressed && !resizeArea.pressed
        width: 28
        height: 28
        radius: 14
        color: Theme.danger
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: -8
        z: 100
        
        scale: deleteMA.containsMouse ? 1.1 : 1.0
        Behavior on scale { NumberAnimation { duration: 100 } }
        
        NordicText {
            anchors.centerIn: parent
            text: "✕"
            type: NordicText.Type.BodyMedium
            color: "white"
        }
        
        MouseArea {
            id: deleteMA
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: deleteAnim.start()
        }
        Accessible.name: "Delete widget"
    }

    // Delete animation
    SequentialAnimation {
        id: deleteAnim
        ParallelAnimation {
            NumberAnimation { target: root; property: "scale"; to: 0; duration: 200; easing.type: Easing.InBack }
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: 200 }
        }
        ScriptAction { script: root.deleteRequested() }
    }
    
    // Keyboard Focus
    activeFocusOnTab: true
    Keys.onDeletePressed: if(editMode) deleteAnim.start()
    
    // Drag Area (Improved with native drag smoothing)
    MouseArea {
        id: dragArea
        anchors.fill: parent
        visible: root.editMode && !resizeArea.pressed
        cursorShape: Qt.OpenHandCursor
        hoverEnabled: true  // Required for wobble stabilization on hover
        
        drag.target: root
        drag.axis: Drag.XAndYAxis
        drag.threshold: 10 // Reduce accidental micro-drags
        drag.smoothed: true // This is key for fixing "jank"
        drag.filterChildren: true // Ensure delete button can still be clicked
        
        onPressed: (mouse) => {
            cursorShape = Qt.ClosedHandCursor
            root.forceActiveFocus()
            // We don't manually emit dragStarted here immediately, 
            // wait for actual drag movement or let z-ordering happen via property binding
            root.dragStarted()
        }
        
        onPositionChanged: (mouse) => {
            // Native drag handles X/Y updates automatically.
            // We just need to notify parent for collision checks
            if (drag.active) {
                root.positionChanged(root.x, root.y)
            }
        }
        
        onReleased: (mouse) => {
            cursorShape = Qt.OpenHandCursor
            root.dragEnded(root.x, root.y)
        }
        
        onCanceled: {
            root.dragEnded(root.x, root.y) // Revert handled by parent if needed
        }
    }
    
    // Resize Handle Area
    Item {
        id: resizeHandleItem
        width: 40; height: 40
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: root.editMode && !dragArea.pressed
        z: 101
        
        // Canvas drawing
        Canvas {
            anchors.fill: parent
            anchors.margins: 8
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = NordicTheme.colors.text.primary
                ctx.lineWidth = 2
                ctx.lineCap = "round"
                ctx.beginPath()
                ctx.moveTo(width, height - 6); ctx.lineTo(width - 6, height)
                ctx.moveTo(width, height - 12); ctx.lineTo(width - 12, height)
                ctx.stroke()
            }
        }
        
        MouseArea {
            id: resizeArea
            anchors.fill: parent
            cursorShape: Qt.SizeFDiagCursor
            
            property real startMouseX: 0
            property real startMouseY: 0
            property real startW: 0
            property real startH: 0
            property real currentWidth: 0
            property real currentHeight: 0
            
            onPressed: (mouse) => {
                startMouseX = mouse.x
                startMouseY = mouse.y
                startW = root.width
                startH = root.height
                currentWidth = startW
                currentHeight = startH
                // Don't propagate to drag area
                mouse.accepted = true
            }
            
            onPositionChanged: (mouse) => {
                // Calculate visual delta
                // Note: since resizeHandle moves with root, we need to map to parent or accumulate
                // Actually easiest is to use mapToItem if possible, or just simpler logic:
                // Dragging a handle inside a resizing item is tricky because the handle moves.
                // Better approach: use `drag.target` but we want custom logic.
                // Let's rely on the fact that mouse events are relative to the Item *at press time* or delivered continuously.
                
                // Simplified: use delta from press point
                // But wait, if we change root.width, resizeHandle moves.
                // We are NOT changing root.width anymore (to fix binding). We update ghost.
                
                var deltaX = mouse.x - startMouseX
                var deltaY = mouse.y - startMouseY
                
                currentWidth = Math.max(cellWidth, startW + deltaX)
                currentHeight = Math.max(cellHeight, startH + deltaY)
                
                // Calculate validity for ghost border
                var gw = Math.round(currentWidth / (cellWidth + spacing))
                var gh = Math.round(currentHeight / (cellHeight + spacing))
                ghost.isValidSize = (gw <= maxGridWidth && gh <= maxGridHeight)
            }
            
            onReleased: (mouse) => {
                 var gridW = Math.round(currentWidth / (cellWidth + spacing))
                 var gridH = Math.round(currentHeight / (cellHeight + spacing))
                 
                 // Clamp properties (Fix #22 - Dynamic limits)
                 gridW = Math.max(1, Math.min(maxGridWidth, gridW))
                 gridH = Math.max(1, Math.min(maxGridHeight, gridH))
                 
                 root.resizeRequested(gridW, gridH)
            }
        }
    }
    
    Accessible.name: widgetId + " widget"
}
