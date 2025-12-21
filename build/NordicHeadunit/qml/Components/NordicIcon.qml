import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import NordicHeadunit

Item {
    id: root
    
    // Size Options
    enum Size { XS, SM, MD, LG, XL, XXL }
    property int size: NordicIcon.Size.MD
    
    // Color property - applied via MultiEffect colorization
    property color color: NordicTheme.colors.text.primary
    
    readonly property int iconSizePx: {
        switch (size) {
            case NordicIcon.Size.XS: return 16
            case NordicIcon.Size.SM: return 20
            case NordicIcon.Size.MD: return 24
            case NordicIcon.Size.LG: return 32
            case NordicIcon.Size.XL: return 48
            case NordicIcon.Size.XXL: return 64
            default: return 24
        }
    }
    
    // Source property
    property alias source: iconImage.source
    
    // Size
    implicitWidth: iconSizePx
    implicitHeight: iconSizePx
    width: implicitWidth
    height: implicitHeight
    
    // Hidden source image
    Image {
        id: iconImage
        anchors.fill: parent
        sourceSize: Qt.size(root.iconSizePx, root.iconSizePx)
        fillMode: Image.PreserveAspectFit
        mipmap: true
        visible: false // Hidden - we show the colorized version
    }
    
    // Colorized version using MultiEffect (Qt 6.5+)
    // REQUIRES: QtQuick.Effects import and Qt6::QuickEffects in CMake
    MultiEffect {
        anchors.fill: iconImage
        source: iconImage
        visible: iconImage.status === Image.Ready
        
        // Colorization to tint the icon
        colorization: 1.0
        colorizationColor: root.color
    }
}
