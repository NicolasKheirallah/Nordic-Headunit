#include "AppModel.h"
#include <QDebug>

// ═══════════════════════════════════════════════════════════════════════════
// AppListModel Implementation
// ═══════════════════════════════════════════════════════════════════════════

AppListModel::AppListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int AppListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_apps.count();
}

QVariant AppListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_apps.count())
        return QVariant();

    const AppInfo &app = m_apps.at(index.row());

    switch (role) {
    case AppIdRole: return app.appId;
    case DisplayNameRole: return app.displayName;
    case IconUrlRole: return app.iconUrl;
    case CategoryRole: return app.category;
    case IsEnabledRole: return app.isEnabled;
    case LastUsedRole: return app.lastUsed;
    case IsPinnedRole: return app.isPinned;
    default: return QVariant();
    }
}

QHash<int, QByteArray> AppListModel::roleNames() const
{
    return {
        {AppIdRole, "appId"},
        {DisplayNameRole, "displayName"},
        {IconUrlRole, "iconUrl"},
        {CategoryRole, "category"},
        {IsEnabledRole, "isEnabled"},
        {LastUsedRole, "lastUsed"},
        {IsPinnedRole, "isPinned"}
    };
}

void AppListModel::setApps(const QList<AppInfo> &apps)
{
    beginResetModel();
    m_apps = apps;
    endResetModel();
    emit countChanged();
}

void AppListModel::updateApp(const QString &appId, const AppInfo &app)
{
    for (int i = 0; i < m_apps.count(); ++i) {
        if (m_apps[i].appId == appId) {
            m_apps[i] = app;
            emit dataChanged(index(i), index(i));
            return;
        }
    }
}

void AppListModel::setPinned(const QString &appId, bool pinned)
{
    for (int i = 0; i < m_apps.count(); ++i) {
        if (m_apps[i].appId == appId) {
            m_apps[i].isPinned = pinned;
            emit dataChanged(index(i), index(i), {IsPinnedRole});
            return;
        }
    }
}

void AppListModel::updateLastUsed(const QString &appId)
{
    for (int i = 0; i < m_apps.count(); ++i) {
        if (m_apps[i].appId == appId) {
            m_apps[i].lastUsed = QDateTime::currentDateTime();
            emit dataChanged(index(i), index(i), {LastUsedRole});
            return;
        }
    }
}

// ═══════════════════════════════════════════════════════════════════════════
// AppModel (Proxy) Implementation
// ═══════════════════════════════════════════════════════════════════════════

AppModel::AppModel(QObject *parent)
    : QSortFilterProxyModel(parent),
      m_settings("NordicAuto", "HeadunitV2")
{
    m_sourceModel = new AppListModel(this);
    setSourceModel(m_sourceModel);
    setDynamicSortFilter(true);
    setSortRole(AppListModel::DisplayNameRole);
    sort(0, Qt::AscendingOrder);

    // Connect for count updates
    connect(m_sourceModel, &AppListModel::countChanged, this, &AppModel::countChanged);
    connect(this, &QSortFilterProxyModel::rowsInserted, this, &AppModel::countChanged);
    connect(this, &QSortFilterProxyModel::rowsRemoved, this, &AppModel::countChanged);
    connect(this, &QSortFilterProxyModel::modelReset, this, &AppModel::countChanged);

    loadPinnedApps();
    populateMockApps();
}

int AppModel::count() const
{
    return rowCount();
}

QString AppModel::searchQuery() const { return m_searchQuery; }
void AppModel::setSearchQuery(const QString &query)
{
    if (m_searchQuery == query) return;
    m_searchQuery = query;
    invalidateFilter();
    emit searchQueryChanged();
}

QString AppModel::categoryFilter() const { return m_categoryFilter; }
void AppModel::setCategoryFilter(const QString &category)
{
    if (m_categoryFilter == category) return;
    m_categoryFilter = category;
    invalidateFilter();
    emit categoryFilterChanged();
}

bool AppModel::isDriving() const { return m_isDriving; }
void AppModel::setIsDriving(bool driving)
{
    if (m_isDriving == driving) return;
    m_isDriving = driving;
    // Update isEnabled for all apps based on driving state
    emit isDrivingChanged();
}

QString AppModel::sortMode() const { return m_sortMode; }

void AppModel::setSortMode(const QString &mode)
{
    if (m_sortMode == mode) return;
    m_sortMode = mode;
    invalidate();  // Re-sort
    emit sortModeChanged();
}

bool AppModel::hasError() const { return m_hasError; }
QString AppModel::errorMessage() const { return m_errorMessage; }

