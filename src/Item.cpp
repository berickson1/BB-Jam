/*
 * Item.cpp
 *
 *  Created on: Aug 18, 2013
 *      Author: Brent.Erickson
 */

#include "Item.hpp"

Item::Item(const int &id, const int &locationID, const QString &name,
		const int &value, const int &quantityID, const int &durationID,
		const int &monthID, QObject *parent) :
		QObject(parent), m_id(id), m_locationID(locationID), m_name(name), m_value(
				value), m_quantityID(quantityID), m_durationID(durationID), m_monthID(
				monthID) {
}

Item::Item(QObject *parent) :
		QObject(parent) {
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

int Item::value() const {
	return m_value;
}

int Item::quantityID() const {
	return m_quantityID;
}

void Item::setQuantityID(const int &newQuantityID) {
	if (newQuantityID != m_quantityID) {
		m_quantityID = newQuantityID;
		emit itemChanged(this);
	}
}

int Item::durationID() const {
	return m_durationID;
}

void Item::setDurationID(const int &newdurationID) {
	if (newdurationID != m_durationID) {
		m_durationID = newdurationID;
		emit itemChanged(this);
	}
}

int Item::monthID() const {
	return m_monthID;
}

void Item::setMonthID(const int &newMonthID) {
	if (newMonthID != m_monthID) {
		m_monthID = newMonthID;
		emit itemChanged(this);
	}
}
