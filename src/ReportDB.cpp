/*
 * ReportDB.cpp
 *
 *  Created on: Aug 9, 2013
 *      Author: Brent.Erickson
 */

#include "ReportDB.hpp"

ReportDB::ReportDB() {
	initDatabase();
	initReportDataModel();
	initLocationDataModel();
	initItemDataModel();
}

//Create New Report in Database
int ReportDB::createReport(QString const& name) {
	//Ensure database is active
	if (!ReportDB::dbActive()) {
		qDebug("DB Not active!");
		return -1;
	}
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
		qDebug() << "Create record error: " << error.text();
		return -1;
	}

}

//Read all reports from Database into datamodel
void ReportDB::readReports() {
	if (!ReportDB::dbActive()) {
		qDebug("DB Not active!");
		return;
	}
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
		qDebug() << "Error reading from database: " << query.lastError().text();
	}
}

//Read all reports from Database into datamodel
void ReportDB::readLocations() {
	if (!ReportDB::dbActive()) {
		qDebug("DB Not active!");
		return;
	}
	QSqlQuery query(m_database);
	const QString sqlQuery =
			"SELECT id, name, image FROM Locations ORDER BY name";

	if (query.exec(sqlQuery)) {

		const int db_id = query.record().indexOf("id");
		const int db_name = query.record().indexOf("name");
		const int db_image = query.record().indexOf("image");

		m_locationsDataModel->clear();

		int nRead = 0;
		bool ok;
		while (query.next()) {
			Location *location = new Location(query.value(db_id).toInt(&ok),
					query.value(db_name).toString(),
					query.value(db_image).toString());
			m_locationsDataModel->insert(location);
			nRead++;
		}
		qDebug() << "Read " << nRead
				<< " records from the database, locations table";

	} else {
		//TODO: Handle this more gracefully
		qDebug() << "Error reading from database: " << query.lastError().text();
	}
}

//Read items from Database by location ID into datamodel
void ReportDB::readItemsByLocationID_ReportID(int locationID, int reportID) {
	if (!ReportDB::dbActive()) {
		qDebug("DB Not active!");
		return;
	}
	QSqlQuery query(m_database);
	QSqlQuery reportQuery(m_database);
	const QString sqlQuery =
			"SELECT id, locationID, name, value FROM Items Where locationID = :locationID ORDER BY name";
	const QString sqlReportQuery =
			"SELECT quantityID, durationID, monthID, durationValue, monthValue FROM ReportData Where reportID = :reportID and itemID = :itemID";
	query.prepare(sqlQuery);
	query.bindValue("locationID", locationID);
	reportQuery.prepare(sqlReportQuery);
	reportQuery.bindValue("reportID", reportID);
	//Save Report ID
	//TODO: Find a better way to do this!
	m_reportID = reportID;
	if (query.exec()) {

		const int db_id = query.record().indexOf("id");
		const int db_locationID = query.record().indexOf("locationID");
		const int db_name = query.record().indexOf("name");
		const int db_value = query.record().indexOf("value");

		int quantityID, durationID, monthID;
		float monthValue, durationValue;
		bool dbItemData;

		m_itemsDataModel->clear();

		int nRead = 0;
		while (query.next()) {
			//Get saved value, if exists
			dbItemData = false;
			quantityID = durationID = monthID = monthValue = durationValue = 0;
			reportQuery.bindValue("itemID", query.value(db_id).toInt());
			if (reportQuery.exec() && reportQuery.next()) {
				const int db_quantityID = reportQuery.record().indexOf(
						"quantityID");
				const int db_durationID = reportQuery.record().indexOf(
						"durationID");
				const int db_monthID = reportQuery.record().indexOf("monthID");
				const int db_durationValue = reportQuery.record().indexOf(
						"durationValue");
				const int db_monthValue = reportQuery.record().indexOf("monthValue");
				quantityID = reportQuery.value(db_quantityID).toInt();
				durationID = reportQuery.value(db_durationID).toInt();
				monthID = reportQuery.value(db_monthID).toInt();
				durationValue = reportQuery.value(db_durationValue).toFloat();
				monthValue = reportQuery.value(db_monthValue).toFloat();
				dbItemData = true;
			}
			Item *item = new Item(query.value(db_id).toInt(),
					query.value(db_locationID).toInt(),
					query.value(db_name).toString(),
					query.value(db_value).toFloat(), quantityID, durationID,
					monthID, durationValue, monthValue, dbItemData);

			bool res = connect(item, SIGNAL(itemUpdated(Item*)), this,
					SLOT(handleItemUpdated(Item*)));
			Q_ASSERT(res);

			// Since the variable is not used in the app, this is added to avoid a
			// compiler warning.
			Q_UNUSED(res);
			m_itemsDataModel->insert(item);
			nRead++;
		}
		qDebug() << "Read " << nRead << " records from the database";

	} else {
		//TODO: Handle this more gracefully
		qDebug() << "Error reading from database: " << query.lastError().text();
	}
}

