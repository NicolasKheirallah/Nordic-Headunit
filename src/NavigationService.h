#ifndef NAVIGATIONSERVICE_H
#define NAVIGATIONSERVICE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QGeoCoordinate>
#include <QTimer>

class NavigationService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QGeoCoordinate vehiclePosition READ vehiclePosition NOTIFY vehiclePositionChanged)
    Q_PROPERTY(qreal vehicleBearing READ vehicleBearing NOTIFY vehiclePositionChanged)
    Q_PROPERTY(bool isNavigating READ isNavigating NOTIFY navigationStateChanged)
    Q_PROPERTY(QString nextManeuver READ nextManeuver NOTIFY guidanceChanged)
    Q_PROPERTY(QString distanceToManeuver READ distanceToManeuver NOTIFY guidanceChanged)
    Q_PROPERTY(QString destination READ destination NOTIFY navigationStateChanged)
    Q_PROPERTY(QString currentRoadName READ currentRoadName NOTIFY guidanceChanged)
    Q_PROPERTY(int speedLimit READ speedLimit NOTIFY guidanceChanged)
    Q_PROPERTY(QVariantList trafficSegments READ trafficSegments NOTIFY routeCalculated)

public:
    explicit NavigationService(QObject *parent = nullptr);

    bool isNavigating() const;
    QString destination() const;
    QString nextManeuver() const;
    QString distanceToManeuver() const; // Formatted string
    QString currentRoadName() const;
    int speedLimit() const;
    QVariantList trafficSegments() const;
    int distanceMeters() const;
    
    QGeoCoordinate vehiclePosition() const;
    qreal vehicleBearing() const;

    Q_INVOKABLE void startNavigation(const QString &dest);
    Q_INVOKABLE void stopNavigation();
    
    // Search & Pins
    Q_PROPERTY(QVariantList recentSearches READ recentSearches NOTIFY recentSearchesChanged)
    Q_PROPERTY(QVariantList mapPins READ mapPins NOTIFY mapPinsChanged)

    // API Integrations
    Q_INVOKABLE void searchPlaces(const QString &query); // Generic Search
    Q_INVOKABLE void searchCategory(const QString &category); // "Gas", "Food"
    Q_INVOKABLE void clearMapPins();
    Q_INVOKABLE void calculateRoute(const QGeoCoordinate &start, const QGeoCoordinate &end);

    QVariantList recentSearches() const;
    QVariantList mapPins() const;

signals:
    void navigationStateChanged();
    void guidanceChanged();
    void vehiclePositionChanged(); // New signal for simulation
    void voiceInstruction(const QString &text); // TTS signal
    void searchResultReceived(const QVariantList &results);
    void recentSearchesChanged();
    void mapPinsChanged();
    void routeCalculated(const QVariantMap &routeData);
    void errorOccurred(const QString &message);

private slots:
    void onSearchFinished();
    void onRouteFinished();

private:
    bool m_isNavigating;
    QString m_destination;
    QString m_nextManeuver;
    int m_distanceMeters;
    QString m_currentRoadName;

    QNetworkAccessManager *m_networkManager;
    QTimer *m_simulationTimer;
    QTimer *m_searchDebounceTimer;
    QString m_pendingSearchQuery;
    
    // Route Data
    struct RouteStep {
        QString instruction;
        QString modifier; // left, right, slight right
        int distance; // meters
        QGeoCoordinate maneuverCoordinate;
    };
    QList<RouteStep> m_routeSteps;
    int m_currentStepIndex;
    
    // Simulation Data
    QGeoCoordinate m_vehiclePosition;
    qreal m_vehicleBearing;
    
    QList<QGeoCoordinate> m_currentRoutePath;
    
    // Search Data
    QVariantList m_recentSearches;
    QVariantList m_mapPins;
    
    int m_speedLimit = 90; // Default
    int m_currentRoutePathIndex; // Replaces m_currentRouteIndex to avoid confusion
    QVariantList m_trafficSegments;
    
    void updateSimulation(); // Tick method
    void checkManeuvers(); // Check if passed a maneuver
};

#endif // NAVIGATIONSERVICE_H
