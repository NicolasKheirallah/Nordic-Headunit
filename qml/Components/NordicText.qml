import QtQuick
import QtQuick.Controls
import NordicHeadunit

Item {
    id: root
    
    // API
    property string text: ""
    property int type: NordicText.Type.BodyLarge
    property color color: NordicTheme.colors.text.primary
    property int elide: Text.ElideRight
    property alias font: textItem.font
    property alias fontSizeMode: textItem.fontSizeMode
    property alias minimumPixelSize: textItem.minimumPixelSize
    property alias style: textItem.style
    property alias styleColor: textItem.styleColor
    
    property int wrapMode: Text.NoWrap // Default to NoWrap for single line scrolling
    property int horizontalAlignment: Text.AlignLeft
    property int verticalAlignment: Text.AlignTop
    
    // Marquee
    property bool autoScroll: false
    
    property real topPadding: 0
    property real bottomPadding: 0
    property real leftPadding: 0
    property real rightPadding: 0
    
    implicitWidth: textItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: textItem.implicitHeight + topPadding + bottomPadding
    clip: autoScroll
    
    Text {
        id: textItem
        x: root.leftPadding
        y: root.topPadding
        width: root.width - root.leftPadding - root.rightPadding
        text: root.text
        color: root.color
        elide: root.autoScroll ? Text.ElideNone : root.elide
        wrapMode: root.autoScroll ? Text.NoWrap : root.wrapMode
        horizontalAlignment: root.horizontalAlignment
        verticalAlignment: root.verticalAlignment
        
        // Font mapping
        font: {
            switch (root.type) {
                case NordicText.Type.DisplayHero: return NordicTheme.typography.display_hero
                case NordicText.Type.DisplayLarge: return NordicTheme.typography.display_large
                case NordicText.Type.DisplayMedium: return NordicTheme.typography.display_medium
                case NordicText.Type.DisplaySmall: return NordicTheme.typography.display_small
                case NordicText.Type.HeadlineLarge: return NordicTheme.typography.headline_large
                case NordicText.Type.HeadlineMedium: return NordicTheme.typography.headline_medium
                case NordicText.Type.HeadlineSmall: return NordicTheme.typography.headline_small
                case NordicText.Type.TitleLarge: return NordicTheme.typography.title_large
                case NordicText.Type.TitleMedium: return NordicTheme.typography.title_medium
                case NordicText.Type.TitleSmall: return NordicTheme.typography.title_small
                case NordicText.Type.BodyLarge: return NordicTheme.typography.body_large
                case NordicText.Type.BodyMedium: return NordicTheme.typography.body_medium
                case NordicText.Type.BodySmall: return NordicTheme.typography.body_small
                case NordicText.Type.Caption: return NordicTheme.typography.caption
                case NordicText.Type.Overline: return NordicTheme.typography.overline
                default: return NordicTheme.typography.body_large
            }
        }
        
        // Marquee Animation
        property bool shouldScroll: root.autoScroll && textItem.implicitWidth > root.width
        
        SequentialAnimation on x {
            id: marqueeAnim
            running: textItem.shouldScroll
            loops: Animation.Infinite
            alwaysRunToEnd: true
            
            // Wait
            PauseAnimation { duration: 2000 }
            // Scroll
            NumberAnimation {
                to: -(textItem.implicitWidth - root.width)
                duration: Math.max(0, (textItem.width - root.width) / 40 * 1000)
                easing.type: Easing.Linear
            }
            // Wait at end
            PauseAnimation { duration: 2000 }
            // Snap back
            PropertyAction { value: root.leftPadding }
        }
    }
    
    // Enums
    enum Type {
        DisplayHero, DisplayLarge, DisplayMedium, DisplaySmall,
        HeadlineLarge, HeadlineMedium, HeadlineSmall,
        TitleLarge, TitleMedium, TitleSmall,
        BodyLarge, BodyMedium, BodySmall,
        Caption, Overline
    }
}
