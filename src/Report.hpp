/*
 * Report.h
 *
 *  Created on: Aug 9, 2013
 *      Author: Brent.Erickson
 */

#ifndef REPORT_H_
#define REPORT_H_

#include <QObject>
#include <QMetaType>

class Report: public QObject {
	Q_OBJECT

	// These are the properties that will be accessible by the datamodel in the view.
	Q_PROPERTY(QString id READ id FINAL)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)

public:
	Report(QObject *parent = 0);
	Report(const QString &id, const QString &name, QObject *parent = 0);

	QString id() const;
	QString name() const;

	void setName(const QString &newName);

	Q_SIGNALS:
	void nameChanged(const QString &firstName);

private:
	QString m_id;
	QString m_name;
};
Q_DECLARE_METATYPE(Report *);
#endif /* REPORT_H_ */
