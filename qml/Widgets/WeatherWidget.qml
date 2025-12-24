import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Time & Weather Widget - Responsive Refactor
// Adapts layout direction based on aspect ratio to prevent overlap.
Item {
    id: root
    
    // -------------------------------------------------------------------------
    // Size Detection
    // -------------------------------------------------------------------------
    readonly property bool isCompact: width < 210 || height < 120
    readonly property bool isWide: width > height * 1.5
    readonly property bool isLarge: width >= 300 && height >= 250 // Supports forecast
    
    // -------------------------------------------------------------------------
    // Data (Simulated)
    // -------------------------------------------------------------------------
    property string currentTime: Qt.formatTime(new Date(), "HH:mm")
    property string currentDate: Qt.formatDate(new Date(), "ddd, MMM d")
    property int temperature: -2
    property string condition: qsTr("Cloudy")
    property string conditionIcon: "weather_cloudy"
    
    property var weekForecast: [
        { day: qsTr("Mon"), temp: -3, icon: "weather_snow" },
        { day: qsTr("Tue"), temp: -1, icon: "weather_cloudy" },
        { day: qsTr("Wed"), temp: 2, icon: "weather_partly_cloudy" },
        { day: qsTr("Thu"), temp: 5, icon: "weather_sunny" },
        { day: qsTr("Fri"), temp: 4, icon: "weather_partly_cloudy" }
    ]
    
    // Update Timers
    Timer {
        interval: 1000; running: true; repeat: true; triggeredOnStart: true
        onTriggered: {
            var format = "HH:mm"
            var now = new Date()
            
            if (typeof SystemSettings !== "undefined") {
                format = SystemSettings.use24HourFormat ? "HH:mm" : "h:mm AP"
                try {
                    now = SystemSettings.currentDateTime
                } catch(e) {
                    console.log("Error accessing SystemSettings.currentDateTime: " + e)
                }
            }
            
            root.currentTime = Qt.formatTime(now, format)
            root.currentDate = Qt.formatDate(now, "ddd, MMM d")
        }
    }
    
    // -------------------------------------------------------------------------
    // UI Layout
    // -------------------------------------------------------------------------
    NordicCard {
        anchors.fill: parent
        variant: NordicCard.Variant.Glass
        
        // Main Container
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: NordicTheme.spacing.space_3
            spacing: NordicTheme.spacing.space_2
            
            // Top Section: Time + Current Weather
            // Use RowLayout if Wide, ColumnLayout if Compact/Square
            Loader {
                Layout.fillWidth: true
                Layout.fillHeight: true // Take all space if forecast hidden
                
                sourceComponent: root.isWide ? wideLayout : verticalLayout
            }
            
            // Bottom Section: Forecast (Only if Large)
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                Layout.minimumHeight: 40
                visible: root.isLarge
                spacing: NordicTheme.spacing.space_2
                
                // Divider
                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: NordicTheme.colors.border.muted }
                
                // Forecast Items
                Repeater {
                    model: root.weekForecast
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        NordicText { 
                            text: modelData.day 
                            type: NordicText.Type.Caption
                            color: NordicTheme.colors.text.tertiary 
                            Layout.alignment: Qt.AlignHCenter 
                        }
                        NordicIcon { 
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/" + modelData.icon + ".svg"
                            size: NordicIcon.Size.SM
                            color: NordicTheme.colors.text.secondary
                            Layout.alignment: Qt.AlignHCenter
                        }
                        NordicText { 
                            text: modelData.temp + "°" 
                            type: NordicText.Type.BodySmall
                            color: modelData.temp < 0 ? Theme.info : NordicTheme.colors.text.primary
                            Layout.alignment: Qt.AlignHCenter 
                        }
                    }
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // Layout Components
    // -------------------------------------------------------------------------
    
    // WIDE (Row) Layout: [Time/Date]   <Space>   [Icon Temp]
    Component {
        id: wideLayout
        RowLayout {
            spacing: NordicTheme.spacing.space_3
            
            // Left: Time & Date
            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true // Allow taking space
                spacing: 0
                NordicText {
                    text: root.currentTime
                    type: NordicText.Type.DisplayMedium
                    color: NordicTheme.colors.text.primary
                    Layout.fillWidth: true
                    fontSizeMode: Text.Fit; minimumPixelSize: 16
                }
                NordicText {
                    text: root.currentDate
                    type: NordicText.Type.BodyLarge
                    color: NordicTheme.colors.text.tertiary
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    fontSizeMode: Text.Fit; minimumPixelSize: 12
                }
            }
            
            Item { Layout.fillWidth: true; Layout.minimumWidth: 16 } // Spacer
            
            // Right: Weather
            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                spacing: NordicTheme.spacing.space_3
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/" + root.conditionIcon + ".svg"
                    size: NordicIcon.Size.LG
                    color: Theme.accent
                }
                
                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 0
                    NordicText {
                        text: root.temperature + "°"
                        type: NordicText.Type.DisplaySmall
                        color: root.temperature < 0 ? Theme.info : Theme.accent
                        fontSizeMode: Text.Fit; minimumPixelSize: 16
                    }
                    NordicText {
                        text: root.condition
                        type: NordicText.Type.Caption
                        color: NordicTheme.colors.text.secondary
                        elide: Text.ElideRight
                        Layout.maximumWidth: 100 // Prevent pushing too wide
                    }
                }
            }
        }
    }
    
    // VERTICAL (Stacked) Layout: [Time] [Icon + Temp]
    Component {
        id: verticalLayout
        ColumnLayout {
            spacing: NordicTheme.spacing.space_1
            
            // Time Centered
            NordicText {
                text: root.currentTime
                type: root.isCompact ? NordicText.Type.TitleLarge : NordicText.Type.DisplaySmall
                color: NordicTheme.colors.text.primary
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit; minimumPixelSize: 18
            }
            
            // Date (Hide if very compact)
            NordicText {
                visible: !root.isCompact
                text: root.currentDate
                type: NordicText.Type.BodyMedium
                color: NordicTheme.colors.text.tertiary
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.Fit; minimumPixelSize: 12
            }
            
            Item { Layout.fillHeight: true } // Spacer
            
            // Weather Row Centered
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: NordicTheme.spacing.space_2
                
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/" + root.conditionIcon + ".svg"
                    size: root.isCompact ? NordicIcon.Size.SM : NordicIcon.Size.MD
                    color: NordicTheme.colors.text.primary
                }
                
                NordicText {
                    text: root.temperature + "°"
                    type: root.isCompact ? NordicText.Type.TitleMedium : NordicText.Type.HeadlineSmall
                    color: root.temperature < 0 ? Theme.info : Theme.accent
                    fontSizeMode: Text.Fit; minimumPixelSize: 16
                }
            }
        }
    }
}
