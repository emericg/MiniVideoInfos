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

#include "minivideo_qml.h"
#include "utils_app.h"
#include "utils_screen.h"

#include "settingsmanager.h"
#include "mediasmanager.h"

#include <statusbar.h>

#include <QtGlobal>
#include <QTranslator>
#include <QLibraryInfo>
#include <QApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>

/* ************************************************************************** */

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    //QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);

    QApplication app(argc, argv);

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    QIcon appIcon(":/assets/logos/logo.svg");
    app.setWindowIcon(appIcon);
#endif

    // Application name
    app.setApplicationName("MiniVideo Infos");
    app.setApplicationDisplayName("MiniVideo Infos");
    app.setOrganizationName("MiniVideo");
    app.setOrganizationDomain("MiniVideo");

    // Keep the StatusBar the same color as the splashscreen until UI starts
    StatusBar sb;
    sb.setColor("#fff");
    qmlRegisterType<StatusBar>("StatusBar", 0, 1, "StatusBar");
/*
    // i18n
    QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);

    QTranslator appTranslator;
    appTranslator.load(":/i18n/mvi.qm");
    app.installTranslator(&appTranslator);
*/
    // Init MiniVideoInfos components
    UtilsApp *utilsApp = UtilsApp::getInstance();
    if (!utilsApp) return EXIT_FAILURE;

    UtilsScreen *utilsScreen = new UtilsScreen();
    if (!utilsScreen) return EXIT_FAILURE;

    SettingsManager *sm = SettingsManager::getInstance();
    if (!sm) return EXIT_FAILURE;

    MediasManager *mm = new MediasManager();
    if (!mm) return EXIT_FAILURE;

    MiniVideoQML::declareQML();

    qmlRegisterSingletonType(QUrl("qrc:/qml/ThemeEngine.qml"),
                             "ThemeEngine", 1, 0, "Theme");

    // Then we start the UI
    QQmlApplicationEngine engine;
    QQmlContext *engine_context = engine.rootContext();
    engine_context->setContextProperty("settingsManager", sm);
    engine_context->setContextProperty("mediasManager", mm);
    engine_context->setContextProperty("utilsApp", utilsApp);
    engine_context->setContextProperty("utilsScreen", utilsScreen);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Application.qml")));
    if (engine.rootObjects().isEmpty())
        return EXIT_FAILURE;

    // QQuickWindow must be valid at this point
    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().value(0));
    engine_context->setContextProperty("quickWindow", window);

    return app.exec();
}

/* ************************************************************************** */
