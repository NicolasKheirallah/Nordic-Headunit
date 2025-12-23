#include "SystemSettings.h"
#include <QDebug>
#include <QTimeZone>
#include <QDateTime>

SystemSettings::SystemSettings(IAudioHAL *audioHal, QObject *parent)
    : QObject(parent),
      m_settings("NordicAuto", "HeadunitV2"),
      m_audioHal(audioHal)
{
    loadSettings();
    
    // Apply loaded settings to Hardware
    if (m_audioHal) {
        m_audioHal->setMasterVolume(m_masterVolume);
        m_audioHal->setEqBass(m_eqBass);
        m_audioHal->setEqMid(m_eqMid);
        m_audioHal->setEqTreble(m_eqTreble);
        m_audioHal->setFaderX(m_faderX);
        m_audioHal->setFaderY(m_faderY);
        
        // Listen for hardware feedback
        connect(m_audioHal, &IAudioHAL::masterVolumeChanged, this, [this](int volume) {
             if (m_masterVolume != volume) {
                 m_masterVolume = volume;
                 m_settings.setValue("masterVolume", m_masterVolume);
                 emit masterVolumeChanged(m_masterVolume);
             }
        });
    }
}

void SystemSettings::loadSettings()
{
    m_darkMode = m_settings.value("darkMode", true).toBool(); // Default to Dark (Nordic Night)
    m_wifiEnabled = m_settings.value("wifiEnabled", true).toBool();
    m_bluetoothEnabled = m_settings.value("bluetoothEnabled", true).toBool();
    m_masterVolume = m_settings.value("masterVolume", 50).toInt();
    m_brightness = m_settings.value("brightness", 80).toInt();
    
    // New Properties
    m_walkAwayLock = m_settings.value("walkAwayLock", true).toBool();
    m_useMetric = m_settings.value("useMetric", true).toBool();
    m_language = m_settings.value("language", "English (US)").toString();
    // Phase 1: Audio
    m_eqBass = m_settings.value("audio/eqBass", 0).toInt();
    m_eqMid = m_settings.value("audio/eqMid", 0).toInt();
    m_eqTreble = m_settings.value("audio/eqTreble", 0).toInt();
    m_faderX = m_settings.value("audio/faderX", 0.0).toDouble();
    m_faderY = m_settings.value("audio/faderY", 0.0).toDouble();
    
    // Phase 3: Vehicle
    m_lightsMode = m_settings.value("vehicle/lightsMode", 0).toInt(); // Default Auto
    m_childLock = m_settings.value("vehicle/childLock", false).toBool();
    m_autoFoldMirrors = m_settings.value("vehicle/autoFoldMirrors", true).toBool();
    m_rainSensingWipers = m_settings.value("vehicle/rainSensingWipers", true).toBool();
    
    // Display/UI
    m_bottomBarEnabled = m_settings.value("display/bottomBarEnabled", true).toBool();
    
    // Theme System - load from string storage, convert to QColor
    m_themeKey = m_settings.value("display/themeKey", "nordic").toString();
    QString accentStr = m_settings.value("display/customAccentColor", "#8B5CF6").toString();
    m_customAccentColor = QColor::isValidColorName(accentStr) ? QColor(accentStr) : QColor("#8B5CF6");
    QString secondaryStr = m_settings.value("display/customSecondaryColor", "#38BDF8").toString();
    m_customSecondaryColor = QColor::isValidColorName(secondaryStr) ? QColor(secondaryStr) : QColor("#38BDF8");
    
    // Date & Time
    m_autoTime = m_settings.value("datetime/autoTime", true).toBool();
    m_use24HourFormat = m_settings.value("datetime/use24HourFormat", true).toBool();
    m_timeZone = m_settings.value("datetime/timeZone", "Europe/Stockholm").toString();
    
    // Map Style
    m_mapStyle = static_cast<MapStyle>(m_settings.value("map/style", 0).toInt());
}

