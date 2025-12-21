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

public:
    explicit PhoneService(QObject *parent = nullptr);

    QString callState() const;
    QString callerName() const;
    QString callerNumber() const;
    QString callDuration() const;

    Q_INVOKABLE void dial(const QString &number);
    Q_INVOKABLE void endCall();
    
    // For incoming call simulation
    Q_INVOKABLE void simulateIncomingCall(const QString &name, const QString &number);

signals:
    void callStateChanged();
    void callInfoChanged();
    void callDurationChanged();

private slots:
    void updateDuration();
    void onConnected();

private:
    QString m_callState;
    QString m_callerName;
    QString m_callerNumber;
    int m_durationSeconds;
    
    QTimer *m_durationTimer;
};

#endif // PHONESERVICE_H
