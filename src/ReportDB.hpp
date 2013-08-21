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
#include <bb/system/SystemListDialog.hpp>
#include "Report.hpp"
#include "Location.hpp"
#include <QDebug>
#include <QObject>

using namespace bb::cascades;
using namespace bb::system;

#define DBPATH "./data/reportDatabase.db"
#define DBASSETPATH "./app/native/assets/db/reports.db"

class ReportDB: public QObject {
	Q_OBJECT

    // A property that is used by the list view in QML
    Q_PROPERTY(bb::cascades::DataModel* reportDataModel READ reportDataModel CONSTANT)
	Q_PROPERTY(bb::cascades::DataModel* locationDataModel READ locationDataModel CONSTANT)

public:

    Q_INVOKABLE int createReport(const QString &name);
    Q_INVOKABLE void readReports();
    Q_INVOKABLE bool updateReport(const QString &key, const QString &name);
    Q_INVOKABLE bool deleteReport(const QString &key);
    Q_INVOKABLE void outputReportItems(bb::system::SystemListDialog * outputDialog);
    Q_INVOKABLE QString getSelectedReportName(int index);
    Q_INVOKABLE int getSelectedReportID(int index);
    Q_INVOKABLE void readLocations();
	ReportDB();

private:
	QSqlDatabase m_database;
	bool dbActive();
    void initReportDataModel();
    void initLocationDataModel();
    bool initDatabase();
    bool dbInited;
    Report * getReportAtIndex(int index);

    void alert(const QString &message);

    // The getter method for the property
    bb::cascades::GroupDataModel* reportDataModel() const;
    bb::cascades::GroupDataModel* locationDataModel() const;

    // The data shown by the list view.
    GroupDataModel* m_reportsDataModel;
    GroupDataModel* m_locationsDataModel;
};

#endif /* REPORTDB_H_ */
