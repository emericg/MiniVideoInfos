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

void SettingsManager::reloadSettings()
{
    readSettings();
}

bool SettingsManager::readSettings()
{
    bool status = false;

    QSettings settings(QCoreApplication::organizationName(), QCoreApplication::applicationName());

    if (settings.status() == QSettings::NoError)
    {
#if defined(Q_OS_LINUX) || defined(Q_OS_MACOS) || defined(Q_OS_WINDOWS)
        if (settings.contains("ApplicationWindow/x"))
            m_appPosition.setWidth(settings.value("ApplicationWindow/x").toInt());
        if (settings.contains("ApplicationWindow/y"))
            m_appPosition.setHeight(settings.value("ApplicationWindow/y").toInt());
        if (settings.contains("ApplicationWindow/width"))
            m_appSize.setWidth(settings.value("ApplicationWindow/width").toInt());
        if (settings.contains("ApplicationWindow/height"))
            m_appSize.setHeight(settings.value("ApplicationWindow/height").toInt());
        if (settings.contains("ApplicationWindow/visibility"))
            m_appVisibility = settings.value("ApplicationWindow/visibility").toUInt();

        if (m_appPosition.width() > 8192) m_appPosition.setWidth(100);
        if (m_appPosition.height() > 8192) m_appPosition.setHeight(100);
        if (m_appSize.width() > 8192) m_appSize.setWidth(1920);
        if (m_appSize.height() > 8192) m_appSize.setHeight(1080);
        if (m_appVisibility < 1 || m_appVisibility > 5) m_appVisibility = 1;
#endif

        ////

        if (settings.contains("settings/appTheme"))
            m_appTheme = settings.value("settings/appTheme").toString();

        if (settings.contains("settings/appThemeAuto"))
            m_appThemeAuto = settings.value("settings/appThemeAuto").toBool();

        if (settings.contains("settings/appSplashScreen"))
            m_appSplashScreen = settings.value("settings/appSplashScreen").toBool();

        if (settings.contains("settings/appLanguage"))
            m_appLanguage = settings.value("settings/appLanguage").toString();

        if (settings.contains("settings/appUnits"))
            m_appUnits = settings.value("settings/appUnits").toInt();
        else
        {
            // Use this setting to check if the settings file exists
            m_firstlaunch = true;

            // If we have no measurement system saved, use system's one
            QLocale lo;
            m_appUnits = lo.measurementSystem();
        }

        ////

        if (settings.contains("settings/mediaNativeFilePicker"))
            m_mediaNativeFilePicker = settings.value("settings/mediaNativeFilePicker").toBool();

        if (settings.contains("settings/mediaFilter"))
            m_mediaFilter = settings.value("settings/mediaFilter").toBool();

        if (settings.contains("settings/mediaPreview"))
            m_mediaPreview = settings.value("settings/mediaPreview").toBool();

        if (settings.contains("settings/exportEnabled"))
            m_exportEnabled = settings.value("settings/exportEnabled").toBool();

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

/* ************************************************************************** */

bool SettingsManager::writeSettings()
{
    bool status = false;

    QSettings settings(QCoreApplication::organizationName(), QCoreApplication::applicationName());

    if (settings.isWritable())
    {
        settings.setValue("settings/appTheme", m_appTheme);
        settings.setValue("settings/appThemeAuto", m_appThemeAuto);
        settings.setValue("settings/appSplashScreen", m_appSplashScreen);
        settings.setValue("settings/appLanguage", m_appLanguage);
        settings.setValue("settings/appUnits", m_appUnits);

        settings.setValue("settings/mediaNativeFilePicker", m_mediaNativeFilePicker);
        settings.setValue("settings/mediaFilter", m_mediaFilter);
        settings.setValue("settings/mediaPreview", m_mediaPreview);
        settings.setValue("settings/exportEnabled", m_exportEnabled);
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
    m_appTheme = "THEME_DESKTOP_LIGHT";
    Q_EMIT appThemeChanged();
    m_appThemeAuto = false;
    Q_EMIT appThemeAutoChanged();
    m_appThemeCSD = false;
    Q_EMIT appThemeCSDChanged();
    m_appSplashScreen = true;
    Q_EMIT appSplashScreenChanged();
    m_appUnits = QLocale().measurementSystem();
    Q_EMIT appUnitsChanged();
    m_appLanguage = "auto";
    Q_EMIT appLanguageChanged();

    m_mediaFilter = true;
    Q_EMIT mediaFilterChanged();
    m_mediaPreview = true;
    Q_EMIT mediaPreviewChanged();
    m_exportEnabled = false;
    Q_EMIT exportEnabledChanged();
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

void SettingsManager::setAppThemeCSD(const bool value)
{
    if (m_appThemeCSD != value)
    {
        m_appThemeCSD = value;
        writeSettings();
        Q_EMIT appThemeCSDChanged();
    }
}

void SettingsManager::setAppSplashScreen(const bool value)
{
    if (m_appSplashScreen != value)
    {
        m_appSplashScreen = value;
        writeSettings();
        Q_EMIT appSplashScreenChanged();
    }
}

void SettingsManager::setAppUnits(int value)
{
    if (m_appUnits != value)
    {
        m_appUnits = value;
        writeSettings();
        Q_EMIT appUnitsChanged();
    }
}

void SettingsManager::setAppLanguage(const QString &value)
{
    if (m_appLanguage != value)
    {
        m_appLanguage = value;
        writeSettings();
        Q_EMIT appLanguageChanged();
    }
}

/* ************************************************************************** */

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
