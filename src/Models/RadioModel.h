#pragma once
#include <QAbstractListModel>
#include <QObject>
#include <QList>

struct RadioStation {
    QString name;
    QString frequency;
    QString band;
    bool active = false;
};

class RadioModel : public QAbstractListModel {
    Q_OBJECT
public:
    enum RadioRoles {
        NameRole = Qt::UserRole + 1,
        FrequencyRole,
        BandRole,
        ActiveRole
    };

    explicit RadioModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addStation(const RadioStation &station);
    void clear();
    void setActive(int index);
    RadioStation getStation(int index) const;
    QList<RadioStation> getAll() const;

private:
    QList<RadioStation> m_stations;
};
