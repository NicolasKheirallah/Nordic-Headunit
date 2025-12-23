#include "ContactsModel.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QFile>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

ContactsModel::ContactsModel(QObject *parent)
    : QAbstractListModel(parent)
{
    loadData();
    if (m_allContacts.isEmpty()) {
        // Default Mock Data
        addContact("Alice Johnson", "+1 555-0101");
        addContact("Bob Smith", "+1 555-0102");
        addContact("Charlie Brown", "+1 555-0103");
        addContact("Diana Ross", "+1 555-0104");
        addContact("Edward Norton", "+1 555-0105");
        addContact("Fiona Apple", "+1 555-0106");
        addContact("George Lucas", "+1 555-0107");
        addContact("Hannah Montana", "+1 555-0108");
        addContact("Isabella Swan", "+1 555-0109");
        addContact("Jack Sparrow", "+1 555-0110");
        addContact("Kyle Reese", "+1 555-0111");
        saveData(); // Save initial mocks
    }
}

int ContactsModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_displayedContacts.count();
}

QVariant ContactsModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_displayedContacts.count())
        return QVariant();

    const ContactItem &item = m_displayedContacts[index.row()];
    switch (role) {
    case NameRole: return item.name;
    case NumberRole: return item.number;
    case AvatarRole: return item.avatar;
    default: return QVariant();
    }
}

QHash<int, QByteArray> ContactsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[NumberRole] = "number";
    roles[AvatarRole] = "avatar";
    return roles;
}

void ContactsModel::addContact(const QString &name, const QString &number, const QString &avatar)
{
    beginInsertRows(QModelIndex(), m_allContacts.count(), m_allContacts.count());
    m_allContacts.append({name, number, avatar});
    endInsertRows();
    applyFilter();
    saveData();
}

void ContactsModel::clear()
{
    beginResetModel();
    m_allContacts.clear();
    m_displayedContacts.clear();
    endResetModel();
    saveData();
}

void ContactsModel::setFilter(const QString &query)
{
    if (m_filterQuery == query) return;
    m_filterQuery = query;
    applyFilter();
}

void ContactsModel::applyFilter()
{
    beginResetModel();
    if (m_filterQuery.isEmpty()) {
        m_displayedContacts = m_allContacts;
    } else {
        m_displayedContacts.clear();
        for (const auto &c : m_allContacts) {
            if (c.name.contains(m_filterQuery, Qt::CaseInsensitive) || 
                c.number.contains(m_filterQuery)) {
                m_displayedContacts.append(c);
            }
        }
    }
    endResetModel();
}

void ContactsModel::loadData()
{
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    QFile file(dir.filePath("contacts.json"));
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonArray arr = doc.array();
        
        beginResetModel();
        m_allContacts.clear();
        for (const auto &v : arr) {
            QJsonObject o = v.toObject();
            m_allContacts.append({o["name"].toString(), o["number"].toString(), o["avatar"].toString()});
        }
        applyFilter(); // Logic handles displayed contacts
        endResetModel();
    }
    // Note: applyFilter calls beginResetModel/endResetModel, so we might double call if careful.
    // Fixed logic: loadData populates m_allContacts, then applyFilter resets.
}

void ContactsModel::saveData()
{
    QJsonArray arr;
    for (const auto &c : m_allContacts) {
        QJsonObject o;
        o["name"] = c.name;
        o["number"] = c.number;
        o["avatar"] = c.avatar;
        arr.append(o);
    }
    
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    if (!dir.exists()) dir.mkpath(".");
    QFile file(dir.filePath("contacts.json"));
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(arr).toJson());
    }
}

QString ContactsModel::getNameForNumber(const QString &number) const {
    for (const auto &c : m_allContacts) {
        // Simple exact match or subset. Phone formatting might complicate this.
        // For simulation, exact or contains.
        if (c.number == number) return c.name;
    }
    return "";
}
