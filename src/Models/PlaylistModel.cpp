#include "PlaylistModel.h"

PlaylistModel::PlaylistModel(QObject *parent) : QAbstractListModel(parent) {}

int PlaylistModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return m_tracks.count();
}

QVariant PlaylistModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_tracks.count()) return QVariant();

    const Track &track = m_tracks[index.row()];
    switch (role) {
    case TitleRole: return track.title;
    case ArtistRole: return track.artist;
    case AlbumRole: return track.album;
    case SourceRole: return track.sourceUrl;
    case CoverRole: return track.coverUrl;
    case DurationRole: return track.duration;
    default: return QVariant();
    }
}

QHash<int, QByteArray> PlaylistModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[TitleRole] = "title";
    roles[ArtistRole] = "artist";
    roles[AlbumRole] = "album";
    roles[SourceRole] = "sourceUrl";
    roles[CoverRole] = "coverUrl";
    roles[DurationRole] = "duration";
    return roles;
}

void PlaylistModel::addTrack(const Track &track) {
    beginInsertRows(QModelIndex(), m_tracks.count(), m_tracks.count());
    m_tracks.append(track);
    endInsertRows();
}

void PlaylistModel::clear() {
    beginResetModel();
    m_tracks.clear();
    endResetModel();
}

Track PlaylistModel::getTrack(int index) const {
    if (index < 0 || index >= m_tracks.count()) return Track();
    return m_tracks[index];
}
