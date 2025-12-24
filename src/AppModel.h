#ifndef APPMODEL_H
#define APPMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QSortFilterProxyModel>
#include <QDateTime>
#include <QSettings>

// ═══════════════════════════════════════════════════════════════════════════
// App Data Structure
// ═══════════════════════════════════════════════════════════════════════════
struct AppInfo {
    QString appId;
    QString displayName;
    QString iconUrl;
    QString category;        // Media, Navigation, Communication, Vehicle, Tools
    bool isEnabled = true;   // Driving policy
    QDateTime lastUsed;
    bool isPinned = false;
};

// ═══════════════════════════════════════════════════════════════════════════
// Base App List Model
// ═══════════════════════════════════════════════════════════════════════════
class AppListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles {
        AppIdRole = Qt::UserRole + 1,
        DisplayNameRole,
        IconUrlRole,
        CategoryRole,
        IsEnabledRole,
        LastUsedRole,
        IsPinnedRole
    };

    explicit AppListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setApps(const QList<AppInfo> &apps);
    void updateApp(const QString &appId, const AppInfo &app);
    void setPinned(const QString &appId, bool pinned);
    void updateLastUsed(const QString &appId);

signals:
    void countChanged();

private:
    QList<AppInfo> m_apps;
};

// ═══════════════════════════════════════════════════════════════════════════
// Filter/Sort Proxy Model (Exposed to QML as AppModel)
// ═══════════════════════════════════════════════════════════════════════════
class AppModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)
    Q_PROPERTY(QString categoryFilter READ categoryFilter WRITE setCategoryFilter NOTIFY categoryFilterChanged)
    Q_PROPERTY(QString sortMode READ sortMode WRITE setSortMode NOTIFY sortModeChanged)
    Q_PROPERTY(bool isDriving READ isDriving WRITE setIsDriving NOTIFY isDrivingChanged)
    Q_PROPERTY(bool hasError READ hasError NOTIFY hasErrorChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)
    Q_PROPERTY(QVariantList recentApps READ recentApps NOTIFY recentAppsChanged)

public:
    explicit AppModel(QObject *parent = nullptr);

    int count() const;
    
    QString searchQuery() const;
    void setSearchQuery(const QString &query);

    QString categoryFilter() const;
    void setCategoryFilter(const QString &category);
    
    QString sortMode() const;
    void setSortMode(const QString &mode);

    bool isDriving() const;
    void setIsDriving(bool driving);

    bool hasError() const;
    QString errorMessage() const;
    QVariantList recentApps() const;

    // Actions
    Q_INVOKABLE void launchApp(const QString &appId);
    Q_INVOKABLE void togglePin(const QString &appId);
    Q_INVOKABLE void refresh();

    // Access to source model
    AppListModel* sourceAppModel() const;

signals:
    void countChanged();
    void searchQueryChanged();
    void categoryFilterChanged();
    void sortModeChanged();
    void isDrivingChanged();
    void hasErrorChanged();
    void errorMessageChanged();
    void recentAppsChanged();
    void appLaunched(const QString &appId);
    void pinToggled(const QString &appId, bool isPinned);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
    bool lessThan(const QModelIndex &left, const QModelIndex &right) const override;

private:
    AppListModel *m_sourceModel;
    QString m_searchQuery;
    QString m_categoryFilter;
    QString m_sortMode = "name";  // name, recent, category
    bool m_isDriving = false;
    bool m_hasError = false;
    QString m_errorMessage;
    QSettings m_settings;

    void loadPinnedApps();
    void savePinnedApps();
    void populateMockApps();
};

#endif // APPMODEL_H
