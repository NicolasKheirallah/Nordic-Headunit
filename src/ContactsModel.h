#ifndef CONTACTSMODEL_H
#define CONTACTSMODEL_H

#include <QAbstractListModel>
#include <QList>
#include <QVariant>

struct ContactItem {
    QString name;
    QString number;
    QString avatar; // Path or Initials
};

class ContactsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum ContactRoles {
        NameRole = Qt::UserRole + 1,
        NumberRole,
        AvatarRole
    };

    explicit ContactsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // Manipulation
    Q_INVOKABLE void addContact(const QString &name, const QString &number, const QString &avatar = "");
    Q_INVOKABLE void clear();
    Q_INVOKABLE QString getNameForNumber(const QString &number) const;
    
    // Filtering
    Q_INVOKABLE void setFilter(const QString &query); // Basic substring filter

    // Persistence
    void loadData();
    void saveData();

private:
    QList<ContactItem> m_allContacts; // Source of truth
    QList<ContactItem> m_displayedContacts; // Filtered view
    QString m_filterQuery;
    
    void applyFilter();
};

#endif // CONTACTSMODEL_H
