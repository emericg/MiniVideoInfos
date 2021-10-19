TARGET  = MiniVideoInfos

VERSION = 0.8
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

CONFIG += c++11
QT     += core qml quickcontrols2 svg widgets charts location
android { QT += androidextras }
ios { QT += gui-private }

# Validate Qt version
!versionAtLeast(QT_VERSION, 5.12) : error("You need at least Qt version 5.12 for $${TARGET}")
!versionAtMost(QT_VERSION, 6.0) : error("You can't use Qt 6.0+ for $${TARGET}")

# Project features #############################################################

# Use Qt Quick compiler
ios | android { CONFIG += qtquickcompiler }

# Use contribs (otherwise use system libs)
ios | android { DEFINES += USE_CONTRIBS }

win32 { DEFINES += _USE_MATH_DEFINES }

# MobileUI and MobileSharing for mobile OS
include(src/thirdparty/MobileUI/MobileUI.pri)
include(src/thirdparty/MobileSharing/MobileSharing.pri)

DEFINES += ENABLE_MINIVIDEO
DEFINES += ENABLE_TAGLIB
DEFINES += ENABLE_LIBEXIF
#DEFINES += ENABLE_EXIV2

# EGM96 altitude correction
include(src/thirdparty/EGM96/EGM96.pri)

# Project files ################################################################

SOURCES  += src/main.cpp \
            src/Media.cpp \
            src/MediaManager.cpp \
            src/SettingsManager.cpp \
            src/minivideo_track_qml.cpp \
            src/minivideo_textexport_qt.cpp \
            src/minivideo_utils_qt.cpp \
            src/utils/utils_app.cpp \
            src/utils/utils_screen.cpp \
            src/utils/utils_android.cpp \
            src/utils/utils_ios.cpp

HEADERS  += src/Media.h \
            src/MediaUtils.h \
            src/MediaManager.h \
            src/SettingsManager.h \
            src/minivideo_qml.h \
            src/minivideo_track_qml.h \
            src/minivideo_textexport_qt.h \
            src/minivideo_utils_qt.h \
            src/utils/utils_app.h \
            src/utils/utils_screen.h \
            src/utils/utils_android.h \
            src/utils/utils_ios.h

RESOURCES   += qml/qml.qrc \
               i18n/i18n.qrc \
               assets/assets.qrc

OTHER_FILES += .gitignore \
               .travis.yml \
               contribs/contribs.py

#TRANSLATIONS = i18n/xx_fr.ts