QVariantList AppModel::recentApps() const
{
    QVariantList result;
    QList<QPair<QDateTime, QVariantMap>> sortedApps;
    
    // Collect apps with lastUsed times
    for (int i = 0; i < m_sourceModel->rowCount(); ++i) {
        QModelIndex idx = m_sourceModel->index(i);
        QDateTime lastUsed = m_sourceModel->data(idx, AppListModel::LastUsedRole).toDateTime();
        if (lastUsed.isValid()) {
            QVariantMap app;
            app["appId"] = m_sourceModel->data(idx, AppListModel::AppIdRole).toString();
            app["displayName"] = m_sourceModel->data(idx, AppListModel::DisplayNameRole).toString();
            app["iconUrl"] = m_sourceModel->data(idx, AppListModel::IconUrlRole).toString();
            app["isEnabled"] = m_sourceModel->data(idx, AppListModel::IsEnabledRole).toBool();
            sortedApps.append({lastUsed, app});
        }
    }
    
    // Sort by most recent first
    std::sort(sortedApps.begin(), sortedApps.end(), 
        [](const QPair<QDateTime, QVariantMap> &a, const QPair<QDateTime, QVariantMap> &b) {
            return a.first > b.first;
        });
    
    // Return top 6
    int count = qMin(6, sortedApps.size());
    for (int i = 0; i < count; ++i) {
        result.append(sortedApps[i].second);
    }
    
    return result;
}

void AppModel::launchApp(const QString &appId)
{
    qDebug() << "Launching app:" << appId;
    m_sourceModel->updateLastUsed(appId);
    emit recentAppsChanged();
    emit appLaunched(appId);
}

void AppModel::togglePin(const QString &appId)
{
    // Find current state
    for (int i = 0; i < m_sourceModel->rowCount(); ++i) {
        QModelIndex idx = m_sourceModel->index(i);
        if (m_sourceModel->data(idx, AppListModel::AppIdRole).toString() == appId) {
            bool currentPinned = m_sourceModel->data(idx, AppListModel::IsPinnedRole).toBool();
            bool newPinned = !currentPinned;
            m_sourceModel->setPinned(appId, newPinned);
            savePinnedApps();
            invalidate(); // Re-sort
            emit pinToggled(appId, newPinned);
            return;
        }
    }
}

void AppModel::refresh()
{
    populateMockApps();
}

AppListModel* AppModel::sourceAppModel() const
{
    return m_sourceModel;
}

bool AppModel::filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const
{
    Q_UNUSED(sourceParent)
    QModelIndex idx = m_sourceModel->index(sourceRow);
    
    // Search filter
    if (!m_searchQuery.isEmpty()) {
        QString name = m_sourceModel->data(idx, AppListModel::DisplayNameRole).toString();
        if (!name.contains(m_searchQuery, Qt::CaseInsensitive))
            return false;
    }

    // Category filter
    if (!m_categoryFilter.isEmpty() && m_categoryFilter != "All") {
        QString category = m_sourceModel->data(idx, AppListModel::CategoryRole).toString();
        if (category != m_categoryFilter)
            return false;
    }

    return true;
}

bool AppModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    // Pinned apps always first
    bool leftPinned = sourceModel()->data(left, AppListModel::IsPinnedRole).toBool();
    bool rightPinned = sourceModel()->data(right, AppListModel::IsPinnedRole).toBool();
    
    if (leftPinned != rightPinned)
        return leftPinned; // Pinned comes first

    // Sort by mode
    if (m_sortMode == "recent") {
        QDateTime leftTime = sourceModel()->data(left, AppListModel::LastUsedRole).toDateTime();
        QDateTime rightTime = sourceModel()->data(right, AppListModel::LastUsedRole).toDateTime();
        // More recent = higher priority (later date)
        if (leftTime.isValid() && rightTime.isValid())
            return leftTime > rightTime;
        if (leftTime.isValid()) return true;
        if (rightTime.isValid()) return false;
    } else if (m_sortMode == "category") {
        QString leftCat = sourceModel()->data(left, AppListModel::CategoryRole).toString();
        QString rightCat = sourceModel()->data(right, AppListModel::CategoryRole).toString();
        if (leftCat != rightCat)
            return leftCat.compare(rightCat, Qt::CaseInsensitive) < 0;
    }

    // Default: alphabetical
    QString leftName = sourceModel()->data(left, AppListModel::DisplayNameRole).toString();
    QString rightName = sourceModel()->data(right, AppListModel::DisplayNameRole).toString();
    return leftName.compare(rightName, Qt::CaseInsensitive) < 0;
}

