#include "NavigationService.h"
#include <QUrlQuery>
#include <QDebug>
#include <QRandomGenerator>

NavigationService::NavigationService(QObject *parent)
    : QObject(parent),
      m_isNavigating(false),
      m_destination(""),
      m_nextManeuver("Turn Right"),
      m_maneuverIcon("turn_right.svg"),
      m_distanceMeters(200)
{
    m_networkManager = new QNetworkAccessManager(this);
    m_simulationTimer = new QTimer(this);
    
    // Simulation Logic
    m_searchDebounceTimer = new QTimer(this);
    m_searchDebounceTimer->setSingleShot(true);
    m_searchDebounceTimer->setInterval(600); // 600ms debounce
    
    connect(m_searchDebounceTimer, &QTimer::timeout, this, [this]() {
        // Perform the actual search
        qDebug() << "Executing Debounced Search:" << m_pendingSearchQuery;
        QUrl url("https://nominatim.openstreetmap.org/search");
        QUrlQuery queryData;
        queryData.addQueryItem("q", m_pendingSearchQuery);
        queryData.addQueryItem("format", "json");
        queryData.addQueryItem("addressdetails", "1");
        queryData.addQueryItem("limit", "5");
        url.setQuery(queryData);

        QNetworkRequest request(url);
        request.setRawHeader("User-Agent", "NordicHeadunit/1.0");

        QNetworkReply *reply = m_networkManager->get(request);
        connect(reply, &QNetworkReply::finished, this, &NavigationService::onSearchFinished);
    });

    // Simulation Logic
    m_simulationTimer->setInterval(100); // 100ms update rate for smoothness (10fps)
    connect(m_simulationTimer, &QTimer::timeout, this, &NavigationService::updateSimulation);
    
    // Default Position (Stockholm)
    m_vehiclePosition = QGeoCoordinate(59.3293, 18.0686);
    m_vehicleBearing = 0;
}

bool NavigationService::isNavigating() const { return m_isNavigating; }
QString NavigationService::destination() const { return m_destination; }
QString NavigationService::nextManeuver() const { return m_nextManeuver; }
QString NavigationService::maneuverIcon() const { return "qrc:/qt/qml/NordicHeadunit/assets/icons/" + m_maneuverIcon; }
int NavigationService::distanceMeters() const { return m_distanceMeters; }

QGeoCoordinate NavigationService::vehiclePosition() const { return m_vehiclePosition; }
qreal NavigationService::vehicleBearing() const { return m_vehicleBearing; }

QString NavigationService::distanceToManeuver() const {
    if (m_distanceMeters >= 1000) return QString::number(m_distanceMeters / 1000.0, 'f', 1) + " km";
    return QString::number(m_distanceMeters) + " m";
}

QString NavigationService::distanceToDestination() const {
    if (m_distanceMeters >= 1000) return QString::number(m_distanceMeters / 1000.0, 'f', 1) + " km";
    return QString::number(m_distanceMeters) + " m";
}

QVariantList NavigationService::routeSteps() const {
    QVariantList list;
    for (const auto &step : m_routeSteps) {
        QVariantMap map;
        map["instruction"] = step.instruction;
        map["distance"] = step.distance;
        // Map Icon logic
        QString mod = step.modifier;
        QString icon = "navigation-arrow.svg";
        if (mod.contains("left")) icon = "turn_left.svg";
        else if (mod.contains("right")) icon = "turn_right.svg";
        else if (mod.contains("u-turn")) icon = "u_turn.svg"; 
        map["icon"] = "qrc:/qt/qml/NordicHeadunit/assets/icons/" + icon;
        
        list.append(map);
    }
    return list;
}

QString NavigationService::currentRoadName() const {
    return m_currentRoadName.isEmpty() ? "Unknown Road" : m_currentRoadName;
}

int NavigationService::speedLimit() const {
    return m_speedLimit;
}

QVariantList NavigationService::trafficSegments() const {
    return m_trafficSegments;
}

