#include "Backend.h"
#include <QQmlApplicationEngine>
#include <QTimer>

Backend::Backend(QObject * parent)
    : QObject(parent)
{

}

Backend::~Backend()
{

}

QString Backend::map()
{
    return m_map;
}

void Backend::setMap(const QString &map)
{
    if (map == m_map)
        return;

    m_map = map;
    emit mapChanged();
}


void Backend::onLayerAdd(const QString& dom)
{
    qDebug("onLayerAdd\n");
}

void Backend::onLayerChange(const QString& dom)
{
    qDebug("onLayerChange\n");

}
void Backend::onLayerDelete(const QString& dom)
{
    qDebug("onLayerDelete\n");

}
//void onColorChange(const Dom& dom);
void Backend::onSuitabilityMapAdd(const QString& dom)
{
    qDebug("onSuitabilityMapAdd\n");

    //m_map = dom;

}
void Backend::onSuitabilityMapDelete(const QString& dom)
{
    qDebug("onSuitabilityMapDelete\n");

}
void Backend::onSuitabilityMapChange(const QString& dom)
{
    qDebug("onSuitabilityMapChange\n");

    qDebug(qPrintable(dom));

    // QTimer::singleShot(200, [=](){ setMap(dom); } );
}

void Backend::onSuitabilityMapActive(const QString& dom)
{
    qDebug("onSuitabilityMapActive\n");

}

void Backend::onSelectFeatureSets(const QString& dom)
{
    qDebug("onSelectFeatureSets\n");

}

void Backend::onRefreshModel(const QString& dom)
{
    qDebug("onRefreshModel\n");

}
