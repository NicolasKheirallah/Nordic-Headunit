#ifndef SYSTEMSETTINGS_H
#define SYSTEMSETTINGS_H

#include <QObject>
#include <QSettings>
#include <QDateTime>
#include "HAL/IAudioHAL.h"

class SystemSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool darkMode READ darkMode WRITE setDarkMode NOTIFY darkModeChanged)
    Q_PROPERTY(bool wifiEnabled READ wifiEnabled WRITE setWifiEnabled NOTIFY wifiEnabledChanged)
    Q_PROPERTY(bool bluetoothEnabled READ bluetoothEnabled WRITE setBluetoothEnabled NOTIFY bluetoothEnabledChanged)
    Q_PROPERTY(int masterVolume READ masterVolume WRITE setMasterVolume NOTIFY masterVolumeChanged)
    Q_PROPERTY(int brightness READ brightness WRITE setBrightness NOTIFY brightnessChanged)
    Q_PROPERTY(bool walkAwayLock READ walkAwayLock WRITE setWalkAwayLock NOTIFY walkAwayLockChanged)
    Q_PROPERTY(bool useMetric READ useMetric WRITE setUseMetric NOTIFY useMetricChanged)
    Q_PROPERTY(QString language READ language WRITE setLanguage NOTIFY languageChanged)
    Q_PROPERTY(QString version READ version CONSTANT)
    
    // Phase 1: Advanced Audio
    Q_PROPERTY(int eqBass READ eqBass WRITE setEqBass NOTIFY eqBassChanged)
    Q_PROPERTY(int eqMid READ eqMid WRITE setEqMid NOTIFY eqMidChanged)
    Q_PROPERTY(int eqTreble READ eqTreble WRITE setEqTreble NOTIFY eqTrebleChanged)
    Q_PROPERTY(double faderX READ faderX WRITE setFaderX NOTIFY faderXChanged)
    Q_PROPERTY(double faderY READ faderY WRITE setFaderY NOTIFY faderYChanged)
    
    // Phase 3: Vehicle Controls
    Q_PROPERTY(int lightsMode READ lightsMode WRITE setLightsMode NOTIFY lightsModeChanged)
    Q_PROPERTY(bool childLock READ childLock WRITE setChildLock NOTIFY childLockChanged)
    Q_PROPERTY(bool autoFoldMirrors READ autoFoldMirrors WRITE setAutoFoldMirrors NOTIFY autoFoldMirrorsChanged)
    Q_PROPERTY(bool rainSensingWipers READ rainSensingWipers WRITE setRainSensingWipers NOTIFY rainSensingWipersChanged)
    
    // Display/UI Settings
    Q_PROPERTY(bool bottomBarEnabled READ bottomBarEnabled WRITE setBottomBarEnabled NOTIFY bottomBarEnabledChanged)

    // Date & Time
    Q_PROPERTY(bool autoTime READ autoTime WRITE setAutoTime NOTIFY autoTimeChanged)
    Q_PROPERTY(bool use24HourFormat READ use24HourFormat WRITE setUse24HourFormat NOTIFY use24HourFormatChanged)
    Q_PROPERTY(QString timeZone READ timeZone WRITE setTimeZone NOTIFY timeZoneChanged)
    Q_PROPERTY(QStringList availableTimeZones READ availableTimeZones CONSTANT)
    Q_PROPERTY(QDateTime currentDateTime READ currentDateTime NOTIFY currentDateTimeChanged)
    
    // Map Settings
    enum MapStyle {
        Standard,
        Dark,
        Satellite,
        Hybrid
    };
    Q_ENUM(MapStyle)
    Q_PROPERTY(MapStyle mapStyle READ mapStyle WRITE setMapStyle NOTIFY mapStyleChanged)
    Q_PROPERTY(int mapOrientation READ mapOrientation WRITE setMapOrientation NOTIFY mapOrientationChanged)

    // Manual Time Helpers
    Q_INVOKABLE void setDate(int year, int month, int day);
    Q_INVOKABLE void setTime(int hour, int minute);

