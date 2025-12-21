#ifndef MEDIASERVICE_H
#define MEDIASERVICE_H

#include <QObject>
#include <QTimer>
#include <QVariantList>
#include <QVariantMap>

struct Track {
    QString title;
    QString artist;
    QString coverSource;
    int duration;
};

struct RadioStation {
    QString name;
    QString frequency;
    QString band;
};

class MediaService : public QObject
{
    Q_OBJECT
    
    // Current playback
    Q_PROPERTY(QString title READ title NOTIFY trackChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY trackChanged)
    Q_PROPERTY(QString coverSource READ coverSource NOTIFY trackChanged)
    Q_PROPERTY(bool playing READ playing WRITE setPlaying NOTIFY playingChanged)
    Q_PROPERTY(int position READ position NOTIFY positionChanged)
    Q_PROPERTY(int duration READ duration NOTIFY trackChanged)
    Q_PROPERTY(double progress READ progress NOTIFY positionChanged)
    
    // Playback controls state
    Q_PROPERTY(bool shuffleEnabled READ shuffleEnabled WRITE setShuffleEnabled NOTIFY shuffleEnabledChanged)
    Q_PROPERTY(bool repeatEnabled READ repeatEnabled WRITE setRepeatEnabled NOTIFY repeatEnabledChanged)
    
    // Source management
    Q_PROPERTY(QString currentSource READ currentSource WRITE setCurrentSource NOTIFY currentSourceChanged)
    Q_PROPERTY(bool isRadioMode READ isRadioMode NOTIFY currentSourceChanged)
    Q_PROPERTY(QVariantList sources READ sources NOTIFY sourcesChanged)
    Q_PROPERTY(QVariantList radioStations READ radioStations NOTIFY radioStationsChanged)
    Q_PROPERTY(QVariantList recentItems READ recentItems NOTIFY recentItemsChanged)
    Q_PROPERTY(QVariantList library READ library CONSTANT)
    Q_PROPERTY(QVariantList playlist READ playlist NOTIFY playlistChanged)
    
    // Radio-specific
    Q_PROPERTY(QString radioFrequency READ radioFrequency NOTIFY radioChanged)
    Q_PROPERTY(QString radioName READ radioName NOTIFY radioChanged)
    Q_PROPERTY(int currentRadioIndex READ currentRadioIndex NOTIFY radioChanged)
    
    // Connection state
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY connectionChanged)
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY loadingChanged)
    Q_PROPERTY(bool hasError READ hasError NOTIFY errorChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorChanged)

public:
    explicit MediaService(QObject *parent = nullptr);

    // Track info
    QString title() const;
    QString artist() const;
    QString coverSource() const;
    bool playing() const;
    int position() const;
    int duration() const;
    double progress() const;
    
    // Playback controls state
    bool shuffleEnabled() const;
    void setShuffleEnabled(bool enabled);
    bool repeatEnabled() const;
    void setRepeatEnabled(bool enabled);
    
    // Source management
    QString currentSource() const;
    void setCurrentSource(const QString &source);
    bool isRadioMode() const;
    QVariantList sources() const;
    QVariantList radioStations() const;
    QVariantList recentItems() const;
    QVariantList library() const;
    QVariantList playlist() const;
    
    // Radio
    QString radioFrequency() const;
    QString radioName() const;
    int currentRadioIndex() const;
    
    // Connection state
    bool isConnected() const;
    bool isLoading() const;
    bool hasError() const;
    QString errorMessage() const;

    // Playback controls
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void seek(int position);
    Q_INVOKABLE void setSource(const QString &source);
    Q_INVOKABLE void tuneRadio(const QString &frequency);
    Q_INVOKABLE void tuneRadioByIndex(int index);
    Q_INVOKABLE void tuneToFrequency(const QString &frequency);
    Q_INVOKABLE void scanRadioStations();
    Q_INVOKABLE void playTrack(int index);
    Q_INVOKABLE void playFromRecent(int index);
    Q_INVOKABLE void playPlaylist(const QString &name);
    
    void setPlaying(bool playing);

signals:
    void trackChanged();
    void playingChanged(bool playing);
    void positionChanged();
    void currentSourceChanged();
    void radioChanged();
    void recentItemsChanged();
    void sourcesChanged();
    void radioStationsChanged();
    void shuffleEnabledChanged();
    void repeatEnabledChanged();
    void playlistChanged();
    void connectionChanged();
    void loadingChanged();
    void errorChanged();

private slots:
    void updatePosition();

private:
    // Music state
    QList<Track> m_playlist;
    int m_currentIndex;
    bool m_playing;
    int m_position;
    QTimer *m_timer;
    bool m_shuffleEnabled;
    bool m_repeatEnabled;
    
    // Source state
    QString m_currentSource;
    QList<RadioStation> m_radioStations;
    int m_currentRadioIndex;
    
    // Connection state
    bool m_isConnected;
    bool m_isLoading;
    
    // Per-source resume positions
    QMap<QString, int> m_lastPosition;
    QMap<QString, int> m_lastTrackIndex;
    
    const Track& currentTrack() const;
};

#endif // MEDIASERVICE_H
