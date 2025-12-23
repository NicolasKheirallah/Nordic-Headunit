#ifndef MEDIASERVICE_H
#define MEDIASERVICE_H

#include <QtMultimedia/QMediaPlayer>
#include <QtMultimedia/QAudioOutput>
#include "Models/RadioModel.h"
#include "Models/PlaylistModel.h"

class MediaService : public QObject
{
    Q_OBJECT
    
    // Current playback
    Q_PROPERTY(QString title READ title NOTIFY trackChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY trackChanged)
    Q_PROPERTY(QString coverSource READ coverSource NOTIFY trackChanged)
    Q_PROPERTY(bool playing READ playing WRITE setPlaying NOTIFY playingChanged)
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY trackChanged)
    Q_PROPERTY(double progress READ progress NOTIFY positionChanged)
    
    // Playback controls state
    Q_PROPERTY(bool shuffleEnabled READ shuffleEnabled WRITE setShuffleEnabled NOTIFY shuffleEnabledChanged)
    Q_PROPERTY(bool repeatEnabled READ repeatEnabled WRITE setRepeatEnabled NOTIFY repeatEnabledChanged)
    
    // Source management
    Q_PROPERTY(QString currentSource READ currentSource WRITE setCurrentSource NOTIFY currentSourceChanged)
    Q_PROPERTY(bool isRadioMode READ isRadioMode NOTIFY currentSourceChanged)
    Q_PROPERTY(QVariantList sources READ sources NOTIFY sourcesChanged)
    
    // Models (Production)
    Q_PROPERTY(RadioModel* radioModel READ radioModel CONSTANT)
    Q_PROPERTY(PlaylistModel* playlistModel READ playlistModel CONSTANT)
    Q_PROPERTY(QVariantList recentItems READ recentItems NOTIFY recentItemsChanged)
    Q_PROPERTY(QVariantList library READ library CONSTANT)
    
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
    qint64 position() const;
    qint64 duration() const;
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
    RadioModel* radioModel() const;
    PlaylistModel* playlistModel() const;
    QVariantList recentItems() const;
    QVariantList library() const;
    
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
    Q_INVOKABLE void seek(qint64 position);
    Q_INVOKABLE void setSource(const QString &source);
    Q_INVOKABLE void tuneRadio(const QString &frequency);
    Q_INVOKABLE void tuneRadioByIndex(int index);
    Q_INVOKABLE void tuneToFrequency(const QString &frequency);
    Q_INVOKABLE void tuneStep(double step);
    Q_INVOKABLE void seekForward();
    Q_INVOKABLE void seekBackward();
    Q_INVOKABLE void scanRadioStations();
    Q_INVOKABLE void playTrack(int index);
    Q_INVOKABLE void playFromRecent(int index);
    Q_INVOKABLE void playPlaylist(const QString &name);
    Q_INVOKABLE bool saveCurrentToPreset();
    
    void setPlaying(bool playing);

signals:
    void trackChanged();
    void playingChanged(bool playing);
    void positionChanged();
    void currentSourceChanged();
    void radioChanged();
    void recentItemsChanged();
    void sourcesChanged();
    void radioStationsChanged(); // Keep for compatibility if needed, but model handles changes
    void shuffleEnabledChanged();
    void repeatEnabledChanged();
    void playlistChanged();
    void connectionChanged();
    void loadingChanged();
    void errorChanged();

private slots:
    void onMediaPlayerPositionChanged(qint64 position);
    void onMediaPlayerDurationChanged(qint64 duration);
    void onMediaPlayerStatusChanged(QMediaPlayer::MediaStatus status);
    void onMediaPlayerErrorOccurred(QMediaPlayer::Error error, const QString &errorString);

private:
    // Production components
    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;
    PlaylistModel *m_playlistModel;
    RadioModel *m_radioModel;

    // State
    int m_currentIndex;
    bool m_shuffleEnabled;
    bool m_repeatEnabled;
    
    // Source state
    QString m_currentSource;
    int m_currentRadioIndex;
    double m_currentFrequency; // Actual tuner frequency
    
    // Connection state
    bool m_isConnected;
    bool m_isLoading;
    
    // Per-source resume positions
    QMap<QString, qint64> m_lastPosition;
    QMap<QString, int> m_lastTrackIndex;
    
    void loadMockData(); // Helper to populate models
    void savePresets();
    void loadPresets();
};

#endif // MEDIASERVICE_H
