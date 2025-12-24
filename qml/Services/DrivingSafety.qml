pragma Singleton
import QtQuick

// Driving Safety Manager
// Centralizes logic for driver distraction mitigation (DDM).
// Enforces UI limitations based on vehicle state.
QtObject {
    id: safety
    
    // Telemetry binding (Simulated for clear abstraction)
    property real speed: 0.0 // km/h
    property string gear: "P" // P, R, N, D
    
    // Interaction Levels
    enum Level {
        Full,       // Stationary, Parked
        Limited,    // Low speed, some restrictions
        Blocked     // High speed, minimal interaction
    }
    
    // Computed Interaction Level
    readonly property int interactionLevel: {
        if (gear === "P") return DrivingSafety.Level.Full
        if (speed < 5) return DrivingSafety.Level.Full
        if (speed < 15) return DrivingSafety.Level.Limited
        return DrivingSafety.Level.Blocked
    }
    
    // Helper accessors
    readonly property bool isRestricted: interactionLevel !== DrivingSafety.Level.Full
    readonly property bool isFullyBlocked: interactionLevel === DrivingSafety.Level.Blocked
    
    // Function to check if a specific action is allowed
    // Returns true if allowed, false if blocked (and shows toast)
    function checkAction(complexity, showToastCallback) {
        if (interactionLevel === DrivingSafety.Level.Full) return true
        
        // Block complex actions while moving
        if (complexity === "complex") {
            if (showToastCallback) showToastCallback(qsTr("Unavailable while driving"))
            return false
        }
        
        // Block moderate actions at high speed
        if (complexity === "moderate" && interactionLevel === DrivingSafety.Level.Blocked) {
             if (showToastCallback) showToastCallback(qsTr("Too fast for this action"))
             return false
        }
        
        return true
    }
    
    // Simulate telemetry (For testing/demo)
    property Timer timer: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
             // In a real system, this property would be bound to VehicleService.speed
             // We won't simulate changes here to avoid breaking the user's manual testing
             // but the structure is ready.
        }
    }
}