// Placeholder for search logic
void NavigationService::searchPlaces(const QString &query) {
    if (query.isEmpty()) return;
    qDebug() << "Searching Places:" << query;
    m_pendingSearchQuery = query;
    m_searchDebounceTimer->start(); // Resets timer
    
    // Add to Recents immediately for UX responsiveness
    bool exists = false;
    for (const QVariant &r : m_recentSearches) {
        if (r.toString() == query) { exists = true; break; }
    }
    if (!exists) {
        m_recentSearches.prepend(query);
        if (m_recentSearches.size() > 5) m_recentSearches.removeLast();
        emit recentSearchesChanged();
    }
}

// onSearchFinished unchanged (it connects to shared reply handler) but logic moved to timer lambda above or split. 
// Actually current implementation uses Member method slot. 
// To allow cleaner code, let's keep onSearchFinished as the slot, and just trigger request in timer.

void NavigationService::onSearchFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;

    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QJsonArray results = doc.array();
        QVariantList searchResults;

        for (const QJsonValue &value : results) {
            QJsonObject obj = value.toObject();
            QVariantMap map;
            map["name"] = obj["display_name"].toString().split(",").first(); // Simplified name
            map["address"] = obj["display_name"].toString();
            map["lat"] = obj["lat"].toString().toDouble();
            map["lon"] = obj["lon"].toString().toDouble();
            searchResults.append(map);
        }
        
        qDebug() << "Found" << searchResults.size() << "results";
        emit searchResultReceived(searchResults);
    } else {
        qDebug() << "Search Error:" << reply->errorString();
        emit errorOccurred("Search failed: " + reply->errorString());
    }
    reply->deleteLater();
}

void NavigationService::startNavigation(const QString &dest)
{
    if (m_currentRoutePath.isEmpty()) {
        emit errorOccurred("No route to navigate");
        return;
    }

    m_isNavigating = true;
    m_destination = dest;
    m_currentRoutePathIndex = 0;
    m_currentStepIndex = 0;
    
    // Snap to start
    if (!m_currentRoutePath.isEmpty()) {
        m_vehiclePosition = m_currentRoutePath.first();
        emit vehiclePositionChanged();
    }
    
    // Initial Maneuver Display
    if (!m_routeSteps.isEmpty()) {
        m_nextManeuver = m_routeSteps[0].instruction;
        QString mod = m_routeSteps[0].modifier;
        if (mod.contains("left")) m_maneuverIcon = "turn_left.svg";
        else if (mod.contains("right")) m_maneuverIcon = "turn_right.svg";
        else if (mod.contains("u-turn")) m_maneuverIcon = "u_turn.svg"; // Placeholder
        else m_maneuverIcon = "navigation-arrow.svg"; // Straight/Head-to
        
        emit voiceInstruction("Starting route. " + m_nextManeuver);
    }
    
    emit navigationStateChanged();
    emit guidanceChanged();
    m_simulationTimer->start(1000);
}

// -----------------------------------------------------------------------------
// SEARCH & PIN LOGIC (Phase 2 Premium)
// -----------------------------------------------------------------------------

QVariantList NavigationService::recentSearches() const { return m_recentSearches; }
QVariantList NavigationService::mapPins() const { return m_mapPins; }

void NavigationService::clearMapPins() {
    if (m_mapPins.isEmpty()) return;
    m_mapPins.clear();
    emit mapPinsChanged();
}

