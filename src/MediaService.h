#ifndef MEDIASERVICE_H
#define MEDIASERVICE_H

#include <QtMultimedia/QMediaPlayer>
#include <QtMultimedia/QAudioOutput>
#include <QTimer>
#include <QDateTime>
#include "RadioTuner.h"
#include "MediaLibrary.h"

class MediaService : public QObject
{
    Q_OBJECT
    
    // Core Playback Properties
    Q_PROPERTY(QString title READ title NOTIFY trackChanged)
    Q_PROPERTY(QString artist READ artist NOTIFY trackChanged)
    Q_PROPERTY(QString coverSource READ coverSource NOTIFY trackChanged) 
    Q_PROPERTY(bool playing READ playing WRITE setPlaying NOTIFY playingChanged)
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY trackChanged)
    Q_PROPERTY(double progress READ progress NOTIFY positionChanged)
     
    // Controls
    Q_PROPERTY(bool shuffleEnabled READ shuffleEnabled WRITE setShuffleEnabled NOTIFY shuffleEnabledChanged)
    Q_PROPERTY(bool repeatEnabled READ repeatEnabled WRITE setRepeatEnabled NOTIFY repeatEnabledChanged)
    Q_PROPERTY(QString currentSource READ currentSource WRITE setCurrentSource NOTIFY currentSourceChanged)
    Q_PROPERTY(bool isRadioMode READ isRadioMode NOTIFY currentSourceChanged)
    Q_PROPERTY(QVariantList sources READ sources NOTIFY sourcesChanged)
    
    // Advanced Playback (Competitor Features)
    Q_PROPERTY(double playbackSpeed READ playbackSpeed WRITE setPlaybackSpeed NOTIFY playbackSpeedChanged)
    Q_PROPERTY(int crossfadeDuration READ crossfadeDuration WRITE setCrossfadeDuration NOTIFY crossfadeDurationChanged)
    Q_PROPERTY(bool gaplessEnabled READ gaplessEnabled WRITE setGaplessEnabled NOTIFY gaplessEnabledChanged)
    Q_PROPERTY(int sleepTimerMinutes READ sleepTimerMinutes WRITE setSleepTimerMinutes NOTIFY sleepTimerChanged)
    Q_PROPERTY(int sleepTimerRemaining READ sleepTimerRemaining NOTIFY sleepTimerChanged)
    Q_PROPERTY(bool sleepTimerActive READ sleepTimerActive NOTIFY sleepTimerChanged)
    
    // Audio EQ (Basic)
    Q_PROPERTY(int bassLevel READ bassLevel WRITE setBassLevel NOTIFY eqChanged)
    Q_PROPERTY(int trebleLevel READ trebleLevel WRITE setTrebleLevel NOTIFY eqChanged)
    Q_PROPERTY(int balanceLevel READ balanceLevel WRITE setBalanceLevel NOTIFY eqChanged)
    
    // Sub-components (Exposed to QML)
    Q_PROPERTY(RadioTuner* radio READ radio CONSTANT)
    Q_PROPERTY(MediaLibrary* library READ library CONSTANT)
    
    // Legacy/Convenience properties for Radio View compatibility
    Q_PROPERTY(QString radioFrequency READ radioFrequency NOTIFY radioChanged) // Proxy
    Q_PROPERTY(QString radioName READ radioName NOTIFY radioChanged) // Proxy
    Q_PROPERTY(int currentRadioIndex READ currentRadioIndex NOTIFY radioChanged)
    Q_PROPERTY(int currentBand READ currentBand WRITE setBand NOTIFY radioChanged) // int for simple QML bind

    // Convenience properties for Browse View compatibility
    Q_PROPERTY(QVariantList recentItems READ recentItems NOTIFY recentItemsChanged)
    Q_PROPERTY(QVariantList libraryCategories READ libraryCategories CONSTANT)

    // Connection
    Q_PROPERTY(bool isConnected READ isConnected CONSTANT) 
    Q_PROPERTY(bool isLoading READ isLoading NOTIFY loadingChanged)
    Q_PROPERTY(bool hasError READ hasError NOTIFY errorChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorChanged)

