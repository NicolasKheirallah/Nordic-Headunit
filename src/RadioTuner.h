#ifndef RADIOTUNER_H
#define RADIOTUNER_H

#include <QObject>
#include <QTimer>
#include "Models/RadioModel.h"

class RadioTuner : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int frequency READ frequency NOTIFY frequencyChanged)
    Q_PROPERTY(QString frequencyString READ frequencyString NOTIFY frequencyChanged)
    Q_PROPERTY(QString stationName READ stationName NOTIFY stationNameChanged)
    Q_PROPERTY(int band READ bandInt WRITE setBandInt NOTIFY bandChanged)
    Q_PROPERTY(bool isScanning READ isScanning NOTIFY scanningChanged)
    Q_PROPERTY(RadioModel* model READ model CONSTANT)
    Q_PROPERTY(bool hasError READ hasError NOTIFY hasErrorChanged)
    Q_PROPERTY(QString errorMessage READ errorMessage NOTIFY errorMessageChanged)
    Q_PROPERTY(int signalStrength READ signalStrength NOTIFY signalStrengthChanged)

public:
    enum Band { BandFM = 0, BandAM = 1, BandDAB = 2 };
    Q_ENUM(Band)

    explicit RadioTuner(QObject *parent = nullptr);

    // Getters
    int frequency() const; // Stored as integer (kHz for AM, 100*MHz for FM)
    QString frequencyString() const;
    QString stationName() const;
    Band band() const;
    int bandInt() const { return static_cast<int>(m_currentBand); }
    RadioModel* model() const;
    bool isScanning() const;
    bool hasError() const { return m_hasError; }
    QString errorMessage() const { return m_errorMessage; }
    int signalStrength() const { return m_signalStrength; }

    // Control
    void setBand(Band band);
    void setBandInt(int band) { setBand(static_cast<Band>(band)); }
    Q_INVOKABLE void tuneTo(int frequency); // Direct integer tuning
    Q_INVOKABLE void tuneToString(const QString &frequency); // String parsing
    Q_INVOKABLE void stepUp();
    Q_INVOKABLE void stepDown();
    Q_INVOKABLE void seekUp();
    Q_INVOKABLE void seekDown();
    Q_INVOKABLE void scan();

    // Presets interaction
    Q_INVOKABLE void loadPresets();
    Q_INVOKABLE void savePreset();
    Q_INVOKABLE void tuneToPreset(int index);
    Q_INVOKABLE void removePreset(int index);

signals:
    void frequencyChanged();
    void stationNameChanged();
    void bandChanged();
    void scanningChanged();
    void hasErrorChanged();
    void errorMessageChanged();
    void signalStrengthChanged();
    void stationFound(const QString &freq, const QString &name);
    void presetRemoved(int index);

private:
    int m_frequency; // Unit: 10kHz for FM (98.3 -> 9830), 1kHz for AM
    Band m_currentBand;
    bool m_isScanning;
    bool m_hasError = false;
    QString m_errorMessage;
    int m_signalStrength = 75; // Simulated 0-100
    RadioModel *m_model;
    QTimer *m_scanTimer;
    QTimer *m_seekDownTimer;

    // Helpers
    int minFreq() const;
    int maxFreq() const;
    int stepSize() const;
    QString formatFrequency(int freq) const;
    void updateStationName();
    
    // Validates and wraps frequency
    int clampFrequency(int freq);
};

#endif // RADIOTUNER_H
