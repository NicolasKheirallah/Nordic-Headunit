#ifndef LAYOUTSERVICE_H
#define LAYOUTSERVICE_H

#include <QObject>
#include <QGuiApplication>
#include <QScreen>
#include <QDebug>

class LayoutService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(WidthClass widthClass READ widthClass NOTIFY layoutChanged)
    Q_PROPERTY(HeightClass heightClass READ heightClass NOTIFY layoutChanged)
    Q_PROPERTY(bool isLandscape READ isLandscape NOTIFY layoutChanged)
    Q_PROPERTY(bool isCompact READ isCompact NOTIFY layoutChanged)
    Q_PROPERTY(QSize screenSize READ screenSize NOTIFY layoutChanged)

public:
    explicit LayoutService(QObject *parent = nullptr);

    enum WidthClass {
        CompactWidth = 0,   // 1024 - 1199
        RegularWidth = 1,   // 1200 - 1599
        ExpandedWidth = 2   // 1600+
    };
    Q_ENUM(WidthClass)

    enum HeightClass {
        ShortHeight = 0,    // 600 - 719
        NormalHeight = 1,   // 720 - 899
        TallHeight = 2      // 900+
    };
    Q_ENUM(HeightClass)

    WidthClass widthClass() const { return m_widthClass; }
    HeightClass heightClass() const { return m_heightClass; }
    bool isLandscape() const { return m_isLandscape; }
    bool isCompact() const { return m_widthClass == CompactWidth || m_heightClass == ShortHeight; }
    QSize screenSize() const { return m_screenSize; }

    static LayoutService* instance();

public slots:
    void updateLayout(const QSize &size);

signals:
    void layoutChanged();

private:
    WidthClass m_widthClass;
    HeightClass m_heightClass;
    bool m_isLandscape;
    QSize m_screenSize;
    
    void calculateClasses();
};

#endif // LAYOUTSERVICE_H
