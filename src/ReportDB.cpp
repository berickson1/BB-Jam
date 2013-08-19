/*
 * ReportDB.cpp
 *
 *  Created on: Aug 9, 2013
 *      Author: Brent.Erickson
 */

#include "ReportDB.hpp"

ReportDB::ReportDB() {
	initDataModel();
	initDatabase();
}

//Create New Report in Database
int ReportDB::createReport(QString const& name) {
	//Ensure database is active
	if (dbActive()) {
		QSqlQuery query(m_database);
		query.prepare("INSERT INTO Reports (name) VALUES(:name)");
		query.bindValue(":name", name);

		if (query.exec()) {
			qDebug() << "New Report created";
			bool isInt;
			int newID = query.lastInsertId().toInt(&isInt);
			if (isInt) {
				return newID;
			} else {
				qDebug() << "Invalid Report ID returned";
				return -1;
			}
			return (isInt) ? newID : -1;
		} else {
			const QSqlError error = query.lastError();
			alert(tr("Create record error: %1").arg(error.text()));
			return -1;
		}
	}
	return -1;

}

//Read all reports from Database into datamodel
void ReportDB::readReports() {

	QSqlQuery query(m_database);
	const QString sqlQuery = "SELECT id, name FROM Reports ORDER BY name";

	if (query.exec(sqlQuery)) {

		const int db_id = query.record().indexOf("id");
		const int db_name = query.record().indexOf("name");

		m_reportsDataModel->clear();

		int nRead = 0;
		bool ok;
		while (query.next()) {
			Report *report = new Report(query.value(db_id).toInt(&ok),
					query.value(db_name).toString());
			m_reportsDataModel->insert(report);
			nRead++;
		}
		qDebug() << "Read " << nRead << " records from the database";

	} else {
		//TODO: Handle this more gracefully
		alert(
				tr("Error reading from database: %1").arg(
						query.lastError().text()));
	}
}

//Output reports from datamodel into SystemListDialog
void ReportDB::outputReportItems(bb::system::SystemListDialog * outDialog) {
	readReports();

	outDialog->clearList();

	int reportCount = m_reportsDataModel->childCount(QVariantList());
	for (int i = 0; i < reportCount; i++) {
		Report * r = getReportAtIndex(i);
		outDialog->appendItem(r->name());
	}

}

//Retrieve report at index from datamodel
Report * ReportDB::getReportAtIndex(int index) {
	QVariantList indexPath = QVariantList();
	indexPath.append(QVariant(index));
	QVariant v = m_reportsDataModel->data(indexPath);
	Report * r = qobject_cast<Report *>(qvariant_cast<QObject *>(v));
	return r;
}

//Update Report in datamodel and database
bool ReportDB::updateReport(QString const&, QString const&) {
	//TODO: Implement
	return false;
}

//Delete Report from datamodel and database
bool ReportDB::deleteReport(QString const&) {
	//TODO: Implement
	return false;
}

//Retrieve DataModel
GroupDataModel* ReportDB::dataModel() const {
	return m_reportsDataModel;
}

//Check if database connection is active, re-initiate it if it isn't active
bool ReportDB::dbActive() {
	//We're done if the connection is active
	if (m_database.isOpen())
		return true;

	//Re-open database in inited
	if (dbInited) {
		m_database = QSqlDatabase::database();
		return true;
	}

	//Init database
	return initDatabase();
}

//Initiate database connection
bool ReportDB::initDatabase() {
	m_database = QSqlDatabase::addDatabase("QSQLITE");

	//Check if datafile exists
	QFile dbFile(DBPATH);

	//Ensure file exists, copy from assets if it doesn't
	if (!dbFile.exists()) {
		qDebug() << "Database does not exist, creating";
		QFile dbAssetFile(DBASSETPATH);
		if (!dbAssetFile.exists()) {
			qDebug() << "FATAL ERROR: Database does not exist in assets";
			return false;
		}
		//Ensure directory structure exists
		QFileInfo fileInfo(dbFile);
		QDir().mkpath(fileInfo.path());

		if (!dbAssetFile.copy(DBPATH)) {
			qDebug() << "FATAL ERROR: Error copying database file";
			return false;
		}
	}
	//Set up database
	m_database.setDatabaseName(DBPATH);

	if (!m_database.open()) {
		qDebug() << "FATAL ERROR: Error opening database";
		return false;
	}
	return true;
}

//Returns report name for report at index
QString ReportDB::getSelectedReportName(int index) {
	return getReportAtIndex(index)->name();
}

//Returns report id for report at index
int ReportDB::getSelectedReportID(int index) {
	return getReportAtIndex(index)->id();
}

//Initiates the Report datamodel
void ReportDB::initDataModel() {
	m_reportsDataModel = new GroupDataModel(this);
	m_reportsDataModel->setSortingKeys(QStringList() << "name");
	m_reportsDataModel->setGrouping(ItemGrouping::None);
}

//Alert Dialog Box Functions
void ReportDB::alert(const QString &message) {
	SystemDialog *dialog;
	dialog = new SystemDialog(tr("OK"), 0);
	dialog->setTitle(tr("Alert"));
	dialog->setBody(message);
	dialog->setDismissAutomatically(true);

	bool ok = connect(dialog,
			SIGNAL(finished(bb::system::SystemUiResult::Type)), dialog,
			SLOT(deleteLater()));
	Q_ASSERT(ok);
	dialog->show();
}
