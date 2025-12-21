import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

// Radio View - Dedicated Radio Tuner Surface
// Manual tuning, seek, presets, station search
Item {
    id: root
    
    // Safe properties
    readonly property string radioFrequency: MediaService?.radioFrequency ?? "101.5"
    readonly property string radioName: MediaService?.radioName ?? "Radio 1"
    readonly property int currentRadioIndex: MediaService?.currentRadioIndex ?? 0
    readonly property var radioStations: MediaService?.radioStations ?? []
    readonly property bool playing: MediaService?.playing ?? false
    
    // Internal state for manual tuning
    property real manualFrequency: 101.5
    property int selectedBand: 0  // 0=FM, 1=AM, 2=DAB
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20
        
        // Band Selector (FM / AM / DAB)
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            
            Repeater {
                model: ["FM", "AM", "DAB"]
                
                Rectangle {
                    width: 80; height: 40
                    radius: 20
                    color: root.selectedBand === index ? NordicTheme.colors.accent.primary : 
                           bandMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 14
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
        
        // Main Tuner Display with Fine Controls
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            radius: 24
            color: NordicTheme.colors.bg.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16
                
                // Seek Previous Station
                TunerButton {
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/skip_previous.svg"
                    label: "Seek"
                    onClicked: {
                        var idx = root.currentRadioIndex - 1
                        if (idx < 0) idx = root.radioStations.length - 1
                        if (MediaService) MediaService.tuneRadioByIndex(idx)
                    }
                }
                
                // Tune Down (-0.1)
                TunerButton {
                    icon: ""
                    label: "- 0.1"
                    large: false
                    onClicked: {
                        root.manualFrequency = Math.max(87.5, root.manualFrequency - 0.1)
                        if (MediaService) MediaService.tuneToFrequency(root.manualFrequency.toFixed(1))
                    }
                }
                
                // Frequency Display
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 4
                            
                            Text {
                                text: root.radioFrequency
                                font.pixelSize: 56
                                font.weight: Font.Bold
                                font.family: "Helvetica"
                                color: NordicTheme.colors.accent.primary
                            }
                            
                            Text {
                                text: root.selectedBand === 0 ? "FM" : root.selectedBand === 1 ? "AM" : "DAB"
                                font.pixelSize: 20
                                font.weight: Font.Medium
                                font.family: "Helvetica"
                                color: NordicTheme.colors.text.secondary
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: 10
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
                
                // Tune Up (+0.1)
                TunerButton {
                    icon: ""
                    label: "+ 0.1"
                    large: false
                    onClicked: {
                        root.manualFrequency = Math.min(108.0, root.manualFrequency + 0.1)
                        if (MediaService) MediaService.tuneToFrequency(root.manualFrequency.toFixed(1))
                    }
                }
                
                // Seek Next Station
                TunerButton {
                    icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/skip_next.svg"
                    label: "Seek"
                    onClicked: {
                        var idx = (root.currentRadioIndex + 1) % Math.max(1, root.radioStations.length)
                        if (MediaService) MediaService.tuneRadioByIndex(idx)
                    }
                }
            }
        }
        
        // Controls Row: Play + Scan
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24
            
            // Scan Button
            Rectangle {
                width: 120; height: 48
                radius: 24
                color: scanMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                border.width: 1
                border.color: NordicTheme.colors.border.muted
                
                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/search.svg"
                        size: NordicIcon.Size.SM
                        color: NordicTheme.colors.text.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        text: "Scan"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.family: "Helvetica"
                        color: NordicTheme.colors.text.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    id: scanMouse
                    anchors.fill: parent
                    onClicked: {
                        if (MediaService) MediaService.scanRadioStations()
                    }
                }
            }
            
            // Play/Pause Button
            Rectangle {
                width: 72; height: 72
                radius: 36
                color: playMouse.pressed ? NordicTheme.colors.accent.secondary : NordicTheme.colors.accent.primary
                
                NordicIcon {
                    anchors.centerIn: parent
                    source: root.playing ? "qrc:/qt/qml/NordicHeadunit/assets/icons/pause.svg" : "qrc:/qt/qml/NordicHeadunit/assets/icons/play.svg"
                    size: NordicIcon.Size.LG
                    color: "white"
                }
                
                MouseArea {
                    id: playMouse
                    anchors.fill: parent
                    onClicked: {
                        if (MediaService) MediaService.togglePlayPause()
                    }
                }
            }
            
            // Favorite Button
            Rectangle {
                width: 120; height: 48
                radius: 24
                color: favMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                border.width: 1
                border.color: NordicTheme.colors.border.muted
                
                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    NordicIcon {
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/heart.svg"
                        size: NordicIcon.Size.SM
                        color: NordicTheme.colors.text.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Text {
                        text: "Save"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.family: "Helvetica"
                        color: NordicTheme.colors.text.primary
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                MouseArea {
                    id: favMouse
                    anchors.fill: parent
                    onClicked: {
                        // TODO: Save to presets
                    }
                }
            }
        }
        
        // Presets Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Text {
                text: "Presets"
                font.pixelSize: 16
                font.weight: Font.Medium
                font.family: "Helvetica"
                color: NordicTheme.colors.text.secondary
            }
            
            GridLayout {
                Layout.fillWidth: true
                columns: 6
                rowSpacing: 12
                columnSpacing: 12
                
                Repeater {
                    model: root.radioStations
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 64
                        radius: 12
                        color: modelData.active ? NordicTheme.colors.accent.primary :
                               presetMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.surface
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.frequency
                                font.pixelSize: 16
                                font.weight: Font.Medium
                                font.family: "Helvetica"
                                color: modelData.active ? "white" : NordicTheme.colors.text.primary
                            }
                            
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.name
                                font.pixelSize: 11
                                font.family: "Helvetica"
                                color: modelData.active ? Qt.rgba(1,1,1,0.7) : NordicTheme.colors.text.tertiary
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
        
        Item { Layout.fillHeight: true }
    }
    
    // =========================================================================
    // TUNER BUTTON COMPONENT
    // =========================================================================
    component TunerButton: Rectangle {
        property string icon: ""
        property string label: ""
        property bool large: true
        
        signal clicked()
        
        width: large ? 64 : 56
        height: large ? 64 : 56
        radius: large ? 32 : 12
        color: tunerMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.primary
        
        Column {
            anchors.centerIn: parent
            spacing: 2
            
            NordicIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                source: icon
                size: NordicIcon.Size.SM
                color: NordicTheme.colors.text.primary
                visible: icon !== ""
            }
            
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: label
                font.pixelSize: icon === "" ? 16 : 10
                font.weight: icon === "" ? Font.Bold : Font.Normal
                font.family: "Helvetica"
                color: NordicTheme.colors.text.primary
            }
        }
        
        MouseArea {
            id: tunerMouse
            anchors.fill: parent
            onClicked: parent.clicked()
        }
    }
}
