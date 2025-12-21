#include "NavigationService.h"

NavigationService::NavigationService(QObject *parent)
    : QObject(parent),
      m_isNavigating(false),
      m_destination(""),
      m_nextManeuver("Turn Right"),
      m_distanceMeters(200)
{
}

bool NavigationService::isNavigating() const { return m_isNavigating; }
QString NavigationService::destination() const { return m_destination; }
QString NavigationService::nextManeuver() const { return m_nextManeuver; }
int NavigationService::distanceMeters() const { return m_distanceMeters; }

QString NavigationService::distanceToManeuver() const {
    if (m_distanceMeters >= 1000) return QString::number(m_distanceMeters / 1000.0, 'f', 1) + " km";
    return QString::number(m_distanceMeters) + " m";
}

void NavigationService::startNavigation(const QString &dest)
{
    m_isNavigating = true;
    m_destination = dest;
    m_distanceMeters = 2500; // Mock starting distance
    emit navigationStateChanged();
    emit guidanceChanged();
}

void NavigationService::stopNavigation()
{
    m_isNavigating = false;
    m_destination = "";
    emit navigationStateChanged();
}
