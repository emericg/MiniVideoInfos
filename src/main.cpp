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
#include "MediaManager.h"
#include "MediaUtils.h"

#include "minivideo_qml.h"
#include "utils_app.h"
#include "utils_screen.h"
#include "utils_sysinfo.h"
#include "utils_language.h"

#include <MobileUI/MobileUI.h>
#include <MobileSharing/MobileSharing.h>

#include <QtGlobal>
#include <QTranslator>
#include <QLibraryInfo>
#include <QIcon>
#include <QFile>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>

/* ************************************************************************** */

int main(int argc, char *argv[])
{
    // Arguments parsing ///////////////////////////////////////////////////////

    bool cli_enabled = false;
    bool cli_details_enabled = false;

    QStringList files;

    for (int i = 1; i < argc; i++)
    {
        if (argv[i])
        {
            //std::cout << "> " << argv[i] << std::endl;

            if (QString::fromUtf8(argv[i]) == "--cli")
                cli_enabled = true;
            else if (QString::fromUtf8(argv[i]) == "--details")
                cli_details_enabled = true;
            else
            {
                QString fileAsArgument = QFile::decodeName(argv[i]);
                if (QFile::exists(fileAsArgument))
                    files << fileAsArgument;
            }
        }
    }

    // TODO

    // Hacks ///////////////////////////////////////////////////////////////////

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    // NVIDIA driver suspend&resume hack
    auto format = QSurfaceFormat::defaultFormat();
    format.setOption(QSurfaceFormat::ResetNotification);
    QSurfaceFormat::setDefaultFormat(format);
#endif

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    // Qt 6.6+ mouse wheel hack
    qputenv("QT_QUICK_FLICKABLE_WHEEL_DECELERATION", "2500");
#endif

    // GUI application /////////////////////////////////////////////////////////

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    SharingApplication app(argc, argv);
#else
    QApplication app(argc, argv);

    QIcon appIcon(":/assets/gfx/logos/logo.svg");
    app.setWindowIcon(appIcon);

    //MenubarManager *mb = MenubarManager::getInstance();
#endif

    // Application name
    app.setApplicationName("MiniVideo Infos");
    app.setApplicationDisplayName("MiniVideo Infos");
    app.setOrganizationName("MiniVideo");
    app.setOrganizationDomain("MiniVideo");

    // Init MiniVideoInfos components
    SettingsManager *sm = SettingsManager::getInstance();
    if (!sm) return EXIT_FAILURE;

    MediaManager *mm = new MediaManager();
    if (!mm) return EXIT_FAILURE;

    MediaUtils *mediaUtils = new MediaUtils();
    if (!mediaUtils) return EXIT_FAILURE;

    // Init MiniVideoInfos utils
    UtilsApp *utilsApp = UtilsApp::getInstance();
    if (!utilsApp) return EXIT_FAILURE;

    UtilsScreen *utilsScreen = UtilsScreen::getInstance();
    if (!utilsScreen) return EXIT_FAILURE;

    UtilsLanguage *utilsLanguage = UtilsLanguage::getInstance();
    if (!utilsLanguage) return EXIT_FAILURE;

    // ThemeEngine
    qmlRegisterSingletonType(QUrl("qrc:/qml/ThemeEngine.qml"), "ThemeEngine", 1, 0, "Theme");

    MiniVideoQML::registerQML();

    // Then we start the UI
    QQmlApplicationEngine engine;
    QQmlContext *engine_context = engine.rootContext();

    engine_context->setContextProperty("settingsManager", sm);
    engine_context->setContextProperty("mediaManager", mm);
    engine_context->setContextProperty("mediaUtils", mediaUtils);
    engine_context->setContextProperty("utilsApp", utilsApp);
    engine_context->setContextProperty("utilsScreen", utilsScreen);
    engine_context->setContextProperty("utilsLanguage", utilsLanguage);

#if defined(Q_OS_ANDROID) || defined(Q_OS_IOS)
    MobileUI::registerQML();
    app.registerQML(engine_context);
    engine.load(QUrl(QStringLiteral("qrc:/qml/MobileApplication.qml")));
#else
    UtilsSysInfo *utilsSysInfo = UtilsSysInfo::getInstance();
    if (!utilsSysInfo) return EXIT_FAILURE;
    engine_context->setContextProperty("utilsSysInfo", utilsSysInfo);

    //engine_context->setContextProperty("menubarManager", mb);
    engine.load(QUrl(QStringLiteral("qrc:/qml/DesktopApplication.qml")));
#endif

    if (engine.rootObjects().isEmpty())
    {
        qWarning() << "Cannot init QmlApplicationEngine!";
        return EXIT_FAILURE;
    }

    // For i18n retranslate
    utilsLanguage->setQmlEngine(&engine);

#if defined(Q_OS_ANDROID)
    QNativeInterface::QAndroidApplication::hideSplashScreen(333);
#endif

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    // QQuickWindow must be valid at this point
    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().value(0));
    utilsApp->setQuickWindow(window); // to get additional infos
    //mb->setupMenubar(window);
#endif

    return app.exec();
}

/* ************************************************************************** */
