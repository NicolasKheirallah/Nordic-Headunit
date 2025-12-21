#ifndef TRANSLATIONSERVICE_H
#define TRANSLATIONSERVICE_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QDebug>
#include <QDir>
#include <QMap>

class TranslationService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentLanguage READ currentLanguage NOTIFY languageChanged)
    Q_PROPERTY(QStringList availableLanguages READ availableLanguages CONSTANT)

public:
    explicit TranslationService(QQmlEngine *engine, QObject *parent = nullptr);

    // Singleton Instance
    static TranslationService* instance();
    static QObject* qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

    QString currentLanguage() const;
    QStringList availableLanguages() const;

    Q_INVOKABLE void selectLanguage(const QString &languageCode);

signals:
    void languageChanged();

private:
    QQmlEngine *m_engine;
    QTranslator m_translator;
    QString m_currentLanguage;
    QMap<QString, QString> m_languageMap; // Name -> Code (e.g. "English" -> "en_US")

    void loadLanguage(const QString &code);
};

#endif // TRANSLATIONSERVICE_H
