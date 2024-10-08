TARGET  = MiniVideoInfos
VERSION = 0.10

DEFINES += APP_NAME=\\\"$$TARGET\\\"
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

CONFIG += c++17
QT     += core qml quickcontrols2 svg widgets
QT     += concurrent charts location

# Validate Qt version
!versionAtLeast(QT_VERSION, 6.5) : error("You need at least Qt version 6.5 for $${TARGET}")

# Bundle name
QMAKE_TARGET_BUNDLE_PREFIX = io.minivideo
QMAKE_BUNDLE = infos

# Project features #############################################################

DEFINES += ENABLE_MINIVIDEO
DEFINES += ENABLE_LIBEXIF
DEFINES += ENABLE_TAGLIB
#DEFINES += ENABLE_EXIV2

DEFINES += USE_CONTRIBS

# Use contribs (otherwise use system libs)
ios | android { DEFINES += USE_CONTRIBS }

# Use Qt Quick compiler
ios | android { CONFIG += qtquickcompiler }

# Project modules ##############################################################

# AppUtils
include(src/thirdparty/AppUtils/AppUtils.pri)

# EGM96 altitude correction
include(src/thirdparty/EGM96/EGM96.pri)

# MobileUI and MobileSharing for mobile OS
include(src/thirdparty/MobileUI/MobileUI.pri)
include(src/thirdparty/MobileSharing/MobileSharing.pri)

INCLUDEPATH += src/thirdparty/

# Project files ################################################################

SOURCES  += src/main.cpp \
            src/Media.cpp \
            src/MediaManager.cpp \
            src/SettingsManager.cpp \
            src/minivideo_track_qml.cpp \
            src/minivideo_textexport_qt.cpp \
            src/minivideo_utils_qt.cpp

HEADERS  += src/Media.h \
            src/MediaUtils.h \
            src/MediaManager.h \
            src/SettingsManager.h \
            src/minivideo_qml.h \
            src/minivideo_track_qml.h \
            src/minivideo_textexport_qt.h \
            src/minivideo_utils_qt.h

RESOURCES   += assets/assets.qrc assets/icons.qrc
RESOURCES   += qml/ComponentLibrary/ComponentLibrary.qrc
RESOURCES   += qml/qml.qrc

OTHER_FILES += .gitignore \
               .github/workflows/builds.yml \
               contribs/contribs_builder.py

RESOURCES   += i18n/i18n.qrc
#TRANSLATIONS = i18n/xx_fr.ts

