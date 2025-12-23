#include "PhoneService.h"
#include <QTime>

PhoneService::PhoneService(QObject *parent)
    : QObject(parent),
      m_callState("Idle"),
      m_durationSeconds(0),
      m_recentsFilter("All")
{
    m_durationTimer = new QTimer(this);
    m_durationTimer->setInterval(1000);
    connect(m_durationTimer, &QTimer::timeout, this, &PhoneService::updateDuration);
    
    // Initialize mock contacts
    m_contacts = {
        {"Alice Johnson", "+1 555-0101"},
        {"Bob Smith", "+1 555-0102"},
        {"Charlie Brown", "+1 555-0103"},
        {"Diana Ross", "+1 555-0104"},
        {"Edward Norton", "+1 555-0105"},
        {"Fiona Apple", "+1 555-0106"},
        {"George Lucas", "+1 555-0107"},
        {"Hannah Montana", "+1 555-0108"}
    };
    
    // Initialize favorites
    m_favorites = {
        {"Mom", "+1 555-1234"},
        {"Dad", "+1 555-5678"},
        {"Work", "+1 555-9999"},
        {"Emergency", "911"}
    };
    
    // Initialize recents
    m_recents = {
        {"Alice Johnson", "+1 555-0101", "10:32 AM", "incoming"},
        {"Unknown", "+1 555-8888", "Yesterday", "missed"},
        {"Bob Smith", "+1 555-0102", "Yesterday", "outgoing"},
        {"Mom", "+1 555-1234", "Dec 21", "outgoing"},
        {"Work", "+1 555-9999", "Dec 20", "missed"}
    };
}

QString PhoneService::callState() const { return m_callState; }
QString PhoneService::callerName() const { return m_callerName; }
QString PhoneService::callerNumber() const { return m_callerNumber; }

QString PhoneService::callDuration() const {
    int mins = m_durationSeconds / 60;
    int secs = m_durationSeconds % 60;
    return QString("%1:%2").arg(mins, 2, 10, QChar('0')).arg(secs, 2, 10, QChar('0'));
}

QString PhoneService::activeNumber() const { return m_activeNumber; }
void PhoneService::setActiveNumber(const QString &number) {
    if (m_activeNumber != number) {
        m_activeNumber = number;
        emit activeNumberChanged();
    }
}

QString PhoneService::searchQuery() const { return m_searchQuery; }
void PhoneService::setSearchQuery(const QString &query) {
    if (m_searchQuery != query) {
        m_searchQuery = query;
        emit searchQueryChanged();
    }
}

QString PhoneService::recentsFilter() const { return m_recentsFilter; }
void PhoneService::setRecentsFilter(const QString &filter) {
    if (m_recentsFilter != filter) {
        m_recentsFilter = filter;
        emit recentsFilterChanged();
    }
}

QVariantList PhoneService::contacts() const {
    QVariantList list;
    for (const auto& c : m_contacts) {
        QVariantMap contact;
        contact["name"] = c.name;
        contact["number"] = c.number;
        list.append(contact);
    }
    return list;
}

QVariantList PhoneService::filteredContacts() const {
    QVariantList list;
    for (const auto& c : m_contacts) {
        if (m_searchQuery.isEmpty() || 
            c.name.contains(m_searchQuery, Qt::CaseInsensitive) ||
            c.number.contains(m_searchQuery)) {
            QVariantMap contact;
            contact["name"] = c.name;
            contact["number"] = c.number;
            list.append(contact);
        }
    }
    return list;
}

QVariantList PhoneService::favorites() const {
    QVariantList list;
    for (const auto& c : m_favorites) {
        QVariantMap contact;
        contact["name"] = c.name;
        contact["number"] = c.number;
        list.append(contact);
    }
    return list;
}

QVariantList PhoneService::recents() const {
    QVariantList list;
    for (const auto& r : m_recents) {
        QVariantMap record;
        record["name"] = r.name;
        record["number"] = r.number;
        record["time"] = r.time;
        record["callType"] = r.callType;
        list.append(record);
    }
    return list;
}

QVariantList PhoneService::filteredRecents() const {
    QVariantList list;
    for (const auto& r : m_recents) {
        if (m_recentsFilter == "All" || 
            (m_recentsFilter == "Missed" && r.callType == "missed")) {
            QVariantMap record;
            record["name"] = r.name;
            record["number"] = r.number;
            record["time"] = r.time;
            record["callType"] = r.callType;
            list.append(record);
        }
    }
    return list;
}

void PhoneService::dial(const QString &number)
{
    if (m_callState != "Idle") return;
    m_callState = "Dialing";
    m_callerNumber = number;
    
    // Lookup name from contacts
    m_callerName = "Unknown";
    for (const auto& c : m_contacts) {
        if (c.number == number) {
            m_callerName = c.name;
            break;
        }
    }
    for (const auto& f : m_favorites) {
        if (f.number == number) {
            m_callerName = f.name;
            break;
        }
    }
    
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
