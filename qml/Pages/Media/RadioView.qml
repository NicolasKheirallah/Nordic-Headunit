import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Radio View - Automotive-Optimized Tuner
// Presets are primary, Seek is obvious, no precision nonsense
Item {
    id: root
    
    // Safe properties
    readonly property string radioFrequency: MediaService?.radioFrequency ?? "102.5"
    readonly property string radioName: MediaService?.radioName ?? "Station"
    readonly property int currentRadioIndex: MediaService?.currentRadioIndex ?? 0
    readonly property var radioStations: MediaService?.radioStations ?? []
    readonly property bool playing: MediaService?.playing ?? false
    
    // Internal state
    property int selectedBand: 0  // 0=FM, 1=AM, 2=DAB
    property bool isScanning: false
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16
        
        // =====================================================================
        // BAND SELECTOR - Larger touch targets
        // =====================================================================
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12
            
            Repeater {
                model: ["FM", "AM", "DAB"]
                
                Rectangle {
                    width: 100; height: 48
                    radius: 24
                    color: root.selectedBand === index ? NordicTheme.colors.accent.primary : 
                           bandMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 16
                        font.weight: Font.Medium
                        font.family: "Helvetica"
                        color: root.selectedBand === index ? "white" : NordicTheme.colors.text.primary
                    }
                    
                    MouseArea {
                        id: bandMouse
                        anchors.fill: parent
                        onClicked: root.selectedBand = index
                    }
                }
            }
        }
        
        // =====================================================================
        // MAIN TUNER - Seek + Frequency + Seek
        // =====================================================================
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            radius: 20
            color: NordicTheme.colors.bg.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 0
                
                // SEEK BACKWARD - Tap = -0.1, Hold = search backward
                SeekButton {
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    direction: "backward"
                    onTapped: {
                        if (MediaService) MediaService.tuneStep(-0.1)
                    }
                    onHeld: {
                        if (MediaService) MediaService.seekBackward()
                    }
                }
                
                // FREQUENCY DISPLAY
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 8
                            
                            Text {
                                text: root.radioFrequency
                                font.pixelSize: 52
                                font.weight: Font.Bold
                                font.family: "Helvetica"
                                color: NordicTheme.colors.accent.primary
                            }
                            
                            Text {
                                text: root.selectedBand === 0 ? "FM" : root.selectedBand === 1 ? "AM" : "DAB"
                                font.pixelSize: 18
                                font.weight: Font.Medium
                                font.family: "Helvetica"
                                color: NordicTheme.colors.text.secondary
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 8
                            }
                        }
                        
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.radioName
                            font.pixelSize: 16
                            font.family: "Helvetica"
                            color: NordicTheme.colors.text.secondary
                        }
                    }
                }
                
                // SEEK FORWARD - Tap = +0.1, Hold = search forward
                SeekButton {
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    direction: "forward"
                    onTapped: {
                        if (MediaService) MediaService.tuneStep(0.1)
                    }
                    onHeld: {
                        if (MediaService) MediaService.seekForward()
                    }
                }
            }
        }
        
        // =====================================================================
        // ACTIONS - Scan + Mute + Save
        // =====================================================================
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 16
            
            // SCAN STATIONS
            ActionButton {
                text: root.isScanning ? "Scanning..." : "Scan Stations"
                icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/search.svg"
                onClicked: {
                    root.isScanning = true
                    if (MediaService) MediaService.scanRadioStations()
                    scanTimer.start()
                }
            }
            
            // MUTE (replaces Play/Pause for radio)
            Rectangle {
                width: 64; height: 64
                radius: 32
                color: muteMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                border.width: 2
                border.color: NordicTheme.colors.border.muted
                
                NordicIcon {
                    anchors.centerIn: parent
                    source: root.playing ? "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_up.svg" : "qrc:/qt/qml/NordicHeadunit/assets/icons/volume_off.svg"
                    size: NordicIcon.Size.MD
                    color: NordicTheme.colors.text.primary
                }
                
                MouseArea {
                    id: muteMouse
                    anchors.fill: parent
                    onClicked: {
                        if (MediaService) MediaService.togglePlayPause()
                    }
                }
            }
            
            // SAVE TO PRESET
            ActionButton {
                text: "Save"
                icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/heart.svg"
                onClicked: {
                    // TODO: Save current frequency to next available preset
                }
            }
        }
        
        // =====================================================================
        // PRESETS - Primary interaction, large targets
        // =====================================================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            
            Text {
                text: "Presets"
                font.pixelSize: 14
                font.weight: Font.Medium
                font.family: "Helvetica"
                color: NordicTheme.colors.text.tertiary
            }
            
            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 3
                rowSpacing: 12
                columnSpacing: 12
                
                Repeater {
                    model: root.radioStations
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 72
                        radius: 16
                        color: modelData.active ? NordicTheme.colors.accent.primary :
                               presetMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Column {
                                Layout.fillWidth: true
                                spacing: 2
                                
                                Text {
                                    text: modelData.frequency
                                    font.pixelSize: 20
                                    font.weight: Font.Bold
                                    font.family: "Helvetica"
                                    color: modelData.active ? "white" : NordicTheme.colors.text.primary
                                }
                                
                                Text {
                                    text: modelData.name
                                    font.pixelSize: 13
                                    font.family: "Helvetica"
                                    color: modelData.active ? Qt.rgba(1,1,1,0.7) : NordicTheme.colors.text.tertiary
                                }
                            }
                            
                            // Active indicator
                            Rectangle {
                                width: 8; height: 8
                                radius: 4
                                color: "white"
                                visible: modelData.active
                            }
                        }
                        
                        MouseArea {
                            id: presetMouse
                            anchors.fill: parent
                            onClicked: {
                                if (MediaService) MediaService.tuneRadioByIndex(modelData.index)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Scan timer to reset scanning state
    Timer {
        id: scanTimer
        interval: 3000
        onTriggered: root.isScanning = false
    }
    
    // =========================================================================
    // SEEK BUTTON COMPONENT
    // Tap = step ±0.1, Hold = search for station
    // =========================================================================
    component SeekButton: Rectangle {
        id: seekBtn
        property string direction: "forward"
        
        signal tapped()
        signal held()
        
        radius: 12
        color: seekMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.primary
        
        Column {
            anchors.centerIn: parent
            spacing: 4
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: seekBtn.direction === "forward" ? "SEEK" : "SEEK"
                font.pixelSize: 12
                font.weight: Font.Bold
                font.family: "Helvetica"
                color: NordicTheme.colors.text.primary
            }
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: seekBtn.direction === "forward" ? ">>" : "<<"
                font.pixelSize: 28
                font.weight: Font.Bold
                font.family: "Helvetica"
                color: NordicTheme.colors.accent.primary
            }
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "hold to scan"
                font.pixelSize: 9
                font.family: "Helvetica"
                color: NordicTheme.colors.text.tertiary
            }
        }
        
        MouseArea {
            id: seekMouse
            anchors.fill: parent
            
            property bool wasHeld: false
            
            onPressed: {
                wasHeld = false
                holdTimer.start()
            }
            
            onReleased: {
                holdTimer.stop()
                if (!wasHeld) {
                    seekBtn.tapped()
                }
            }
            
            Timer {
                id: holdTimer
                interval: 500
                onTriggered: {
                    seekMouse.wasHeld = true
                    seekBtn.held()
                }
            }
        }
    }
    
    // =========================================================================
    // ACTION BUTTON COMPONENT
    // =========================================================================
    component ActionButton: Rectangle {
        property string text: ""
        property string icon: ""
        
        signal clicked()
        
        width: 140; height: 48
        radius: 24
        color: actionMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
        border.width: 1
        border.color: NordicTheme.colors.border.muted
        
        Row {
            anchors.centerIn: parent
            spacing: 8
            
            NordicIcon {
                source: icon
                size: NordicIcon.Size.SM
                color: NordicTheme.colors.text.primary
                anchors.verticalCenter: parent.verticalCenter
                visible: icon !== ""
            }
            
            Text {
                text: parent.parent.text
                font.pixelSize: 14
                font.weight: Font.Medium
                font.family: "Helvetica"
                color: NordicTheme.colors.text.primary
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        MouseArea {
            id: actionMouse
            anchors.fill: parent
            onClicked: parent.clicked()
        }
    }
}