public:
    explicit SystemSettings(IAudioHAL *audioHal, QObject *parent = nullptr);

    bool darkMode() const;
    void setDarkMode(bool darkMode);

    bool wifiEnabled() const;
    void setWifiEnabled(bool wifiEnabled);

    bool bluetoothEnabled() const;
    void setBluetoothEnabled(bool bluetoothEnabled);

    int masterVolume() const;
    void setMasterVolume(int masterVolume);

    int brightness() const;
    void setBrightness(int brightness);

    bool walkAwayLock() const;
    void setWalkAwayLock(bool walkAwayLock);

    bool useMetric() const;
    void setUseMetric(bool useMetric);

    QString language() const;
    void setLanguage(const QString &language);

    QString version() const;

    // Audio EQ & Fader
    int eqBass() const;
    void setEqBass(int eqBass);

    int eqMid() const;
    void setEqMid(int eqMid);

    int eqTreble() const;
    void setEqTreble(int eqTreble);

    double faderX() const;
    void setFaderX(double faderX);

    double faderY() const;
    void setFaderY(double faderY);

    // Vehicle Controls
    int lightsMode() const;
    void setLightsMode(int lightsMode);

    bool childLock() const;
    void setChildLock(bool childLock);

    bool autoFoldMirrors() const;
    void setAutoFoldMirrors(bool autoFoldMirrors);

    bool rainSensingWipers() const;
    void setRainSensingWipers(bool rainSensingWipers);
    
    bool bottomBarEnabled() const;
    void setBottomBarEnabled(bool bottomBarEnabled);

    // Date & Time
    bool autoTime() const;
    void setAutoTime(bool autoTime);

    bool use24HourFormat() const;
    void setUse24HourFormat(bool use24HourFormat);

    QString timeZone() const;
    void setTimeZone(const QString &timeZone);
    
    QStringList availableTimeZones() const;
    QDateTime currentDateTime() const;

    SystemSettings::MapStyle mapStyle() const;
    void setMapStyle(SystemSettings::MapStyle style);
    
    int mapOrientation() const;
    void setMapOrientation(int orientation);
    
    Q_INVOKABLE void factoryReset();

signals:
    void darkModeChanged(bool darkMode);
    void wifiEnabledChanged(bool wifiEnabled);
    void bluetoothEnabledChanged(bool bluetoothEnabled);
    void masterVolumeChanged(int masterVolume);
    void brightnessChanged(int brightness);
    void walkAwayLockChanged(bool walkAwayLock);
    void useMetricChanged(bool useMetric);
    void languageChanged(const QString &language);
    
    // Audio Signals
    void eqBassChanged(int eqBass);
    void eqMidChanged(int eqMid);
    void eqTrebleChanged(int eqTreble);
    void faderXChanged(double faderX);
    void faderYChanged(double faderY);
    
    // Vehicle Signals
    void lightsModeChanged(int lightsMode);
    void childLockChanged(bool childLock);
    void autoFoldMirrorsChanged(bool autoFoldMirrors);
    void rainSensingWipersChanged(bool rainSensingWipers);
    void bottomBarEnabledChanged(bool bottomBarEnabled);
    // Date & Time Signals
    void autoTimeChanged(bool autoTime);
    void use24HourFormatChanged(bool use24HourFormat);
    void timeZoneChanged(const QString &timeZone);
    void currentDateTimeChanged();
    void mapStyleChanged(SystemSettings::MapStyle mapStyle);
    void mapOrientationChanged(int mapOrientation);

private:
    QSettings m_settings;
    
    bool m_darkMode;
    bool m_wifiEnabled;
    bool m_bluetoothEnabled;
    int m_masterVolume;
    int m_brightness;
    bool m_walkAwayLock;
    bool m_useMetric;
    QString m_language;
    
    // Audio State
    int m_eqBass;
    int m_eqMid;
    int m_eqTreble;
    double m_faderX;
    double m_faderY;
    
    // Vehicle State
    int m_lightsMode;
    bool m_childLock;
    bool m_autoFoldMirrors;
    bool m_rainSensingWipers;
    bool m_bottomBarEnabled = true;  // Default enabled per HMI spec
    
    // Date & Time State
    bool m_autoTime;
    bool m_use24HourFormat;
    QString m_timeZone;
    MapStyle m_mapStyle;
    int m_mapOrientation = 1; // Default to Heading-up (1)
    qint64 m_timeOffsetMs = 0; // Manual offset from system clock
    
    IAudioHAL *m_audioHal;

    void saveSettings();
    void loadSettings();
};

#endif // SYSTEMSETTINGS_H
