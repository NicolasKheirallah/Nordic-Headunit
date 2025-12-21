import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit

Rectangle {
    id: root
    
    // API
    property int bass: 0
    property int mid: 0
    property int treble: 0
    
    signal bassModified(int val)
    signal midModified(int val)
    signal trebleModified(int val)
    
    color: NordicTheme.colors.bg.surface
    radius: NordicTheme.shapes.radius_lg
    border.color: NordicTheme.colors.border.muted
    border.width: 1
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: NordicTheme.spacing.space_5
        spacing: NordicTheme.spacing.space_4
        
        // Bass
        EQBand {
            label: "Bass"
            value: root.bass
            onMoved: (val) => root.bassModified(val)
        }
        
        // Mid
        EQBand {
            label: "Mid"
            value: root.mid
            onMoved: (val) => root.midModified(val)
        }
        
        // Treble
        EQBand {
            label: "Treble"
            value: root.treble
            onMoved: (val) => root.trebleModified(val)
        }
    }
    
    component EQBand: ColumnLayout {
        property string label: ""
        property int value: 0
        signal moved(int val)
        
        Layout.fillHeight: true
        Layout.fillWidth: true
        spacing: NordicTheme.spacing.space_2
        
        // Value Text
        NordicText {
            Layout.alignment: Qt.AlignHCenter
            text: (value > 0 ? "+" : "") + value + " dB"
            type: NordicText.Type.Caption
            color: NordicTheme.colors.accent.primary
        }
        
        // Slider (Vertical)
        Slider {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            from: -10
            to: 10
            value: parent.value
            stepSize: 1
            orientation: Qt.Vertical
            
            onMoved: parent.moved(value)
            
            background: Rectangle {
                x: parent.leftPadding + parent.availableWidth / 2 - width / 2
                y: parent.topPadding
                implicitWidth: 6
                implicitHeight: 200
                width: implicitWidth
                height: parent.availableHeight
                radius: 3
                color: NordicTheme.colors.bg.elevated
                
                Rectangle {
                    width: parent.width
                    height: parent.height / 2 // Just visual fill logic if needed, but for EQ, center is 0
                    // For now simple background is fine
                }
            }
            
            handle: Rectangle {
                x: parent.leftPadding + parent.availableWidth / 2 - width / 2
                y: parent.topPadding + parent.visualPosition * (parent.availableHeight - height)
                implicitWidth: 24
                implicitHeight: 24
                radius: 12
                color: parent.pressed ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.primary
                border.color: NordicTheme.colors.bg.primary
                border.width: 2
            }
        }
        
        // Label
        NordicText {
            Layout.alignment: Qt.AlignHCenter
            text: label
            type: NordicText.Type.BodySmall
            color: NordicTheme.colors.text.secondary
        }
    }
}