void SystemSettings::saveSettings()
{
    m_settings.setValue("darkMode", m_darkMode);
    m_settings.setValue("wifiEnabled", m_wifiEnabled);
    m_settings.setValue("bluetoothEnabled", m_bluetoothEnabled);
    m_settings.setValue("masterVolume", m_masterVolume);
    m_settings.setValue("brightness", m_brightness);
    
    // New Properties
    m_settings.setValue("walkAwayLock", m_walkAwayLock);
    m_settings.setValue("useMetric", m_useMetric);
    m_settings.setValue("language", m_language);
    
    // Phase 1: Audio
    m_settings.setValue("audio/eqBass", m_eqBass);
    m_settings.setValue("audio/eqMid", m_eqMid);
    m_settings.setValue("audio/eqTreble", m_eqTreble);
    m_settings.setValue("audio/faderX", m_faderX);
    m_settings.setValue("audio/faderY", m_faderY);
    
    // Phase 3: Vehicle
    m_settings.setValue("vehicle/lightsMode", m_lightsMode);
    m_settings.setValue("vehicle/childLock", m_childLock);
    m_settings.setValue("vehicle/autoFoldMirrors", m_autoFoldMirrors);
    m_settings.setValue("vehicle/rainSensingWipers", m_rainSensingWipers);
    
    // Display/UI + Theme
    m_settings.setValue("display/bottomBarEnabled", m_bottomBarEnabled);
    m_settings.setValue("display/themeKey", m_themeKey);
    m_settings.setValue("display/customAccentColor", m_customAccentColor.name(QColor::HexRgb));
    m_settings.setValue("display/customSecondaryColor", m_customSecondaryColor.name(QColor::HexRgb));
    
    // Date & Time
    m_settings.setValue("datetime/autoTime", m_autoTime);
    m_settings.setValue("datetime/use24HourFormat", m_use24HourFormat);
    m_settings.setValue("datetime/timeZone", m_timeZone);
    
    // Map Style
    m_settings.setValue("map/style", static_cast<int>(m_mapStyle));
    
    m_settings.sync(); // Ensure write to disk
}

// Dark Mode
bool SystemSettings::darkMode() const { return m_darkMode; }
void SystemSettings::setDarkMode(bool darkMode)
{
    if (m_darkMode == darkMode) return;
    m_darkMode = darkMode;
    saveSettings();
    emit darkModeChanged(m_darkMode);
}

// Wifi
bool SystemSettings::wifiEnabled() const { return m_wifiEnabled; }
void SystemSettings::setWifiEnabled(bool wifiEnabled)
{
    if (m_wifiEnabled == wifiEnabled) return;
    m_wifiEnabled = wifiEnabled;
    saveSettings();
    emit wifiEnabledChanged(m_wifiEnabled);
}

// Bluetooth
bool SystemSettings::bluetoothEnabled() const { return m_bluetoothEnabled; }
void SystemSettings::setBluetoothEnabled(bool bluetoothEnabled)
{
    if (m_bluetoothEnabled == bluetoothEnabled) return;
    m_bluetoothEnabled = bluetoothEnabled;
    saveSettings();
    emit bluetoothEnabledChanged(m_bluetoothEnabled);
}

// Volume
int SystemSettings::masterVolume() const { return m_masterVolume; }
void SystemSettings::setMasterVolume(int masterVolume)
{
    if (m_masterVolume == masterVolume) return;
    m_masterVolume = masterVolume;
    saveSettings();
    emit masterVolumeChanged(m_masterVolume);
    if (m_audioHal) m_audioHal->setMasterVolume(m_masterVolume);
}

// Brightness
int SystemSettings::brightness() const { return m_brightness; }
void SystemSettings::setBrightness(int brightness)
{
    if (m_brightness == brightness) return;
    m_brightness = brightness;
    saveSettings();
    emit brightnessChanged(m_brightness);
}