void AppModel::loadPinnedApps()
{
    // Load from settings
    QStringList pinned = m_settings.value("apps/pinned", QStringList()).toStringList();
    // Will be applied when apps are loaded
}

void AppModel::savePinnedApps()
{
    QStringList pinned;
    for (int i = 0; i < m_sourceModel->rowCount(); ++i) {
        QModelIndex idx = m_sourceModel->index(i);
        if (m_sourceModel->data(idx, AppListModel::IsPinnedRole).toBool()) {
            pinned << m_sourceModel->data(idx, AppListModel::AppIdRole).toString();
        }
    }
    m_settings.setValue("apps/pinned", pinned);
    m_settings.sync();
}

void AppModel::populateMockApps()
{
    // Load persisted pins
    QStringList pinnedIds = m_settings.value("apps/pinned", QStringList()).toStringList();
    
    QList<AppInfo> apps = {
        // Media
        {"com.nordic.music", "Music", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", "Media", true, QDateTime(), pinnedIds.contains("com.nordic.music")},
        {"com.nordic.radio", "Radio", "qrc:/qt/qml/NordicHeadunit/assets/icons/radio-tower.svg", "Media", true, QDateTime(), pinnedIds.contains("com.nordic.radio")},
        {"com.spotify", "Spotify", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", "Media", true, QDateTime(), pinnedIds.contains("com.spotify")},
        {"com.apple.podcasts", "Podcasts", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", "Media", true, QDateTime(), pinnedIds.contains("com.apple.podcasts")},
        {"com.audible", "Audible", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", "Media", true, QDateTime(), pinnedIds.contains("com.audible")},
        
        // Navigation
        {"com.nordic.maps", "Maps", "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg", "Navigation", true, QDateTime(), pinnedIds.contains("com.nordic.maps")},
        {"com.google.maps", "Google Maps", "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg", "Navigation", true, QDateTime(), pinnedIds.contains("com.google.maps")},
        {"com.waze", "Waze", "qrc:/qt/qml/NordicHeadunit/assets/icons/map.svg", "Navigation", true, QDateTime(), pinnedIds.contains("com.waze")},
        
        // Communication
        {"com.nordic.phone", "Phone", "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg", "Communication", true, QDateTime(), pinnedIds.contains("com.nordic.phone")},
        {"com.nordic.messages", "Messages", "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg", "Communication", false, QDateTime(), pinnedIds.contains("com.nordic.messages")}, // Disabled while driving
        {"com.whatsapp", "WhatsApp", "qrc:/qt/qml/NordicHeadunit/assets/icons/phone.svg", "Communication", false, QDateTime(), pinnedIds.contains("com.whatsapp")},
        
        // Vehicle
        {"com.nordic.vehicle", "Vehicle", "qrc:/qt/qml/NordicHeadunit/assets/icons/car.svg", "Vehicle", true, QDateTime(), pinnedIds.contains("com.nordic.vehicle")},
        {"com.nordic.climate", "Climate", "qrc:/qt/qml/NordicHeadunit/assets/icons/fan.svg", "Vehicle", true, QDateTime(), pinnedIds.contains("com.nordic.climate")},
        {"com.nordic.charging", "Charging", "qrc:/qt/qml/NordicHeadunit/assets/icons/charging-station.svg", "Vehicle", true, QDateTime(), pinnedIds.contains("com.nordic.charging")},
        {"com.nordic.parking", "Parking", "qrc:/qt/qml/NordicHeadunit/assets/icons/parking-location.svg", "Vehicle", true, QDateTime(), pinnedIds.contains("com.nordic.parking")},
        
        // Tools
        {"com.nordic.settings", "Settings", "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg", "Tools", true, QDateTime(), pinnedIds.contains("com.nordic.settings")},
        {"com.nordic.weather", "Weather", "qrc:/qt/qml/NordicHeadunit/assets/icons/weather_sunny.svg", "Tools", true, QDateTime(), pinnedIds.contains("com.nordic.weather")},
        {"com.nordic.calendar", "Calendar", "qrc:/qt/qml/NordicHeadunit/assets/icons/clock.svg", "Tools", false, QDateTime(), pinnedIds.contains("com.nordic.calendar")},
        {"com.nordic.calculator", "Calculator", "qrc:/qt/qml/NordicHeadunit/assets/icons/settings.svg", "Tools", false, QDateTime(), pinnedIds.contains("com.nordic.calculator")},
        {"com.nordic.browser", "Browser", "qrc:/qt/qml/NordicHeadunit/assets/icons/search.svg", "Tools", false, QDateTime(), pinnedIds.contains("com.nordic.browser")}
    };
    
    m_sourceModel->setApps(apps);
    invalidate(); // Re-apply filter/sort
}
