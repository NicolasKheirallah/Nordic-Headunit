#include "MediaLibrary.h"
#include <QtConcurrent/QtConcurrent>
#include <QStandardPaths>
#include <QDir>
#include <QDirIterator>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>

MediaLibrary::MediaLibrary(QObject *parent)
    : QObject(parent),
      m_isIndexing(false)
{
    m_mainModel = new PlaylistModel(this);
    m_searchModel = new PlaylistModel(this); // Separate model for search
    m_scanWatcher = new QFutureWatcher<QList<Track>>(this);

    connect(m_scanWatcher, &QFutureWatcher<QList<Track>>::finished, this, [this]() {
        QList<Track> results = m_scanWatcher->result();
        
        QMutexLocker locker(&m_mutex);
        m_allTracks = results;
        m_mainModel->setTracks(m_allTracks); // Update UI model
        
        m_isIndexing = false;
        emit indexingChanged();
        emit libraryUpdated();
    });

    loadLikes();
    scanLibrary(); // Triggers async scan
}

MediaLibrary::~MediaLibrary() {
    if (m_scanWatcher && m_scanWatcher->isRunning()) {
        m_scanWatcher->waitForFinished();
    }
}

PlaylistModel* MediaLibrary::model() const { return m_mainModel; }
PlaylistModel* MediaLibrary::searchResultsModel() const { return m_searchModel; }
bool MediaLibrary::isIndexing() const { return m_isIndexing; }

void MediaLibrary::scanLibrary() {
    if (m_isIndexing) return;
    m_isIndexing = true;
    emit indexingChanged();

    // Run in background thread
    QFuture<QList<Track>> future = QtConcurrent::run(&MediaLibrary::performScan, this);
    m_scanWatcher->setFuture(future);
}

QList<Track> MediaLibrary::performScan() {
    QList<Track> tracks;
    
    // Real File Scan
    QStringList musicPaths = QStandardPaths::standardLocations(QStandardPaths::MusicLocation);
    QStringList filters;
    filters << "*.mp3" << "*.wav" << "*.m4a";
    
    // Also include a fallback Asset path for demo purposes if needed, logic here
    
    for (const QString &path : musicPaths) {
        QDirIterator it(path, filters, QDir::Files, QDirIterator::Subdirectories);
        while (it.hasNext()) {
            it.next();
            QFileInfo file = it.fileInfo();
            
            Track t;
            t.title = file.baseName();
            t.artist = "Unknown Artist"; // Need taglib for real metadata
            t.album = "Unknown Album";
            t.sourceUrl = file.absoluteFilePath();
            t.coverUrl = "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg";
            t.duration = 0; 
            tracks.append(t);
        }
    }

    // If empty, Mock it for Demo (so user sees something)
    if (tracks.isEmpty()) {
        tracks.append({"Blinding Lights", "The Weeknd", "After Hours", "qrc:/qt/qml/NordicHeadunit/assets/music/track1.mp3", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 200});
        tracks.append({"Midnight City", "M83", "Hurry Up, We're Dreaming", "qrc:/qt/qml/NordicHeadunit/assets/music/track2.mp3", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 243});
        tracks.append({"Levitating", "Dua Lipa", "Future Nostalgia", "qrc:/qt/qml/NordicHeadunit/assets/music/track3.mp3", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 180});
        tracks.append({"Starboy", "The Weeknd", "Starboy", "qrc:/qt/qml/NordicHeadunit/assets/music/track4.mp3", "qrc:/qt/qml/NordicHeadunit/assets/icons/music.svg", 230});
    }

    return tracks;
}

void MediaLibrary::search(const QString &query) {
    if (query.isEmpty()) {
        m_searchModel->clear();
        return;
    }

    QList<Track> results;
    QMutexLocker locker(&m_mutex);
    for (const auto &t : m_allTracks) {
        if (t.title.contains(query, Qt::CaseInsensitive) || 
            t.artist.contains(query, Qt::CaseInsensitive)) {
            results.append(t);
        }
    }
    m_searchModel->setTracks(results);
    emit searchResultsUpdated();
}

void MediaLibrary::toggleLike(int trackIndex) {
    // Assuming trackIndex refers to main model for now
    Track t = m_mainModel->getTrack(trackIndex);
    if (t.sourceUrl.isEmpty()) return;

    if (m_likedTracks.contains(t.sourceUrl)) {
        m_likedTracks.remove(t.sourceUrl);
    } else {
        m_likedTracks.insert(t.sourceUrl);
    }
    saveLikes();
    // Notify? Ideally the model data would update 'isLiked' property
}

bool MediaLibrary::isLiked(int trackIndex) const {
    Track t = m_mainModel->getTrack(trackIndex);
    return m_likedTracks.contains(t.sourceUrl);
}

void MediaLibrary::loadLikes() {
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/likes.json");
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonArray array = doc.array();
        for (const auto &val : array) {
            m_likedTracks.insert(val.toString());
        }
    }
}

void MediaLibrary::saveLikes() {
    QJsonArray array;
    for (const auto &url : m_likedTracks) {
        array.append(url);
    }
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/likes.json");
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(array).toJson());
    }
}
