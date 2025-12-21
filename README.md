# Nordic Headunit

A modern automotive infotainment system built with Qt6/QML, designed for in-vehicle head units with a focus on driver safety, OEM-grade aesthetics, and responsive design across multiple display resolutions.

---

## Table of Contents

1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Hardware Abstraction Layer](#hardware-abstraction-layer)
4. [Service Layer](#service-layer)
5. [User Interface Architecture](#user-interface-architecture)
6. [Design System](#design-system)
7. [Navigation and Routing](#navigation-and-routing)
8. [Media Subsystem](#media-subsystem)
9. [Vehicle Integration](#vehicle-integration)
10. [Climate Control](#climate-control)
11. [Responsive Design](#responsive-design)
12. [State Management](#state-management)
13. [Internationalization](#internationalization)
14. [Build System](#build-system)
15. [Testing Strategy](#testing-strategy)
16. [Deployment](#deployment)

---

## Overview

Nordic Headunit is a reference implementation of an automotive infotainment system that demonstrates best practices for in-vehicle user interfaces. The system is built on Qt6 with a clear separation between hardware abstraction, business logic, and presentation layers.

### Design Philosophy

The application follows several core principles derived from automotive UI/UX research:

**Driver Safety** - Every interaction is designed to minimize driver distraction. Touch targets exceed 44x44 points, critical actions require single taps, and the interface avoids modal dialogs that block operation.

**Glanceability** - Information is presented in a hierarchy that allows the driver to understand system state within 1-2 seconds of visual attention. Status indicators use semantic colors consistently.

**Predictability** - Navigation patterns are consistent across all sections. The left rail in Media, the bottom bar for app switching, and the overlay system all follow established patterns that build muscle memory.

**Graceful Degradation** - When data is unavailable or connections are lost, the interface clearly communicates state without presenting errors as failures. "Not available" is preferred over error messages.

---

## System Architecture

The application follows a layered architecture with clear dependency directions:

```
┌─────────────────────────────────────────────────────────────┐
│                    QML Presentation Layer                    │
│  (Pages, Components, Overlays, Layouts, Widgets)            │
├─────────────────────────────────────────────────────────────┤
│                    C++ Service Layer                         │
│  (MediaService, VehicleService, PhoneService, Navigation)   │
├─────────────────────────────────────────────────────────────┤
│               Hardware Abstraction Layer (HAL)               │
│  (IVehicleHAL, IAudioHAL - Interfaces to vehicle systems)   │
├─────────────────────────────────────────────────────────────┤
│                    Vehicle CAN/LIN Bus                       │
│                    Audio Hardware                            │
│                    GPS/Navigation Hardware                   │
└─────────────────────────────────────────────────────────────┘
```

### Dependency Injection

Services are instantiated in the main application entry point and registered as QML context properties. This allows the QML layer to access services without tight coupling, and enables substitution of mock implementations for testing.

### Signal-Slot Communication

All cross-layer communication uses Qt's signal-slot mechanism. Services emit signals when data changes, and QML bindings automatically update. This reactive pattern eliminates manual UI refresh logic.

---

## Hardware Abstraction Layer

The HAL provides interfaces between the application services and actual vehicle hardware. Two primary interfaces exist:

### IVehicleHAL

Abstracts all vehicle data access including:

- Powertrain data (speed, gear, engine state)
- Body electronics (doors, locks, lights, windows)
- Climate system (HVAC, seat heating, defrost)
- Battery management (SOC, voltage, charging state)
- Tire pressure monitoring
- Warning and diagnostic messages

The interface defines both synchronous getters for current state and asynchronous signals for real-time updates. A simulated implementation provides mock data for development and testing.

### IAudioHAL

Abstracts audio system access:

- Volume control with ducking support
- Audio source routing
- Equalizer and DSP settings
- Radio tuner control (FM/AM/DAB)
- Audio focus management

### Simulation Mode

When running without vehicle hardware, the HAL implementations provide realistic simulated data with temporal progression. Speed, fuel consumption, and other values change over time to enable realistic UI testing.

---

## Service Layer

Services encapsulate business logic and state management, exposing properties and methods to the QML layer through Q_PROPERTY and Q_INVOKABLE declarations.

### MediaService

Manages all audio playback across multiple sources:

**Source Management** - Tracks available audio sources (Bluetooth, USB, Radio, Streaming) with per-source state persistence. Switching sources resumes playback from the last position.

**Radio Integration** - Handles FM/AM/DAB radio with preset storage, frequency tuning, station scanning, and RDS/RBDS metadata display.

**Playback Control** - Unified play/pause/next/previous actions that adapt behavior based on current source. Radio mode replaces skip with seek.

**Metadata Handling** - Extracts and caches track information from various sources with fallback displays for missing data.

### VehicleService

Provides read-only access to vehicle state:

**Data Aggregation** - Combines data from multiple vehicle subsystems into a coherent view. Individual door states are aggregated into a human-readable status string.

**Connection State** - Tracks connection to vehicle systems and reports connection quality (Connected, Limited, Offline).

**Warning Management** - Collects and prioritizes warning messages from vehicle diagnostics with severity classification and timestamps.

**Trip Computer** - Calculates and exposes trip statistics including distance, duration, average speed, and consumption metrics.

The service explicitly excludes control functions. All vehicle control (locks, lights, climate) is handled through separate, permission-gated interfaces.

### PhoneService

Manages phone connectivity and call state:

**Bluetooth HFP** - Handles Hands-Free Profile connection for call audio routing.

**Contact Synchronization** - Downloads and caches contact list from connected phone with PBAP.

**Call History** - Tracks recent calls with call type (incoming, outgoing, missed) and duration.

**DTMF** - Provides dial tone generation for in-call number entry.

### NavigationService

Handles routing and guidance:

**Route Calculation** - Computes routes with waypoint support and alternative route suggestions.

**Turn-by-Turn Guidance** - Generates maneuver instructions with distance countdowns.

**POI Search** - Provides category-based and text-based point of interest search.

**Map Rendering** - Interfaces with map tile providers and manages offline map storage.

---

## User Interface Architecture

The UI is structured as a hierarchy of QML components with clear responsibilities:

### Main.qml

The root component that initializes the application window, loads the theme singleton, and establishes the primary layout container.

### AppLayout.qml

Manages the overall screen structure:

- Status bar (time, connectivity, battery)
- Content area (page stack)
- Persistent bottom bar (navigation + climate)
- Overlay container

### Page Structure

Each major section is a Page component containing:

- Page-specific header (if needed)
- Content area with section-appropriate layout
- State management for sub-navigation

Pages are loaded into a StackView for forward/back navigation or directly swapped for tab-style navigation.

### Component Hierarchy

```
NordicButton, NordicIcon, NordicText, NordicSlider
        │
        ▼
StatusCard, RailItem, TunerButton, SettingsToggle
        │
        ▼
PlayerView, RadioView, BrowseView, VehiclePage
        │
        ▼
MediaPage, HomePage, SettingsPage
        │
        ▼
AppLayout
        │
        ▼
Main
```

---

## Design System

The NordicTheme singleton provides all design tokens:

### Color System

**Background Hierarchy**

- `bg.primary` - Main application background
- `bg.secondary` - Sections and cards
- `bg.surface` - Elevated surfaces
- `bg.elevated` - Pressed/active states
- `bg.overlay` - Modal backgrounds

**Text Hierarchy**

- `text.primary` - Headings and important text
- `text.secondary` - Body text
- `text.tertiary` - Captions and hints

**Semantic Colors**

- `semantic.success` - Positive states (green)
- `semantic.warning` - Attention needed (amber)
- `semantic.error` - Problems (red)
- `semantic.info` - Informational (blue)

**Accent**

- `accent.primary` - Swedish Gold (#C6930A)
- `accent.secondary` - Hover/pressed variant

### Typography

System fonts are used for reliability (Helvetica on macOS). Type scale follows automotive accessibility guidelines with minimum 11pt for any text.

### Spacing

An 8-point grid system with named increments:

- `space_1` = 4pt
- `space_2` = 8pt
- `space_3` = 12pt
- `space_4` = 16pt
- `space_6` = 24pt
- `space_8` = 32pt

### Dark/Light Mode

The theme supports runtime switching between dark and light modes. Dark mode is optimized for nighttime driving with reduced brightness and blue light.

---

## Navigation and Routing

### Bottom Bar Navigation

The persistent bottom bar provides constant access to:

1. Primary navigation (Home, Nav, Media, Phone)
2. Climate quick controls (temperature, fan, seats)
3. Secondary navigation (Vehicle, Settings)

The bar uses icon + label format with active state indication. Height is fixed at 64pt to balance touch accessibility with content area preservation.

### In-Page Navigation

Pages with multiple sections use consistent patterns:

**Media** - Left rail navigation (90pt) with icon + label items. Content switches via Loader for efficient memory use.

**Settings** - Two-column split layout with sidebar navigation and detail panel.

**Phone** - Top tab bar for Favorites/Recents/Keypad views.

### Overlay System

Modal overlays handle:

- Volume feedback
- Climate detailed controls
- Control center (quick settings)
- Notifications
- Rear camera feed

Overlays use the OverlayManager for z-order management and dismiss gestures.

---

## Media Subsystem

### Source Architecture

Audio sources are treated uniformly with source-specific adapters:

**Bluetooth A2DP** - Receives metadata via AVRCP, controls via HFP/AVRCP.

**USB Mass Storage** - Scans connected media for audio files, builds local library.

**Radio** - Interfaces with tuner hardware for FM/AM/DAB reception.

**Streaming** - Placeholder for future Spotify/Apple Music integration.

### Radio Tuner

The radio subsystem provides:

**Manual Tuning** - Fine-grained frequency adjustment in 0.1 MHz steps for FM.

**Seek** - Automatic scanning to next station with signal above threshold.

**Scan** - Full band scan to discover all available stations.

**Presets** - Six preset slots for quick access to favorite stations.

**RDS/RBDS** - Decodes station name, program type, and radio text where available.

### Playback State Machine

```
         ┌─────────┐
    ┌────│ Stopped │◄───────────────┐
    │    └────┬────┘                │
    │         │ play()              │
    │         ▼                     │
    │    ┌─────────┐    pause()     │
    │    │ Playing │───────────┐    │
    │    └────┬────┘           │    │
    │         │                ▼    │
    │         │           ┌────────┐│
    │         │           │ Paused ││
    │         │           └───┬────┘│
    │         │    play()     │     │
    │         │◄──────────────┘     │
    │         │                     │
    │         │ end of track        │
    │         ▼                     │
    │    ┌─────────┐                │
    └───►│  Next   │────────────────┘
         └─────────┘ (if no more tracks)
```

---

## Vehicle Integration

### Data Model

Vehicle data is organized into logical groups:

**Identity** - Vehicle name, VIN, connection state, last update timestamp.

**Powertrain** - Speed, gear, RPM, power output, regenerative braking state.

**Energy** - Battery SOC, 12V battery status, estimated range, charging state.

**Body** - Door states (4 doors + trunk + hood), lock state, window positions.

**Climate** - Cabin temperature, HVAC settings, seat heating levels.

**Tires** - Pressure per wheel with warning thresholds.

**Trip** - Distance, duration, average speed, energy consumption.

**Warnings** - Active diagnostic messages with severity and timestamps.

### Update Frequency

Data is refreshed at appropriate intervals:

- Speed, RPM: 10 Hz
- Battery SOC: 1 Hz
- Door states: Event-driven
- Tire pressure: 0.1 Hz
- Diagnostics: Event-driven

### Data Honesty

The UI explicitly handles unavailable data:

- "Not supported" for features the vehicle lacks
- "Unavailable" for temporary data loss
- "Last updated: HH:MM" for stale data
- No fake values or optimistic placeholders

---

## Climate Control

### HVAC Integration

The climate system interfaces with vehicle HVAC through VehicleService:

**Temperature Control** - Dual-zone support with driver and passenger setpoints.

**Fan Control** - 5-speed fan with auto mode support.

**Air Distribution** - Face, feet, defrost modes (when supported).

**Recirculation** - Toggle between fresh air and recirculated cabin air.

**Defrost** - Quick-access front and rear defrost activation.

### Seat Comfort

**Seat Heating** - 3-level heating for driver and passenger seats.

**Seat Ventilation** - Cooling (vehicle-dependent).

### UI Placement

Climate controls appear in two locations:

1. **Bottom Bar** - Compact temperature display and fan indicator
2. **Climate Overlay** - Full controls accessible via bottom bar tap

---

## Responsive Design

### LayoutService

The LayoutService singleton calculates layout parameters based on window dimensions:

**Width Classes**

- Compact: < 800pt
- Regular: 800-1200pt
- Expanded: > 1200pt

**Height Classes**

- Short: < 500pt
- Regular: >= 500pt

**Orientation**

- Landscape: width > height
- Portrait: width <= height

### Adaptive Layouts

Components read layout properties to adjust:

- Column counts in grids
- Font sizes (within accessibility bounds)
- Margin and padding values
- Control sizes (larger on touch-heavy sizes)
- Information density (more columns on wider screens)

### Breakpoint Behavior

At 1024x600 (minimum supported):

- Single-column layouts
- Reduced margins
- Essential information only

At 1280x720 (common):

- Standard layouts
- Full feature set

At 1920x1080 (high-end):

- Multi-column where beneficial
- Enhanced information density
- No additional features (scope parity)

---

## State Management

### Property Binding

The primary state mechanism is Qt's reactive property binding. Service properties are bound directly to UI elements, eliminating manual update logic.

### Per-Source State

MediaService maintains separate playback state for each audio source:

- Current track/station index
- Playback position
- Shuffle/repeat settings

Switching sources restores the previous state for that source.

### Persistent Settings

SystemSettings handles persistent configuration:

- Theme preference (dark/light/auto)
- Language selection
- Audio settings (volume, balance, EQ)
- Widget layout
- Favorite stations/contacts

Settings are stored using QSettings with appropriate platform backends.

---

## Internationalization

### String Externalization

All user-visible strings use qsTr() for translation support.

### Translation Files

Translations are stored in Qt Linguist format (.ts files) in the i18n directory.

### RTL Support

Layout components use LayoutMirroring for right-to-left language support.

### Date/Time Formatting

Locale-aware formatting for all dates, times, and numbers.

---

## Build System

### CMake Configuration

The project uses CMake with Qt6 integration:

- qt_add_executable for the main target
- qt_add_qml_module for QML registration
- AUTOMOC, AUTOUIC, AUTORCC for Qt tooling

### Resource Handling

Assets are bundled using the Qt resource system:

- SVG icons with runtime coloring
- Font files
- Translation binaries

### Build Variants

**Debug** - Full symbols, assertions enabled, verbose logging.

**Release** - Optimized, stripped, minimal logging.

**RelWithDebInfo** - Optimized with debug symbols for profiling.

---

## Testing Strategy

### Unit Tests

Service layer classes have unit tests using Qt Test framework:

- State transitions
- Property calculations
- Signal emissions

### QML Tests

tst_qml tests verify component behavior:

- Property binding
- Signal handling
- Visual state changes

### Integration Tests

End-to-end tests with mock HAL:

- User flow verification
- State persistence
- Error handling

### Manual Testing

Systematic testing on reference hardware:

- Touch accuracy
- Response times
- Visual consistency

---

## Deployment

### Target Platforms

- Embedded Linux (Yocto-based)
- Desktop Linux (development)
- macOS (development)
- Windows (development)

### Hardware Requirements

Minimum:

- ARM Cortex-A53 or equivalent
- 1GB RAM
- OpenGL ES 2.0
- 1024x600 display

Recommended:

- ARM Cortex-A72 or equivalent
- 2GB RAM
- OpenGL ES 3.0
- 1280x720 or higher display

### Startup Optimization

- Splash screen during initialization
- Lazy loading of non-critical services
- Precompiled QML for faster startup
- Resource preloading for critical UI

---

## License

MIT License - See LICENSE file for details.

---

## Contributing

Contributions are welcome. Please follow the coding standards established in the codebase and ensure all tests pass before submitting pull requests.
