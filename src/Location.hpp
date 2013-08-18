/*
 * Location.h
 *
 *  Created on: Aug 18, 2013
 *      Author: Brent.Erickson
 */

#ifndef LOCATION_H_
#define LOCATION_H_

#include <QObject>
#include <QMetaType>

class Location: public QObject {
	Q_OBJECT

	// These are the properties that will be accessible by the datamodel in the view.
	Q_PROPERTY(QString id READ id FINAL)
	Q_PROPERTY(QString name READ name FINAL)
	Q_PROPERTY(QString image READ image FINAL)

public:
	Location(QObject *parent = 0);
	Location(const QString &id, const QString &name, const QString &image,QObject *parent = 0);

	QString id() const;
	QString name() const;
	QString image() const;

private:
	QString m_id;
	QString m_name;
	QString m_image;
};
Q_DECLARE_METATYPE(Location *);
#endif /* LOCATION_H_ */
