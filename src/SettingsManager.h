/*!
 * COPYRIGHT (C) 2020 Emeric Grange - All Rights Reserved
 *
 * This file is part of MiniVideo.
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

#ifndef SETTINGS_MANAGER_H
#define SETTINGS_MANAGER_H
/* ************************************************************************** */

#include <QObject>
#include <QString>

/* ************************************************************************** */

/*!
 * \brief The SettingsManager class
 */
class SettingsManager: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool firstLaunch READ isFirstLaunch NOTIFY firstLaunchChanged)

    Q_PROPERTY(QString appTheme READ getAppTheme WRITE setAppTheme NOTIFY appThemeChanged)
    Q_PROPERTY(bool appThemeAuto READ getAppThemeAuto WRITE setAppThemeAuto NOTIFY appThemeAutoChanged)

    Q_PROPERTY(bool mediaNativeFilePicker READ getMediaNativeFilePicker WRITE setMediaNativeFilePicker NOTIFY mediaNativeFilePickerChanged)
    Q_PROPERTY(bool mediaFilter READ getMediaFilter WRITE setMediaFilter NOTIFY mediaFilterChanged)
    Q_PROPERTY(bool mediaPreview READ getMediaPreview WRITE setMediaPreview NOTIFY mediaPreviewChanged)
    Q_PROPERTY(bool exportEnabled READ getExportEnabled WRITE setExportEnabled NOTIFY exportEnabledChanged)
    Q_PROPERTY(int unitSystem READ getUnitSystem WRITE setUnitSystem NOTIFY unitSystemChanged)
    Q_PROPERTY(int unitSizes READ getUnitSizes WRITE setUnitSizes NOTIFY unitSizesChanged)

    bool m_firstlaunch = true;

    // Application generic
    QString m_appTheme = "light";
    bool m_appThemeAuto = false;

    // Application specific
    bool m_mediaNativeFilePicker = false;
    bool m_mediaFilter = true;
    bool m_mediaPreview = true;
    bool m_exportEnabled = false;
    int m_unitSystem = 0;                       //!< QLocale::MeasurementSystem
    int m_unitSizes = 0;                        //!< 0: KB, 1: KiB, 2: display both

    // Singleton
    static SettingsManager *instance;
    SettingsManager();
    ~SettingsManager();

    bool readSettings();
    bool writeSettings();

Q_SIGNALS:
    void firstLaunchChanged();
    void appThemeChanged();
    void appThemeAutoChanged();
    void mediaNativeFilePickerChanged();
    void mediaFilterChanged();
    void mediaPreviewChanged();
    void exportEnabledChanged();
    void unitSystemChanged();
    void unitSizesChanged();

public:
    static SettingsManager *getInstance();

    bool isFirstLaunch() const { return m_firstlaunch; }

    QString getAppTheme() const { return m_appTheme; }
    void setAppTheme(const QString &value);

    bool getAppThemeAuto() const { return m_appThemeAuto; }
    void setAppThemeAuto(const bool value);

    bool getMediaNativeFilePicker() const { return m_mediaNativeFilePicker; }
    void setMediaNativeFilePicker(const bool value);

    bool getMediaFilter() const { return m_mediaFilter; }
    void setMediaFilter(const bool value);

    bool getMediaPreview() const { return m_mediaPreview; }
    void setMediaPreview(const bool value);

    bool getExportEnabled() const { return m_exportEnabled; }
    void setExportEnabled(const bool value);

    int getUnitSystem() const { return m_unitSystem; }
    void setUnitSystem(const int value);

    int getUnitSizes() const { return m_unitSizes; }
    void setUnitSizes(const int value);

    // Utils
    Q_INVOKABLE void resetSettings();
};

/* ************************************************************************** */
#endif // SETTINGS_MANAGER_H
