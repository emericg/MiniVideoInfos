/*
 * Copyright (c) 2016 J-P Nurmi
 * Copyright (c) 2020 Emeric Grange
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "MobileUI_private.h"

#include <UIKit/UIKit.h>
#include <QGuiApplication>

#include <QScreen>
#include <QTimer>

/* ************************************************************************** */

@interface QIOSViewController : UIViewController
@property (nonatomic, assign) BOOL prefersStatusBarHidden;
@property (nonatomic, assign) UIStatusBarAnimation preferredStatusBarUpdateAnimation;
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;
@end

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static UIStatusBarStyle statusBarStyle(MobileUI::Theme theme)
{
    if (theme == MobileUI::Dark)
        return UIStatusBarStyleLightContent;
    else if (@available(iOS 13.0, *))
        return UIStatusBarStyleDarkContent;
    else
        return UIStatusBarStyleDefault;
}

static void setPreferredStatusBarStyle(UIWindow *window, UIStatusBarStyle style)
{
    QIOSViewController *viewController = static_cast<QIOSViewController *>([window rootViewController]);
    if (!viewController || viewController.preferredStatusBarStyle == style)
        return;

    viewController.preferredStatusBarStyle = style;
    [viewController setNeedsStatusBarAppearanceUpdate];
}

void togglePreferredStatusBarStyle()
{
    UIStatusBarStyle style = statusBarStyle(MobileUI::Light);
    if(MobileUIPrivate::statusbarTheme == MobileUI::Light) {
        style = statusBarStyle(MobileUI::Dark);
    }
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (keyWindow)
        setPreferredStatusBarStyle(keyWindow, style);
    QTimer::singleShot(200, []() {
        UIStatusBarStyle style = statusBarStyle(MobileUIPrivate::statusbarTheme);
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if (keyWindow)
            setPreferredStatusBarStyle(keyWindow, style);
    });
}

static void updatePreferredStatusBarStyle()
{
    UIStatusBarStyle style = statusBarStyle(MobileUIPrivate::statusbarTheme);
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (keyWindow)
        setPreferredStatusBarStyle(keyWindow, style);
}

/* ************************************************************************** */

bool MobileUIPrivate::isAvailable_sys()
{
    return true;
}

void MobileUIPrivate::setColor_statusbar(const QColor &color)
{
    Q_UNUSED(color)
}

void MobileUIPrivate::setTheme_statusbar(MobileUI::Theme)
{
    updatePreferredStatusBarStyle();

    QObject::connect(qApp, &QGuiApplication::applicationStateChanged, qApp, [](Qt::ApplicationState state) {
        if (state == Qt::ApplicationActive)
            updatePreferredStatusBarStyle();
    }, Qt::UniqueConnection);

    QScreen *screen = qApp->primaryScreen();
    screen->setOrientationUpdateMask(Qt::PortraitOrientation | Qt::LandscapeOrientation | Qt::InvertedPortraitOrientation | Qt::InvertedLandscapeOrientation);
    QObject::connect(screen, &QScreen::orientationChanged, qApp, [](Qt::ScreenOrientation) { togglePreferredStatusBarStyle(); }, Qt::UniqueConnection);
}

void MobileUIPrivate::setColor_navbar(const QColor &color)
{
    Q_UNUSED(color)
}

void MobileUIPrivate::setTheme_navbar(MobileUI::Theme theme)
{
    Q_UNUSED(theme)
}

/* ************************************************************************** */
