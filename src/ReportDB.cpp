/*
 * ReportDB.cpp
 *
 *  Created on: Aug 9, 2013
 *      Author: Brent.Erickson
 */

#include "ReportDB.hpp"

ReportDB::ReportDB(){
	initDataModel();
	initDatabase();
}
bool ReportDB::createReport(QString const& name) {
	//Ensure database is active
	if (dbActive()) {
		QSqlQuery query(m_database);
		query.prepare("INSERT INTO Reports (name) VALUES(:name)");
		query.bindValue(":name", name);
		query.exec();

		if (query.exec()) {
			alert(tr("Record created"));
			return true;
		} else {
			const QSqlError error = query.lastError();
			alert(tr("Create record error: %1").arg(error.text()));
			return false;
		}
	}
	return false;

}
void ReportDB::readReports() {

	QSqlQuery query(m_database);
	const QString sqlQuery = "SELECT id, name FROM Reports";

	if (query.exec(sqlQuery)) {

		const int db_id = query.record().indexOf("id");
		const int db_name = query.record().indexOf("name");

		m_dataModel->clear();

		int nRead = 0;
		while (query.next()) {
			Report *report = new Report(query.value(db_id).toString(),
					query.value(db_name).toString());
			m_dataModel->insert(report);
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
void ReportDB::outputReportItems(bb::system::SystemListDialog * outDialog){
	QSqlQuery query(m_database);
	const QString sqlQuery = "SELECT id, name FROM Reports";

	if (query.exec(sqlQuery)) {

		const int db_id = query.record().indexOf("id");
		const int db_name = query.record().indexOf("name");

		int nRead = 0;
		while (query.next()) {
			outDialog->appendItem(query.value(db_name).toString());
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
bool ReportDB::updateReport(QString const&, QString const&) {
	//TODO: Implement
	return false;
}
bool ReportDB::deleteReport(QString const&) {
	//TODO: Implement
	return false;
}
GroupDataModel* ReportDB::dataModel() const {
	return m_dataModel;
}
bool ReportDB::dbActive() {
	//We're done if the connection is active
	if(m_database.isOpen())
		return true;

	//Re-open database in inited
	if(dbInited){
		m_database = QSqlDatabase::database();
		return true;
	}

	//Init database
	return initDatabase();

}

bool ReportDB::initDatabase(){
	m_database = QSqlDatabase::addDatabase("QSQLITE");

	//Check if datafile exists
	QFile dbFile(DBPATH);

	//Ensure file exists, copy from assets if it doesn't
	if(!dbFile.exists()){
		alert("File does not exist");
		QFile dbAssetFile(DBASSETPATH);
		if (!dbAssetFile.exists()){
			alert("Error initializing database");
		}
		//Ensure directory structure exists
		QFileInfo fileInfo(dbFile);
		QDir().mkpath(fileInfo.path());

		if(!dbAssetFile.copy(DBPATH)){
			alert("Error copying database file");
		}
	}
	//Set up database
	m_database.setDatabaseName(DBPATH);

	if (!m_database.open()){
		alert("Error opening database");
		return false;
	}
	return true;
}

void ReportDB::initDataModel(){
	m_dataModel = new GroupDataModel(this);
	m_dataModel->setSortingKeys(QStringList() << "name");
	m_dataModel->setGrouping(ItemGrouping::None);
}

// Alert Dialog Box Functions
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