lupdate_only { SOURCES += qml/*.qml qml/*.js qml/components/*.qml }

# Dependencies #################################################################

contains(DEFINES, USE_CONTRIBS) {

    ARCH = "x86_64"
    linux { PLATFORM = "linux" }
    win32 { PLATFORM = "windows" }

    macx {
        PLATFORM = "macOS"

        exists($${PWD}/contribs/env/macOS_unified/usr) {
            ARCH = "unified"
        }
    }
    android { # ANDROID_TARGET_ARCH available: x86 x86_64 armeabi-v7a arm64-v8a
        PLATFORM = "android"

        equals(ANDROID_TARGET_ARCH, "x86") { ARCH = "x86" }
        equals(ANDROID_TARGET_ARCH, "x86_64") { ARCH = "x86_64" }
        equals(ANDROID_TARGET_ARCH, "armeabi-v7a") { ARCH = "armv7" }
        equals(ANDROID_TARGET_ARCH, "arm64-v8a") { ARCH = "armv8" }
    }
    ios { # QMAKE_APPLE_DEVICE_ARCHS available: armv7 arm64
        PLATFORM = "iOS"
        ARCH = "armv8" # can be unified, simulator, armv7 and armv8
        QMAKE_APPLE_DEVICE_ARCHS = "arm64" # force 'arm64'

        exists($${PWD}/contribs/env/iOS_unified/usr) {
            ARCH = "unified"
        }
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

    !unix { warning("Building $${TARGET} without contribs on Windows is untested...") }

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

win32 { DEFINES += _USE_MATH_DEFINES }

DEFINES += QT_DEPRECATED_WARNINGS

# Debug indication macros
CONFIG(release, debug|release) : DEFINES += NDEBUG QT_NO_DEBUG QT_NO_DEBUG_OUTPUT

# Build artifacts ##############################################################

OBJECTS_DIR = build/$${QT_ARCH}/obj/
MOC_DIR     = build/$${QT_ARCH}/moc/
RCC_DIR     = build/$${QT_ARCH}/rcc/
UI_DIR      = build/$${QT_ARCH}/ui/

DESTDIR     = bin/

# Application deployment steps #################################################

android {
    # ANDROID_TARGET_ARCH: [x86_64, armeabi-v7a, arm64-v8a]
    #message("ANDROID_TARGET_ARCH: $$ANDROID_TARGET_ARCH")

    ANDROID_PACKAGE_SOURCE_DIR = $${PWD}/assets/android

    OTHER_FILES += assets/android/src/com/minivideo/infos/QShareActivity.java \
                   assets/android/src/com/minivideo/utils/QShareUtils.java \
                   assets/android/src/com/minivideo/utils/QSharePathResolver.java

    DISTFILES += $${PWD}/assets/android/AndroidManifest.xml \
                 $${PWD}/assets/android/gradle.properties \
                 $${PWD}/assets/android/build.gradle

    contains(DEFINES, ENABLE_LIBEXIF) { ANDROID_EXTRA_LIBS += $${CONTRIBS_DIR}/lib/libexif.so }
    contains(DEFINES, ENABLE_TAGLIB) { ANDROID_EXTRA_LIBS += $${CONTRIBS_DIR}/lib/libtag.so }
    contains(DEFINES, ENABLE_MINIVIDEO) { ANDROID_EXTRA_LIBS += $${CONTRIBS_DIR}/lib/libminivideo.so }

    include($${PWD}/contribs/env/android_openssl-master/openssl.pri)
}

ios {
    #QMAKE_IOS_DEPLOYMENT_TARGET = 13.0
    #message("QMAKE_IOS_DEPLOYMENT_TARGET: $$QMAKE_IOS_DEPLOYMENT_TARGET")

    # OS icons
    #QMAKE_ASSET_CATALOGS = $${PWD}/assets/ios/Images.xcassets
    #QMAKE_ASSET_CATALOGS_APP_ICON = "AppIcon"

    # OS infos
    QMAKE_INFO_PLIST = $${PWD}/assets/ios/Info.plist

    # Target devices
    QMAKE_APPLE_TARGETED_DEVICE_FAMILY = 1,2 # 1: iPhone / 2: iPad / 1,2: Universal

    # iOS developer settings
    exists($${PWD}/assets/ios/ios_signature.pri) {
        # Must contain values for:
        # QMAKE_DEVELOPMENT_TEAM
        # QMAKE_PROVISIONING_PROFILE
        include($${PWD}/assets/ios/ios_signature.pri)
    }
}

# Application deployment steps #################################################

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
    target_icon.files      += $${OUT_PWD}/assets/gfx/logos/$$lower($${TARGET}).svg
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

macx {
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

    # Target architecture(s)
    QMAKE_APPLE_DEVICE_ARCHS = x86_64 arm64

    # Target OS
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 11.0

    # macOS developer settings
    exists($${PWD}/assets/macos/macos_signature.pri) {
        # Must contain values for:
        # QMAKE_DEVELOPMENT_TEAM
        # QMAKE_PROVISIONING_PROFILE
        # QMAKE_XCODE_CODE_SIGN_IDENTITY (optional)
        include($${PWD}/assets/macos/macos_signature.pri)
    }
}

win32 {
    # OS icon
    RC_ICONS = $${PWD}/assets/windows/$$lower($${TARGET}).ico
}
