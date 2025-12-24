#include "RadioTuner.h"
#include <QStandardPaths>
#include <QDir>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDebug>
#include <QRandomGenerator>

RadioTuner::RadioTuner(QObject *parent)
    : QObject(parent),
      m_currentBand(BandFM),
      m_isScanning(false)
{
    m_model = new RadioModel(this);
    m_frequency = 8750; // 87.5 MHz default

    m_scanTimer = new QTimer(this);
    m_scanTimer->setInterval(200);
    connect(m_scanTimer, &QTimer::timeout, this, [this]() {
        stepUp();
        // Simulate finding a station randomly
        if (m_frequency % 50 == 0) { // e.g. 90.0, 95.0
             m_isScanning = false;
             m_scanTimer->stop();
             emit scanningChanged();
        }
    });
    
    // Seek down timer
    m_seekDownTimer = new QTimer(this);
    m_seekDownTimer->setInterval(200);
    connect(m_seekDownTimer, &QTimer::timeout, this, [this]() {
        stepDown();
        // Simulate finding a station randomly
        if (m_frequency % 50 == 0) {
             m_isScanning = false;
             m_seekDownTimer->stop();
             emit scanningChanged();
        }
    });

    loadPresets();
}

int RadioTuner::frequency() const { return m_frequency; }

QString RadioTuner::frequencyString() const {
    return formatFrequency(m_frequency);
}

QString RadioTuner::stationName() const {
    // Check presets
    for (const auto &s : m_model->getAll()) {
        if (s.frequency == frequencyString()) return s.name;
    }
    // Check DAB logic or RDS simulation
    if (m_currentBand == BandDAB) return "DAB Station " + frequencyString();
    return "";
}

RadioTuner::Band RadioTuner::band() const { return m_currentBand; }
RadioModel* RadioTuner::model() const { return m_model; }
bool RadioTuner::isScanning() const { return m_isScanning; }

void RadioTuner::setBand(Band band) {
    if (m_currentBand == band) return;
    m_currentBand = band;
    
    // Reset to safe defaults
    if (m_currentBand == BandFM) m_frequency = 8750;
    else if (m_currentBand == BandAM) m_frequency = 531;
    else if (m_currentBand == BandDAB) m_frequency = 0;

    emit bandChanged();
    emit frequencyChanged();
    emit stationNameChanged();
}

void RadioTuner::tuneTo(int frequency) {
    int newFreq = clampFrequency(frequency);
    if (m_frequency != newFreq) {
        m_frequency = newFreq;
        // Simulate signal strength (random 50-100 for stations on .5, lower for others)
        m_signalStrength = (m_frequency % 50 == 0) ? (75 + QRandomGenerator::global()->bounded(25)) : (30 + QRandomGenerator::global()->bounded(40));
        emit signalStrengthChanged();
        emit frequencyChanged();
        emit stationNameChanged();
        updateStationName();
    }
}

void RadioTuner::tuneToString(const QString &frequency) {
    if (m_currentBand == BandFM) {
        bool ok;
        double f = frequency.toDouble(&ok);
        if (ok) tuneTo(static_cast<int>(f * 100 + 0.5));
    } else if (m_currentBand == BandAM) {
        bool ok;
        int f = frequency.toInt(&ok);
        if (ok) tuneTo(f);
    }
}

void RadioTuner::stepUp() {
    tuneTo(m_frequency + stepSize());
}

void RadioTuner::stepDown() {
    tuneTo(m_frequency - stepSize());
}

void RadioTuner::seekUp() {
    // Simulate seek
    m_isScanning = true;
    emit scanningChanged();
    m_scanTimer->start();
}

void RadioTuner::seekDown() {
    // Proper seek down implementation
    m_isScanning = true;
    emit scanningChanged();
    m_seekDownTimer->start();
}

void RadioTuner::scan() {
    m_isScanning = true;
    emit scanningChanged();
    // Simulate scan by clearing and repopulating logic, 
    // but here we just start seeking for next
    m_scanTimer->start();
}

// Private Helpers
int RadioTuner::minFreq() const {
    if (m_currentBand == BandFM) return 8750; // 87.50 MHz
    if (m_currentBand == BandAM) return 531;  // 531 kHz
    return 0;
}