// Vehicle - Walk Away Lock
bool SystemSettings::walkAwayLock() const { return m_walkAwayLock; }
void SystemSettings::setWalkAwayLock(bool walkAwayLock)
{
    if (m_walkAwayLock == walkAwayLock) return;
    m_walkAwayLock = walkAwayLock;
    saveSettings();
    emit walkAwayLockChanged(m_walkAwayLock);
}

// Vehicle - Metric Units
bool SystemSettings::useMetric() const { return m_useMetric; }
void SystemSettings::setUseMetric(bool useMetric)
{
    if (m_useMetric == useMetric) return;
    m_useMetric = useMetric;
    saveSettings();
    emit useMetricChanged(m_useMetric);
}

// System - Language
QString SystemSettings::language() const { return m_language; }
void SystemSettings::setLanguage(const QString &language)
{
    if (m_language == language) return;
    m_language = language;
    saveSettings();
    emit languageChanged(m_language);
}

// System - Version (Read Only)
QString SystemSettings::version() const {
    return "2.1.0"; // Production Version
}

// ═══════════════════════════════════════════════════════════════════
// PHASE 1: AUDIO SETTINGS (EQ & FADER)
// ═══════════════════════════════════════════════════════════════════

// Bass (-10 to 10)
int SystemSettings::eqBass() const { return m_eqBass; }
void SystemSettings::setEqBass(int eqBass)
{
    if (m_eqBass == eqBass) return;
    m_eqBass = std::clamp(eqBass, -10, 10);
    saveSettings();
    emit eqBassChanged(m_eqBass);
}

// Mid (-10 to 10)
int SystemSettings::eqMid() const { return m_eqMid; }
void SystemSettings::setEqMid(int eqMid)
{
    if (m_eqMid == eqMid) return;
    m_eqMid = std::clamp(eqMid, -10, 10);
    saveSettings();
    emit eqMidChanged(m_eqMid);
}

// Treble (-10 to 10)
int SystemSettings::eqTreble() const { return m_eqTreble; }
void SystemSettings::setEqTreble(int eqTreble)
{
    if (m_eqTreble == eqTreble) return;
    m_eqTreble = std::clamp(eqTreble, -10, 10);
    saveSettings();
    emit eqTrebleChanged(m_eqTreble);
}

// Fader X (-1.0 Left to 1.0 Right)
double SystemSettings::faderX() const { return m_faderX; }
void SystemSettings::setFaderX(double faderX)
{
    if (qFuzzyCompare(m_faderX, faderX)) return;
    m_faderX = std::clamp(faderX, -1.0, 1.0);
    saveSettings();
    emit faderXChanged(m_faderX);
}

// Fader Y (-1.0 Front to 1.0 Rear)
double SystemSettings::faderY() const { return m_faderY; }
void SystemSettings::setFaderY(double faderY)
{
    if (qFuzzyCompare(m_faderY, faderY)) return;
    m_faderY = std::clamp(faderY, -1.0, 1.0);
    saveSettings();
    emit faderYChanged(m_faderY);
}

// ═══════════════════════════════════════════════════════════════════
// PHASE 3: VEHICLE CONTROLS
// ═══════════════════════════════════════════════════════════════════

// Lights Mode: 0=Auto, 1=Parking, 2=On, 3=Off
int SystemSettings::lightsMode() const { return m_lightsMode; }
void SystemSettings::setLightsMode(int lightsMode)
{
    if (m_lightsMode == lightsMode) return;
    m_lightsMode = std::clamp(lightsMode, 0, 3);
    saveSettings();
    emit lightsModeChanged(m_lightsMode);
}

// Child Lock
bool SystemSettings::childLock() const { return m_childLock; }
void SystemSettings::setChildLock(bool childLock)
{
    if (m_childLock == childLock) return;
    m_childLock = childLock;
    saveSettings();
    emit childLockChanged(m_childLock);
}

