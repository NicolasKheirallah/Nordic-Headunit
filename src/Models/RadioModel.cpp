#include "RadioModel.h"

RadioModel::RadioModel(QObject *parent) : QAbstractListModel(parent) {}

int RadioModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return m_stations.count();
}

QVariant RadioModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_stations.count()) return QVariant();

    const RadioStation &station = m_stations[index.row()];
    switch (role) {
    case NameRole: return station.name;
    case FrequencyRole: return station.frequency;
    case BandRole: return station.band;
    case ActiveRole: return station.active;
    default: return QVariant();
    }
}

QHash<int, QByteArray> RadioModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[FrequencyRole] = "frequency";
    roles[BandRole] = "band";
    roles[ActiveRole] = "active";
    return roles;
}

void RadioModel::addStation(const RadioStation &station) {
    beginInsertRows(QModelIndex(), m_stations.count(), m_stations.count());
    m_stations.append(station);
    endInsertRows();
}

void RadioModel::clear() {
    beginResetModel();
    m_stations.clear();
    endResetModel();
}

void RadioModel::setActive(int index) {
    // Deactivate all
    for (int i = 0; i < m_stations.count(); ++i) {
        if (m_stations[i].active) {
            m_stations[i].active = false;
            emit dataChanged(this->index(i), this->index(i), {ActiveRole});
        }
    }
    
    if (index >= 0 && index < m_stations.count()) {
        m_stations[index].active = true;
        emit dataChanged(this->index(index), this->index(index), {ActiveRole});
    }
}

RadioStation RadioModel::getStation(int index) const {
    if (index < 0 || index >= m_stations.count()) return RadioStation();
    return m_stations[index];
}

int RadioModel::activeStationIndex() const {
    for (int i = 0; i < m_stations.count(); ++i) {
        if (m_stations[i].active) return i;
    }
    return -1;
}

QList<RadioStation> RadioModel::getAll() const {
    return m_stations;
}
