/*!
 * This file is part of MiniVideoInfos.
 * COPYRIGHT (C) 2019 Emeric Grange - All Rights Reserved
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
#include <QApplication>
#include <QQuickWindow>

/* ************************************************************************** */

/*!
 * \brief The SettingsManager class
 */
class SettingsManager: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool firstLaunch READ isFirstLaunch NOTIFY firstLaunchChanged)

    Q_PROPERTY(QString appTheme READ getAppTheme WRITE setAppTheme NOTIFY appthemeChanged)
    Q_PROPERTY(bool autoDark READ getAutoDark WRITE setAutoDark NOTIFY autodarkChanged)

    Q_PROPERTY(bool mediaFilter READ getMediaFilter WRITE setMediaFilter NOTIFY mediaFilterChanged)
    Q_PROPERTY(bool mediaPreview READ getMediaPreview WRITE setMediaPreview NOTIFY mediaPreviewChanged)
    Q_PROPERTY(bool exportEnabled READ getExportEnabled WRITE setExportEnabled NOTIFY exportEnabledChanged)

    Q_PROPERTY(int unitSystem READ getUnitSystem WRITE setUnitSystem NOTIFY unitSystemChanged)
    Q_PROPERTY(int unitSizes READ getUnitSizes WRITE setUnitSizes NOTIFY unitSizesChanged)

    bool m_firstlaunch = true;

    QString m_appTheme = "light";
    bool m_autoDark = false;
    bool m_mediaFilter = true;
    bool m_mediaPreview = true;
    bool m_exportEnabled = false;
    int m_unitSystem = 0;   //!< 0: Metric, 1: ImperialUSSystem, 2: ImperialUKSystem // Or use QLocal::MeasurementSystem
    int m_unitSizes = 0;    //!< 0: KB, 1: KiB, 2: display both

    bool readSettings();
    bool writeSettings();

    static SettingsManager *instance;

    SettingsManager();
    ~SettingsManager();

Q_SIGNALS:
    void firstLaunchChanged();
    void appthemeChanged();
    void autodarkChanged();
    void mediaFilterChanged();
    void mediaPreviewChanged();
    void exportEnabledChanged();
    void unitSystemChanged();
    void unitSizesChanged();

public:
    static SettingsManager *getInstance();

    void resetSettings();

    bool isFirstLaunch() const { return m_firstlaunch; }

    QString getAppTheme() const { return m_appTheme; }
    void setAppTheme(const QString &value);

    bool getAutoDark() const { return m_autoDark; }
    void setAutoDark(const bool value);

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
};

/* ************************************************************************** */
#endif // SETTINGS_MANAGER_H
