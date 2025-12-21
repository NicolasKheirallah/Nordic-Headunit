import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import NordicHeadunit
import "../../Components"

SettingsSubPage {
    title: qsTr("Language")
    
    ListView {
        Layout.fillWidth: true
        Layout.preferredHeight: contentHeight
        
        // Expose available languages
        model: TranslationService.availableLanguages
        
        delegate: NordicListItem {
            width: parent.width
            text: modelData
            
            // Show checkmark if selected
            // Show checkmark if selected
            trailing: Component {
                NordicIcon {
                    source: "qrc:/qt/qml/NordicHeadunit/assets/icons/focus.svg" 
                    color: NordicTheme.colors.accent.primary
                    visible: modelData === TranslationService.currentLanguage
                    size: NordicIcon.Size.MD
                }
            }
            
            onClicked: {
                TranslationService.selectLanguage(modelData)
                // Optional: Go back automatically? 
                // stackView.pop() // No, user might want to confirm it changed
            }
        }
    }
}
