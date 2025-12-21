#include "PhoneService.h"
#include <QTime>

PhoneService::PhoneService(QObject *parent)
    : QObject(parent),
      m_callState("Idle"),
      m_durationSeconds(0)
{
    m_durationTimer = new QTimer(this);
    m_durationTimer->setInterval(1000);
    connect(m_durationTimer, &QTimer::timeout, this, &PhoneService::updateDuration);
}

QString PhoneService::callState() const { return m_callState; }
QString PhoneService::callerName() const { return m_callerName; }
QString PhoneService::callerNumber() const { return m_callerNumber; }

QString PhoneService::callDuration() const {
    int mins = m_durationSeconds / 60;
    int secs = m_durationSeconds % 60;
    return QString("%1:%2").arg(mins, 2, 10, QChar('0')).arg(secs, 2, 10, QChar('0'));
}

void PhoneService::dial(const QString &number)
{
    if (m_callState != "Idle") return;
    m_callState = "Dialing";
    m_callerNumber = number;
    m_callerName = "Unknown"; // Mock lookup
    emit callStateChanged();
    emit callInfoChanged();
    
    // Connect after 2s
    QTimer::singleShot(2000, this, &PhoneService::onConnected);
}

void PhoneService::onConnected()
{
    if (m_callState == "Dialing") {
        m_callState = "Connected";
        m_durationSeconds = 0;
        m_durationTimer->start();
        emit callStateChanged();
    }
}

void PhoneService::endCall()
{
    m_callState = "Idle";
    m_durationTimer->stop();
    m_callerName = "";
    m_callerNumber = "";
    emit callStateChanged();
    emit callInfoChanged();
}

void PhoneService::simulateIncomingCall(const QString &name, const QString &number)
{
     if (m_callState != "Idle") return;
     m_callState = "Incoming";
     m_callerName = name;
     m_callerNumber = number;
     emit callStateChanged();
     emit callInfoChanged();
}

void PhoneService::updateDuration()
{
    m_durationSeconds++;
    emit callDurationChanged();
}
