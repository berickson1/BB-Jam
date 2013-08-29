/*
 * Report.cpp
 *
 *  Created on: Aug 9, 2013
 *      Author: Brent.Erickson
 */

#include "Report.hpp"

Report::Report(const int &id, const QString &name, QObject *parent) :QObject(parent), m_id(id), m_name(name){
}

int Report::id() const
{
	return m_id;
}

QString Report::name() const
{
	return m_name;
}
void Report::setName(const QString &newName){
	if (newName != m_name){
		m_name = newName;
		emit nameChanged(newName);
	}
}