void NavigationService::searchCategory(const QString &category) {
    // Mock Category Search
    // In production, this would query OSRM or Geocoding API with "near me"
    qDebug() << "Searching Category:" << category;
    
    QVariantList results;
    QVariantList newPins;
    
    // Simulate Results based on user location
    // Using random slight offsets from vehicle position
    double lat = m_vehiclePosition.latitude();
    double lon = m_vehiclePosition.longitude();
    
    // Generate 3 mock results
    for (int i = 0; i < 3; i++) {
        double offsetLat = (QRandomGenerator::global()->generateDouble() - 0.5) * 0.02; // ~2km
        double offsetLon = (QRandomGenerator::global()->generateDouble() - 0.5) * 0.02;
        
        QVariantMap place;
        place["name"] = QString("%1 %2").arg(category).arg(i + 1);
        place["address"] = QString("%1 Street %2").arg(category).arg(QRandomGenerator::global()->bounded(10, 999));
        place["latitude"] = lat + offsetLat;
        place["longitude"] = lon + offsetLon;
        
        results.append(place);
        newPins.append(place); // Add to pins
    }
    
    // Add Query to Recents (if unique)
    bool exists = false;
    for (const QVariant &r : m_recentSearches) {
        if (r.toString() == category) { exists = true; break; }
    }
    if (!exists) {
        m_recentSearches.prepend(category);
        if (m_recentSearches.size() > 5) m_recentSearches.removeLast();
        emit recentSearchesChanged();
    }
    
    // Update Pins
    m_mapPins = newPins;
    emit mapPinsChanged();
    
    emit searchResultReceived(results);
}


void NavigationService::stopNavigation()
{
    m_isNavigating = false;
    m_destination = "";
    m_simulationTimer->stop();
    m_currentRoutePath.clear();
    m_routeSteps.clear();
    emit navigationStateChanged();
}

void NavigationService::calculateRoute(const QGeoCoordinate &start, const QGeoCoordinate &end)
{
    // Reset Speed Limit for new route
    m_speedLimit = 90;
    emit guidanceChanged();

    // OSRM Demo API
    QString urlStr = QString("http://router.project-osrm.org/route/v1/driving/%1,%2;%3,%4?overview=full&geometries=geojson&steps=true")
                     .arg(start.longitude())
                     .arg(start.latitude())
                     .arg(end.longitude())
                     .arg(end.latitude());
    
    QUrl url(urlStr);
    QNetworkRequest request(url);
    QNetworkReply *reply = m_networkManager->get(request);
    connect(reply, &QNetworkReply::finished, this, &NavigationService::onRouteFinished);
}

void NavigationService::onRouteFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply) return;

    if (reply->error() == QNetworkReply::NoError) {
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QJsonObject root = doc.object();
        
        if (root.contains("routes") && !root["routes"].toArray().isEmpty()) {
            QJsonObject route = root["routes"].toArray().first().toObject();
            QJsonObject geometry = route["geometry"].toObject();
            QJsonArray coords = geometry["coordinates"].toArray();
            
            // Extract Path for Simulation
            m_currentRoutePath.clear();
            QVariantList pathViz;
            
            for (const QJsonValue &pt : coords) {
                QJsonArray point = pt.toArray();
                double lon = point[0].toDouble();
                double lat = point[1].toDouble();
                QGeoCoordinate coord(lat, lon);
                
                m_currentRoutePath.append(coord);
                pathViz.append(QVariant::fromValue(coord));
            }
            
            // Generate Traffic Segments (Simulated)
            m_trafficSegments.clear();
            if (m_currentRoutePath.size() > 2) {
                int chunkSize = 20; // Points per segment
                for (int i = 0; i < m_currentRoutePath.size(); i += chunkSize) {
                    QVariantList segmentPath;
                    // Ensure overlap to prevent gaps
                    int end = qMin(i + chunkSize + 1, (int)m_currentRoutePath.size());
                    
                    for (int j = i; j < end; j++) {
                        segmentPath.append(QVariant::fromValue(m_currentRoutePath[j]));
                    }
                    
                    // Random Traffic Color
                    QString color = "#4CAF50"; // Green (Default)
                    int rand = QRandomGenerator::global()->bounded(100);
                    if (rand > 80) color = "#F44336"; // Red (Congestion)
                    else if (rand > 60) color = "#FF9800"; // Orange (Slow)
                    
                    QVariantMap segment;
                    segment["path"] = segmentPath;
                    segment["color"] = color;
                    m_trafficSegments.append(segment);
                }
            }
            
            // Extract Steps (REAL LOGIC)
             m_routeSteps.clear();
             if (route.contains("legs")) {
                 QJsonArray legs = route["legs"].toArray();
                 if (!legs.isEmpty()) {
                    QJsonArray steps = legs.first().toObject()["steps"].toArray();
                    for (const QJsonValue &s : steps) {
                        QJsonObject stepObj = s.toObject();
                        QJsonObject maneuver = stepObj["maneuver"].toObject();
                        QJsonArray loc = maneuver["location"].toArray(); // lon, lat
                        
                        RouteStep step;
                        step.distance = stepObj["distance"].toInt();
                        step.maneuverCoordinate = QGeoCoordinate(loc[1].toDouble(), loc[0].toDouble());
                        
                        
                        QString type = maneuver["type"].toString(); // e.g., "turn"
                        QString modifier = maneuver["modifier"].toString(); // e.g., "left"
                        QString name = stepObj["name"].toString();
                        
                        step.modifier = modifier;
                        
                        // Human Readable Construction
                        if (type == "depart") step.instruction = "Head to " + name;
                        else if (type == "arrive") step.instruction = "Arrive at destination";
                        else if (name.isEmpty()) step.instruction = type + " " + modifier;
                        else step.instruction = type + " " + modifier + " on " + name;
                        
                        // Capitalize
                        step.instruction = step.instruction.left(1).toUpper() + step.instruction.mid(1);
                        
                        m_routeSteps.append(step);
                    }
                 }
             }
            
            QVariantMap routeData;
            routeData["path"] = pathViz;
            routeData["duration"] = route["duration"].toDouble();
            routeData["distance"] = route["distance"].toDouble();
            
            // Store total distance for display
            m_distanceMeters = route["distance"].toInt();
            
            emit routeCalculated(routeData);
        }
    } else {
        emit errorOccurred("Routing failed: " + reply->errorString());
    }
    reply->deleteLater();
}

