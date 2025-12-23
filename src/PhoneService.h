#ifndef PHONESERVICE_H
#define PHONESERVICE_H

#include <QObject>
#include <QTimer>

class PhoneService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString callState READ callState NOTIFY callStateChanged) // "Idle", "Dialing", "Connected"
    Q_PROPERTY(QString callerName READ callerName NOTIFY callInfoChanged)
    Q_PROPERTY(QString callerNumber READ callerNumber NOTIFY callInfoChanged)
    Q_PROPERTY(QString callDuration READ callDuration NOTIFY callDurationChanged)
    
    // Active number being dialed
    Q_PROPERTY(QString activeNumber READ activeNumber WRITE setActiveNumber NOTIFY activeNumberChanged)
    
    // Contacts and recents data
    Q_PROPERTY(QVariantList contacts READ contacts CONSTANT)
    Q_PROPERTY(QVariantList filteredContacts READ filteredContacts NOTIFY searchQueryChanged)
    Q_PROPERTY(QVariantList favorites READ favorites CONSTANT)
    Q_PROPERTY(QVariantList recents READ recents CONSTANT)
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
    QVariantList contacts() const;
    QVariantList filteredContacts() const;
    QVariantList favorites() const;
    QVariantList recents() const;
    QVariantList filteredRecents() const;
    
    // Filters
    QString searchQuery() const;
    void setSearchQuery(const QString &query);
    QString recentsFilter() const;
    void setRecentsFilter(const QString &filter);

    Q_INVOKABLE void dial(const QString &number);
    Q_INVOKABLE void endCall();
    
    // For incoming call simulation
    Q_INVOKABLE void simulateIncomingCall(const QString &name, const QString &number);

signals:
    void callStateChanged();
    void callInfoChanged();
    void callDurationChanged();
    void activeNumberChanged();
    void searchQueryChanged();
    void recentsFilterChanged();

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
    
    QTimer *m_durationTimer;
    
    // Mock data
    struct Contact {
        QString name;
        QString number;
    };
    QList<Contact> m_contacts;
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
