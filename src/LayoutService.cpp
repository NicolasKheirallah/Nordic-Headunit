#include "LayoutService.h"

LayoutService::LayoutService(QObject *parent) : QObject(parent)
{
    m_widthClass = RegularWidth;
    m_heightClass = NormalHeight;
    m_isLandscape = true;
    m_screenSize = QSize(1280, 720);
}

LayoutService* LayoutService::instance()
{
    static LayoutService* inst = new LayoutService();
    return inst;
}

void LayoutService::updateLayout(const QSize &size)
{
    if (m_screenSize == size) return;
    
    m_screenSize = size;
    calculateClasses();
    emit layoutChanged();
    
    qDebug() << "LayoutService: Updated layout to" << size.width() << "x" << size.height() 
             << "WidthClass:" << m_widthClass << "HeightClass:" << m_heightClass;
}

void LayoutService::calculateClasses()
{
    int w = m_screenSize.width();
    int h = m_screenSize.height();
    
    m_isLandscape = w > h;

    // Width Classification
    if (w < 800) {
        m_widthClass = CompactWidth;
    } else if (w < 1400) {
        m_widthClass = RegularWidth;
    } else {
        m_widthClass = ExpandedWidth;
    }

    // Height Classification
    if (h < 720) {
        m_heightClass = ShortHeight;
    } else if (h < 900) {
        m_heightClass = NormalHeight;
    } else {
        m_heightClass = TallHeight;
    }
}