void NavigationService::updateSimulation()
{
    if (!m_isNavigating || m_currentRoutePath.isEmpty()) return;
    
    // Move along path
    if (m_currentRoutePathIndex < m_currentRoutePath.size() - 1) {
        QGeoCoordinate current = m_currentRoutePath[m_currentRoutePathIndex];
        QGeoCoordinate next = m_currentRoutePath[m_currentRoutePathIndex + 1];
        
        m_vehicleBearing = current.azimuthTo(next);
        m_vehiclePosition = next;
        m_currentRoutePathIndex++;
        
        // Update distance
        if (m_distanceMeters > 0) m_distanceMeters -= current.distanceTo(next);
        
        // Maneuver Logic
        checkManeuvers();
        
        emit vehiclePositionChanged();
        emit guidanceChanged(); 
        
    } else {
        stopNavigation();
        m_nextManeuver = "Arrived";
        emit voiceInstruction("You have arrived.");
        emit guidanceChanged();
    }
}

void NavigationService::checkManeuvers() {
    if (m_currentStepIndex >= m_routeSteps.size()) return;
    
    RouteStep currentStep = m_routeSteps[m_currentStepIndex];
    double distToManeuver = m_vehiclePosition.distanceTo(currentStep.maneuverCoordinate);
    
    // If we are very close to the maneuver point (<30m), assume we made the turn and switch to next
    if (distToManeuver < 30) {
        m_currentStepIndex++;
        if (m_currentStepIndex < m_routeSteps.size()) {
             m_nextManeuver = m_routeSteps[m_currentStepIndex].instruction;
             QString mod = m_routeSteps[m_currentStepIndex].modifier;
             if (mod.contains("left")) m_maneuverIcon = "turn_left.svg";
             else if (mod.contains("right")) m_maneuverIcon = "turn_right.svg";
             else if (mod.contains("u-turn")) m_maneuverIcon = "u_turn.svg"; 
             else m_maneuverIcon = "navigation-arrow.svg";
             
             emit voiceInstruction(m_nextManeuver + " in " + QString::number(m_routeSteps[m_currentStepIndex].distance) + " meters");
        }
    }
    
    // Voice Triggers for approaching turn
    // (This required tracking 'state' of voice to avoid spamming, for this MVP we just trigger on index change above)
}
