import QtQuick
import QtQuick.Layouts
import NordicHeadunit

// Persistent Bottom Bar - Full-Width, OEM-Grade
// Layout: [Nav Icons] | [L Seat][Driver Temp][Fan][Passenger Temp][R Seat] | [Vehicle][Settings]
Rectangle {
    id: root
    
    color: NordicTheme.colors.bg.secondary
    implicitHeight: 64
    
    property int currentIndex: 0
    
    // Top border
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: NordicTheme.colors.border.muted
    }
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // ═══════════════════════════════════════════════════════════════════
        // LEFT: APP NAVIGATION (Home, Nav, Media, Phone)
        // ═══════════════════════════════════════════════════════════════════
        RowLayout {
            Layout.fillHeight: true
            spacing: 0
            
            component NavItem : Item {
                id: navRoot
                property string label
                property string icon
                property bool active: navIdx === root.currentIndex
                property int navIdx
                
                Layout.preferredWidth: 72
                Layout.fillHeight: true
                
                Rectangle {
                    anchors.fill: parent
                    color: navMouse.pressed ? NordicTheme.colors.bg.elevated : "transparent"
                }
                
                Rectangle {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 32
                    height: 3
                    radius: 1.5
                    color: NordicTheme.colors.accent.primary
                    visible: active
                }
                
                Column {
                    anchors.centerIn: parent
                    spacing: 4
                    
                    NordicIcon {
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: navRoot.icon
                        size: NordicIcon.Size.MD
                        color: active ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.secondary
                    }
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: navRoot.label
                        font.pixelSize: 10
                        font.family: "Helvetica"
                        color: active ? NordicTheme.colors.text.primary : NordicTheme.colors.text.tertiary
                    }
                }
                
                MouseArea {
                    id: navMouse
                    anchors.fill: parent
                    onClicked: root.currentIndex = navRoot.navIdx
                }
            }
            
            NavItem { navIdx: 0; label: "Home"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/home.svg" }
            NavItem { navIdx: 1; label: "Nav"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg" }
            NavItem { navIdx: 2; label: "Media"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg" }
            NavItem { navIdx: 3; label: "Phone"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg" }
        }
        
        // Separator
        Rectangle {
            width: 1; Layout.fillHeight: true
            Layout.topMargin: 12; Layout.bottomMargin: 12
            color: NordicTheme.colors.border.muted
        }
        
        // ═══════════════════════════════════════════════════════════════════
        // CENTER: CLIMATE CORE
        // [L Seat] [Driver −21°+] [Fan] [Passenger −21°+] [R Seat]
        // ═══════════════════════════════════════════════════════════════════
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            spacing: 8
            
            Item { Layout.fillWidth: true }  // Left spacer
            
            // ═══════════════════════════════════════════════════════════════
            // DRIVER CLUSTER
            // ═══════════════════════════════════════════════════════════════
            Row {
                spacing: 8
                
                // Heated Seat
                Item {
                    width: 48; height: 48
                    Rectangle {
                        anchors.fill: parent; radius: 8
                        color: internal.leftSeatHeatLevel > 0 ? NordicTheme.colors.accent.warm : 
                               leftSeatHeatMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.elevated
                    }
                    Column {
                        anchors.centerIn: parent; spacing: 2
                        NordicIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/heated-front-seat.svg"
                            size: NordicIcon.Size.SM
                            color: internal.leftSeatHeatLevel > 0 ? "white" : NordicTheme.colors.text.secondary
                        }
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter; spacing: 2
                            Repeater {
                                model: 3
                                Rectangle {
                                    width: 6; height: 3; radius: 1
                                    color: index < internal.leftSeatHeatLevel ? "white" : (internal.leftSeatHeatLevel > 0 ? Qt.rgba(1,1,1,0.3) : NordicTheme.colors.border.muted)
                                }
                            }
                        }
                    }
                    MouseArea {
                        id: leftSeatHeatMouse; anchors.fill: parent
                        onClicked: {
                            internal.leftSeatHeatLevel = (internal.leftSeatHeatLevel + 1) % 4
                            if (internal.leftSeatHeatLevel > 0) internal.leftSeatVentLevel = 0 // Mutual exclusion
                        }
                    }
                }

                // Ventilated Seat
                Item {
                    width: 48; height: 48
                    Rectangle {
                        anchors.fill: parent; radius: 8
                        color: internal.leftSeatVentLevel > 0 ? NordicTheme.colors.accent.primary : 
                               leftSeatVentMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.elevated
                    }
                    Column {
                        anchors.centerIn: parent; spacing: 2
                        NordicIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/ventilated-front-seat.svg"
                            size: NordicIcon.Size.SM
                            color: internal.leftSeatVentLevel > 0 ? "white" : NordicTheme.colors.text.secondary
                        }
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter; spacing: 2
                            Repeater {
                                model: 3
                                Rectangle {
                                    width: 6; height: 3; radius: 1
                                    color: index < internal.leftSeatVentLevel ? "white" : (internal.leftSeatVentLevel > 0 ? Qt.rgba(1,1,1,0.3) : NordicTheme.colors.border.muted)
                                }
                            }
                        }
                    }
                    MouseArea {
                        id: leftSeatVentMouse; anchors.fill: parent
                        onClicked: {
                            internal.leftSeatVentLevel = (internal.leftSeatVentLevel + 1) % 4
                            if (internal.leftSeatVentLevel > 0) internal.leftSeatHeatLevel = 0 // Mutual exclusion
                        }
                    }
                }
                
                Item { width: 12; height: 1 } // Spacer

                // Temperature
                RowLayout {
                    spacing: 4
                    Item {
                        width: 36; height: 44
                        Rectangle { anchors.fill: parent; radius: 6; color: dMinus.pressed ? NordicTheme.colors.bg.elevated : "transparent" }
                        Text { anchors.centerIn: parent; text: "−"; font.pixelSize: 22; font.family: "Helvetica"; color: NordicTheme.colors.text.secondary }
                        MouseArea { id: dMinus; anchors.fill: parent; onClicked: VehicleService.driverTemp = Math.max(16, VehicleService.driverTemp - 1) }
                    }
                    Text {
                        text: VehicleService.driverTemp + "°"
                        font.pixelSize: 24; font.weight: Font.Medium; font.family: "Helvetica"; color: NordicTheme.colors.text.primary
                    }
                    Item {
                        width: 36; height: 44
                        Rectangle { anchors.fill: parent; radius: 6; color: dPlus.pressed ? NordicTheme.colors.bg.elevated : "transparent" }
                        Text { anchors.centerIn: parent; text: "+"; font.pixelSize: 22; font.family: "Helvetica"; color: NordicTheme.colors.text.secondary }
                        MouseArea { id: dPlus; anchors.fill: parent; onClicked: VehicleService.driverTemp = Math.min(28, VehicleService.driverTemp + 1) }
                    }
                }
            }

            Item { Layout.fillWidth: true }  // Spacer

            // ═══════════════════════════════════════════════════════════════
            // CENTRAL CLUSTER (Defrosts & Fan)
            // ═══════════════════════════════════════════════════════════════
            Row {
                spacing: 8
                
                // Front Defrost
                Item {
                    width: 48; height: 48
                    Rectangle {
                        anchors.fill: parent; radius: 8
                        color: VehicleService.frontDefrostEnabled ? NordicTheme.colors.semantic.warning : 
                               fDefrostMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.elevated
                    }
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/windscreen_defrost.svg"
                        size: NordicIcon.Size.SM
                        color: VehicleService.frontDefrostEnabled ? "black" : NordicTheme.colors.text.secondary
                    }
                    MouseArea {
                        id: fDefrostMouse; anchors.fill: parent
                        onClicked: VehicleService.frontDefrostEnabled = !VehicleService.frontDefrostEnabled
                    }
                }

                // Fan Control
                Item {
                    width: 48; height: 48
                    Rectangle {
                        anchors.fill: parent; radius: 8
                        color: VehicleService.autoClimate ? NordicTheme.colors.accent.primary : NordicTheme.colors.bg.elevated
                    }
                    Column {
                        anchors.centerIn: parent; spacing: 2
                        NordicIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/fan.svg"
                            size: NordicIcon.Size.SM
                            color: VehicleService.autoClimate ? "white" : NordicTheme.colors.text.secondary
                        }
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter; spacing: 1
                            Repeater {
                                model: 5
                                Rectangle {
                                    width: 4; height: 3 + index; radius: 1
                                    color: index < VehicleService.fanSpeed 
                                        ? (VehicleService.autoClimate ? "white" : NordicTheme.colors.accent.primary)
                                        : (VehicleService.autoClimate ? Qt.rgba(1,1,1,0.3) : NordicTheme.colors.border.muted)
                                }
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: VehicleService.fanSpeed = (VehicleService.fanSpeed + 1) % 6
                    }
                }

                // Rear Defrost
                Item {
                    width: 48; height: 48
                    Rectangle {
                        anchors.fill: parent; radius: 8
                        color: VehicleService.rearDefrostEnabled ? NordicTheme.colors.semantic.warning : 
                               rDefrostMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.elevated
                    }
                    NordicIcon {
                        anchors.centerIn: parent
                        source: "qrc:/qt/qml/NordicHeadunit/assets/icons/rear-window-defrost.svg"
                        size: NordicIcon.Size.SM
                        color: VehicleService.rearDefrostEnabled ? "black" : NordicTheme.colors.text.secondary
                    }
                    MouseArea {
                        id: rDefrostMouse; anchors.fill: parent
                        onClicked: VehicleService.rearDefrostEnabled = !VehicleService.rearDefrostEnabled
                    }
                }
            }

            Item { Layout.fillWidth: true }  // Spacer

            // ═══════════════════════════════════════════════════════════════
            // PASSENGER CLUSTER
            // ═══════════════════════════════════════════════════════════════
            Row {
                spacing: 8
                
                // Temperature
                RowLayout {
                    spacing: 4
                    Item {
                        width: 36; height: 44
                        Rectangle { anchors.fill: parent; radius: 6; color: pMinus.pressed ? NordicTheme.colors.bg.elevated : "transparent" }
                        Text { anchors.centerIn: parent; text: "−"; font.pixelSize: 22; font.family: "Helvetica"; color: NordicTheme.colors.text.secondary }
                        MouseArea { id: pMinus; anchors.fill: parent; onClicked: VehicleService.passengerTemp = Math.max(16, VehicleService.passengerTemp - 1) }
                    }
                    Text {
                        text: VehicleService.passengerTemp + "°"
                        font.pixelSize: 24; font.weight: Font.Medium; font.family: "Helvetica"; color: NordicTheme.colors.text.primary
                    }
                    Item {
                        width: 36; height: 44
                        Rectangle { anchors.fill: parent; radius: 6; color: pPlus.pressed ? NordicTheme.colors.bg.elevated : "transparent" }
                        Text { anchors.centerIn: parent; text: "+"; font.pixelSize: 22; font.family: "Helvetica"; color: NordicTheme.colors.text.secondary }
                        MouseArea { id: pPlus; anchors.fill: parent; onClicked: VehicleService.passengerTemp = Math.min(28, VehicleService.passengerTemp + 1) }
                    }
                }
                
                Item { width: 12; height: 1 } // Spacer

                // Ventilated Seat
                Item {
                    width: 48; height: 48
                    Rectangle {
                        anchors.fill: parent; radius: 8
                        color: internal.rightSeatVentLevel > 0 ? NordicTheme.colors.accent.primary : 
                               rightSeatVentMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.elevated
                    }
                    Column {
                        anchors.centerIn: parent; spacing: 2
                        NordicIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/ventilated-front-seat.svg"
                            size: NordicIcon.Size.SM
                            color: internal.rightSeatVentLevel > 0 ? "white" : NordicTheme.colors.text.secondary
                        }
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter; spacing: 2
                            Repeater {
                                model: 3
                                Rectangle {
                                    width: 6; height: 3; radius: 1
                                    color: index < internal.rightSeatVentLevel ? "white" : (internal.rightSeatVentLevel > 0 ? Qt.rgba(1,1,1,0.3) : NordicTheme.colors.border.muted)
                                }
                            }
                        }
                    }
                    MouseArea {
                        id: rightSeatVentMouse; anchors.fill: parent
                        onClicked: {
                            internal.rightSeatVentLevel = (internal.rightSeatVentLevel + 1) % 4
                            if (internal.rightSeatVentLevel > 0) internal.rightSeatHeatLevel = 0 // Mutual exclusion
                        }
                    }
                }

                // Heated Seat
                Item {
                    width: 48; height: 48
                    Rectangle {
                        anchors.fill: parent; radius: 8
                        color: internal.rightSeatHeatLevel > 0 ? NordicTheme.colors.accent.warm : 
                               rightSeatHeatMouse.pressed ? NordicTheme.colors.bg.elevated : NordicTheme.colors.bg.elevated
                    }
                    Column {
                        anchors.centerIn: parent; spacing: 2
                        NordicIcon {
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/qt/qml/NordicHeadunit/assets/icons/heated-front-seat.svg"
                            size: NordicIcon.Size.SM
                            color: internal.rightSeatHeatLevel > 0 ? "white" : NordicTheme.colors.text.secondary
                        }
                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter; spacing: 2
                            Repeater {
                                model: 3
                                Rectangle {
                                    width: 6; height: 3; radius: 1
                                    color: index < internal.rightSeatHeatLevel ? "white" : (internal.rightSeatHeatLevel > 0 ? Qt.rgba(1,1,1,0.3) : NordicTheme.colors.border.muted)
                                }
                            }
                        }
                    }
                    MouseArea {
                        id: rightSeatHeatMouse; anchors.fill: parent
                        onClicked: {
                            internal.rightSeatHeatLevel = (internal.rightSeatHeatLevel + 1) % 4
                            if (internal.rightSeatHeatLevel > 0) internal.rightSeatVentLevel = 0 // Mutual exclusion
                        }
                    }
                }
            }
            
            Item { Layout.fillWidth: true }  // Right spacer
        }
        
        // Separator
        Rectangle {
            width: 1; Layout.fillHeight: true
            Layout.topMargin: 12; Layout.bottomMargin: 12
            color: NordicTheme.colors.border.muted
        }
        
        // ═══════════════════════════════════════════════════════════════════
        // RIGHT: Vehicle & Settings
        // ═══════════════════════════════════════════════════════════════════
        RowLayout {
            Layout.fillHeight: true
            spacing: 0
            
            component RightNavItem : Item {
                id: rNavRoot
                property string label
                property string icon
                property bool active: rNavIdx === root.currentIndex
                property int rNavIdx
                
                Layout.preferredWidth: 72
                Layout.fillHeight: true
                
                Rectangle {
                    anchors.fill: parent
                    color: rNavMouse.pressed ? NordicTheme.colors.bg.elevated : "transparent"
                }
                
                Rectangle {
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 32; height: 3; radius: 1.5
                    color: NordicTheme.colors.accent.primary
                    visible: active
                }
                
                Column {
                    anchors.centerIn: parent
                    spacing: 4
                    
                    NordicIcon {
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: rNavRoot.icon
                        size: NordicIcon.Size.MD
                        color: active ? NordicTheme.colors.accent.primary : NordicTheme.colors.text.secondary
                    }
                    
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: rNavRoot.label
                        font.pixelSize: 10; font.family: "Helvetica"
                        color: active ? NordicTheme.colors.text.primary : NordicTheme.colors.text.tertiary
                    }
                }
                
                MouseArea {
                    id: rNavMouse; anchors.fill: parent
                    onClicked: root.currentIndex = rNavRoot.rNavIdx
                }
            }
            
            RightNavItem { rNavIdx: 4; label: "Vehicle"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg" }
            RightNavItem { rNavIdx: 5; label: "Settings"; icon: "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg" }
        }
    }
    
    QtObject {
        id: internal
        property int leftSeatHeatLevel: VehicleService.leftSeatHeat ? 3 : 0
        property int leftSeatVentLevel: VehicleService.leftSeatVentilation ? 3 : 0
        property int rightSeatHeatLevel: VehicleService.rightSeatHeat ? 3 : 0
        property int rightSeatVentLevel: VehicleService.rightSeatVentilation ? 3 : 0
        
        onLeftSeatHeatLevelChanged: VehicleService.leftSeatHeat = leftSeatHeatLevel > 0
        onLeftSeatVentLevelChanged: VehicleService.leftSeatVentilation = leftSeatVentLevel > 0
        onRightSeatHeatLevelChanged: VehicleService.rightSeatHeat = rightSeatHeatLevel > 0
        onRightSeatVentLevelChanged: VehicleService.rightSeatVentilation = rightSeatVentLevel > 0
    }
}