// Auto Fold Mirrors
bool SystemSettings::autoFoldMirrors() const { return m_autoFoldMirrors; }
void SystemSettings::setAutoFoldMirrors(bool autoFoldMirrors)
{
    if (m_autoFoldMirrors == autoFoldMirrors) return;
    m_autoFoldMirrors = autoFoldMirrors;
    saveSettings();
    emit autoFoldMirrorsChanged(m_autoFoldMirrors);
}

// Rain Sensing Wipers
bool SystemSettings::rainSensingWipers() const { return m_rainSensingWipers; }
void SystemSettings::setRainSensingWipers(bool rainSensingWipers)
{
    if (m_rainSensingWipers == rainSensingWipers) return;
    m_rainSensingWipers = rainSensingWipers;
    saveSettings();
    emit rainSensingWipersChanged(m_rainSensingWipers);
}

// Bottom Bar Enabled (Display/UI Setting)
bool SystemSettings::bottomBarEnabled() const { return m_bottomBarEnabled; }
void SystemSettings::setBottomBarEnabled(bool bottomBarEnabled)
{
    if (m_bottomBarEnabled == bottomBarEnabled) return;
    m_bottomBarEnabled = bottomBarEnabled;
    saveSettings();
    emit bottomBarEnabledChanged(m_bottomBarEnabled);
}

// ═══════════════════════════════════════════════════════════════════
// THEME SYSTEM
// ═══════════════════════════════════════════════════════════════════

// Valid theme keys
static const QStringList validThemeKeys = {"nordic", "ocean", "sunset", "forest", "custom"};

// Theme Key: "nordic", "ocean", "sunset", "forest", "custom"
QString SystemSettings::themeKey() const { return m_themeKey; }
void SystemSettings::setThemeKey(const QString &themeKey)
{
    if (m_themeKey == themeKey) return;
    // Validate theme key - fallback to "nordic" if invalid
    m_themeKey = validThemeKeys.contains(themeKey) ? themeKey : "nordic";
    saveSettings();
    emit themeKeyChanged(m_themeKey);
}

// Custom Accent Color (QColor, stored as hex string)
QColor SystemSettings::customAccentColor() const { return m_customAccentColor; }
void SystemSettings::setCustomAccentColor(const QColor &customAccentColor)
{
    if (m_customAccentColor == customAccentColor) return;
    // Validate color - fallback to default if invalid
    m_customAccentColor = customAccentColor.isValid() ? customAccentColor : QColor("#8B5CF6");
    saveSettings();
    emit customAccentColorChanged(m_customAccentColor);
}

// Custom Secondary Color (QColor, stored as hex string)
QColor SystemSettings::customSecondaryColor() const { return m_customSecondaryColor; }
void SystemSettings::setCustomSecondaryColor(const QColor &customSecondaryColor)
{
    if (m_customSecondaryColor == customSecondaryColor) return;
    // Validate color - fallback to default if invalid
    m_customSecondaryColor = customSecondaryColor.isValid() ? customSecondaryColor : QColor("#38BDF8");
    saveSettings();
    emit customSecondaryColorChanged(m_customSecondaryColor);
}

// Map Style
SystemSettings::MapStyle SystemSettings::mapStyle() const { return m_mapStyle; }
void SystemSettings::setMapStyle(SystemSettings::MapStyle style)
{
    if (m_mapStyle == style) return;
    m_mapStyle = style;
    saveSettings();
    emit mapStyleChanged(m_mapStyle);
}

// Map Orientation (0=NorthUp, 1=HeadingUp)
int SystemSettings::mapOrientation() const { return m_mapOrientation; }
void SystemSettings::setMapOrientation(int orientation)
{
    if (m_mapOrientation == orientation) return;
    m_mapOrientation = orientation;
    m_settings.setValue("map/orientation", m_mapOrientation);
    m_settings.sync();
    emit mapOrientationChanged(m_mapOrientation);
}

