#include "PhoneService.h"
#include <QTime>

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <QRandomGenerator>

PhoneService::PhoneService(QObject *parent)
    : QObject(parent),
      m_callState("Idle"),
      m_durationSeconds(0),
      m_recentsFilter("All"),
      m_muted(false),
      m_audioRoute(RouteVehicle)
{
    m_durationTimer = new QTimer(this);
    m_durationTimer->setInterval(1000);
    connect(m_durationTimer, &QTimer::timeout, this, &PhoneService::updateDuration);
    
    // Initialize Contacts Model
    m_contactsModel = new ContactsModel(this);
    
    // Initialize favorites
    if (m_favorites.isEmpty()) {
        m_favorites = {
            {"Mom", "+1 555-1234"},
            {"Dad", "+1 555-5678"},
            {"Work", "+1 555-9999"},
            {"Emergency", "911"}
        };
    }
    
    if (m_recents.isEmpty()) {
        // Default mocks
        m_recents = {
            {"Alice Johnson", "+1 555-0101", "10:32 AM", "incoming"},
            {"Unknown", "+1 555-8888", "Yesterday", "missed"},
            {"Bob Smith", "+1 555-0102", "Yesterday", "outgoing"}
        };
    }
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

ContactsModel* PhoneService::contactsModel() const { return m_contactsModel; }

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
    
    // Lookup name from contacts model
    m_callerName = m_contactsModel->getNameForNumber(number);
    if (m_callerName.isEmpty()) m_callerName = "Unknown";
    
    // Also check favorites
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
        
        // Add to Recents
        CallRecord record;
        record.name = m_callerName;
        record.number = m_callerNumber;
        record.time = QTime::currentTime().toString("h:mm AP");
        record.callType = "outgoing";
        
        m_recents.prepend(record);
        if (m_recents.size() > 50) m_recents.removeLast();
        
        emit recentsChanged();
        emit recentsFilterChanged();
        saveData();
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
     m_callState = "Incoming Call";
     m_callerName = name;
     m_callerNumber = number;
     emit callStateChanged();
     emit callInfoChanged();
     
     // Add to recents as Incoming (or Missed if ignored?) 
     // We settle it when answered or ignored. For now add as incoming.
     // Real implementation sets it on end.
     
     // Auto-answer simulation after 10s if we wanted, but let's wait for user.
}

// Audio Controls
bool PhoneService::muted() const { return m_muted; }
void PhoneService::setMuted(bool muted) {
    if (m_muted == muted) return;
    m_muted = muted;
    emit mutedChanged();
}

PhoneService::AudioRoute PhoneService::audioRoute() const { return m_audioRoute; }
void PhoneService::setAudioRoute(AudioRoute route) {
    if (m_audioRoute == route) return;
    m_audioRoute = route;
    emit audioRouteChanged();
}
void PhoneService::setAudioRoute(int route) { setAudioRoute(static_cast<AudioRoute>(route)); }

void PhoneService::sendDtmf(const QString &tone) {
    if (m_callState == "Connected") {
        qDebug() << "Sending DTMF Tone:" << tone;
        // In real backend, e.g. bluez-qt, we would call call->sendDtmf(tone)
    }
}

void PhoneService::triggerIncomingCall() {
    if (m_callState != "Idle") return;
    
    // Randomly pick a contact from model (via simple logic or just create random implementation here)
    // Accessing model data from service: access filtered or raw? 
    // m_contactsModel has internal lists.
    // For simulation, we can just pick a random mock number.
    
    QString name, number;
    int roll = QRandomGenerator::global()->bounded(0, 100);
    
    if (roll > 50) {
        // Mock known contact
        name = "Alice Johnson"; // Should ideally pick from m_contactsModel->data() but we don't have easy random access without casting.
        number = "+1 555-0101"; 
    } else {
        name = "";
        number = "+1 555-" + QString::number(QRandomGenerator::global()->bounded(1000, 9999));
    }
    
    simulateIncomingCall(name, number);
}

QString PhoneService::formatNumber(const QString &number) const {
    // Basic US-style formatting logic
    QString clean = number;
    clean.remove(QRegularExpression("[^0-9]"));
    
    // 10 digit local: (XXX) XXX-XXXX
    if (clean.length() == 10) {
        return QString("(%1) %2-%3")
            .arg(clean.mid(0, 3))
            .arg(clean.mid(3, 3))
            .arg(clean.mid(6, 4));
    }
    
    // 11 digit with +1: +1 (XXX) XXX-XXXX
    if (clean.length() == 11 && clean.startsWith("1")) {
         return QString("+1 (%1) %2-%3")
            .arg(clean.mid(1, 3))
            .arg(clean.mid(4, 3))
            .arg(clean.mid(7, 4));
    }
    
    // Fallback: Return original structure if it looks pre-formatted or unknown length
    return number;
}

void PhoneService::loadData() {
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    QFile file(dir.filePath("phone_data.json"));
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonObject root = doc.object();
        
        // Recents
        m_recents.clear();
        QJsonArray rec = root["recents"].toArray();
        for (const auto &v : rec) {
            QJsonObject o = v.toObject();
            m_recents.append({o["name"].toString(), o["number"].toString(), o["time"].toString(), o["type"].toString()});
        }
        
        // Favorites
        m_favorites.clear();
        QJsonArray fav = root["favorites"].toArray();
        for (const auto &v : fav) {
            QJsonObject o = v.toObject();
            m_favorites.append({o["name"].toString(), o["number"].toString()});
        }
    }
}

void PhoneService::saveData() {
    QJsonObject root;
    
    QJsonArray rec;
    for (const auto &r : m_recents) {
        QJsonObject o;
        o["name"] = r.name;
        o["number"] = r.number;
        o["time"] = r.time;
        o["type"] = r.callType;
        rec.append(o);
    }
    root["recents"] = rec;
    
    QJsonArray fav;
    for (const auto &f : m_favorites) {
        QJsonObject o;
        o["name"] = f.name;
        o["number"] = f.number;
        fav.append(o);
    }
    root["favorites"] = fav;
    
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    if (!dir.exists()) dir.mkpath(".");
    QFile file(dir.filePath("phone_data.json"));
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(root).toJson());
    }
}

void PhoneService::updateDuration()
{
    m_durationSeconds++;
    emit callDurationChanged();
}