public:
    explicit MediaService(QObject *parent = nullptr);

    // Getters
    QString title() const;
    QString artist() const;
    QString coverSource() const;
    bool playing() const;
    qint64 position() const;
    qint64 duration() const;
    double progress() const;
    
    bool shuffleEnabled() const;
    void setShuffleEnabled(bool enabled);
    bool repeatEnabled() const;
    void setRepeatEnabled(bool enabled);
    
    QString currentSource() const;
    void setCurrentSource(const QString &source);
    bool isRadioMode() const;
    QVariantList sources() const;

    RadioTuner* radio() const;
    MediaLibrary* library() const;

    // Proxy Radio Getters
    QString radioFrequency() const;
    QString radioName() const;
    int currentRadioIndex() const;
    int currentBand() const;
    Q_INVOKABLE void setBand(int band);

    // Proxy Library Getters
    QVariantList recentItems() const;
    QVariantList libraryCategories() const;

    bool isConnected() const;
    bool isLoading() const;
    bool hasError() const;
    QString errorMessage() const;

    // Invokables
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void seek(qint64 position);
    Q_INVOKABLE void setSource(const QString &source);
    
    Q_INVOKABLE void playTrack(int index);
    Q_INVOKABLE void playFromRecent(int index);
    
    // Radio specific proxies (to minimize QML rewrite, but redirect to Tuner)
    Q_INVOKABLE void tuneRadioByIndex(int index);
    Q_INVOKABLE void tuneStep(double step);
    Q_INVOKABLE void seekForward();
    Q_INVOKABLE void seekBackward();
    Q_INVOKABLE void scanRadioStations();
    Q_INVOKABLE bool saveCurrentToPreset();
    
    // Library specific
    Q_INVOKABLE void toggleLike(); // Uses current track
    Q_INVOKABLE bool isLiked() const;
    
    // Advanced Playback Getters/Setters
    double playbackSpeed() const { return m_playbackSpeed; }
    void setPlaybackSpeed(double speed);
    int crossfadeDuration() const { return m_crossfadeDuration; }
    void setCrossfadeDuration(int seconds);
    bool gaplessEnabled() const { return m_gaplessEnabled; }
    void setGaplessEnabled(bool enabled);
    int sleepTimerMinutes() const { return m_sleepTimerMinutes; }
    void setSleepTimerMinutes(int minutes);
    int sleepTimerRemaining() const;
    bool sleepTimerActive() const { return m_sleepTimerMinutes > 0; }
    Q_INVOKABLE void cancelSleepTimer();
    
    // EQ Getters/Setters
    int bassLevel() const { return m_bassLevel; }
    void setBassLevel(int level);
    int trebleLevel() const { return m_trebleLevel; }
    void setTrebleLevel(int level);
    int balanceLevel() const { return m_balanceLevel; }
    void setBalanceLevel(int level);

    void setPlaying(bool playing);

signals:
    void trackChanged();
    void playingChanged(bool playing);
    void positionChanged();
    void shuffleEnabledChanged();
    void repeatEnabledChanged();
    void currentSourceChanged();
    void sourcesChanged();
    void radioChanged();
    void recentItemsChanged();
    void loadingChanged();
    void errorChanged();
    void playbackSpeedChanged();
    void crossfadeDurationChanged();
    void gaplessEnabledChanged();
    void sleepTimerChanged();
    void eqChanged();

private slots:
    void onMPlayerPositionChanged(qint64 position);
    void onMPlayerDurationChanged(qint64 duration);
    void onMPlayerStatusChanged(QMediaPlayer::MediaStatus status);
    
    // Handle sub-component signals
    void onRadioFrequencyChanged();
    void onLibraryUpdated();

private:
    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;
    
    RadioTuner *m_radioTuner;
    MediaLibrary *m_mediaLibrary;

    // State
    QString m_currentSource;
    int m_currentIndex;
    bool m_shuffleEnabled;
    bool m_repeatEnabled;
    bool m_isSimulating; // Still need sim for files?
    
    // Simulation
    QTimer *m_simTimer;
    qint64 m_simPos;
    qint64 m_simDur;
    void startSimulation(qint64 dur);
    void stopSimulation();
    void updateSimulation();

    // Source Memory
    QMap<QString, qint64> m_lastPos;
    QMap<QString, int> m_lastIndex;

    bool m_isConnected;
    bool m_isLoading;
    
    // Advanced Playback State
    double m_playbackSpeed = 1.0;
    int m_crossfadeDuration = 0;  // 0 = off, 1-12 seconds
    bool m_gaplessEnabled = false;
    int m_sleepTimerMinutes = 0;
    QTimer *m_sleepTimer = nullptr;
    QDateTime m_sleepTimerEnd;
    
    // EQ State (range -10 to +10)
    int m_bassLevel = 0;
    int m_trebleLevel = 0;
    int m_balanceLevel = 0;  // -10 = full left, +10 = full right

    void playRadio();
    void stopRadio();
    void playFile(const QString &url);
};

#endif // MEDIASERVICE_H
