/*
 * ReportDB.h
 *
 *  Created on: Aug 9, 2013
 *      Author: Brent.Erickson
 */

#ifndef REPORTDB_H_
#define REPORTDB_H_

#include <qobject.h>
#include <bb/cascades/GroupDataModel>
#include <QtSql/QtSql>
#include <bb/system/SystemDialog>
#include "Report.h"
#include <QDebug>

using namespace bb::cascades;
using namespace bb::system;

class ReportDB: public QObject {
	Q_OBJECT

    // A property that is used by the list view in QML
    Q_PROPERTY(DataModel* dataModel READ dataModel CONSTANT)

public:

    Q_INVOKABLE bool createReport(const QString &name);
    Q_INVOKABLE void readReports();
    Q_INVOKABLE bool updateReport(const QString &key, const QString &name);
    Q_INVOKABLE bool deleteReport(const QString &key);

	ReportDB();

private:
	QSqlDatabase database;
	bool dbActive();
    void initDataModel();
    bool initDatabase();

    void alert(const QString &message);

    // The getter method for the property
    GroupDataModel* dataModel() const;

    // The data shown by the list view.
    GroupDataModel* m_dataModel;
};

#endif /* REPORTDB_H_ */
