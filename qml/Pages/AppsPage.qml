import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// ═══════════════════════════════════════════════════════════════════════════
// Apps Page - Android-style App Launcher
// ═══════════════════════════════════════════════════════════════════════════
Page {
    id: root
    
    background: Rectangle { color: NordicTheme.colors.bg.primary }
    
    // Accessibility
    readonly property bool reducedMotion: SystemSettings.reducedMotion
    
    // -------------------------------------------------------------------------
    // Responsive Layout
    // -------------------------------------------------------------------------
    readonly property int columns: {
        if (width < 800) return 4
        if (width < 1200) return 5
        return 6
    }
    readonly property int iconSize: {
        if (width < 800) return 64
        if (width < 1200) return 72
        return 80
    }
    readonly property int tileWidth: Math.max(80, Math.floor((width - 48) / Math.max(1, columns)))
    readonly property int tileHeight: Math.max(100, iconSize + 48) // Icon + label + padding
    
    // -------------------------------------------------------------------------
    // Categories & Sorting
    // -------------------------------------------------------------------------
    readonly property var categories: ["All", "Media", "Navigation", "Communication", "Vehicle", "Tools"]
    property string selectedCategory: "All"
    property string sortMode: "name" // name, recent, category
    readonly property var sortOptions: [
        { key: "name", label: qsTr("A-Z") },
        { key: "recent", label: qsTr("Recent") },
        { key: "category", label: qsTr("Category") }
    ]
    
    // -------------------------------------------------------------------------
    // State bindings
    // -------------------------------------------------------------------------
    readonly property bool isLoading: AppModel.count === 0 && !AppModel.hasError
    readonly property bool hasResults: AppModel.count > 0
    readonly property bool isSearching: searchField.text.length > 0
    readonly property bool hasError: AppModel.hasError
    readonly property bool hasRecentApps: AppModel.recentApps.length > 0
    
    // Launch animation state
    property string launchingAppId: ""
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: NordicTheme.spacing.space_4
        spacing: NordicTheme.spacing.space_4
        
        // ---------------------------------------------------------------------
        // Header: Search + Sort + Title
        // ---------------------------------------------------------------------
        RowLayout {
            Layout.fillWidth: true
            spacing: NordicTheme.spacing.space_3
            
            NordicText {
                text: qsTr("Apps")
                type: NordicText.Type.HeadlineMedium
                color: Theme.textPrimary
            }
            
            // App count badge
            Rectangle {
                visible: AppModel.count > 0
                Layout.leftMargin: -NordicTheme.spacing.space_2
                width: countText.implicitWidth + 16
                height: 24
                radius: 12
                color: Theme.surfaceAlt
                
                NordicText {
                    id: countText
                    anchors.centerIn: parent
                    text: AppModel.count
                    type: NordicText.Type.Caption
                    color: Theme.textSecondary
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Sort Menu Button
            Rectangle {
                Layout.preferredWidth: sortRow.width + 24
                Layout.preferredHeight: 40
                radius: 20
                color: sortMouse.pressed ? Theme.surfaceAlt : Theme.surfaceAlt
                
                Row {
                    id: sortRow
                    anchors.centerIn: parent
                    spacing: 6
                    
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/list.svg"
                        size: NordicIcon.Size.SM
                        color: Theme.textSecondary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    NordicText {
                        text: root.sortOptions.find(o => o.key === root.sortMode)?.label ?? "A-Z"
                        type: NordicText.Type.BodySmall
                        color: Theme.textSecondary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    id: sortMouse
                    anchors.fill: parent
                    onClicked: sortMenu.open()
                }
                
                // Sort Dropdown Menu
                Menu {
                    id: sortMenu
                    y: parent.height + 4
                    
                    Repeater {
                        model: root.sortOptions
                        MenuItem {
                            text: modelData.label
                            checkable: true
                            checked: root.sortMode === modelData.key
                            onTriggered: {
                                root.sortMode = modelData.key
                                AppModel.sortMode = modelData.key
                            }
                        }
                    }
                }
            }
            
            // Search Field
            NordicTextField {
                id: searchField
                Layout.preferredWidth: 280
                placeholderText: qsTr("Search apps...")
                
                onTextChanged: {
                    searchDebounce.restart()
                }
                
                Timer {
                    id: searchDebounce
                    interval: 150
                    onTriggered: AppModel.searchQuery = searchField.text
                }
            }
        }
        
        // ---------------------------------------------------------------------
        // Category Chips
        // ---------------------------------------------------------------------
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff
            clip: true
            
            Row {
                spacing: NordicTheme.spacing.space_2
                
                Repeater {
                    model: root.categories
                    
                    Rectangle {
                        width: chipText.implicitWidth + 32
                        height: 40
                        radius: 20
                        color: modelData === root.selectedCategory 
                            ? Theme.accent 
                            : Theme.surfaceAlt
                        
                        NordicText {
                            id: chipText
                            anchors.centerIn: parent
                            text: modelData
                            type: NordicText.Type.BodyMedium
                            color: modelData === root.selectedCategory 
                                ? "white" 
                                : Theme.textSecondary
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.selectedCategory = modelData
                                AppModel.categoryFilter = modelData === "All" ? "" : modelData
                            }
                        }
                        
                        Behavior on color { 
                            enabled: !root.reducedMotion
                            ColorAnimation { duration: 150 } 
                        }
                    }
                }
            }
        }
        
        // ---------------------------------------------------------------------
        // Recently Used Section
        // ---------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            visible: root.hasRecentApps && !root.isSearching && root.selectedCategory === "All"
            spacing: NordicTheme.spacing.space_2
            
            NordicText {
                text: qsTr("Recently Used")
                type: NordicText.Type.TitleSmall
                color: Theme.textSecondary
            }
            
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: root.tileHeight
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                clip: true
                
                Row {
                    spacing: NordicTheme.spacing.space_2
                    
                    Repeater {
                        model: AppModel.recentApps
                        
                        AppTile {
                            width: root.tileWidth
                            height: root.tileHeight
                            iconSize: root.iconSize
                            
                            appId: modelData.appId
                            displayName: modelData.displayName
                            iconUrl: modelData.iconUrl
                            isEnabled: modelData.isEnabled
                            isPinned: false
                            
                            onClicked: {
                                if (modelData.isEnabled) {
                                    AppModel.launchApp(modelData.appId)
                                }
                            }
                        }
                    }
                }
            }
            
            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Theme.surfaceAlt
            }
        }
        
        // ---------------------------------------------------------------------
        // Error State
        // ---------------------------------------------------------------------
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.hasError
            spacing: NordicTheme.spacing.space_4
            
            Item { Layout.fillHeight: true }
            
            NordicIcon {
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/qt/qml/NordicHeadunit/assets/icons/wifi.svg"
                size: NordicIcon.Size.XXL
                color: Theme.textTertiary
            }
            
            NordicText {
                Layout.alignment: Qt.AlignHCenter
                text: AppModel.errorMessage || qsTr("Unable to load apps")
                type: NordicText.Type.TitleMedium
                color: Theme.textSecondary
            }
            
            NordicButton {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Retry")
                variant: NordicButton.Variant.Primary
                onClicked: AppModel.refresh()
            }
            
            Item { Layout.fillHeight: true }
        }
        
        // ---------------------------------------------------------------------
        // App Grid
        // ---------------------------------------------------------------------
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            // Loading State
            GridView {
                id: loadingGrid
                anchors.fill: parent
                visible: root.isLoading
                cellWidth: root.tileWidth
                cellHeight: root.tileHeight
                interactive: false
                
                model: 12 // Skeleton count
                
                delegate: Item {
                    width: root.tileWidth
                    height: root.tileHeight
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        // Skeleton Icon
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: root.iconSize
                            height: root.iconSize
                            radius: NordicTheme.shapes.radius_lg
                            color: Theme.surfaceAlt
                            // opacity handled by Animation
                            
                            SequentialAnimation on opacity {
                                id: skeletonAnim
                                loops: Animation.Infinite
                                running: !root.reducedMotion
                                NumberAnimation { to: 0.3; duration: 800 }
                                NumberAnimation { to: 0.6; duration: 800 }
                            }
                        }
                        
                        // Skeleton Label
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 48
                            height: 12
                            radius: 6
                            color: Theme.surfaceAlt
                            opacity: 0.4
                        }
                    }
                }
            }
            
            // Apps Grid
            GridView {
                id: appsGrid
                anchors.fill: parent
                anchors.rightMargin: alphabetScroller.visible ? 28 : 0
                visible: root.hasResults
                cellWidth: root.tileWidth
                cellHeight: root.tileHeight
                clip: true
                
                model: AppModel
                
                // Focus handling
                focus: true
                keyNavigationEnabled: true
                highlightFollowsCurrentItem: true
                
                delegate: AppTile {
                    width: root.tileWidth
                    height: root.tileHeight
                    iconSize: root.iconSize
                    
                    appId: model.appId
                    displayName: model.displayName
                    iconUrl: model.iconUrl
                    isEnabled: model.isEnabled
                    isPinned: model.isPinned
                    
                    // Launch animation state
                    opacity: root.launchingAppId === model.appId ? 0.5 : 1.0
                    scale: root.launchingAppId === model.appId ? 1.15 : 1.0
                    Behavior on opacity { enabled: !root.reducedMotion; NumberAnimation { duration: 200 } }
                    Behavior on scale { enabled: !root.reducedMotion; NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                    
                    onClicked: {
                        if (model.isEnabled) {
                            // Launch animation
                            root.launchingAppId = model.appId
                            launchResetTimer.restart()
                            AppModel.launchApp(model.appId)
                        }
                    }
                    
                    onPinToggled: {
                        AppModel.togglePin(model.appId)
                    }
                }
                
                // Scroll behavior
                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                boundsBehavior: Flickable.StopAtBounds
                
                // Smooth scrolling
                flickDeceleration: 3000
                maximumFlickVelocity: 3000
            }
            
            // A-Z Fast Scroller (Side Rail)
            Rectangle {
                id: alphabetScroller
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 24
                visible: AppModel.count > 20 && root.sortMode === "name"
                color: "transparent"
                
                Column {
                    anchors.centerIn: parent
                    spacing: 2
                    
                    Repeater {
                        model: ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]
                        
                        Rectangle {
                            width: 20
                            height: Math.max(12, (alphabetScroller.height - 60) / 27)
                            radius: 4
                            color: letterMouse.containsMouse ? Theme.accent : "transparent"
                            
                            NordicText {
                                anchors.centerIn: parent
                                text: modelData
                                type: NordicText.Type.Caption
                                font.pixelSize: 9
                                color: letterMouse.containsMouse ? "white" : Theme.textTertiary
                            }
                            
                            MouseArea {
                                id: letterMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    // Find first app starting with this letter
                                    for (var i = 0; i < AppModel.count; i++) {
                                        var name = AppModel.data(AppModel.index(i, 0), 258) // DisplayNameRole
                                        if (name && name.toUpperCase().startsWith(modelData)) {
                                            appsGrid.positionViewAtIndex(i, GridView.Beginning)
                                            break
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Launch reset timer
            Timer {
                id: launchResetTimer
                interval: 400
                onTriggered: root.launchingAppId = ""
            }
            
            // Empty State
            ColumnLayout {
                anchors.centerIn: parent
                visible: !root.hasResults && !root.isLoading
                spacing: NordicTheme.spacing.space_3
                
                NordicIcon {
                    Layout.alignment: Qt.AlignHCenter
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/search.svg"
                    size: NordicIcon.Size.XXL
                    color: Theme.textTertiary
                }
                
                NordicText {
                    Layout.alignment: Qt.AlignHCenter
                    text: root.isSearching 
                        ? qsTr("No apps match \"%1\"").arg(searchField.text)
                        : qsTr("No apps installed")
                    type: NordicText.Type.TitleMedium
                    color: Theme.textSecondary
                }
                
                NordicButton {
                    visible: root.isSearching
                    Layout.alignment: Qt.AlignHCenter
                    text: qsTr("Clear Search")
                    variant: NordicButton.Variant.Secondary
                    onClicked: searchField.text = ""
                }
            }
        }
    }
}
