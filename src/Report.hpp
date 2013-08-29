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
	Q_PROPERTY(int id READ id FINAL CONSTANT)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged FINAL)

public:
	Report(const int &id, const QString &name, QObject *parent = 0);

	int id() const;
	QString name() const;

	void setName(const QString &newName);

	Q_SIGNALS:
	void nameChanged(const QString &firstName);

private:
	int m_id;
	QString m_name;
};
Q_DECLARE_METATYPE(Report *);
#endif /* REPORT_H_ */
