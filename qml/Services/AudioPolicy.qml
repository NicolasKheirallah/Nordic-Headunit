import QtQuick

Item {
    id: root
    
    // States
    property bool mediaPlaying: false
    property bool phoneCallActive: false
    property bool voiceAssistantActive: false
    property bool navigationAnnouncement: false
    
    // Derived Audio Focus State
    property string focusState: {
        if (phoneCallActive) return "call"
        if (voiceAssistantActive || navigationAnnouncement) return "duck"
        if (mediaPlaying) return "media"
        return "idle"
    }
    
    property real targetVolume: {
        switch(focusState) {
            case "call": return 0.0 // Media silent
            case "duck": return 0.3 // Media ducked
            default: return 1.0
        }
    }
    
    // Signals
    signal duckMedia()
    signal unduckMedia()
    signal pauseMedia()
    
    onFocusStateChanged: {
        console.log("Audio Focus Changed: " + focusState)
    }
}
