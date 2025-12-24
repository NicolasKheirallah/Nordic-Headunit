import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

import "../Services"

// WidgetGrid - Customizable widget dashboard
Item {
    id: root
    
    // Telemetry (Fix #32)
    signal userAction(string action, var data)
    
    // Toast notifications for user feedback
    signal showToast(string message, int toastType)
    
    // Driving Mode - simplified UI at speed
    property bool drivingMode: false
    // Safety: Force exit edit mode when driving starts
    onDrivingModeChanged: if (drivingMode) editMode = false
    
    // Accessibility
    readonly property bool reducedMotion: SystemSettings.reducedMotion ?? false
    
    // Edit mode
    property bool editMode: false
    onEditModeChanged: { /* Layout updates automatically */ }
    
    // Undo support - multi-step history
    property var undoHistory: []
    readonly property int maxUndoHistory: 5
    property bool canUndo: undoHistory.length > 0
    readonly property var lastDeletedWidget: undoHistory.length > 0 ? undoHistory[undoHistory.length - 1] : null
    
    // Configuration constants (avoid magic numbers)
    readonly property int maxReflowRows: 100
    readonly property int maxSlotSearchRows: 20
    readonly property int maxDisplacementDepth: 2
    
    // Grid configuration - follows CSS Grid best practices
    // Column count: responsive based on WidthClass
    // Compact (0) -> 2 columns
    // Regular (1) -> 3 columns
    // Expanded (2) -> 4 columns
    readonly property int columns: {
        if (width >= 800) return 4
        if (width >= 550) return 3
        if (width >= 300) return 2
        return 1
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
    
    // Paging (Disabled - Vertical Scroll)
    property int pageCount: 1
    property int currentPage: 0
    
    // Auto-reflow layout when columns change (Fix #28 - comprehensive)
    onColumnsChanged: reflowLayout()
    
    // Comprehensive reflow: Masonry Packing (Sort & Fill)
    function reflowLayout() {
        if (widgetModel.count === 0) return
        
        // 1. Snapshot current positions
        var items = []
        for (var i = 0; i < widgetModel.count; i++) {
            var item = widgetModel.get(i)
            items.push({
                index: i,
                type: item.widgetType, // Debugging
                x: item.gridX,
                y: item.gridY,
                w: Math.min(item.sizeX, columns), // Clamp width immediately
                h: item.sizeY
            })
        }
        
        // 2. Sort by visual position (Row-major: Top-to-bottom, Left-to-right)
        // This preserves the relative order the user intended
        items.sort(function(a, b) {
            if (a.y !== b.y) return a.y - b.y
            return a.x - b.x
        })
        
        // 3. Occupancy Grid
        var occupancy = []
        function check(x, y) {
            if (!occupancy[y]) return false
            return occupancy[y][x] === true
        }
        function mark(x, y, w, h) {
            for(var r=y; r<y+h; r++) {
                if(!occupancy[r]) occupancy[r] = []
                for(var c=x; c<x+w; c++) occupancy[r][c] = true
            }
        }
        function isAreaFree(x, y, w, h) {
             if (x + w > columns) return false
             for(var r=y; r<y+h; r++) {
                 for(var c=x; c<x+w; c++) {
                     if (check(c, r)) return false
                 }
             }
             return true
        }
        
        // 4. Repack
        for (var i = 0; i < items.length; i++) {
            var item = items[i]
            var placed = false
            
            // Find first available slot
            // Scan rows indefinitely until fit (usually fits within current bounds + height)
            var scanRow = 0
            while (!placed && scanRow < maxReflowRows) { // Use constant for safety bound
                for (var c = 0; c <= columns - item.w; c++) {
                    if (isAreaFree(c, scanRow, item.w, item.h)) {
                        
                        // Apply new position
                        widgetModel.setProperty(item.index, "gridX", c)
                        widgetModel.setProperty(item.index, "gridY", scanRow)
                        widgetModel.setProperty(item.index, "sizeX", item.w) // Apply clamped width
                        widgetModel.setProperty(item.index, "page", 0)
                        
                        // Mark occupied
                        mark(c, scanRow, item.w, item.h)
                        placed = true
                        break
                    }
                }
                scanRow++
            }
        }
        
        saveLayout()
    }
    
    // Constants - dynamic based on screen
    readonly property int maxRows: Math.max(6, Math.ceil(height / cellHeight) + 2)
    
    // Widget model
    property ListModel widgetModel: ListModel { id: internalModel }
    
    // Cached content height (not really used for Flickable width calc but good to keep)
    // Cached content height removed (Paging uses fixed height)
    
    // Navigation helper
    signal navigateTo(int tabIndex)
    
    // Helper functions (Updated for Vertical Scroll)
    function calcX(gridX, page) { 
        return margin + gridX * (cellWidth + spacing) 
    }
    function calcY(gridY) { return margin + gridY * (cellHeight + spacing) }
    function calcWidth(sizeX) { return sizeX * cellWidth + (sizeX - 1) * spacing }
    function calcHeight(sizeY) { return sizeY * cellHeight + (sizeY - 1) * spacing }
    
    function pixelToGridX(px) { 
        var localPx = Math.max(0, px)
        return Math.floor((localPx - margin) / (cellWidth + spacing)) 
    }
    function pixelToPage(px) { return 0 } // No pages
    
    function pixelToGridY(py) { return Math.round((py - margin) / (cellHeight + spacing)) }
    
    // Check occupancy
    function isOccupied(page, gridX, gridY, sizeX, sizeY, excludeIndex) {
        // Ignore page
        for (var i = 0; i < widgetModel.count; i++) {
            if (i === excludeIndex) continue
            var item = widgetModel.get(i)
            
            var overlapX = gridX < (item.gridX + item.sizeX) && (gridX + sizeX) > item.gridX
            var overlapY = gridY < (item.gridY + item.sizeY) && (gridY + sizeY) > item.gridY
            if (overlapX && overlapY) return true
        }
        return false
    }
    
    // Find slot (Vertical)
    function findAvailableSlot(sizeX, sizeY, excludeIndex) {
        for (var y = 0; y < maxSlotSearchRows; y++) {
            for (var x = 0; x <= columns - sizeX; x++) {
                if (!isOccupied(0, x, y, sizeX, sizeY, excludeIndex)) {
                    return { x: x, y: y, page: 0 }
                }
            }
        }
        return { x: 0, y: maxSlotSearchRows, page: 0 }
    }

    // DISPLACEMENT LOGIC (Fix #21 & #3) + RECURSION LIMIT (Fix #26)
    function moveWidget(index, newGridX, newGridY, newPage, depth) {
        if (depth === undefined) depth = 0
        if (depth > maxDisplacementDepth) return
        
        var item = widgetModel.get(index)
        
        // Clamp bounds
        newGridX = Math.max(0, Math.min(columns - item.sizeX, newGridX))
        newGridY = Math.max(0, newGridY)
        if (newPage === undefined) newPage = 0
        newPage = Math.max(0, Math.min(pageCount - 1, newPage))
        
        // Check for collision
        var collidingIndex = -1
        for (var i = 0; i < widgetModel.count; i++) {
            if (i === index) continue
            var other = widgetModel.get(i)
            if (other.page !== newPage) continue // Ignore other pages
            
            var overlapX = newGridX < (other.gridX + other.sizeX) && (newGridX + item.sizeX) > other.gridX
            var overlapY = newGridY < (other.gridY + other.sizeY) && (newGridY + item.sizeY) > other.gridY
            
            if (overlapX && overlapY) {
                collidingIndex = i
                break 
            }
        }
        
        if (collidingIndex !== -1) {
            // Collision: Move OTHER widget
            var other = widgetModel.get(collidingIndex)
            
            // 1. Move 'index' to new pos
            widgetModel.setProperty(index, "gridX", newGridX)
            widgetModel.setProperty(index, "gridY", newGridY)
            widgetModel.setProperty(index, "page", newPage)
            
            // 2. Find slot for 'collidingIndex'
            var newSlot = findAvailableSlot(other.sizeX, other.sizeY, collidingIndex)
            
            // 3. Move colliding widget
            moveWidget(collidingIndex, newSlot.x, newSlot.y, newSlot.page, depth + 1)
            
        } else {
            // No collision
            widgetModel.setProperty(index, "gridX", newGridX)
            widgetModel.setProperty(index, "gridY", newGridY)
            widgetModel.setProperty(index, "page", newPage)
        }
        
        if (depth === 0) {
            saveLayout()
            root.userAction("move", { index: index, x: newGridX, y: newGridY, p: newPage })
        }
    }
    
    function updateWidgetSize(index, newSizeX, newSizeY) {
        var item = widgetModel.get(index)
        // Clamp (Fix #22)
        newSizeX = Math.max(1, Math.min(columns, newSizeX))
        newSizeY = Math.max(1, Math.min(3, newSizeY))
        
        if (item.gridX + newSizeX > columns) newSizeX = columns - item.gridX
        
        if (!isOccupied(item.page, item.gridX, item.gridY, newSizeX, newSizeY, index)) {
            widgetModel.setProperty(index, "sizeX", newSizeX)
            widgetModel.setProperty(index, "sizeY", newSizeY)
            // updateContentHeight() // No longer needed as we use fixed height pages?
            saveLayout()
            root.userAction("resize", { index: index, w: newSizeX, h: newSizeY })
        }
    }
    
    // Persistence (Fix #29 - Settings Check)
    function saveLayout() {
        var layout = []
        for (var i = 0; i < widgetModel.count; i++) {
             var item = widgetModel.get(i)
             layout.push({ type: item.widgetType, x: item.gridX, y: item.gridY, w: item.sizeX, h: item.sizeY, p: item.page !== undefined ? item.page : 0 })
        }
        if (typeof SystemSettings !== "undefined") {
            try {
                SystemSettings.widgetLayout = JSON.stringify(layout)
            } catch (e) {
                console.error("Error saving layout: " + e)
                root.showToast(qsTr("Failed to save layout"), 2) // 2 = Error
            }
        }
    }
    
    function loadLayout() {
        if (typeof SystemSettings !== "undefined" && SystemSettings.widgetLayout) {
            try {
                var layout = JSON.parse(SystemSettings.widgetLayout)
                widgetModel.clear()
                for (var i=0; i<layout.length; i++) {
                    widgetModel.append({ 
                        widgetType: layout[i].type, 
                        gridX: layout[i].x, 
                        gridY: layout[i].y, 
                        sizeX: layout[i].w, 
                        sizeY: layout[i].h,
                        page: layout[i].p !== undefined ? layout[i].p : 0
                    })
                }
                return
            } catch(e) {
                console.error("Error loading layout: " + e)
                root.showToast(qsTr("Failed to load layout, using defaults"), 2)
            }
        }
        loadDefaultLayout()
    }
    
    function loadDefaultLayout() {
        widgetModel.clear()
        // Standard Widgets (Top)
        widgetModel.append({ widgetType: "nowPlaying", gridX: 0, gridY: 0, sizeX: 2, sizeY: 1, page: 0 })
        widgetModel.append({ widgetType: "weather", gridX: 0, gridY: 1, sizeX: 2, sizeY: 1, page: 0 })
        
        // Driving Widgets (Below)
        widgetModel.append({ widgetType: "speed", gridX: 0, gridY: 2, sizeX: 1, sizeY: 1, page: 0 })
        widgetModel.append({ widgetType: "range", gridX: 1, gridY: 2, sizeX: 1, sizeY: 1, page: 0 })
        widgetModel.append({ widgetType: "tripInfo", gridX: 0, gridY: 3, sizeX: 2, sizeY: 1, page: 0 })
    }
    
    Timer {
        id: undoTimer
        interval: 8000  // Extended from 5s to 8s for better UX
        repeat: false
        onTriggered: {
            undoHistory = []  // Clear all undo history
        }
    }

    function deleteWidget(index) {
        var item = widgetModel.get(index)
        var widgetData = WidgetRegistry.get(item.widgetType)
        var widgetLabel = widgetData?.label ?? item.widgetType
        
        // Push to undo history (multi-step)
        var historyItem = { widgetType: item.widgetType, gridX: item.gridX, gridY: item.gridY, sizeX: item.sizeX, sizeY: item.sizeY, page: item.page || 0 }
        var newHistory = undoHistory.slice()  // Clone to trigger binding update
        newHistory.push(historyItem)
        if (newHistory.length > maxUndoHistory) newHistory.shift()
        undoHistory = newHistory
        
        widgetModel.remove(index)
        saveLayout()
        root.userAction("delete", { type: item.widgetType })
        undoTimer.restart()
    }
    
    function undoDelete() {
        if (undoHistory.length > 0) {
            var newHistory = undoHistory.slice()
            var widget = newHistory.pop()
            undoHistory = newHistory
            
            widgetModel.append(widget)
            reflowLayout()  // Ensure no collisions
            root.userAction("undo", { type: widget.widgetType })
            root.showToast(qsTr("Widget restored"), 1)  // 1 = Success
            
            if (undoHistory.length > 0) {
                undoTimer.restart()  // Keep timer running if more undo available
            }
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
    
    Component.onCompleted: {
        loadLayout()
        
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
    property int addTargetPage: -1
    
    function addWidget(type) {
        var reg = WidgetRegistry.get(type)
        if(!reg) return
        
        // Use target position if set, otherwise find available slot
        var slot
        if (addTargetX >= 0 && addTargetY >= 0) {
            slot = { x: addTargetX, y: addTargetY, page: (addTargetPage >= 0 ? addTargetPage : currentPage) }
            addTargetX = -1
            addTargetY = -1
            addTargetPage = -1
        } else {
            slot = findAvailableSlot(reg.defaultW, reg.defaultH, -1)
        }
        
        widgetModel.append({ widgetType: type, gridX: slot.x, gridY: slot.y, sizeX: reg.defaultW, sizeY: reg.defaultH, page: slot.page })
        
        // Reflow to handle any overlaps caused by adding at specific position
        reflowLayout()
        root.userAction("add", { type: type })
        root.showToast(qsTr("%1 added").arg(reg.label), 1)  // 1 = Success
    }
    
    function getWidgetSource(type) {
        var reg = WidgetRegistry.get(type)
        return reg ? reg.source : ""
    }
    
    function getWidgetTab(type) {
        var reg = WidgetRegistry.get(type)
        return reg ? (reg.tabIndex !== undefined ? reg.tabIndex : 0) : 0
    }
    
    TapHandler { 
        onLongPressed: {
            if (!root.drivingMode) root.editMode = true 
            else root.showToast(qsTr("Cannot customize while driving"), 0)
        }
    }
    
    // Main Content Area (Clipped to preventing bleeding over map)
    Item {
        id: container
        anchors.fill: parent
        clip: true

        

        
        // Undo handled by global overlay now
        
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
        
        // Vertical Scroll Container
        Flickable {
            id: pager
            anchors.fill: parent
            contentWidth: width
            contentHeight: Math.max(height, (getMaxRow() + 2) * (root.cellHeight + root.spacing))
            flickableDirection: Flickable.VerticalFlick
            boundsBehavior: Flickable.StopAtBounds
            flickDeceleration: 3000
            clip: true
            
            // Function to find the lowest occupied row to determine content height
            function getMaxRow() {
                var maxR = 4 // Minimum height
                for (var i = 0; i < widgetModel.count; i++) {
                    var item = widgetModel.get(i)
                    if (item.gridY + item.sizeY > maxR) maxR = item.gridY + item.sizeY
                }
                return maxR
            }
            
            // Content
            Item {
                 width: pager.contentWidth
                 height: pager.height
                 
                 // 1. DROP TARGETS (Per Page)
                 Repeater {
                     model: root.pageCount
                     Item {
                         property int pageIndex: index
                         width: root.width
                         height: pager.height
                         x: index * root.width
                         y: 0
                         visible: Math.abs(root.currentPage - index) <= 1 // Optimization
                         
                         Repeater {
                             model: root.editMode ? root.columns * root.maxRows : 0
                             Rectangle {
                                 id: dropCell
                                 property int gridCol: index % root.columns
                                 property int gridRow: Math.floor(index / root.columns)
                                 
                                 x: root.margin + gridCol * (root.cellWidth + root.spacing)
                                 y: root.margin + gridRow * (root.cellHeight + root.spacing)
                                 width: root.cellWidth
                                 height: root.cellHeight
                                 
                                 color: cellMouse.containsMouse ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.1) : "transparent"
                                 border.color: cellMouse.containsMouse ? Theme.accent : Theme.border
                                 border.width: cellMouse.containsMouse ? 2 : 1
                                 radius: NordicTheme.shapes.radius_md
                                 opacity: 0.5
                                 z: -1
                                 
                                 Text {
                                     anchors.centerIn: parent
                                     text: "+"
                                     font.pixelSize: 32
                                     font.weight: Font.Light
                                     color: NordicTheme.colors.text.tertiary
                                     opacity: cellMouse.containsMouse ? 1.0 : 0.3
                                     Behavior on opacity { enabled: !root.reducedMotion; NumberAnimation { duration: 150 } }
                                 }
                                 
                                 MouseArea {
                                     id: cellMouse
                                     anchors.fill: parent
                                     hoverEnabled: true
                                     cursorShape: Qt.PointingHandCursor
                                     onClicked: {
                                         root.addTargetX = dropCell.gridCol
                                         root.addTargetY = dropCell.gridRow
                                         root.addTargetPage = pageIndex
                                         widgetPicker.open()
                                     }
                                 }
                             }
                         }
                     }
                 }
    
                 // 2. WIDGETS
                 Repeater {
                    model: widgetModel
                    DraggableWidget {
                        id: widgetWrapper
                        widgetId: model.widgetType
                        gridWidth: model.sizeX; gridHeight: model.sizeY
                        editMode: root.editMode
                        modelIndex: index
                        
                        maxGridWidth: root.columns
                        maxGridHeight: 3
                        cellWidth: root.cellWidth; cellHeight: root.cellHeight; spacing: root.spacing
                        
                        // Safety
                        isComplex: WidgetRegistry.get(model.widgetType)?.isComplex || false
                        
                        x: calcX(model.gridX, model.page)
                        y: calcY(model.gridY)
                        width: calcWidth(model.sizeX)
                        height: calcHeight(model.sizeY)
                        
                        Behavior on x { enabled: !editMode && !root.reducedMotion; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on y { enabled: !editMode && !root.reducedMotion; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on width { enabled: !editMode && !root.reducedMotion; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        Behavior on height { enabled: !editMode && !root.reducedMotion; NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                        
                        onDeleteRequested: root.deleteWidget(index)
                        onDragEnded: function(newX, newY) { root.moveWidget(index, pixelToGridX(newX), pixelToGridY(newY), pixelToPage(newX)) }
                        onResizeRequested: function(newW, newH) { root.updateWidgetSize(index, newW, newH) }
                        
                        Loader {
                            id: wLoader
                            anchors.fill: parent
                            source: getWidgetSource(model.widgetType)
                            
                            onStatusChanged: {
                                if (status === Loader.Error) console.error("Failed to load widget: " + model.widgetType)
                            }
                            
                            onLoaded: {
                                var reg = WidgetRegistry.get(model.widgetType)
                                if(reg && item.icon !== undefined) { item.icon = reg.icon; item.label = reg.label }
                                if(item.clicked) item.clicked.connect(function() { if(!root.editMode) { var t = getWidgetTab(model.widgetType); if(t>0) root.navigateTo(t) } })
                            }
                            
                            Rectangle {
                                anchors.fill: parent
                                visible: wLoader.status === Loader.Loading
                                color: NordicTheme.colors.bg.surface
                                radius: NordicTheme.shapes.radius_md
                                NordicSpinner { anchors.centerIn: parent }
                            }
                            
                            Rectangle {
                                anchors.fill: parent
                                visible: wLoader.status === Loader.Error
                                color: NordicTheme.colors.bg.surface
                                radius: NordicTheme.shapes.radius_md
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    NordicText { text: qsTr("Error"); type: NordicText.Type.BodySmall }
                                    NordicButton { text: "Retry"; size: NordicButton.Size.Sm; onClicked: wLoader.source = wLoader.source }
                                }
                            }
                        }
                    }
                 }
            }
        }
        


        }

    
    // Undo Overlay (Prominent & Auto-hiding)
    Rectangle {
        id: undoOverlay
        visible: root.canUndo
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        anchors.horizontalCenter: parent.horizontalCenter
        width: 300
        height: 56
        radius: 28
        color: NordicTheme.colors.text.primary
        z: 200
        
        layer.enabled: true
        layer.effect: MultiEffect { shadowEnabled: true; shadowBlur: 16; shadowVerticalOffset: 4 }
        
        // Entrance Animation
        opacity: visible ? 1.0 : 0.0
        Behavior on opacity { enabled: !root.reducedMotion; NumberAnimation { duration: 200 } }
        y: visible ? parent.height - 88 : parent.height
        Behavior on y { enabled: !root.reducedMotion; NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 12
            
            Item { width: 12 } // Spacer
            
            NordicText {
                text: qsTr("Widget removed")
                type: NordicText.Type.BodyMedium
                color: NordicTheme.colors.text.inverse
                Layout.fillWidth: true
            }
            
            NordicButton {
                text: qsTr("Undo")
                variant: NordicButton.Variant.Primary
                size: NordicButton.Size.Sm
                onClicked: {
                    root.undoDelete()
                    undoTimer.stop()
                }
            }
            
            Item { width: 4 } // Spacer
        }
    }

        // Done Button
        Rectangle {
            id: editButton
            visible: root.editMode
            anchors.right: parent.right; anchors.top: parent.top; anchors.margins: root.margin
            width: editBtn.width + 32; height: 44; radius: 22
            color: doneMouse.pressed ? Qt.darker(Theme.accent, 1.15) : (doneMouse.containsMouse ? Qt.lighter(Theme.accent, 1.1) : Theme.accent)
            border.width: editButton.activeFocus ? 2 : 0
            border.color: "white"
            z: 100
            
            activeFocusOnTab: true
            Keys.onReturnPressed: root.editMode = false
            Keys.onSpacePressed: root.editMode = false
            
            Behavior on color { enabled: !root.reducedMotion; ColorAnimation { duration: 150 } }
            
            MouseArea { 
                id: doneMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: { editButton.forceActiveFocus(); root.editMode = false }
            }
            NordicText { id: editBtn; anchors.centerIn: parent; text: qsTr("Done"); type: NordicText.Type.BodyMedium; color: "white" }
        }

        // Edit Mode Hint
        Rectangle {
            id: editHint
            visible: !root.editMode && !root.drivingMode && widgetModel.count > 0
            anchors.right: parent.right; anchors.top: parent.top; anchors.margins: root.margin
            width: 44; height: 44; radius: 22
            color: hintMouse.pressed ? Qt.darker(NordicTheme.colors.bg.elevated, 1.1) : (hintMouse.containsMouse || editHint.activeFocus ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface)
            border.color: editHint.activeFocus ? Theme.accent : (hintMouse.containsMouse ? Theme.accent : Theme.border)
            border.width: editHint.activeFocus ? 2 : 1
            opacity: hintMouse.containsMouse || editHint.activeFocus ? 1.0 : 0.85
            z: 100
            
            activeFocusOnTab: true
            Keys.onReturnPressed: root.editMode = true
            Keys.onSpacePressed: root.editMode = true
            
            Behavior on opacity { enabled: !root.reducedMotion; NumberAnimation { duration: 150 } }
            Behavior on color { enabled: !root.reducedMotion; ColorAnimation { duration: 150 } }
            
            NordicIcon {
                anchors.centerIn: parent
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/edit.svg"
                size: NordicIcon.Size.MD
                color: hintMouse.containsMouse || editHint.activeFocus ? Theme.accent : NordicTheme.colors.text.secondary
            }
            
            MouseArea { 
                id: hintMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: { editHint.forceActiveFocus(); root.editMode = true }
            }
            
            // Tooltip on hover or focus
            Rectangle {
                visible: hintMouse.containsMouse || editHint.activeFocus
                anchors.right: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 8
                width: tooltipText.width + 16
                height: 32
                radius: 8
                color: NordicTheme.colors.bg.elevated
                border.width: 1
                border.color: NordicTheme.colors.border.muted
                
                NordicText {
                    id: tooltipText
                    anchors.centerIn: parent
                    text: qsTr("Customize")
                    type: NordicText.Type.BodySmall
                    color: NordicTheme.colors.text.primary
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
                    text: qsTr("Reset")
                    variant: NordicButton.Variant.Secondary
                    size: NordicButton.Size.Sm
                    onClicked: {
                        root.loadDefaultLayout()
                        root.saveLayout()
                        widgetPicker.close()
                    }
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
                        model: WidgetRegistry.getAllTypes()
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 72
                            radius: NordicTheme.shapes.radius_md
                            color: pickerMA.containsMouse ? NordicTheme.colors.bg.surface : NordicTheme.colors.bg.secondary
                            border.color: pickerMA.containsMouse ? Theme.accent : "transparent"
                            border.width: 1
                            
                            property var reg: WidgetRegistry.get(modelData) || {}
                            
                            Behavior on color { enabled: !root.reducedMotion; ColorAnimation { duration: 150 } }
                            
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
                            }  // RowLayout
                        }  // Rectangle (picker item)
                    }  // Repeater
                }  // GridLayout
            }  // ScrollView
        }  // ColumnLayout (contentItem)
    }  // Popup (widgetPicker)
}  // Item (root)
