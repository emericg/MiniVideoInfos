/*!
 * COPYRIGHT (C) 2020 Emeric Grange - All Rights Reserved
 *
 * This file is part of MiniVideoInfos.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \author    Emeric Grange <emeric.grange@gmail.com>
 * \date      2019
 */

#include "SettingsManager.h"

#include <QCoreApplication>
#include <QSettings>
#include <QLocale>
#include <QDebug>

/* ************************************************************************** */

SettingsManager *SettingsManager::instance = nullptr;

SettingsManager *SettingsManager::getInstance()
{
    if (instance == nullptr)
    {
        instance = new SettingsManager();
        return instance;
    }

    return instance;
}

SettingsManager::SettingsManager()
{
    readSettings();
}

SettingsManager::~SettingsManager()
{
    //
}

/* ************************************************************************** */
/* ************************************************************************** */

bool SettingsManager::readSettings()
{
    bool status = false;

    QSettings settings(QCoreApplication::organizationName(), QCoreApplication::applicationName());

    if (settings.status() == QSettings::NoError)
    {
        if (settings.contains("settings/appTheme"))
            m_appTheme = settings.value("settings/appTheme").toString();

        if (settings.contains("settings/appThemeAuto"))
            m_appThemeAuto = settings.value("settings/appThemeAuto").toBool();

        if (settings.contains("settings/mediaNativeFilePicker"))
            m_mediaNativeFilePicker = settings.value("settings/mediaNativeFilePicker").toBool();

        if (settings.contains("settings/mediaFilter"))
            m_mediaFilter = settings.value("settings/mediaFilter").toBool();

        if (settings.contains("settings/mediaPreview"))
            m_mediaPreview = settings.value("settings/mediaPreview").toBool();

        if (settings.contains("settings/exportEnabled"))
            m_exportEnabled = settings.value("settings/exportEnabled").toBool();

        if (settings.contains("settings/unitSystem"))
        {
            m_unitSystem = settings.value("settings/unitSystem").toInt();

            // Use this setting to check if the settings file exists
            m_firstlaunch = false;
        }
        else
        {
            // If we have no measurement system saved, use system's one
            QLocale lo;
            m_unitSystem = lo.measurementSystem();
        }

        if (settings.contains("settings/unitSizes"))
            m_unitSizes = settings.value("settings/unitSizes").toInt();

        status = true;
    }
    else
    {
        qWarning() << "SettingsManager::readSettings() error:" << settings.status();
    }

    if (m_firstlaunch)
    {
        // force settings file creation
        writeSettings();
    }

    return status;
}

bool SettingsManager::writeSettings()
{
    bool status = false;

    QSettings settings(QCoreApplication::organizationName(), QCoreApplication::applicationName());

    if (settings.isWritable())
    {
        settings.setValue("settings/appTheme", m_appTheme);
        settings.setValue("settings/appThemeAuto", m_appThemeAuto);
        settings.setValue("settings/mediaNativeFilePicker", m_mediaNativeFilePicker);
        settings.setValue("settings/mediaFilter", m_mediaFilter);
        settings.setValue("settings/mediaPreview", m_mediaPreview);
        settings.setValue("settings/exportEnabled", m_exportEnabled);
        settings.setValue("settings/unitSystem", m_unitSystem);
        settings.setValue("settings/unitSizes", m_unitSizes);

        if (settings.status() == QSettings::NoError)
        {
            status = true;
        }
        else
        {
            qWarning() << "SettingsManager::writeSettings() error:" << settings.status();
        }
    }
    else
    {
        qWarning() << "SettingsManager::writeSettings() error: read only file?";
    }

    return status;
}

/* ************************************************************************** */

void SettingsManager::resetSettings()
{
    m_appTheme = "light";
    Q_EMIT appThemeChanged();
    m_appThemeAuto = false;
    Q_EMIT appThemeAutoChanged();
    m_mediaFilter = true;
    Q_EMIT mediaFilterChanged();
    m_mediaPreview = true;
    Q_EMIT mediaPreviewChanged();
    m_exportEnabled = false;
    Q_EMIT exportEnabledChanged();

    QLocale lo;
    m_unitSystem = lo.measurementSystem();
    Q_EMIT unitSystemChanged();
    m_unitSizes = 0;
    Q_EMIT unitSizesChanged();
}

/* ************************************************************************** */
/* ************************************************************************** */

void SettingsManager::setAppTheme(const QString &value)
{
    if (m_appTheme != value)
    {
        m_appTheme = value;
        writeSettings();
        Q_EMIT appThemeChanged();
    }
}

void SettingsManager::setAppThemeAuto(const bool value)
{
    if (m_appThemeAuto != value)
    {
        m_appThemeAuto = value;
        writeSettings();
        Q_EMIT appThemeAutoChanged();
    }
}

void SettingsManager::setMediaNativeFilePicker(const bool value)
{
    if (m_mediaNativeFilePicker != value)
    {
        m_mediaNativeFilePicker = value;
        writeSettings();
        Q_EMIT mediaNativeFilePickerChanged();
    }
}

void SettingsManager::setMediaFilter(const bool value)
{
    if (m_mediaFilter != value)
    {
        m_mediaFilter = value;
        writeSettings();
        Q_EMIT mediaFilterChanged();
    }
}

void SettingsManager::setMediaPreview(const bool value)
{
    if (m_mediaPreview != value)
    {
        m_mediaPreview = value;
        writeSettings();
        Q_EMIT mediaPreviewChanged();
    }
}

void SettingsManager::setExportEnabled(const bool value)
{
    if (m_exportEnabled != value)
    {
        m_exportEnabled = value;
        writeSettings();
        Q_EMIT exportEnabledChanged();
    }
}

void SettingsManager::setUnitSystem(const int value)
{
    if (m_unitSystem != value)
    {
        m_unitSystem = value;
        writeSettings();
        Q_EMIT unitSystemChanged();
    }
}

void SettingsManager::setUnitSizes(const int value)
{
    if (m_unitSizes != value)
    {
        m_unitSizes = value;
        writeSettings();
        Q_EMIT unitSizesChanged();
    }
}

/* ************************************************************************** */
