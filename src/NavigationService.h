#ifndef NAVIGATIONSERVICE_H
#define NAVIGATIONSERVICE_H

#include <QObject>

class NavigationService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isNavigating READ isNavigating NOTIFY navigationStateChanged)
    Q_PROPERTY(QString destination READ destination NOTIFY navigationStateChanged)
    Q_PROPERTY(QString nextManeuver READ nextManeuver NOTIFY guidanceChanged)
    Q_PROPERTY(QString distanceToManeuver READ distanceToManeuver NOTIFY guidanceChanged)
    Q_PROPERTY(int distanceMeters READ distanceMeters NOTIFY guidanceChanged)

public:
    explicit NavigationService(QObject *parent = nullptr);

    bool isNavigating() const;
    QString destination() const;
    QString nextManeuver() const;
    QString distanceToManeuver() const; // Formatted string
    int distanceMeters() const;

    Q_INVOKABLE void startNavigation(const QString &dest);
    Q_INVOKABLE void stopNavigation();

signals:
    void navigationStateChanged();
    void guidanceChanged();

private:
    bool m_isNavigating;
    QString m_destination;
    QString m_nextManeuver;
    int m_distanceMeters;
};

#endif // NAVIGATIONSERVICE_H
