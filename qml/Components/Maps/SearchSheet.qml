import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

// Bottom Sheet for Search
NordicCard {
    id: root
    
    // API
    signal searchRequested(string query)
    signal resultSelected(var resultData)
    signal closed()
    
    property alias searchText: searchInput.text
    property ListModel resultsModel: ListModel {} // External controller populates this
    
    // Sheet Props
    // anchors.bottom: parent.bottom // REMOVED: Managed by MapPage via 'y' property for animation
    
    // Glassmorphism Style
    
    // Glassmorphism Style handled by NordicCard.Variant.Glass
    variant: NordicCard.Variant.Glass 
    
    // Custom height logic
    width: 380
    height: Math.min(600, 160 + (resultsList.count * 72)) // Dynamic height
    
    // Custom height logic 
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        
        // Drag Handle
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 40; height: 4
            color: Theme.surface
            radius: 2
        }
        
        // Search Input Container (Dark Glassmorphic Pill)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            color: Qt.rgba(0, 0, 0, 0.3) // Dark semi-transparent
            radius: 28 // Pill shape
            border.color: Qt.rgba(255, 255, 255, 0.15)
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12
                
                NordicIcon { 
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/search.svg" 
                    size: NordicIcon.Size.MD
                    color: Theme.textSecondary
                }
                
                NordicTextField {
                    id: searchInput
                    Layout.fillWidth: true
                    placeholderText: qsTr("Where to?")
                    background: Item {} // Remove default background of TextField to blend in
                    onTextEdited: root.searchRequested(text)
                    focus: true // Auto focus on open
                }
                
                NordicButton {
                    text: "✕"
                    variant: NordicButton.Variant.Tertiary
                    visible: searchInput.text !== ""
                    onClicked: {
                        searchInput.text = ""
                        root.closed()
                    }
                }
            }
        }
        
        // Content Area (Results or Suggestions)
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            // A. Search Results (Visible when typing)
            ListView {
                id: resultsList
                anchors.fill: parent
                visible: searchInput.text.length > 0
                model: root.resultsModel
                delegate: NordicListItem {
                    width: ListView.view.width
                    text: model.name
                    secondaryText: model.address
                    leading: NordicIcon { source: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg" }
                    onClicked: root.resultSelected(model)
                }
            }
            
            // B. Explore / Recents (Visible when empty)
            ColumnLayout {
                anchors.fill: parent
                visible: searchInput.text.length === 0
                spacing: 24
                
                // 1. Categories
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    component CategoryChip : Rectangle {
                        property string label
                        property string icon
                        signal clicked()
                        
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        radius: 16
                        // Dark glassmorphic look
                        color: mouse.containsMouse 
                            ? Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.2)
                            : Qt.rgba(0, 0, 0, 0.25)
                        border.color: Qt.rgba(255, 255, 255, 0.1)
                        border.width: 1
                        
                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 8
                            NordicIcon { 
                                source: icon; 
                                size: NordicIcon.Size.MD; 
                                color: Theme.accent 
                                Layout.alignment: Qt.AlignHCenter
                            }
                            NordicText { 
                                text: label; 
                                type: NordicText.Type.Caption; 
                                Layout.alignment: Qt.AlignHCenter 
                            }
                        }
                        MouseArea { 
                            id: mouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: parent.clicked() 
                        }
                    }
                    
                    CategoryChip { label: "Gas"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/gas-station.svg"; onClicked: NavigationService.searchCategory("Gas Station") }
                    CategoryChip { label: "Food"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/food-dinner.svg"; onClicked: NavigationService.searchCategory("Restaurant") }
                    CategoryChip { label: "Parking"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/parking-location.svg"; onClicked: NavigationService.searchCategory("Parking") }
                    CategoryChip { label: "Coffee"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/cup-of-coffee.svg"; onClicked: NavigationService.searchCategory("Coffee Shop") }
                }
                
                // 2. Recent Searches
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    
                    NordicText {
                        text: "Recent Searches"
                        type: NordicText.Type.TitleSmall
                        color: Theme.textSecondary
                    }
                    
                    Repeater {
                        model: NavigationService.recentSearches
                        delegate: NordicListItem {
                            width: parent.width
                            text: modelData
                            leading: NordicIcon { source: "qrc:/qt/qml/NordicHeadunit/assets/icons/clock.svg" }
                            onClicked: {
                                searchInput.text = modelData
                                NavigationService.searchPlaces(modelData)
                            }
                        }
                    }
                    
                    // Empty State for Recents
                    NordicText {
                        visible: NavigationService.recentSearches.length === 0
                        text: "No recent searches"
                        type: NordicText.Type.BodySmall
                        color: Theme.textTertiary
                        Layout.topMargin: 8
                    }
                }
                
                Item { Layout.fillHeight: true } // Spacer
            }
        }
    }
}
