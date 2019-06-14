#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickWidget>
#include "backend.h"
#include "fileio.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

/*

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/SuitabilityMap.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
*/

    QQuickWidget* w = new QQuickWidget();
    Backend data;
    w->engine()->rootContext()->setContextProperty("applicationData", &data);

    w->setSource(QUrl("qrc:/layer.qml"));
    w->show();


    FileIO map;
    map.setSource("E:\\dev\\qml-dynamiclist\\data\\maps.json");
    data.setMap(map.read());

    return app.exec();
}
