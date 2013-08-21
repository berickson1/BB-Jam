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
	Q_PROPERTY(int id READ id FINAL CONSTANT)
	Q_PROPERTY(int locationID READ locationID FINAL CONSTANT)
	Q_PROPERTY(QString name READ name FINAL CONSTANT)
	Q_PROPERTY(int value READ value FINAL CONSTANT)

public:
	Item(QObject *parent = 0);
	Item(const int &id, const int &locationID, const QString &name, const int &value,QObject *parent = 0);

	int id() const;
	int locationID() const;
	QString name() const;
	int value() const;

private:
	int m_id;
	int m_locationID;
	QString m_name;
	int m_value;
};
Q_DECLARE_METATYPE(Item *);
#endif /* ITEM_H_ */
