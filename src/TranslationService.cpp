#include "TranslationService.h"

// Static instance for Singleton handling
static TranslationService *s_instance = nullptr;

TranslationService::TranslationService(QQmlEngine *engine, QObject *parent)
    : QObject(parent), m_engine(engine)
{
    s_instance = this;
    m_currentLanguage = "English";

    // Initialize Language Map
    // In a real app, this could be dynamic or read from metadata
    m_languageMap["English"] = "en_US";
    m_languageMap["Svenska"] = "sv_SE";
    m_languageMap["Deutsch"] = "de_DE";
    m_languageMap["Français"] = "fr_FR";
    m_languageMap["Norsk"] = "nb_NO";
}

TranslationService* TranslationService::instance()
{
    return s_instance;
}

QObject* TranslationService::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(scriptEngine)
    // We assume the engine passed in constructor is the main one.
    // If not, we might need to handle multiple engines.
    if (!s_instance) {
        s_instance = new TranslationService(engine);
    }
    return s_instance;
}

QString TranslationService::currentLanguage() const
{
    return m_currentLanguage;
}

QStringList TranslationService::availableLanguages() const
{
    return m_languageMap.keys();
}

void TranslationService::selectLanguage(const QString &languageName)
{
    if (m_currentLanguage == languageName) return;

    if (m_languageMap.contains(languageName)) {
        QString code = m_languageMap[languageName];
        loadLanguage(code);
        m_currentLanguage = languageName;
        emit languageChanged();
    }
}

void TranslationService::loadLanguage(const QString &code)
{
    // Remove old translator
    qApp->removeTranslator(&m_translator);

    // Load new one
    // Path: :/i18n/nordic_en_US.qm
    QString filename = QString(":/i18n/nordic_%1.qm").arg(code);
    
    if (m_translator.load(filename)) {
        qApp->installTranslator(&m_translator);
        m_engine->retranslate(); // Trigger QML re-evaluation
        qDebug() << "Translation loaded:" << filename;
    } else {
        qWarning() << "Failed to load translation:" << filename;
    }
}