int RadioTuner::maxFreq() const {
    if (m_currentBand == BandFM) return 10800; // 108.00 MHz
    if (m_currentBand == BandAM) return 1602;  // 1602 kHz
    return 15; // DAB Channels
}

int RadioTuner::stepSize() const {
    if (m_currentBand == BandFM) return 10; // 0.1 MHz -> 10 units
    if (m_currentBand == BandAM) return 9;  // 9 kHz
    return 1;
}

int RadioTuner::clampFrequency(int freq) {
    if (freq > maxFreq()) return minFreq();
    if (freq < minFreq()) return maxFreq();
    return freq;
}

QString RadioTuner::formatFrequency(int freq) const {
    if (m_currentBand == BandFM) {
        return QString::number(freq / 100.0, 'f', 1);
    }
    if (m_currentBand == BandAM) {
        return QString::number(freq);
    }
    if (m_currentBand == BandDAB) {
         static const QStringList dabChannels = { "5A", "5B", "5C", "5D", "6A", "6B", "6C", "6D", "12A", "12B", "12C", "12D" };
         if (freq >= 0 && freq < dabChannels.size()) return dabChannels[freq];
         return "5A";
    }
    return "";
}

void RadioTuner::updateStationName() {
    // Update active preset
    QList<RadioStation> stations = m_model->getAll();
    QString currentFreqStr = formatFrequency(m_frequency);
    
    int activeIndex = -1;
    for (int i=0; i<stations.count(); ++i) {
        if (stations[i].frequency == currentFreqStr) {
            activeIndex = i;
            break;
        }
    }
    m_model->setActive(activeIndex);
}

void RadioTuner::tuneToPreset(int index) {
    if (index < 0 || index >= m_model->rowCount()) return;
    RadioStation s = m_model->getStation(index);
    // Parse Logic
    // ... Assume correct band for simplicity or switch band
    tuneToString(s.frequency);
}

void RadioTuner::savePreset() {
    RadioStation s;
    s.frequency = formatFrequency(m_frequency);
    s.band = (m_currentBand == BandFM) ? "FM" : (m_currentBand == BandAM) ? "AM" : "DAB";
    s.name = "Saved " + s.frequency; // Could lookup RDS here
    m_model->addStation(s);
    
    // Persist
    QJsonArray array;
    for (const auto &st : m_model->getAll()) {
        QJsonObject obj;
        obj["name"] = st.name;
        obj["frequency"] = st.frequency;
        obj["band"] = st.band;
        array.append(obj);
    }
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/radio_presets.json");
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(array).toJson());
    }
}

void RadioTuner::loadPresets() {
    QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    if (!dir.exists()) dir.mkpath(".");
    
    QFile file(dir.filePath("radio_presets.json"));
    if (file.open(QIODevice::ReadOnly)) {
        QJsonDocument doc = QJsonDocument::fromJson(file.readAll());
        QJsonArray array = doc.array();
        m_model->clear();
        for (const auto &val : array) {
            QJsonObject obj = val.toObject();
            m_model->addStation({
                obj["name"].toString(),
                obj["frequency"].toString(),
                obj["band"].toString(),
                false
            });
        }
    }
    
    // Defaults if empty
    if (m_model->rowCount() == 0) {
        m_model->addStation({"Radio 1", "101.5", "FM", false});
        m_model->addStation({"Classic FM", "98.3", "FM", false});
        m_model->addStation({"Jazz Radio", "105.7", "FM", false});
    }
}

void RadioTuner::removePreset(int index) {
    if (index < 0 || index >= m_model->rowCount()) return;
    
    m_model->removeStation(index);
    emit presetRemoved(index);
    
    // Persist updated list
    QJsonArray array;
    for (const auto &st : m_model->getAll()) {
        QJsonObject obj;
        obj["name"] = st.name;
        obj["frequency"] = st.frequency;
        obj["band"] = st.band;
        array.append(obj);
    }
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/radio_presets.json");
    if (file.open(QIODevice::WriteOnly)) {
        file.write(QJsonDocument(array).toJson());
    }
}
