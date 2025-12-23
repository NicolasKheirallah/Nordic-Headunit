#ifndef PHONESERVICE_H
#define PHONESERVICE_H

#include <QObject>
#include <QTimer>
#include "ContactsModel.h"

class PhoneService : public QObject
{
    Q_OBJECT
    
public:
    enum AudioRoute { RouteVehicle = 0, RouteHandset = 1, RouteSpeaker = 2 };
    Q_ENUM(AudioRoute)

    Q_PROPERTY(QString callState READ callState NOTIFY callStateChanged) // "Idle", "Dialing", "Connected"
    Q_PROPERTY(QString callerName READ callerName NOTIFY callInfoChanged)
    Q_PROPERTY(QString callerNumber READ callerNumber NOTIFY callInfoChanged)
    Q_PROPERTY(QString callDuration READ callDuration NOTIFY callDurationChanged)
    
    // Active number being dialed
    Q_PROPERTY(QString activeNumber READ activeNumber WRITE setActiveNumber NOTIFY activeNumberChanged)
    
    // Contacts and recents data
    Q_PROPERTY(bool muted READ muted WRITE setMuted NOTIFY mutedChanged)
    Q_PROPERTY(AudioRoute audioRoute READ audioRoute WRITE setAudioRoute NOTIFY audioRouteChanged)



    // Using ContactsModel directly for filtered/all contacts
    Q_PROPERTY(ContactsModel* contactsModel READ contactsModel CONSTANT)
    
    // Legacy QVariantList properties removed or proxied if absolutely needed (removing for clean break)
    // Q_PROPERTY(QVariantList filteredContacts READ filteredContacts NOTIFY searchQueryChanged) -> Handled by ContactsModel filtering
    Q_PROPERTY(QVariantList favorites READ favorites NOTIFY favoritesChanged)
    Q_PROPERTY(QVariantList recents READ recents NOTIFY recentsChanged)
    Q_PROPERTY(QVariantList filteredRecents READ filteredRecents NOTIFY recentsFilterChanged)
    
    // Filters
    Q_PROPERTY(QString searchQuery READ searchQuery WRITE setSearchQuery NOTIFY searchQueryChanged)
    Q_PROPERTY(QString recentsFilter READ recentsFilter WRITE setRecentsFilter NOTIFY recentsFilterChanged)

public:
    explicit PhoneService(QObject *parent = nullptr);

    QString callState() const;
    QString callerName() const;
    QString callerNumber() const;
    QString callDuration() const;
    
    // Active number
    QString activeNumber() const;
    void setActiveNumber(const QString &number);
    
    // Data lists
    ContactsModel* contactsModel() const;
    QVariantList favorites() const;
    QVariantList recents() const;
    QVariantList filteredRecents() const;
    
    // Filters
    QString searchQuery() const;
    void setSearchQuery(const QString &query);
    QString recentsFilter() const;
    void setRecentsFilter(const QString &filter);

    // Audio Controls
    bool muted() const;
    void setMuted(bool muted);
    AudioRoute audioRoute() const;
    void setAudioRoute(AudioRoute route);
    Q_INVOKABLE void setAudioRoute(int route); // QML convenience

    Q_INVOKABLE void dial(const QString &number);
    Q_INVOKABLE void endCall();
    Q_INVOKABLE void sendDtmf(const QString &tone);
    
    // For incoming call simulation
    Q_INVOKABLE void simulateIncomingCall(const QString &name, const QString &number);
    Q_INVOKABLE void triggerIncomingCall(); // Random simulation helper
    
    Q_INVOKABLE QString formatNumber(const QString &number) const;

signals:
    void callStateChanged();
    void callInfoChanged();
    void callDurationChanged();
    void activeNumberChanged();

    void searchQueryChanged();
    void recentsFilterChanged();
    
    void mutedChanged();
    void audioRouteChanged();
    void contactsChanged();
    void favoritesChanged();
    void recentsChanged();

private slots:
    void updateDuration();
    void onConnected();

private:
    QString m_callState;
    QString m_callerName;
    QString m_callerNumber;
    int m_durationSeconds;
    QString m_activeNumber;
    QString m_searchQuery;
    QString m_recentsFilter;
    
    bool m_muted;
    AudioRoute m_audioRoute;
    
    QTimer *m_durationTimer;
    
    // Data persistence
    void loadData();
    void saveData();
    
    // Models
    ContactsModel *m_contactsModel;
    
    // Mock data (favorites and recents still simple lists for now, or upgrade them too? Keeping lists for scope management)
    struct Contact {
        QString name;
        QString number;
    };
    QList<Contact> m_favorites;
    
    struct CallRecord {
        QString name;
        QString number;
        QString time;
        QString callType; // "incoming", "outgoing", "missed"
    };
    QList<CallRecord> m_recents;
};

#endif // PHONESERVICE_H
