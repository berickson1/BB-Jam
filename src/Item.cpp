/*
 * Item.cpp
 *
 *  Created on: Aug 18, 2013
 *      Author: Brent.Erickson
 */

#include "Item.hpp"

Item::Item(const QString &id, const QString &locationID, const QString &name, const QString &value, QObject *parent) :QObject(parent), m_id(id), m_locationID(locationID), m_name(name), m_value(value){
}

Item::Item(QObject *parent) :QObject(parent){
}

QString Item::id() const
{
	return m_id;
}

QString Item::locationID() const
{
	return m_locationID;
}

QString Item::name() const
{
	return m_name;
}

QString Item::value() const
{
	return m_value;
}
