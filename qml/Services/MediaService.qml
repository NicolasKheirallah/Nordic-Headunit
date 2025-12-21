pragma Singleton
import QtQuick

QtObject {
    id: mediaService
    
    // -------------------------------------------------------------------------
    // Playback State
    // -------------------------------------------------------------------------
    property bool playing: false
    property bool shuffleEnabled: false
    property bool repeatEnabled: false
    property bool isFavorite: false
    
    // Core Metadata
    property string title: ""
    property string artist: ""
    property string album: ""
    property string coverSource: "" 
    
    property int duration: 0 // Seconds
    property int position: 0
    property int volume: 50
    
    property string currentSource: "Spotify" // "Spotify", "Bluetooth", "Radio", "USB"
    
    // -------------------------------------------------------------------------
    // Data Models (Read-Only from View Perspective)
    // -------------------------------------------------------------------------
    
    property string lyrics: ""
    property ListModel playlist: ListModel {}
    property ListModel library: ListModel {}
    property ListModel sources: ListModel {}
    
    // -------------------------------------------------------------------------
    // Initialization (Simulate Backend Connection)
    // -------------------------------------------------------------------------
    
    Component.onCompleted: {
        console.log("MediaService: Connecting to backend...")
        _mockBackendFetch()
    }
    
    // -------------------------------------------------------------------------
    // Logic
    // -------------------------------------------------------------------------
    
    function togglePlayPause() {
        playing = !playing
    }
    
    function next() {
        position = 0
        // Simulate track change logic would go here
        // For production mock, we'll just toggle between two states for demo
        if (title === "Blinding Lights") {
            _loadTrack("Save Your Tears", "The Weeknd", 215, true)
        } else {
            _loadTrack("Blinding Lights", "The Weeknd", 200, false)
        }
    }
    
    function previous() {
        if (position > 5) {
             position = 0
        } else {
            // Go to prev track logic
            _loadTrack("Starboy", "The Weeknd", 230, false)
        }
    }
    
    function seek(val) {
        position = val
    }
    
    function setVolume(val) {
        volume = val
    }
    
    function toggleFavorite() {
        isFavorite = !isFavorite
        // Telemetry signal would be emitted here
    }
    
    function setSource(sourceName) {
        currentSource = sourceName
        // Update active state in model
        for(var i=0; i<sources.count; i++) {
            sources.setProperty(i, "active", sources.get(i).name === sourceName)
        }
    }
    
    // -------------------------------------------------------------------------
    // Internal Simulation / Mock Data
    // -------------------------------------------------------------------------
    
    function _loadTrack(newTitle, newArtist, newDuration, favorite) {
        title = newTitle
        artist = newArtist
        duration = newDuration
        isFavorite = favorite
        coverSource = "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg"
    }
    
    function _mockBackendFetch() {
        // 1. Initial Track Load
        _loadTrack("Blinding Lights", "The Weeknd", 200, false)
        
        // 2. Load Lyrics (Async simulation)
        lyrics = "I've been on my own for long enough\n" +
                 "Maybe you can show me how to love, maybe\n" +
                 "I'm going through withdrawals\n" +
                 "You don't even have to do too much\n" +
                 "You can turn me on with just a touch, baby\n" +
                 "I look around and\n" +
                 "Sin City's cold and empty (oh)\n" +
                 "No one's around to judge me (oh)\n" +
                 "I can't see clearly when you're gone"
                 
        // 3. Populate Library
        library.append({ name: "Driving Mix", type: "Playlist", count: "50 songs", color: "#FF6B6B" })
        library.append({ name: "Chill Vibes", type: "Playlist", count: "120 songs", color: "#4ECDC4" })
        library.append({ name: "The Weeknd", type: "Artist", count: "5 Albums", color: "#FFE66D" })
        library.append({ name: "80s Hits", type: "Playlist", count: "85 songs", color: "#1A535C" })
        library.append({ name: "Podcast: Tech", type: "Podcast", count: "New Ep", color: "#FF9F1C" })
        
        // 4. Populate Sources
        sources.append({ name: "Spotify", icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", active: true })
        sources.append({ name: "Bluetooth", icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg", active: false })
        sources.append({ name: "FM Radio", icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg", active: false })
        sources.append({ name: "USB", icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg", active: false })
        
        // 5. Populate Up Next
        playlist.append({ title: "Blinding Lights", artist: "The Weeknd", duration: 200 })
        playlist.append({ title: "Save Your Tears", artist: "The Weeknd", duration: 215 })
        playlist.append({ title: "Starboy", artist: "The Weeknd", duration: 230 })
        playlist.append({ title: "Levitating", artist: "Dua Lipa", duration: 203 })
    }
    
    // Playback Timer
    property Timer _progressTimer: Timer {
        interval: 1000
        running: mediaService.playing
        repeat: true
        onTriggered: {
            if (mediaService.position < mediaService.duration) {
                mediaService.position += 1
            } else {
                mediaService.next()
            }
        }
    }
}
