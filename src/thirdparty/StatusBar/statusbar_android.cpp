/*
 * Copyright (c) 2016 J-P Nurmi
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

#include "statusbar_p.h"

#include <QtAndroid>

// WindowManager.LayoutParams
#define FLAG_TRANSLUCENT_STATUS             0x04000000
#define FLAG_TRANSLUCENT_NAVIGATION         0x08000000
#define FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS   0x80000000

// View
#define SYSTEM_UI_FLAG_LAYOUT_STABLE            0x00000100
#define SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION   0x00000200
#define SYSTEM_UI_FLAG_LIGHT_STATUS_BAR         0x00002000
#define SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR     0x00000010

static bool isColorLight(int color) {
    int r = (color & 0x00FF0000) >> 16;
    int g = (color & 0x0000FF00) >> 8;
    int b = (color & 0x000000FF);

    double darkness = 1.0 - (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
    return darkness < 0.2;
}

static bool isQColorLight(QColor color) {
    double darkness = 1.0 - (0.299 * color.red() + 0.587 * color.green() + 0.114 * color.blue()) / 255.0;
    return darkness < 0.2;
}

static QAndroidJniObject getAndroidWindow()
{
    QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
    window.callMethod<void>("addFlags", "(I)V", FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
    window.callMethod<void>("clearFlags", "(I)V", FLAG_TRANSLUCENT_STATUS);
    return window;
}

bool StatusBarPrivate::isAvailable_sys()
{
    return QtAndroid::androidSdkVersion() >= 21;
}

void StatusBarPrivate::setColor_sb(const QColor &color)
{
    if (QtAndroid::androidSdkVersion() < 21)
        return;

    QtAndroid::runOnAndroidThread([=]() {
        QAndroidJniObject window = getAndroidWindow();
        window.callMethod<void>("setStatusBarColor", "(I)V", color.rgba());
    });

    if (QtAndroid::androidSdkVersion() < 23)
        return;

    QtAndroid::runOnAndroidThread([=]() {
        QAndroidJniObject window = getAndroidWindow();
        QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        int visibility = view.callMethod<int>("getSystemUiVisibility", "()I");
        if (isQColorLight(color))
            visibility |= SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        else
            visibility &= ~SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        view.callMethod<void>("setSystemUiVisibility", "(I)V", visibility);
    });
}

void StatusBarPrivate::setTheme_sb(StatusBar::Theme theme)
{
    if (QtAndroid::androidSdkVersion() < 23)
        return;

    QtAndroid::runOnAndroidThread([=]() {
        QAndroidJniObject window = getAndroidWindow();
        QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        int visibility = view.callMethod<int>("getSystemUiVisibility", "()I");
        if (theme == StatusBar::Theme::Light)
            visibility |= SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        else
            visibility &= ~SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
        view.callMethod<void>("setSystemUiVisibility", "(I)V", visibility);
    });
}

void StatusBarPrivate::setColor_nav(const QColor &color)
{
    if (QtAndroid::androidSdkVersion() < 21)
        return;

    QtAndroid::runOnAndroidThread([=]() {
        QAndroidJniObject window = getAndroidWindow();
        window.callMethod<void>("setNavigationBarColor", "(I)V", color.rgba());
    });

    if (QtAndroid::androidSdkVersion() < 23)
        return;

    QtAndroid::runOnAndroidThread([=]() {
        QAndroidJniObject window = getAndroidWindow();
        QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        int visibility = view.callMethod<int>("getSystemUiVisibility", "()I");
        if (isQColorLight(color))
            visibility |= SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
        else
            visibility &= ~SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
        view.callMethod<void>("setSystemUiVisibility", "(I)V", visibility);
    });
}

void StatusBarPrivate::setTheme_nav(StatusBar::Theme theme)
{
    if (QtAndroid::androidSdkVersion() < 23)
        return;

    QtAndroid::runOnAndroidThread([=]() {
        QAndroidJniObject window = getAndroidWindow();
        QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        int visibility = view.callMethod<int>("getSystemUiVisibility", "()I");
        if (theme == StatusBar::Theme::Light)
            visibility |= SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
        else
            visibility &= ~SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR;
        view.callMethod<void>("setSystemUiVisibility", "(I)V", visibility);
    });
}