// Date & Time
bool SystemSettings::autoTime() const { return m_autoTime; }
void SystemSettings::setAutoTime(bool autoTime)
{
    if (m_autoTime == autoTime) return;
    m_autoTime = autoTime;
    saveSettings();
    emit autoTimeChanged(m_autoTime);
}

bool SystemSettings::use24HourFormat() const { return m_use24HourFormat; }
void SystemSettings::setUse24HourFormat(bool use24HourFormat)
{
    if (m_use24HourFormat == use24HourFormat) return;
    m_use24HourFormat = use24HourFormat;
    saveSettings();
    emit use24HourFormatChanged(m_use24HourFormat);
}

QString SystemSettings::timeZone() const { return m_timeZone; }
void SystemSettings::setTimeZone(const QString &timeZone)
{
    if (m_timeZone == timeZone) return;
    m_timeZone = timeZone;
    saveSettings();
    emit timeZoneChanged(m_timeZone);
}

QStringList SystemSettings::availableTimeZones() const {
    QStringList zones;
    // Iterate and convert QByteArray to QString
    const auto ids = QTimeZone::availableTimeZoneIds();
    for (const auto &id : ids) {
        zones.append(QString::fromLatin1(id));
    }
    // If list is empty (embedded?), provide fallback
    if (zones.isEmpty()) {
        zones << "Europe/Stockholm" << "America/New_York" << "Asia/Tokyo" << "UTC";
    }
    return zones;
}

QDateTime SystemSettings::currentDateTime() const {
    // Return system time + manual offset
    return QDateTime::currentDateTime().addMSecs(m_timeOffsetMs);
}

void SystemSettings::setDate(int year, int month, int day) {
    if (m_autoTime) return;
    
    QDateTime current = currentDateTime();
    QDate newDate(year, month, day);
    QDateTime target(newDate, current.time());
    
    // Calculate new offset: Target - Real System Time
    m_timeOffsetMs = QDateTime::currentDateTime().msecsTo(target);
    emit currentDateTimeChanged();
}

void SystemSettings::setTime(int hour, int minute) {
    if (m_autoTime) return;
    
    QDateTime current = currentDateTime();
    QTime newTime(hour, minute, current.time().second());
    QDateTime target(current.date(), newTime);
    
    m_timeOffsetMs = QDateTime::currentDateTime().msecsTo(target);
    emit currentDateTimeChanged();
}

// ═══════════════════════════════════════════════════════════════════
// PHASE 4: SYSTEM ADMIN
// ═══════════════════════════════════════════════════════════════════

void SystemSettings::factoryReset()
{
    m_settings.clear();
    m_settings.sync();
    
    // Reset Logic: Reload defaults
    // Or just manually reset members to defaults
    // For simplicity, we'll reload defaults (since clear() removed keys, loadSettings will pick defaults)
    loadSettings();
    
    // Emit all signals to update UI
    emit darkModeChanged(m_darkMode);
    emit wifiEnabledChanged(m_wifiEnabled);
    emit bluetoothEnabledChanged(m_bluetoothEnabled);
    emit masterVolumeChanged(m_masterVolume);
    emit brightnessChanged(m_brightness);
    
    emit walkAwayLockChanged(m_walkAwayLock);
    emit useMetricChanged(m_useMetric);
    emit languageChanged(m_language);
    
    emit eqBassChanged(m_eqBass);
    emit eqMidChanged(m_eqMid);
    emit eqTrebleChanged(m_eqTreble);
    emit faderXChanged(m_faderX);
    emit faderYChanged(m_faderY);
    
    emit lightsModeChanged(m_lightsMode);
    emit childLockChanged(m_childLock);
    emit autoFoldMirrorsChanged(m_autoFoldMirrors);
    emit rainSensingWipersChanged(m_rainSensingWipers);
    
    emit autoTimeChanged(m_autoTime);
    emit use24HourFormatChanged(m_use24HourFormat);
    emit timeZoneChanged(m_timeZone);
}
