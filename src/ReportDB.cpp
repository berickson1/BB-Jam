/*
 * ReportDB.cpp
 *
 *  Created on: Aug 9, 2013
 *      Author: Brent.Erickson
 */

#include "ReportDB.h"

ReportDB::ReportDB() {
	// TODO Auto-generated constructor stub
}
bool ReportDB::createReport(QString const& name) {
	//Ensure database is active
	if (dbActive()) {
		QSqlQuery query(database);
		query.prepare("INSERT INTO Reports (name) VALUES(:name)");
		query.bindValue(":name", name);
		query.exec();

		if (query.exec()) {
			alert(tr("Record created"));
		} else {
			const QSqlError error = query.lastError();
			alert(tr("Create record error: %1").arg(error.text()));
		}
	}

}
void ReportDB::readReports() {

	QSqlQuery query(database);
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
	//TODO: Implement
	return false;
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
