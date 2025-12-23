#ifndef RADIOTUNER_H
#define RADIOTUNER_H

#include <QObject>
#include <QTimer>
#include "Models/RadioModel.h"

class RadioTuner : public QObject
{
    Q_OBJECT

public:
    enum Band { BandFM = 0, BandAM = 1, BandDAB = 2 };
    Q_ENUM(Band)

    explicit RadioTuner(QObject *parent = nullptr);

    // Getters
    int frequency() const; // Stored as integer (kHz for AM, 100*MHz for FM)
    QString frequencyString() const;
    QString stationName() const;
    Band band() const;
    RadioModel* model() const;
    bool isScanning() const;

    // Control
    void setBand(Band band);
    void tuneTo(int frequency); // Direct integer tuning
    void tuneToString(const QString &frequency); // String parsing
    void stepUp();
    void stepDown();
    void seekUp();
    void seekDown();
    void scan();

    // Presets interaction
    void loadPresets();
    void savePreset();
    void tuneToPreset(int index);

signals:
    void frequencyChanged();
    void stationNameChanged();
    void bandChanged();
    void scanningChanged();
    void stationFound(const QString &freq, const QString &name);

private:
    int m_frequency; // Unit: 10kHz for FM (98.3 -> 9830), 1kHz for AM
    Band m_currentBand;
    bool m_isScanning;
    RadioModel *m_model;
    QTimer *m_scanTimer;

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
