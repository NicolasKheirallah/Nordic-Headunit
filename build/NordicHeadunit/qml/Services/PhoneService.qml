pragma Singleton
import QtQuick

QtObject {
    id: phoneService
    
    // -------------------------------------------------------------------------
    // Properties
    // -------------------------------------------------------------------------
    
    // Call State
    readonly property string stateIdle: "Idle"
    readonly property string stateDialing: "Dialing..."
    readonly property string stateIncoming: "Incoming Call"
    readonly property string stateConnected: "Connected"
    
    property string callState: stateIdle
    property string activeContactName: ""
    property string activeNumber: ""
    property string callDuration: "00:00"
    
    // Controls
    property bool muted: false
    property bool speakerOn: false
    
    // Models
    property ListModel recentCalls: ListModel {
        ListElement { name: "Sarah Johnson"; number: "+1 555-0123"; time: "2 mins ago"; callType: "incoming" }
        ListElement { name: "Mike Chen"; number: "+1 555-0456"; time: "15 mins ago"; callType: "outgoing" }
        ListElement { name: "Work Office"; number: "+1 555-0789"; time: "1 hour ago"; callType: "missed" }
        ListElement { name: "Mom"; number: "+1 555-1111"; time: "Yesterday 18:45"; callType: "incoming" }
        ListElement { name: "Pizza Place"; number: "+1 555-7777"; time: "Yesterday 12:30"; callType: "outgoing" }
        ListElement { name: "Unknown"; number: "+1 555-9999"; time: "Mon 09:15"; callType: "missed" }
        ListElement { name: "Dad"; number: "+1 555-2222"; time: "Sun 20:00"; callType: "incoming" }
        ListElement { name: "Dentist"; number: "+1 555-3456"; time: "Last week"; callType: "missed" }
    }
    
    property ListModel favorites: ListModel {
        ListElement { name: "Mom"; number: "+1 555-1111" }
        ListElement { name: "Dad"; number: "+1 555-2222" }
        ListElement { name: "Sarah"; number: "+1 555-0123" }
        ListElement { name: "Work"; number: "+1 555-0789" }
        ListElement { name: "Mike"; number: "+1 555-0456" }
        ListElement { name: "Home"; number: "+1 555-3333" }
    }
    
    property ListModel contacts: ListModel {
        ListElement { name: "Alice Martinez"; number: "+1 555-1001" }
        ListElement { name: "Bob Thompson"; number: "+1 555-1002" }
        ListElement { name: "Carlos Garcia"; number: "+1 555-1003" }
        ListElement { name: "Diana Ross"; number: "+1 555-1004" }
        ListElement { name: "Eric Johnson"; number: "+1 555-1005" }
        ListElement { name: "Fiona Apple"; number: "+1 555-1006" }
        ListElement { name: "George Miller"; number: "+1 555-1007" }
        ListElement { name: "Hannah Lee"; number: "+1 555-1008" }
        ListElement { name: "Ivan Petrov"; number: "+1 555-1009" }
        ListElement { name: "Julia Roberts"; number: "+1 555-1010" }
        ListElement { name: "Kevin Hart"; number: "+1 555-1011" }
        ListElement { name: "Lisa Simpson"; number: "+1 555-1012" }
        ListElement { name: "Mike Chen"; number: "+1 555-0456" }
        ListElement { name: "Nancy Drew"; number: "+1 555-1014" }
        ListElement { name: "Oscar Wilde"; number: "+1 555-1015" }
        ListElement { name: "Sarah Johnson"; number: "+1 555-0123" }
    }
    
    // -------------------------------------------------------------------------
    // Advanced Logic
    // -------------------------------------------------------------------------
    
    property string searchQuery: ""
    property string recentsFilter: "All" // "All" | "Missed"
    property string audioRoute: "Speaker" // "Speaker" | "Handset" | "Bluetooth"
    
    property ListModel filteredContacts: ListModel {}
    property ListModel filteredRecents: ListModel {}
    
    // Initialize
    Component.onCompleted: {
        updateFilteredContacts()
        updateFilteredRecents()
    }
    
    onSearchQueryChanged: updateFilteredContacts()
    onRecentsFilterChanged: updateFilteredRecents()
    // When underlying models change, update filtered views (simplified for mock)
    // Real impl would use proper signals or a ProxyModel
    
    function updateFilteredContacts() {
        filteredContacts.clear()
        var query = searchQuery.toLowerCase()
        
        for (var i = 0; i < contacts.count; i++) {
             var item = contacts.get(i)
             if (item.name.toLowerCase().includes(query) || item.number.includes(query)) {
                 filteredContacts.append(item)
             }
        }
    }
    
    function updateFilteredRecents() {
        filteredRecents.clear()
        for (var i = 0; i < recentCalls.count; i++) {
            var item = recentCalls.get(i)
            if (recentsFilter === "All" || (recentsFilter === "Missed" && item.callType === "missed")) {
                filteredRecents.append(item)
            }
        }
    }

    function dial(number) {
        if (callState !== stateIdle) return
        
        activeNumber = number
        // Check if number matches a known contact
        let found = false
        for (let i = 0; i < contacts.count; i++) {
            if (contacts.get(i).number === number) {
                activeContactName = contacts.get(i).name
                found = true
                break
            }
        }
        if (!found) activeContactName = number
        
        callState = stateDialing
        audioRoute = "Speaker" // Default to speaker for car context
        
        // Fake connection time
        _connectionTimer.start()
        
        // Add to recents
        addRecent(activeContactName, number, "outgoing")
    }
    
    function endCall() {
        callState = stateIdle
        activeNumber = ""
        activeContactName = ""
        _seconds = 0
        callDuration = "00:00"
        muted = false
        speakerOn = false // Legacy property sync
        _callTimer.stop()
    }
    
    function addRecent(name, number, type) {
        recentCalls.insert(0, { 
            "name": name, 
            "number": number, 
            "time": "Just now", 
            "callType": type 
        })
        if (recentCalls.count > 50) recentCalls.remove(50)
        updateFilteredRecents()
    }
    
    // Mock incoming call simulation
    function simulateIncomingCall(name, number) {
        if (callState !== stateIdle) return
        activeNumber = number
        activeContactName = name
        callState = stateIncoming
        audioRoute = "Speaker"
    }
    
    function answerCall() {
        if (callState === stateIncoming) {
            callState = stateConnected
            _seconds = 0
            _callTimer.start()
            
            addRecent(activeContactName, activeNumber, "incoming")
        }
    }
    
    // Internal Timer for "Dialing" -> "Connected"
    property Timer _connectionTimer: Timer {
        interval: 2000
        repeat: false
        onTriggered: {
            if (phoneService.callState === phoneService.stateDialing) {
                phoneService.callState = phoneService.stateConnected
                phoneService._seconds = 0
                phoneService._callTimer.start()
            }
        }
    }
    
    // Call Duration Tracking
    property int _seconds: 0
    property Timer _callTimer: Timer {
        interval: 1000
        repeat: true
        onTriggered: {
            phoneService._seconds++
            var mins = Math.floor(phoneService._seconds / 60)
            var secs = phoneService._seconds % 60
            phoneService.callDuration = (mins < 10 ? "0" : "") + mins + ":" + (secs < 10 ? "0" : "") + secs
        }
    }
}
