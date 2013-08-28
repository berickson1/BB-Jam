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
	Q_PROPERTY(float value READ value FINAL CONSTANT)
	Q_PROPERTY(int quantityID READ quantityID WRITE setQuantityID NOTIFY itemUpdated FINAL)
	Q_PROPERTY(int durationID READ durationID WRITE setDurationID NOTIFY itemUpdated FINAL)
	Q_PROPERTY(int monthID READ monthID WRITE setMonthID NOTIFY itemUpdated FINAL)
	Q_PROPERTY(float durationValue READ durationValue WRITE setDurationValue NOTIFY itemUpdated FINAL)
	Q_PROPERTY(float monthValue READ monthValue WRITE setMonthValue NOTIFY itemUpdated FINAL)

public:
	Item(const int &id, const int &locationID, const QString &name,
			const float &value, const int &quantityID, const int &durationID,
			const int &monthID, const float &durationValue, const float &monthValue,
			const bool &dbItemData, QObject *parent = 0);

	int id() const;
	int locationID() const;
	QString name() const;
	float value() const;
	int quantityID() const;
	int durationID() const;
	int monthID() const;
	float durationValue() const;
	float monthValue() const;
	bool dbItemData() const;
	void setQuantityID(const int &newQuantityID);
	void setDurationID(const int &newDurationID);
	void setMonthID(const int &newMonthID);
	void setDurationValue(const float &newDurationValue);
	void setMonthValue(const float &newMonthValue);
	void setDbItemData(const bool &newDbItemData);

	signals:
	void itemUpdated(Item *newItem);

private:
	int m_id;
	int m_locationID;
	QString m_name;
	float m_value;
	int m_quantityID;
	int m_durationID;
	int m_monthID;
	float m_durationValue;
	float m_monthValue;
	bool m_dbItemData;
};
Q_DECLARE_METATYPE(Item *);
#endif /* ITEM_H_ */
