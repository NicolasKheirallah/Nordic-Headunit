#pragma once
#include <QAbstractListModel>
#include <QObject>
#include <QList>

struct Track {
    QString title;
    QString artist;
    QString album;
    QString sourceUrl;
    QString coverUrl;
    int duration = 0;
};

class PlaylistModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum TrackRoles {
        TitleRole = Qt::UserRole + 1,
        ArtistRole,
        AlbumRole,
        SourceRole,
        CoverRole,
        DurationRole
    };

    explicit PlaylistModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addTrack(const Track &track);
    void setTracks(const QList<Track> &tracks);
    void clear();
    Track getTrack(int index) const;

private:
    QList<Track> m_tracks;
};