//Get energy usage value for a location in a report
QString ReportDB::getEnergyUsageByLocationID_ReportID(int locationID, int reportID){
	//parseFloat(ListItemData.value * qty * hrs * 365 * months / 12 / 1000).toFixed(2) + "kWh"
	QString retString = "";
	float retval = 0;
	if (!ReportDB::dbActive()) {
		qDebug("DB Not active!");
		return "";
	}
	QSqlQuery query(m_database);
	//SUM(quantityID * durationID * monthID * value)
	//ListItemData.value * qty * hrs * 365 * months / 12 / 1000
	const QString sqlQuery =
			"SELECT SUM(ROUND(365.0 * durationValue * value * quantityID * monthValue / 12.0 / 1000.0, 2)) as energy FROM ReportData AS R "
					"JOIN Items AS I ON R.itemID = I.id "
					"WHERE locationID = :locationID AND reportID = :reportID";

	query.prepare(sqlQuery);
	query.bindValue("locationID", locationID);
	query.bindValue("reportID", reportID);

	if (query.exec()) {
		const int db_energy = query.record().indexOf("energy");
		if (query.next()) {
			retval = query.value(db_energy).toFloat();
			qDebug() << "Retval" << retval;
		}
		qDebug() << "Read record from the database";
		retString = QString("%1 kWh").arg(retval);
		return retString;

	} else {
		//TODO: Handle this more gracefully
		qDebug() << "Error reading from database: " << query.lastError().text();
		retString = QString("");
		return retString;
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

//Update ReportData
void ReportDB::updateItemValues(Item * newItem) {
	if (!ReportDB::dbActive()) {
		qDebug("DB Not active!");
		return;
	}
	if (newItem->dbItemData()) {
		qDebug() << "Item exists in database. Updating...";
		QSqlQuery query(m_database);
		const QString sqlCommand =
				"UPDATE ReportData SET quantityID = :quantityID, "
				"durationID = :durationID, durationValue = :durationValue, "
				"monthID = :monthID, monthValue = :monthValue "
				"WHERE reportID = :reportID and itemID = :itemID";
		query.prepare(sqlCommand);

		query.bindValue(":quantityID", newItem->quantityID());
		query.bindValue(":durationID", newItem->durationID());
		query.bindValue(":monthID", newItem->monthID());
		query.bindValue(":durationValue", newItem->durationValue());
		query.bindValue(":monthValue", newItem->monthValue());
		query.bindValue(":itemID", newItem->id());
		query.bindValue(":reportID", m_reportID);

		if (query.exec()) {
			//We *could* have duplicates at this point...update them all
			if (query.numRowsAffected() > 0) {
				qDebug() << "Report id=" << newItem->id() << " was updated.";
			} else {
				qDebug() << "Error updating Report id=" << newItem->id();
			}
		} else {
			qDebug() << "Error updating:" << query.lastError().text();
		}
	} else {
		qDebug() << "Item does not exist in database. Inserting...";
		QSqlQuery query(m_database);
		const QString sqlCommand =
				"INSERT INTO ReportData (reportID, itemID, quantityID, durationID, monthID, durationValue, monthValue)"
						"VALUES (:reportID, :itemID, :quantityID, :durationID, :monthID, :durationValue, :monthValue)";
		query.prepare(sqlCommand);

		//TODO: Make sure report ID is valid, it always *should be*, but you never know
		query.bindValue(":reportID", m_reportID);
		query.bindValue(":itemID", newItem->id());
		query.bindValue(":quantityID", newItem->quantityID());
		query.bindValue(":durationID", newItem->durationID());
		query.bindValue(":durationValue", newItem->durationValue());
		query.bindValue(":monthValue", newItem->monthValue());
		query.bindValue(":monthID", newItem->monthID());
		query.bindValue(":durationValue", newItem->durationValue());
		query.bindValue(":monthValue", newItem->monthValue());

		//TODO: Handle duplicates, should never happen but stranger things have happened
		if (query.exec()) {
			if (query.numRowsAffected() == 1) {
				qDebug() << "Report item was inserted.";
				//Store that we have a value in the database!
				newItem->setDbItemData(true);
			} else {
				qDebug() << "Error inserting new item";
			}
		} else {
			qDebug() << "Error updating:" << query.lastError().text();
		}
	}
}

//Retrieve Report DataModel
GroupDataModel* ReportDB::reportDataModel() const {
	return m_reportsDataModel;
}

//Retrieve Location DataModel
GroupDataModel* ReportDB::locationDataModel() const {
	return m_locationsDataModel;
}

//Retrieve Location DataModel
GroupDataModel* ReportDB::itemDataModel() const {
	return m_itemsDataModel;
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
void ReportDB::initReportDataModel() {
	m_reportsDataModel = new GroupDataModel(this);
	m_reportsDataModel->setSortingKeys(QStringList() << "name");
	m_reportsDataModel->setGrouping(ItemGrouping::None);
}

//Initiates the Location datamodel
void ReportDB::initLocationDataModel() {
	m_locationsDataModel = new GroupDataModel(this);
	m_locationsDataModel->setSortingKeys(QStringList() << "name");
	m_locationsDataModel->setGrouping(ItemGrouping::None);
	readLocations();
}

//Initiates the iTEM datamodel
void ReportDB::initItemDataModel() {
	m_itemsDataModel = new GroupDataModel(this);
	m_itemsDataModel->setSortingKeys(QStringList() << "name");
	m_itemsDataModel->setGrouping(ItemGrouping::None);
}

void ReportDB::handleItemUpdated(Item* newItem) {
	updateItemValues(newItem);
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
