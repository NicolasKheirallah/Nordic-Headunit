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
    Q_PROPERTY(bool isSearching READ isSearching NOTIFY isSearchingChanged)
    Q_PROPERTY(bool hasSearchResults READ hasSearchResults NOTIFY searchResultsUpdated)
    Q_PROPERTY(int searchResultsCount READ searchResultsCount NOTIFY searchResultsUpdated)

public:
    explicit MediaLibrary(QObject *parent = nullptr);
    ~MediaLibrary();

    PlaylistModel* model() const;
    PlaylistModel* searchResultsModel() const; // For search results
    
    bool isIndexing() const;
    bool isSearching() const { return m_isSearching; }
    bool hasSearchResults() const;
    int searchResultsCount() const;

    // Actions
    void scanLibrary();
    Q_INVOKABLE void search(const QString &query);
    void toggleLike(int trackIndex);
    bool isLiked(int trackIndex) const;
    Q_INVOKABLE void playFromSearchResult(int index);
    Q_INVOKABLE void clearSearch();

signals:
    void indexingChanged();
    void libraryUpdated();
    void searchResultsUpdated();
    void isSearchingChanged();

private:
    PlaylistModel *m_mainModel;
    PlaylistModel *m_searchModel;
    
    bool m_isIndexing;
    bool m_isSearching = false;
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
