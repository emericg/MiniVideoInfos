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
#include <QLocale>
#include <QString>
#include <QSize>

/* ************************************************************************** */

/*!
 * \brief The SettingsManager class
 */
class SettingsManager: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool firstLaunch READ isFirstLaunch NOTIFY firstLaunchChanged)

    Q_PROPERTY(QSize initialSize READ getInitialSize NOTIFY initialSizeChanged)
    Q_PROPERTY(QSize initialPosition READ getInitialPosition NOTIFY initialSizeChanged)
    Q_PROPERTY(int initialVisibility READ getInitialVisibility NOTIFY initialSizeChanged)

    Q_PROPERTY(QString appTheme READ getAppTheme WRITE setAppTheme NOTIFY appThemeChanged)
    Q_PROPERTY(bool appThemeAuto READ getAppThemeAuto WRITE setAppThemeAuto NOTIFY appThemeAutoChanged)
    Q_PROPERTY(bool appThemeCSD READ getAppThemeCSD WRITE setAppThemeCSD NOTIFY appThemeCSDChanged)
    Q_PROPERTY(bool appSplashScreen READ getAppSplashScreen WRITE setAppSplashScreen NOTIFY appSplashScreenChanged)
    Q_PROPERTY(int appUnits READ getAppUnits WRITE setAppUnits NOTIFY appUnitsChanged)
    Q_PROPERTY(QString appLanguage READ getAppLanguage WRITE setAppLanguage NOTIFY appLanguageChanged)

    Q_PROPERTY(bool mediaNativeFilePicker READ getMediaNativeFilePicker WRITE setMediaNativeFilePicker NOTIFY mediaNativeFilePickerChanged)
    Q_PROPERTY(bool mediaFilter READ getMediaFilter WRITE setMediaFilter NOTIFY mediaFilterChanged)
    Q_PROPERTY(bool mediaPreview READ getMediaPreview WRITE setMediaPreview NOTIFY mediaPreviewChanged)
    Q_PROPERTY(bool exportEnabled READ getExportEnabled WRITE setExportEnabled NOTIFY exportEnabledChanged)
    Q_PROPERTY(int unitSizes READ getUnitSizes WRITE setUnitSizes NOTIFY unitSizesChanged)

    bool m_firstlaunch = false;

    // Application window
    QSize m_appSize;
    QSize m_appPosition;
    int m_appVisibility = 1;                        //!< QWindow::Visibility

    // Application generic
    QString m_appTheme = "THEME_DESKTOP_LIGHT";
    bool m_appThemeAuto = false;
    bool m_appThemeCSD = false;
    bool m_appSplashScreen = true;
    int m_appUnits = QLocale::MetricSystem;         //!< QLocale::MeasurementSystem
    QString m_appLanguage = "auto";

    // Application specific
    bool m_mediaNativeFilePicker = false;
    bool m_mediaFilter = true;
    bool m_mediaPreview = true;
    bool m_exportEnabled = false;
    int m_unitSizes = 0;                        //!< 0: KB, 1: KiB, 2: display both

    // Singleton
    static SettingsManager *instance;
    SettingsManager();
    ~SettingsManager();

    bool readSettings();
    bool writeSettings();

Q_SIGNALS:
    void firstLaunchChanged();
    void initialSizeChanged();
    void appThemeChanged();
    void appThemeAutoChanged();
    void appThemeCSDChanged();
    void appSplashScreenChanged();
    void appUnitsChanged();
    void appLanguageChanged();

    void mediaNativeFilePickerChanged();
    void mediaFilterChanged();
    void mediaPreviewChanged();
    void exportEnabledChanged();
    void unitSystemChanged();
    void unitSizesChanged();

public:
    static SettingsManager *getInstance();

    bool isFirstLaunch() const { return m_firstlaunch; }

    QSize getInitialSize() { return m_appSize; }
    QSize getInitialPosition() { return m_appPosition; }
    int getInitialVisibility() { return m_appVisibility; }

    ////

    QString getAppTheme() const { return m_appTheme; }
    void setAppTheme(const QString &value);

    bool getAppThemeAuto() const { return m_appThemeAuto; }
    void setAppThemeAuto(const bool value);

    bool getAppThemeCSD() const { return m_appThemeCSD; }
    void setAppThemeCSD(const bool value);

    bool getAppSplashScreen() const { return m_appSplashScreen; }
    void setAppSplashScreen(const bool value);

    int getAppUnits() const { return m_appUnits; }
    void setAppUnits(int value);

    QString getAppLanguage() const { return m_appLanguage; }
    void setAppLanguage(const QString &value);

    ////

    bool getMediaNativeFilePicker() const { return m_mediaNativeFilePicker; }
    void setMediaNativeFilePicker(const bool value);

    bool getMediaFilter() const { return m_mediaFilter; }
    void setMediaFilter(const bool value);

    bool getMediaPreview() const { return m_mediaPreview; }
    void setMediaPreview(const bool value);

    bool getExportEnabled() const { return m_exportEnabled; }
    void setExportEnabled(const bool value);

    int getUnitSizes() const { return m_unitSizes; }
    void setUnitSizes(const int value);

    ////

    Q_INVOKABLE void reloadSettings();
    Q_INVOKABLE void resetSettings();
};

/* ************************************************************************** */
#endif // SETTINGS_MANAGER_H