lupdate_only { SOURCES += qml/*.qml qml/*.js qml/components/*.qml }

# Dependencies #################################################################

contains(DEFINES, USE_CONTRIBS) {

    ARCH = "x86_64"
    linux { PLATFORM = "linux" }
    macx { PLATFORM = "macOS" }
    win32 { PLATFORM = "windows" }

    android { # ANDROID_TARGET_ARCH available: x86 x86_64 armeabi-v7a arm64-v8a
        PLATFORM = "android"
        equals(ANDROID_TARGET_ARCH, "x86") { ARCH = "x86" }
        equals(ANDROID_TARGET_ARCH, "x86_64") { ARCH = "x86_64" }
        equals(ANDROID_TARGET_ARCH, "armeabi-v7a") { ARCH = "armv7" }
        equals(ANDROID_TARGET_ARCH, "arm64-v8a") { ARCH = "armv8" }
    }
    ios { # QMAKE_APPLE_DEVICE_ARCHS available: armv7 arm64
        PLATFORM = "iOS"
        ARCH = "armv8" # can be simulator, armv7 and armv8
        QMAKE_APPLE_DEVICE_ARCHS = "arm64" # force 'arm64'
    }

    CONTRIBS_DIR = $${PWD}/contribs/env/$${PLATFORM}_$${ARCH}/usr

    INCLUDEPATH     += $${CONTRIBS_DIR}/include/
    QMAKE_LIBDIR    += $${CONTRIBS_DIR}/lib/
    QMAKE_RPATHDIR  += $${CONTRIBS_DIR}/lib/
    LIBS            += -L$${CONTRIBS_DIR}/lib/

    contains(DEFINES, ENABLE_LIBEXIF) { LIBS += -lexif }
    contains(DEFINES, ENABLE_EXIV2) { LIBS += -lexiv2 }
    contains(DEFINES, ENABLE_TAGLIB) { LIBS += -ltag }
    contains(DEFINES, ENABLE_MINIVIDEO) { LIBS += -lminivideo }

} else {

    !unix { warning("Building $${TARGET} without contribs on windows is untested...") }

    CONFIG += link_pkgconfig
    macx { PKG_CONFIG = /usr/local/bin/pkg-config } # use pkg-config from brew
    macx { INCLUDEPATH += /usr/local/include/ }

    contains(DEFINES, ENABLE_LIBEXIF) { PKGCONFIG += libexif }
    contains(DEFINES, ENABLE_EXIV2) { PKGCONFIG += exiv2 }
    contains(DEFINES, ENABLE_TAGLIB) { PKGCONFIG += taglib }
    contains(DEFINES, ENABLE_MINIVIDEO) { PKGCONFIG += libminivideo }

    ## minivideo library
    #INCLUDEPATH += ../minivideo/src
    #QMAKE_LIBDIR+= ../minivideo/build
    #LIBS        += -L../minivideo/build -lminivideo # dynamic linking
}

# Build settings ###############################################################

unix {
    # Enables AddressSanitizer
    #QMAKE_CXXFLAGS += -fsanitize=address,undefined
    #QMAKE_LFLAGS += -fsanitize=address,undefined
}

DEFINES += QT_DEPRECATED_WARNINGS

CONFIG(release, debug|release) : DEFINES += QT_NO_DEBUG_OUTPUT

# Build artifacts ##############################################################

OBJECTS_DIR = build/$${QT_ARCH}/
MOC_DIR     = build/$${QT_ARCH}/
RCC_DIR     = build/$${QT_ARCH}/
UI_DIR      = build/$${QT_ARCH}/
QMLCACHE_DIR= build/$${QT_ARCH}/

DESTDIR = bin/

################################################################################
# Application deployment and installation steps

linux:!android {
    TARGET = $$lower($${TARGET})

    # Automatic application packaging # Needs linuxdeployqt installed
    #system(linuxdeployqt $${OUT_PWD}/$${DESTDIR}/ -qmldir=qml/)

    # Application packaging # Needs linuxdeployqt installed
    #deploy.commands = $${OUT_PWD}/$${DESTDIR}/ -qmldir=qml/
    #install.depends = deploy
    #QMAKE_EXTRA_TARGETS += install deploy

    # Installation
    isEmpty(PREFIX) { PREFIX = /usr/local }
    target_app.files       += $${OUT_PWD}/$${DESTDIR}/$$lower($${TARGET})
    target_app.path         = $${PREFIX}/bin/
    target_icon.files      += $${OUT_PWD}/assets/logos/$$lower($${TARGET}).svg
    target_icon.path        = $${PREFIX}/share/pixmaps/
    target_appentry.files  += $${OUT_PWD}/assets/linux/$$lower($${TARGET}).desktop
    target_appentry.path    = $${PREFIX}/share/applications
    target_appdata.files   += $${OUT_PWD}/assets/linux/$$lower($${TARGET}).appdata.xml
    target_appdata.path     = $${PREFIX}/share/appdata
    INSTALLS += target_app target_icon target_appentry target_appdata

    # Clean appdir/ and bin/ directories
    #QMAKE_CLEAN += $${OUT_PWD}/$${DESTDIR}/$$lower($${TARGET})
    #QMAKE_CLEAN += $${OUT_PWD}/appdir/
}

android {
    # ANDROID_TARGET_ARCH: [x86_64, armeabi-v7a, arm64-v8a]
    #message("ANDROID_TARGET_ARCH: $$ANDROID_TARGET_ARCH")

    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.minivideo
    QMAKE_BUNDLE = infos

    ANDROID_PACKAGE_SOURCE_DIR = $${PWD}/assets/android

    OTHER_FILES += assets/android/src/com/minivideo/infos/QShareActivity.java \
                   assets/android/src/com/minivideo/utils/QShareUtils.java \
                   assets/android/src/com/minivideo/utils/QSharePathResolver.java

    DISTFILES += $${PWD}/assets/android/AndroidManifest.xml \
                 $${PWD}/assets/android/gradle.properties \
                 $${PWD}/assets/android/build.gradle

    versionAtLeast(QT_VERSION, "5.14.0") {
        DEFINES += LIBS_SUFFIX='\\"_$${QT_ARCH}.so\\"'
        ANDROID_EXTRA_LIBS += \
            $${PWD}/contribs/env/android_armv7/usr/lib/libexif.so \
            $${PWD}/contribs/env/android_armv7/usr/lib/libtag.so \
            $${PWD}/contribs/env/android_armv7/usr/lib/libminivideo.so \
            $${PWD}/contribs/env/android_armv8/usr/lib/libexif.so \
            $${PWD}/contribs/env/android_armv8/usr/lib/libtag.so \
            $${PWD}/contribs/env/android_armv8/usr/lib/libminivideo.so \
            $${PWD}/contribs/env/android_x86/usr/lib/libexif.so \
            $${PWD}/contribs/env/android_x86/usr/lib/libtag.so \
            $${PWD}/contribs/env/android_x86/usr/lib/libminivideo.so \
            $${PWD}/contribs/env/android_x86_64/usr/lib/libexif.so \
            $${PWD}/contribs/env/android_x86_64/usr/lib/libtag.so \
            $${PWD}/contribs/env/android_x86_64/usr/lib/libminivideo.so
    } else {
        ANDROID_EXTRA_LIBS += $${CONTRIBS_DIR}/lib/libexif.so
        ANDROID_EXTRA_LIBS += $${CONTRIBS_DIR}/lib/libtag.so
        ANDROID_EXTRA_LIBS += $${CONTRIBS_DIR}/lib/libminivideo.so
    }
    include($${PWD}/contribs/env/android_openssl-master/openssl.pri)
}

macx {
    #QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.12
    #message("QMAKE_MACOSX_DEPLOYMENT_TARGET: $$QMAKE_MACOSX_DEPLOYMENT_TARGET")

    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.minivideo
    QMAKE_BUNDLE = infos
    CONFIG += app_bundle

    # OS icons
    ICON = $${PWD}/assets/macos/$$lower($${TARGET}).icns
    #QMAKE_ASSET_CATALOGS = $${PWD}/assets/macos/Images.xcassets
    #QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"

    # OS infos
    #QMAKE_INFO_PLIST = $${PWD}/assets/macos/Info.plist

    # OS entitlement (sandbox and stuff)
    ENTITLEMENTS.name = CODE_SIGN_ENTITLEMENTS
    ENTITLEMENTS.value = $${PWD}/assets/macos/$$lower($${TARGET}).entitlements
    QMAKE_MAC_XCODE_SETTINGS += ENTITLEMENTS

    #======== Automatic bundle packaging

    # Deploy step (app bundle packaging)
    deploy.commands = macdeployqt $${OUT_PWD}/$${DESTDIR}/$${TARGET}.app -qmldir=qml/ -appstore-compliant
    install.depends = deploy
    QMAKE_EXTRA_TARGETS += install deploy

    # Installation step (note: app bundle packaging)
    isEmpty(PREFIX) { PREFIX = /usr/local }
    target.files += $${OUT_PWD}/${DESTDIR}/${TARGET}.app
    target.path = $$(HOME)/Applications
    INSTALLS += target

    # Clean step
    QMAKE_DISTCLEAN += -r $${OUT_PWD}/${DESTDIR}/${TARGET}.app

    #======== XCode

    # macOS developer settings
    exists($${PWD}/assets/macos/macos_signature.pri) {
        # Must contain values for:
        # QMAKE_DEVELOPMENT_TEAM
        # QMAKE_PROVISIONING_PROFILE
        # QMAKE_XCODE_CODE_SIGN_IDENTITY (optional)
        include($${PWD}/assets/macos/macos_signature.pri)
    }

    # Paths and folders
    QT_BIN_PATH = $$dirname(QMAKE_QMAKE)
    QT_PLUGINS_FOLDER = $$dirname(QT_BIN_PATH)/plugins
    QT_PATH = $$dirname(QT_BIN_PATH)

    # 'xcodeproj' rule / Generate xcode project file
    # todo

    # 'xcodedeploy' rule / Bundle packaging from XCode archive
    # todo
}

ios {
    #QMAKE_IOS_DEPLOYMENT_TARGET = 12.0
    #message("QMAKE_IOS_DEPLOYMENT_TARGET: $$QMAKE_IOS_DEPLOYMENT_TARGET")

    # Bundle name
    QMAKE_TARGET_BUNDLE_PREFIX = com.minivideo
    QMAKE_BUNDLE = infos

    # OS icons
    #QMAKE_ASSET_CATALOGS = $${PWD}/assets/ios/Images.xcassets
    #QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"

    #Q_ENABLE_BITCODE.name = ENABLE_BITCODE
    #Q_ENABLE_BITCODE.value = NO
    #QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE

    # OS infos
    QMAKE_INFO_PLIST = $${PWD}/assets/ios/Info.plist
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1,2 # 1: iPhone / 2: iPad / 1,2: Universal

    # iOS developer settings
    exists($${PWD}/assets/ios/ios_signature.pri) {
        # Must contain values for:
        # QMAKE_DEVELOPMENT_TEAM
        # QMAKE_PROVISIONING_PROFILE
        include($${PWD}/assets/ios/ios_signature.pri)
    }
}

win32 {
    # OS icon
    RC_ICONS = $${PWD}/assets/windows/$$lower($${TARGET}).ico

    # Deploy step
    deploy.commands = $$quote(windeployqt $${OUT_PWD}/$${DESTDIR}/ --qmldir qml/)
    install.depends = deploy
    QMAKE_EXTRA_TARGETS += install deploy

    # Installation step
    # TODO?

    # Clean step
    # TODO
}
