#ifndef MEDIALIBRARY_H
#define MEDIALIBRARY_H

#include <QObject>
#include <QMutex>
#include <QFutureWatcher>
#include "Models/PlaylistModel.h"

class MediaLibrary : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isIndexing READ isIndexing NOTIFY indexingChanged)

public:
    explicit MediaLibrary(QObject *parent = nullptr);
    ~MediaLibrary();

    PlaylistModel* model() const;
    PlaylistModel* searchResultsModel() const; // For search results
    
    bool isIndexing() const;

    // Actions
    void scanLibrary();
    void search(const QString &query);
    void toggleLike(int trackIndex);
    bool isLiked(int trackIndex) const;

signals:
    void indexingChanged();
    void libraryUpdated();
    void searchResultsUpdated();

private:
    PlaylistModel *m_mainModel;
    PlaylistModel *m_searchModel;
    
    bool m_isIndexing;
    QFutureWatcher<QList<Track>> *m_scanWatcher;
    QList<Track> m_allTracks; // Master list
    QMutex m_mutex;
    QSet<QString> m_likedTracks; // Persisted by URL/Path
    
    // Helpers
    QList<Track> performScan();
    void loadLikes();
    void saveLikes();
};

#endif // MEDIALIBRARY_H
