/*
 * Item.cpp
 *
 *  Created on: Aug 18, 2013
 *      Author: Brent.Erickson
 */

#include "Item.hpp"

Item::Item(const int &id, const int &locationID, const QString &name,
		const float &value, const int &quantityID, const int &durationID,
		const int &monthID, const float &durationValue, const float &monthValue, const bool &dbItemData, QObject *parent) :
		QObject(parent), m_id(id), m_locationID(locationID), m_name(name), m_value(
				value), m_quantityID(quantityID), m_durationID(durationID), m_monthID(
				monthID), m_dbItemData(dbItemData), m_durationValue(durationValue), m_monthValue(monthValue) {
}

int Item::id() const {
	return m_id;
}

int Item::locationID() const {
	return m_locationID;
}

QString Item::name() const {
	return m_name;
}

float Item::value() const {
	return m_value;
}

int Item::quantityID() const {
	return m_quantityID;
}

void Item::setQuantityID(const int &newQuantityID) {
	if (newQuantityID != m_quantityID) {
		m_quantityID = newQuantityID;
		emit itemUpdated(this);
	}
}

bool Item::dbItemData() const {
	return m_dbItemData;
}

void Item::setDbItemData(const bool &newDbItemData) {
	m_dbItemData = newDbItemData;
}

int Item::durationID() const {
	return m_durationID;
}

void Item::setDurationID(const int &newdurationID) {
	if (newdurationID != m_durationID) {
		m_durationID = newdurationID;
		emit itemUpdated(this);
	}
}

int Item::monthID() const {
	return m_monthID;
}

void Item::setMonthID(const int &newMonthID) {
	if (newMonthID != m_monthID) {
		m_monthID = newMonthID;
		emit itemUpdated(this);
	}
}

float Item::durationValue() const {
	return m_durationValue;
}

void Item::setDurationValue(const float &newdurationValue) {
	if (newdurationValue != m_durationValue) {
		m_durationValue = newdurationValue;
		emit itemUpdated(this);
	}
}

float Item::monthValue() const {
	return m_monthValue;
}

void Item::setMonthValue(const float &newMonthValue) {
	if (newMonthValue != m_monthValue) {
		m_monthValue = newMonthValue;
		emit itemUpdated(this);
	}
}
