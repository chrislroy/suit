#ifndef BACKEND_H
#define BACKEND_H

#include <QtCore/QObject>


typedef QString Dom;


class Backend : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString map READ map WRITE setMap NOTIFY mapChanged)

public:
    Backend(QObject* parent = nullptr);
    ~Backend();

    QString map();
    void setMap(const QString &map);

signals:
    void mapChanged();

public slots:

    void onLayerAdd(const QString& dom);
    void onLayerChange(const QString& dom);
    void onLayerDelete(const QString& dom);
    //void onColorChange(const Dom& dom);
    void onSuitabilityMapAdd(const QString& dom);
    void onSuitabilityMapDelete(const QString& dom);
    void onSuitabilityMapChange(const QString& dom);
    void onSuitabilityMapActive(const QString& dom);
    void onSelectFeatureSets(const QString& dom);
    void onRefreshModel(const QString& dom);

private:
    QString m_map;
};

#endif // BACKEND_H
