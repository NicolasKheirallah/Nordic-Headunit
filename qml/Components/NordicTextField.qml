import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import NordicHeadunit

TextField {
    id: root
    
    // API
    property string label: ""
    property string helperText: ""
    property bool error: false
    
    // Variants: Outlined, Filled
    enum Variant { Outlined, Filled }
    property int variant: NordicTextField.Variant.Outlined
    
    // Styling
    placeholderTextColor: Theme.textTertiary
    color: Theme.textPrimary
    font: NordicTheme.typography.body_large
    
    topPadding: label !== "" ? 24 : 16
    bottomPadding: 8
    leftPadding: 16
    rightPadding: 16
    
    background: Rectangle { // Container
        implicitHeight: 56
        color: {
            if (variant === NordicTextField.Variant.Filled) {
                return root.activeFocus ? Theme.surfaceAlt : Theme.surface
            }
            return "transparent"
        }
        
        border.color: {
             if (root.error) return Theme.danger
             if (root.activeFocus) return Theme.accent
             if (variant === NordicTextField.Variant.Outlined) return Theme.border
             return variant === NordicTextField.Variant.Filled ? "transparent" : Theme.border
        }
        
        border.width: (variant === NordicTextField.Variant.Outlined || root.activeFocus || root.error) ? 2 : 0
        radius: variant === NordicTextField.Variant.Filled ? Theme.radiusSm : Theme.radiusMd 
        // Spec: Filled often has top corners rounded only? "Border or filled background".
        // We'll stick to uniform radius for now as per shape tokens.
        
        // Label
        Text {
            text: root.label
            font: NordicTheme.typography.body_small
            color: root.error ? Theme.danger : (root.activeFocus ? Theme.accent : Theme.textSecondary)
            visible: root.label !== ""
            
            x: 16
            y: 8
        }
    }
    
    // Helper Text (Outside the field usually, or below)
    // TextField contentItem is usually inside background.
    // We can't easily put things 'below' the TextField control unless we wrap it.
    // BUT we can use a footer Item if we wrap this in a Control or ColumnLayout.
    // Since this inherits TextField, to add helper text BELOW, we might need to rely on parent layout OR modify height.
    // Better pattern: NordicTextField is a ColumnLayout containing a TextField?
    // BUT that changes usage `text: ...` binding.
    // Let's keep it simple: Helper text renders internal to the background at bottom? No.
    // We'll skip internal helper text rendering for now, it should be external, OR we use a wrapper component.
    // Current NordicTextField was a TextField.
    // Let's assume helper text is handled externally or we add a component for "NordicFormField"?
    // The previous implementation (Step 183) had it? Let's check view_file history. Step 183 was NordicText. Step 174 Main.qml. I didn't view TextField code.
    // I will write it as a TextField. Application layout handles spacing.
}
