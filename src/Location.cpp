/*
 * Location.cpp
 *
 *  Created on: Aug 18, 2013
 *      Author: Brent.Erickson
 */

#include "Location.hpp"

Location::Location(const QString &id, const QString &name, const QString &image, QObject *parent) :QObject(parent), m_id(id), m_name(name), m_image(image){
}

Location::Location(QObject *parent) :QObject(parent){
}

QString Location::id() const
{
	return m_id;
}

QString Location::name() const
{
	return m_name;
}

QString Location::image() const
{
	return m_image;
}
