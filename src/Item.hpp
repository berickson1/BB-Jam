/*
 * Item.h
 *
 *  Created on: Aug 18, 2013
 *      Author: Brent.Erickson
 */

#ifndef ITEM_H_
#define ITEM_H_

#include <QObject>
#include <QMetaType>

class Item: public QObject {
	Q_OBJECT

	// These are the properties that will be accessible by the datamodel in the view.
	Q_PROPERTY(QString id READ id FINAL)
	Q_PROPERTY(QString locationID READ id FINAL)
	Q_PROPERTY(QString name READ name FINAL)
	Q_PROPERTY(QString value READ image FINAL)

public:
	Item(QObject *parent = 0);
	Item(const QString &id, const QString &locationID, const QString &name, const QString &value,QObject *parent = 0);

	QString id() const;
	QString locationID() const;
	QString name() const;
	QString value() const;

private:
	QString m_id;
	QString m_locationID;
	QString m_name;
	QString m_value;
};
Q_DECLARE_METATYPE(Item *);
#endif /* ITEM_H_ */
