import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

// WidgetGrid - Customizable widget dashboard
Item {
    id: root
    
    // Telemetry (Fix #32)
    signal userAction(string action, var data)
    
    // Toast notifications for user feedback
    signal showToast(string message, int toastType)
    
    // Driving Mode - simplified UI at speed
    property bool drivingMode: false
    
    // Edit mode
    property bool editMode: false
    onEditModeChanged: updateContentHeight()
    
    // Undo support
    property var lastDeletedWidget: null
    property bool canUndo: lastDeletedWidget !== null
    
    // Grid configuration - follows CSS Grid best practices
    // Column count: responsive based on WidthClass
    // Compact (0) -> 2 columns
    // Regular (1) -> 3 columns
    // Expanded (2) -> 4 columns
    readonly property int columns: {
        switch(NordicTheme.layout.widthClass) {
            case 0: return 2
            case 2: return 4
            default: return 3
        }
    }
    
    // Spacing and margins: proportional to width with sensible minimums
    readonly property real spacing: Math.max(12, Math.round(width * 0.012))
    readonly property real margin: Math.max(16, Math.round(width * 0.02))
    
    // Cell dimensions: precise calculation
    // Available width = total width - left margin - right margin - gaps between columns
    // cellWidth = availableWidth / columns
    readonly property real cellWidth: (width - 2 * margin - (columns - 1) * spacing) / columns
    
    // Cell height: maintain 16:10 aspect ratio with minimum height for content
    readonly property real cellHeight: Math.max(140, Math.round(cellWidth * 0.625))
    
    // Auto-reflow layout when columns change (Fix #28 - comprehensive)
    onColumnsChanged: reflowLayout()
    
    // Comprehensive reflow: repositions ALL widgets to prevent overlaps
    function reflowLayout() {
        if (widgetModel.count === 0) return
        
        // Build occupancy grid
        var occupancy = []
        for (var r = 0; r < maxRows; r++) {
            occupancy[r] = []
            for (var c = 0; c < columns; c++) {
                occupancy[r][c] = false
            }
        }
        
        // Mark cell as occupied
        function markOccupied(x, y, w, h) {
            for (var r = y; r < y + h && r < maxRows; r++) {
                for (var c = x; c < x + w && c < columns; c++) {
                    occupancy[r][c] = true
                }
            }
        }
        
        // Check if position is available
        function isAvailable(x, y, w, h) {
            if (x + w > columns || y + h > maxRows) return false
            for (var r = y; r < y + h; r++) {
                for (var c = x; c < x + w; c++) {
                    if (occupancy[r][c]) return false
                }
            }
            return true
        }
        
        // Find next available slot for widget
        function findSlot(w, h) {
            for (var r = 0; r < maxRows; r++) {
                for (var c = 0; c <= columns - w; c++) {
                    if (isAvailable(c, r, w, h)) {
                        return { x: c, y: r }
                    }
                }
            }
            return { x: 0, y: maxRows }
        }
        
        // Reflow each widget in order
        for (var i = 0; i < widgetModel.count; i++) {
            var item = widgetModel.get(i)
            var w = Math.min(item.sizeX, columns)  // Clamp width to columns
            var h = item.sizeY
            
            // Update width if needed
            if (w !== item.sizeX) {
                widgetModel.setProperty(i, "sizeX", w)
            }
            
            // Find next available position
            var slot = findSlot(w, h)
            widgetModel.setProperty(i, "gridX", slot.x)
            widgetModel.setProperty(i, "gridY", slot.y)
            
            // Mark as occupied
            markOccupied(slot.x, slot.y, w, h)
        }
        
        updateContentHeight()
        saveLayout()
    }
    
    // Constants - dynamic based on screen
    readonly property int maxRows: Math.max(6, Math.ceil(height / cellHeight) + 2)
    
    // Centralized Widget Registry with flexible sizing
    // allowedSizes: array of [width, height] pairs that widget supports
    readonly property var widgetRegistry: ({
        // Large feature widgets
        "navigation": { 
            label: qsTr("Navigation"), 
            icon: "map", 
            defaultW: 2, defaultH: 2, 
            allowedSizes: [[2,2], [3,2], [2,1], [3,1]],
            canDelete: true 
        },
        "nowPlaying": { 
            label: qsTr("Now Playing"), 
            icon: "music", 
            defaultW: 2, defaultH: 1, 
            allowedSizes: [[2,1], [3,1], [2,2], [1,1]],
            canDelete: true 
        },
        
        // Medium widgets
        "weather": { 
            label: qsTr("Weather"), 
            icon: "weather_cloudy", 
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1], [1,2]],
            canDelete: true 
        },
        "systems": { 
            label: qsTr("Systems"), 
            icon: "car", 
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1]],
            canDelete: true 
        },
        "clock": { 
            label: qsTr("Clock"), 
            icon: "clock", 
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1]],
            canDelete: true 
        },
        
        // Quick action widgets
        "quickCall": { label: qsTr("Call"), icon: "phone", defaultW: 1, defaultH: 1, allowedSizes: [[1,1]], canDelete: true },
        "quickMedia": { label: qsTr("Media"), icon: "music", defaultW: 1, defaultH: 1, allowedSizes: [[1,1]], canDelete: true },
        "quickVehicle": { label: qsTr("Vehicle"), icon: "car", defaultW: 1, defaultH: 1, allowedSizes: [[1,1]], canDelete: true },
        "quickSettings": { label: qsTr("Settings"), icon: "settings", defaultW: 1, defaultH: 1, allowedSizes: [[1,1]], canDelete: true },
        
        // New widgets
        "compass": { 
            label: qsTr("Compass"), 
            icon: "compass", 
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1]],
            canDelete: true 
        },
        "tripInfo": { 
            label: qsTr("Trip Info"), 
            icon: "car_info", 
            defaultW: 2, defaultH: 1, 
            allowedSizes: [[2,1], [3,1], [1,1]],
            canDelete: true 
        },
        
        // Competitor-style widgets
        "speed": { 
            label: qsTr("Speed"), 
            icon: "speed", 
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1], [2,2]],
            canDelete: true 
        },
        "range": { 
            label: qsTr("Range"), 
            icon: "battery", 
            defaultW: 1, defaultH: 1, 
            allowedSizes: [[1,1], [2,1]],
            canDelete: true 
        },
        "parking": { 
            label: qsTr("Parking"), 
            icon: "car", 
            defaultW: 2, defaultH: 2, 
            allowedSizes: [[2,2], [2,1]],
            canDelete: true 
        },
        "calendar": { 
            label: qsTr("Calendar"), 
            icon: "settings", 
            defaultW: 1, defaultH: 2, 
            allowedSizes: [[1,2], [2,2], [1,1]],
            canDelete: true 
        },
        "favorites": { 
            label: qsTr("Favorites"), 
            icon: "heart", 
            defaultW: 2, defaultH: 2, 
            allowedSizes: [[2,2], [2,1], [1,2]],
            canDelete: true 
        },
        "climate": { 
            label: qsTr("Climate"), 
            icon: "settings", 
            defaultW: 2, defaultH: 1, 
            allowedSizes: [[2,1], [3,1], [2,2]],
            canDelete: true 
        }
    })
    
    // Widget model
    property ListModel widgetModel: ListModel { id: internalModel }
    
    // Cached content height
    property real cachedContentHeight: 400
    
    // Navigation helper
    signal navigateTo(int tabIndex)
    
    // Helper functions
    function calcX(gridX) { return margin + gridX * (cellWidth + spacing) }
    function calcY(gridY) { return margin + gridY * (cellHeight + spacing) }
    function calcWidth(sizeX) { return sizeX * cellWidth + (sizeX - 1) * spacing }
    function calcHeight(sizeY) { return sizeY * cellHeight + (sizeY - 1) * spacing }
    
    function pixelToGridX(px) { return Math.round((px - margin) / (cellWidth + spacing)) }
    function pixelToGridY(py) { return Math.round((py - margin) / (cellHeight + spacing)) }
    
    function updateContentHeight() {
        var maxY = 0
        for (var i = 0; i < widgetModel.count; i++) {
            var item = widgetModel.get(i)
            var bottom = calcY(item.gridY) + calcHeight(item.sizeY)
            if (bottom > maxY) maxY = bottom
        }
        // In edit mode, allow extra space at bottom to add new widgets
        // Otherwise, fit exactly to last widget
        cachedContentHeight = maxY + margin + (editMode ? (cellHeight + spacing) : 0)
    }
    
    // Check occupancy
    function isOccupied(gridX, gridY, sizeX, sizeY, excludeIndex) {
        for (var i = 0; i < widgetModel.count; i++) {
            if (i === excludeIndex) continue
            var item = widgetModel.get(i)
            var overlapX = gridX < (item.gridX + item.sizeX) && (gridX + sizeX) > item.gridX
            var overlapY = gridY < (item.gridY + item.sizeY) && (gridY + sizeY) > item.gridY
            if (overlapX && overlapY) return true
        }
        return false
    }
    
    // Find slot
    function findAvailableSlot(sizeX, sizeY, excludeIndex) {
        for (var y = 0; y < maxRows; y++) {
            for (var x = 0; x <= columns - sizeX; x++) {
                if (!isOccupied(x, y, sizeX, sizeY, excludeIndex)) {
                    return { x: x, y: y }
                }
            }
        }
        return { x: 0, y: maxRows } // Should be far bottom
    }

    // DISPLACEMENT LOGIC (Fix #21 & #3) + RECURSION LIMIT (Fix #26)
    function moveWidget(index, newGridX, newGridY, depth) {
        if (depth === undefined) depth = 0
        if (depth > 2) { 
            // Halt recursion - reject logic could be here, but for now we just stop displacing
            console.log("Max displacement depth reached. Aborting further moves.")
            return 
        }
        
        var item = widgetModel.get(index)
        
        // Clamp bounds
        newGridX = Math.max(0, Math.min(columns - item.sizeX, newGridX))
        newGridY = Math.max(0, newGridY)
        
        // Check for collision
        var collidingIndex = -1
        for (var i = 0; i < widgetModel.count; i++) {
            if (i === index) continue
            var other = widgetModel.get(i)
            var overlapX = newGridX < (other.gridX + other.sizeX) && (newGridX + item.sizeX) > other.gridX
            var overlapY = newGridY < (other.gridY + other.sizeY) && (newGridY + item.sizeY) > other.gridY
            
            if (overlapX && overlapY) {
                collidingIndex = i
                break // Handle one collision at a time
            }
        }
        
        if (collidingIndex !== -1) {
            // Collision detected! Try to move the OTHER widget
            var other = widgetModel.get(collidingIndex)
            
            // Tentatively unset colliding widget pos (mentally) or just find next slot that works
            // We use findAvailableSlot BUT we need to exclude 'index' (occupying new spot) AND 'collidingIndex' (moving)
            // Actually 'isOccupied' logic will fail if we don't update 'index' first.
            
            // 1. Move 'index' to new pos
            widgetModel.setProperty(index, "gridX", newGridX)
            widgetModel.setProperty(index, "gridY", newGridY)
            
            // 2. Find slot for 'collidingIndex'
            // We pass -1 as excludeIndex because we want to respect ALL other widgets including the one we just moved.
            // Wait, isOccupied wants to exclude 'collidingIndex' itself so it doesn't collide with old self.
            var newSlot = findAvailableSlot(other.sizeX, other.sizeY, collidingIndex)
            
            // 3. Move colliding widget (Recursively? Or just move?)
            // If we just move, it's safe. If we call moveWidget recursively, we get chain reaction.
            // Chain reaction is good for "Push", but needs limit.
            moveWidget(collidingIndex, newSlot.x, newSlot.y, depth + 1)
            
        } else {
            // No collision, just move
            widgetModel.setProperty(index, "gridX", newGridX)
            widgetModel.setProperty(index, "gridY", newGridY)
        }
        
        if (depth === 0) {
            updateContentHeight()
            saveLayout()
            root.userAction("move", { index: index, x: newGridX, y: newGridY })
        }
    }
    
    function updateWidgetSize(index, newSizeX, newSizeY) {
        var item = widgetModel.get(index)
        
        // Clamp (Fix #22)
        newSizeX = Math.max(1, Math.min(columns, newSizeX))
        newSizeY = Math.max(1, Math.min(2, newSizeY))
        
        if (item.gridX + newSizeX > columns) newSizeX = columns - item.gridX
        
        if (!isOccupied(item.gridX, item.gridY, newSizeX, newSizeY, index)) {
            widgetModel.setProperty(index, "sizeX", newSizeX)
            widgetModel.setProperty(index, "sizeY", newSizeY)
            updateContentHeight()
            saveLayout()
            root.userAction("resize", { index: index, w: newSizeX, h: newSizeY })
        }
    }
    
    // Persistence (Fix #29 - Settings Check)
    function saveLayout() {
        var layout = []
        for (var i = 0; i < widgetModel.count; i++) {
             var item = widgetModel.get(i)
             layout.push({ type: item.widgetType, x: item.gridX, y: item.gridY, w: item.sizeX, h: item.sizeY })
        }
        // Safety check
        if (typeof SystemSettings !== "undefined") {
            try {
                SystemSettings.widgetLayout = JSON.stringify(layout)
            } catch (e) { console.error("Error saving layout: " + e) }
        }
    }
    
    function loadLayout() {
        if (typeof SystemSettings !== "undefined" && SystemSettings.widgetLayout) {
            try {
                var layout = JSON.parse(SystemSettings.widgetLayout)
                widgetModel.clear()
                for (var i=0; i<layout.length; i++) widgetModel.append({ widgetType: layout[i].type, gridX: layout[i].x, gridY: layout[i].y, sizeX: layout[i].w, sizeY: layout[i].h })
                return
            } catch(e) {
                console.error("Error loading layout: " + e)
            }
        }
        loadDefaultLayout()
    }
    
    function loadDefaultLayout() {
        widgetModel.clear()
        // Stack Layout (2 columns wide)
        // Row 0: Media (Hero of the stack)
        widgetModel.append({ widgetType: "nowPlaying", gridX: 0, gridY: 0, sizeX: 2, sizeY: 1 })
        
        // Row 1: Driving Stats
        widgetModel.append({ widgetType: "speed", gridX: 0, gridY: 1, sizeX: 1, sizeY: 1 })
        widgetModel.append({ widgetType: "range", gridX: 1, gridY: 1, sizeX: 1, sizeY: 1 })
        
        // Row 2: Secondary Info
        widgetModel.append({ widgetType: "weather", gridX: 0, gridY: 2, sizeX: 2, sizeY: 1 })
        
        // Row 3: Quick Controls
        widgetModel.append({ widgetType: "quickCall", gridX: 0, gridY: 3, sizeX: 1, sizeY: 1 })
        widgetModel.append({ widgetType: "quickSettings", gridX: 1, gridY: 3, sizeX: 1, sizeY: 1 })
    }
    
    function deleteWidget(index) {
        var item = widgetModel.get(index)
        var widgetLabel = widgetRegistry[item.widgetType]?.label ?? item.widgetType
        lastDeletedWidget = { widgetType: item.widgetType, gridX: item.gridX, gridY: item.gridY, sizeX: item.sizeX, sizeY: item.sizeY }
        widgetModel.remove(index)
        updateContentHeight()
        saveLayout()
        root.userAction("delete", { type: item.widgetType })
        root.showToast(qsTr("%1 removed").arg(widgetLabel), 0)  // 0 = Info
    }
    
    function undoDelete() {
        if(lastDeletedWidget) {
            widgetModel.append(lastDeletedWidget)
            root.userAction("undo", { type: lastDeletedWidget.widgetType })
            lastDeletedWidget = null
            updateContentHeight()
            saveLayout()
        }
    }
    
    // Layout Presets - save/restore named layouts
    property var layoutPresets: ({})
    
    function saveLayoutPreset(name) {
        var layout = []
        for (var i = 0; i < widgetModel.count; i++) {
            var item = widgetModel.get(i)
            layout.push({ widgetType: item.widgetType, gridX: item.gridX, gridY: item.gridY, sizeX: item.sizeX, sizeY: item.sizeY })
        }
        layoutPresets[name] = layout
        
        // Persist presets
        if (typeof SystemSettings !== "undefined") {
            try {
                SystemSettings.widgetPresets = JSON.stringify(layoutPresets)
            } catch (e) { console.error("Error saving preset: " + e) }
        }
        root.userAction("savePreset", { name: name, count: layout.length })
    }
    
    function loadLayoutPreset(name) {
        if (!layoutPresets[name]) return false
        
        widgetModel.clear()
        var layout = layoutPresets[name]
        for (var i = 0; i < layout.length; i++) {
            widgetModel.append(layout[i])
        }
        updateContentHeight()
        saveLayout()
        root.userAction("loadPreset", { name: name })
        return true
    }
    
    function getPresetNames() {
        return Object.keys(layoutPresets)
    }
    
    function deleteLayoutPreset(name) {
        delete layoutPresets[name]
        if (typeof SystemSettings !== "undefined") {
            try {
                SystemSettings.widgetPresets = JSON.stringify(layoutPresets)
            } catch (e) { console.error("Error deleting preset: " + e) }
        }
    }
    
    // Load presets from storage on init
    Component.onCompleted: {
        loadLayout()
        updateContentHeight()
        
        // Load saved presets
        if (typeof SystemSettings !== "undefined" && SystemSettings.widgetPresets) {
            try {
                layoutPresets = JSON.parse(SystemSettings.widgetPresets)
            } catch (e) { console.error("Error loading presets: " + e) }
        }
    }
    
    // Target position for adding new widget (used by empty cell click)
    property int addTargetX: -1
    property int addTargetY: -1
    
    function addWidget(type) {
        var reg = widgetRegistry[type]
        if(!reg) return
        
        // Use target position if set, otherwise find available slot
        var slot
        if (addTargetX >= 0 && addTargetY >= 0) {
            slot = { x: addTargetX, y: addTargetY }
            addTargetX = -1
            addTargetY = -1
        } else {
            slot = findAvailableSlot(reg.defaultW, reg.defaultH, -1)
        }
        
        widgetModel.append({ widgetType: type, gridX: slot.x, gridY: slot.y, sizeX: reg.defaultW, sizeY: reg.defaultH })
        
        // Reflow to handle any overlaps caused by adding at specific position
        reflowLayout()
        root.userAction("add", { type: type })
        root.showToast(qsTr("%1 added").arg(reg.label), 1)  // 1 = Success
    }
    
    function getWidgetSource(type) {
        switch(type) {
            case "navigation": return "../Widgets/NavigationWidget.qml"
            case "weather": return "../Widgets/WeatherWidget.qml"
            case "nowPlaying": return "../Widgets/NowPlayingWidget.qml"
            case "systems": return "../Widgets/SystemsWidget.qml"
            case "clock": return "../Widgets/ClockWidget.qml"
            case "compass": return "../Widgets/CompassWidget.qml"
            case "tripInfo": return "../Widgets/TripInfoWidget.qml"
            case "speed": return "../Widgets/SpeedWidget.qml"
            case "range": return "../Widgets/RangeWidget.qml"
            case "parking": return "../Widgets/ParkingWidget.qml"
            case "calendar": return "../Widgets/CalendarWidget.qml"
            case "favorites": return "../Widgets/FavoritesWidget.qml"
            case "climate": return "../Widgets/ClimateWidget.qml"
            default: return "../Widgets/QuickActionWidget.qml"
        }
    }
    
    function getWidgetTab(type) {
        switch(type) {
            case "navigation": return 1
            case "nowPlaying": case "quickMedia": return 2
            case "quickCall": return 3
            case "systems": case "quickVehicle": return 4
            case "quickSettings": return 5
            default: return 0
        }
    }
    
    TapHandler { onLongPressed: root.editMode = true }
    
    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width
        // Only allow scrolling if content exceeds visible area
        // If content fits in view, set contentHeight = height (no scroll)
        contentHeight: Math.max(height, root.cachedContentHeight)
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        
        // Edit Mode Hint - visible when NOT in edit mode (improves discoverability)
        // Hidden in driving mode for simplified UI
        Rectangle {
            id: editHint
            visible: !root.editMode && !root.drivingMode && widgetModel.count > 0
            anchors.right: parent.right; anchors.top: parent.top; anchors.margins: root.margin
            width: 36; height: 36; radius: 18
            color: hintMouse.containsMouse ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
            border.color: Theme.border
            border.width: 1
            opacity: hintMouse.containsMouse ? 1.0 : 0.7
            z: 100
            
            Behavior on opacity { NumberAnimation { duration: 150 } }
            Behavior on color { ColorAnimation { duration: 150 } }
            
            NordicIcon {
                anchors.centerIn: parent
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/edit.svg"
                size: NordicIcon.Size.SM
                color: NordicTheme.colors.text.secondary
            }
            
            MouseArea { 
                id: hintMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.editMode = true
            }
            
            // Tooltip on hover
            Rectangle {
                visible: hintMouse.containsMouse
                anchors.right: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
                width: tooltipText.width + 16
                height: 28
                radius: 6
                color: NordicTheme.colors.bg.elevated
                
                NordicText {
                    id: tooltipText
                    anchors.centerIn: parent
                    text: qsTr("Customize")
                    type: NordicText.Type.Caption
                    color: NordicTheme.colors.text.primary
                }
            }
        }
        
        // Done Button - only visible in edit mode (enter edit via long-press)
        Rectangle {
            id: editButton
            visible: root.editMode  // Only show in edit mode
            anchors.right: parent.right; anchors.top: parent.top; anchors.margins: root.margin
            width: editBtn.width + 24; height: 36; radius: 18
            color: Theme.accent
            z: 100
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.editMode = false }
            NordicText { id: editBtn; anchors.centerIn: parent; text: qsTr("Done"); type: NordicText.Type.BodySmall; color: "white" }
        }
        
        // Undo Button (Fix #31 i18n)
        Rectangle {
            visible: root.editMode && root.canUndo
            anchors.right: editButton.left; anchors.top: parent.top; anchors.margins: root.margin; anchors.rightMargin: 8
            width: 60; height: 36; radius: 18; color: NordicTheme.colors.bg.elevated; z: 100
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.undoDelete() }
            NordicText { anchors.centerIn: parent; text: qsTr("Undo"); type: NordicText.Type.BodySmall; color: NordicTheme.colors.text.primary }
        }
        
        // Empty State (Fix #31 i18n)
        Item {
            visible: widgetModel.count === 0
            anchors.centerIn: parent
            width: 280; height: 120
            ColumnLayout {
                anchors.centerIn: parent; spacing: 16
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg"
                    size: NordicIcon.Size.LG
                    color: NordicTheme.colors.text.tertiary
                    Layout.alignment: Qt.AlignHCenter
                }
                NordicText { 
                    text: qsTr("No widgets")
                    type: NordicText.Type.TitleMedium
                    color: NordicTheme.colors.text.secondary
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
                NordicText { 
                    text: qsTr("Press and hold to customize")
                    type: NordicText.Type.BodySmall
                    color: NordicTheme.colors.text.tertiary
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
        
        // Drop Grid - clickable empty cells to add widgets
        Repeater {
            model: root.editMode ? columns * 6 : 0
            Rectangle {
                id: dropCell
                property int gridCol: index % root.columns
                property int gridRow: Math.floor(index / root.columns)
                
                x: calcX(gridCol)
                y: calcY(gridRow)
                width: root.cellWidth
                height: root.cellHeight
                color: cellMouse.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.1) : "transparent"
                border.color: cellMouse.containsMouse ? Theme.accent : Theme.border
                border.width: cellMouse.containsMouse ? 2 : 1
                radius: NordicTheme.shapes.radius_md
                opacity: 0.5
                z: -1
                
                // Plus icon
                Text {
                    anchors.centerIn: parent
                    text: "+"
                    font.pixelSize: 32
                    font.weight: Font.Light
                    color: NordicTheme.colors.text.tertiary
                    opacity: cellMouse.containsMouse ? 1.0 : 0.3
                    
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
                
                MouseArea {
                    id: cellMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.addTargetX = dropCell.gridCol
                        root.addTargetY = dropCell.gridRow
                        widgetPicker.open()
                    }
                }
            }
        }
        
        // Widgets
        Repeater {
            model: widgetModel
            DraggableWidget {
                id: widgetWrapper
                widgetId: model.widgetType
                gridWidth: model.sizeX; gridHeight: model.sizeY
                editMode: root.editMode
                modelIndex: index
                
                // Fix #22 pass columns
                maxGridWidth: root.columns
                maxGridHeight: 2
                cellWidth: root.cellWidth; cellHeight: root.cellHeight; spacing: root.spacing
                
                x: calcX(model.gridX)
                y: calcY(model.gridY)
                width: calcWidth(model.sizeX)
                height: calcHeight(model.sizeY)
                
                // Fix #19 Disable behavior during edit to prevent fighting
                Behavior on x { enabled: !editMode; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on y { enabled: !editMode; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on width { enabled: !editMode; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on height { enabled: !editMode; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                
                onDeleteRequested: root.deleteWidget(index)
                onDragEnded: function(newX, newY) { root.moveWidget(index, pixelToGridX(newX), pixelToGridY(newY)) }
                onResizeRequested: function(newW, newH) { root.updateWidgetSize(index, newW, newH) }
                
                // Fix #27 Loader Error Handling
                Loader {
                    id: wLoader
                    anchors.fill: parent
                    source: getWidgetSource(model.widgetType)
                    
                    onStatusChanged: {
                        if (status === Loader.Error) {
                            console.error("Failed to load widget: " + model.widgetType)
                        }
                    }
                    
                    onLoaded: {
                        var reg = widgetRegistry[model.widgetType]
                        if(reg && item.icon !== undefined) { item.icon = reg.icon; item.label = reg.label }
                        if(item.clicked) item.clicked.connect(function() { if(!root.editMode) { var t = getWidgetTab(model.widgetType); if(t>0) root.navigateTo(t) } })
                    }
                    
                    // Loading State UI
                    Rectangle {
                        anchors.fill: parent
                        visible: wLoader.status === Loader.Loading
                        color: NordicTheme.colors.bg.surface
                        radius: NordicTheme.shapes.radius_md
                        
                        NordicSpinner {
                            anchors.centerIn: parent
                        }
                    }
                    
                    // Error Fallback UI with Retry
                    Rectangle {
                        anchors.fill: parent
                        visible: wLoader.status === Loader.Error
                        color: NordicTheme.colors.bg.secondary
                        border.color: Theme.danger
                        border.width: 1
                        radius: NordicTheme.shapes.radius_md
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: NordicTheme.spacing.space_2
                            
                            NordicIcon { 
                                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/signal.svg"
                                color: Theme.danger
                                size: NordicIcon.Size.MD
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            NordicText { 
                                text: qsTr("Unable to load") 
                                color: NordicTheme.colors.text.secondary 
                                type: NordicText.Type.BodySmall 
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            NordicButton {
                                variant: NordicButton.Variant.Secondary
                                size: NordicButton.Size.Sm
                                text: qsTr("Retry")
                                Layout.alignment: Qt.AlignHCenter
                                onClicked: {
                                    // Force reload by resetting source
                                    var src = wLoader.source
                                    wLoader.source = ""
                                    wLoader.source = src
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Add Button (Fix #31 i18n)
    Rectangle {
        visible: root.editMode
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter; anchors.bottomMargin: 100
        width: 170; height: 48; radius: 24; color: Theme.accent; z: 50
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: widgetPicker.open() }
        Row {
            anchors.centerIn: parent; spacing: 8
            NordicText { text: qsTr("+ Add Widget"); type: NordicText.Type.TitleSmall; color: "white" }
        }
    }
    
    // Widget Picker - Responsive & Scrollable (Fix #32)
    Popup {
        id: widgetPicker
        anchors.centerIn: parent
        width: Math.min(600, parent.width * 0.9)
        height: Math.min(500, parent.height * 0.8)
        modal: true
        dim: true // Dim background for focus
        
        // Custom background with shadow
        background: Rectangle {
            color: NordicTheme.colors.bg.elevated
            radius: NordicTheme.shapes.radius_xl
            border.color: Theme.border
            border.width: 1
            
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: 1.5
                shadowOpacity: 0.3
                shadowVerticalOffset: 8
            }
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_5
            spacing: NordicTheme.spacing.space_4
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                
                NordicText { 
                    text: qsTr("Add Widget")
                    type: NordicText.Type.HeadlineSmall
                    color: NordicTheme.colors.text.primary
                    Layout.fillWidth: true
                }
                
                NordicButton {
                    variant: NordicButton.Variant.Icon
                    text: "✕"
                    onClicked: widgetPicker.close()
                }
            }
            
            // Content
            ScrollView {
                id: gridScrollView
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                
                GridLayout {
                    columns: width > 450 ? 3 : 2
                    rowSpacing: NordicTheme.spacing.space_3
                    columnSpacing: NordicTheme.spacing.space_3
                    width: gridScrollView.availableWidth
                    
                    Repeater {
                        model: ["navigation", "weather", "nowPlaying", "systems", "clock", "compass", "tripInfo", "speed", "range", "parking", "calendar", "favorites", "climate", "quickCall", "quickMedia", "quickVehicle", "quickSettings"]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 72
                            radius: NordicTheme.shapes.radius_md
                            color: pickerMA.containsMouse ? NordicTheme.colors.bg.surface : NordicTheme.colors.bg.secondary
                            border.color: pickerMA.containsMouse ? Theme.accent : "transparent"
                            border.width: 1
                            
                            property var reg: widgetRegistry[modelData] || {}
                            
                            Behavior on color { ColorAnimation { duration: 150 } }
                            
                            MouseArea { 
                                id: pickerMA
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: { root.addWidget(modelData); widgetPicker.close() } 
                            }
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: NordicTheme.spacing.space_3
                                spacing: NordicTheme.spacing.space_3
                                
                                Rectangle {
                                    width: 40; height: 40
                                    radius: 20
                                    color: NordicTheme.colors.bg.elevated
                                    Layout.alignment: Qt.AlignVCenter
                                    
                                    NordicIcon { 
                                        anchors.centerIn: parent
                                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/" + (parent.parent.parent.reg.icon||"settings") + ".svg"
                                        color: Theme.accent
                                        size: NordicIcon.Size.MD 
                                    }
                                }
                                
                                NordicText { 
                                    text: parent.parent.reg.label || modelData
                                    type: NordicText.Type.TitleSmall
                                    color: NordicTheme.colors.text.primary
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Widget Expansion Overlay - tap widget to expand full-screen
    property string expandedWidget: ""
    property var expandedWidgetData: null
    
    Rectangle {
        id: expansionOverlay
        anchors.fill: parent
        visible: root.expandedWidget !== ""
        color: Qt.rgba(0, 0, 0, 0.7)
        z: 10000
        
        // Click outside to close
        MouseArea {
            anchors.fill: parent
            onClicked: root.expandedWidget = ""
        }
        
        // Expanded widget container
        Rectangle {
            id: expandedContainer
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: parent.height * 0.85
            radius: NordicTheme.shapes.radius_lg
            color: NordicTheme.colors.bg.primary
            
            // Entrance animation
            scale: root.expandedWidget !== "" ? 1.0 : 0.8
            opacity: root.expandedWidget !== "" ? 1.0 : 0
            
            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
            Behavior on opacity { NumberAnimation { duration: 150 } }
            
            // Prevent click-through
            MouseArea { anchors.fill: parent }
            
            // Close button
            Rectangle {
                id: closeBtn
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 16
                width: 40; height: 40; radius: 20
                color: closeMa.containsMouse ? Theme.danger : NordicTheme.colors.bg.elevated
                z: 10
                
                Behavior on color { ColorAnimation { duration: 150 } }
                
                NordicText {
                    anchors.centerIn: parent
                    text: "✕"
                    type: NordicText.Type.TitleMedium
                    color: NordicTheme.colors.text.primary
                }
                
                MouseArea {
                    id: closeMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.expandedWidget = ""
                }
            }
            
            // Widget content loader
            Loader {
                id: expandedLoader
                anchors.fill: parent
                anchors.margins: NordicTheme.spacing.space_4
                source: root.expandedWidget !== "" ? getWidgetSource(root.expandedWidget) : ""
            }
        }
    }
    
    // Function to expand a widget
    function expandWidget(widgetType, widgetData) {
        root.expandedWidget = widgetType
        root.expandedWidgetData = widgetData
    }
}
