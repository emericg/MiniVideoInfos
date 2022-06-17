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
#include "utils_language.h"

#include <MobileUI>
#include <MobileSharing>

#include <QtGlobal>
#include <QTranslator>
#include <QLibraryInfo>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>

/* ************************************************************************** */

int main(int argc, char *argv[])
{
    SharingApplication app(argc, argv);

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    QIcon appIcon(":/assets/logos/logo.svg");
    app.setWindowIcon(appIcon);
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

    UtilsScreen *utilsScreen = UtilsScreen::getInstance(&app);
    if (!utilsScreen) return EXIT_FAILURE;

    UtilsLanguage *utilsLanguage = UtilsLanguage::getInstance();
    if (!utilsLanguage) return EXIT_FAILURE;

    // ThemeEngine
    qmlRegisterSingletonType(QUrl("qrc:/qml/ThemeEngine.qml"), "ThemeEngine", 1, 0, "Theme");

    MobileUI::registerQML();

    // Then we start the UI
    QQmlApplicationEngine engine;
    QQmlContext *engine_context = engine.rootContext();
    engine_context->setContextProperty("settingsManager", sm);
    engine_context->setContextProperty("mediaManager", mm);
    engine_context->setContextProperty("mediaUtils", mediaUtils);
    engine_context->setContextProperty("utilsApp", utilsApp);
    engine_context->setContextProperty("utilsScreen", utilsScreen);
    engine_context->setContextProperty("utilsLanguage", utilsLanguage);

    MiniVideoQML::registerQML();
    app.registerQML(engine_context);

    engine.load(QUrl(QStringLiteral("qrc:/qml/Application.qml")));
    if (engine.rootObjects().isEmpty()) return EXIT_FAILURE;

    // For i18n retranslate
    utilsLanguage->setQmlEngine(&engine);

    // QQuickWindow must be valid at this point
    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().value(0));
    engine_context->setContextProperty("quickWindow", window);

#if defined (Q_OS_ANDROID)
    QNativeInterface::QAndroidApplication::hideSplashScreen(333);
#endif

    return app.exec();
}

/* ************************************************************************** */
