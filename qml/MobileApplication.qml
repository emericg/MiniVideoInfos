import QtQuick
import QtQuick.Controls
import QtQuick.Window

import ThemeEngine
import MobileUI

ApplicationWindow {
    id: appWindow

    minimumWidth: 400
    minimumHeight: 720

    width: isMobile ? Screen.width : 1440
    height: isMobile ? Screen.height : 720

    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    color: Theme.colorBackground
    visible: true

    property bool isHdpi: (utilsScreen.screenDpi >= 128 || utilsScreen.screenPar >= 2.0)
    property bool isDesktop: (Qt.platform.os !== "ios" && Qt.platform.os !== "android")
    property bool isMobile: (Qt.platform.os === "ios" || Qt.platform.os === "android")
    property bool isPhone: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (utilsScreen.screenSize < 7.0))
    property bool isTablet: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (utilsScreen.screenSize >= 7.0))

    // Mobile stuff ////////////////////////////////////////////////////////////

    // 1 = Qt.PortraitOrientation, 2 = Qt.LandscapeOrientation
    // 4 = Qt.InvertedPortraitOrientation, 8 = Qt.InvertedLandscapeOrientation
    property int screenOrientation: Screen.primaryOrientation
    property int screenOrientationFull: Screen.orientation

    property int screenPaddingStatusbar: 0
    property int screenPaddingNavbar: 0

    property int screenPaddingTop: 0
    property int screenPaddingLeft: 0
    property int screenPaddingRight: 0
    property int screenPaddingBottom: 0

    Connections {
        target: Screen
        function onOrientationChanged() { mobileUI.handleSafeAreas() }
    }

    MobileUI {
        id: mobileUI

        statusbarColor: "transparent"
        statusbarTheme: Theme.themeStatusbar
        navbarColor: {
            if (appContent.state === "ScreenTutorial") return Theme.colorHeader
            if ((appContent.state === "ScreenMediaList" && screenMediaList.dialogIsOpen) ||
                (appContent.state === "ScreenMediaInfos" && isPhone) ||
                mobileMenu.visible) return Theme.colorForeground

            return Theme.colorBackground
        }

        Component.onCompleted: handleSafeAreas()

        function handleSafeAreas() {
            // safe areas handling is a work in progress /!\
            // safe areas are only taken into account when using maximized geometry / full screen mode

            mobileUI.refreshUI() // hack

            if (appWindow.visibility === Window.FullScreen ||
                appWindow.flags & Qt.MaximizeUsingFullscreenGeometryHint) {

                screenPaddingStatusbar = mobileUI.statusbarHeight
                screenPaddingNavbar = mobileUI.navbarHeight

                screenPaddingTop = mobileUI.safeAreaTop
                screenPaddingLeft = mobileUI.safeAreaLeft
                screenPaddingRight = mobileUI.safeAreaRight
                screenPaddingBottom = mobileUI.safeAreaBottom

                // hacks
                if (Qt.platform.os === "android") {
                    if (appWindow.visibility === Window.FullScreen) {
                        screenPaddingStatusbar = 0
                        screenPaddingNavbar = 0
                    }
                    if (appWindow.flags & Qt.MaximizeUsingFullscreenGeometryHint) {
                        if (mobileUI.isPhone) {
                            if (Screen.orientation === Qt.LandscapeOrientation) {
                                screenPaddingLeft = screenPaddingStatusbar
                                screenPaddingRight = screenPaddingNavbar
                                screenPaddingNavbar = 0
                            } else if (Screen.orientation === Qt.InvertedLandscapeOrientation) {
                                screenPaddingLeft = screenPaddingNavbar
                                screenPaddingRight = screenPaddingStatusbar
                                screenPaddingNavbar = 0
                            }
                        }
                    }
                }
                // hacks
                if (Qt.platform.os === "ios") {
                    if (appWindow.visibility === Window.FullScreen) {
                        screenPaddingStatusbar = 0
                    }
                }
            } else {
                screenPaddingStatusbar = 0
                screenPaddingNavbar = 0
                screenPaddingTop = 0
                screenPaddingLeft = 0
                screenPaddingRight = 0
                screenPaddingBottom = 0
            }
/*
            console.log("> handleSafeAreas()")
            console.log("- window mode:         " + appWindow.visibility)
            console.log("- window flags:        " + appWindow.flags)
            console.log("- screen dpi:          " + Screen.devicePixelRatio)
            console.log("- screen width:        " + Screen.width)
            console.log("- screen width avail:  " + Screen.desktopAvailableWidth)
            console.log("- screen height:       " + Screen.height)
            console.log("- screen height avail: " + Screen.desktopAvailableHeight)
            console.log("- screen orientation (full): " + Screen.orientation)
            console.log("- screen orientation (primary): " + Screen.primaryOrientation)
            console.log("- screenSizeStatusbar: " + screenPaddingStatusbar)
            console.log("- screenSizeNavbar:    " + screenPaddingNavbar)
            console.log("- screenPaddingTop:    " + screenPaddingTop)
            console.log("- screenPaddingLeft:   " + screenPaddingLeft)
            console.log("- screenPaddingRight:  " + screenPaddingRight)
            console.log("- screenPaddingBottom: " + screenPaddingBottom)
*/
        }
    }

    MobileHeader {
        id: appHeader
    }

    Rectangle { // separator
        anchors.top: appHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        visible: (appContent.state !== "ScreenTutorial")
        z: (appContent.state === "ScreenSettings" ||
            appContent.state === "ScreenAbout" ||
            appContent.state === "ScreenAboutPermissions") ? 5 : 0

        height: 2
        opacity: 1
        color: Theme.colorSeparator

        Rectangle { // fake shadow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            z: -1
            height: 8
            opacity: 0.66

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.colorHeader; }
                GradientStop { position: 1.0; color: "transparent"; }
            }
        }
    }

    MobileDrawer {
        id: appDrawer

        interactive: (appContent.state !== "ScreenTutorial")
    }

    // Sharing handling ////////////////////////////////////////////////////////

    Connections {
        target: utilsShare
        function onFileUrlReceived() {
            console.log("onFileUrlReceived + " + url)
            screenMediaList.loadMedia(url)
        }
        function onFileReceivedAndSaved() {
            console.log("onFileReceivedAndSaved + " + url)
            screenMediaList.loadMedia(url)
        }
    }

    // Events handling /////////////////////////////////////////////////////////

    Connections {
        target: Qt.application
        function onStateChanged() {
            switch (Qt.application.state) {
            case Qt.ApplicationSuspended:
                //console.log("Qt.ApplicationSuspended")
                break
            case Qt.ApplicationHidden:
                //console.log("Qt.ApplicationHidden")
                break
            case Qt.ApplicationInactive:
                //console.log("Qt.ApplicationInactive")
                break
            case Qt.ApplicationActive:
                //console.log("Qt.ApplicationActive")

                // Check if we need an 'automatic' theme change
                Theme.loadTheme(settingsManager.appTheme)

                break
            }
        }
    }

    Connections {
        target: appHeader
        function onLeftMenuClicked() {
            if (appHeader.leftMenuMode === "drawer") {
                appDrawer.open()
            } else {
                backAction()
            }
        }
        function onRightMenuClicked() {
            //
        }
    }

    function backAction() {
        if (appContent.state === "ScreenTutorial" && screenTutorial.entryPoint === "ScreenMediaList") {
            // do nothing
            return
        }

        if (appContent.state === "ScreenTutorial") {
            appContent.state = screenTutorial.entryPoint
        } else if (appContent.state === "ScreenAboutPermissions") {
            appContent.state = screenAboutPermissions.entryPoint
        } else if (appContent.state === "ScreenMediaList") {
            screenMediaList.backAction()
        } else {
            appContent.state = "ScreenMediaList"
        }
    }
    function forwardAction() {
        if (appContent.state === "ScreenMediaList") {
            if (screenMediaInfos.mediaItem !== null) {
                appContent.state = "ScreenMediaInfos"
            }
        }
    }

    Shortcut {
        sequences: [StandardKey.Back]
        onActivated: backAction()
    }
    Shortcut {
        sequences: [StandardKey.Forward]
        onActivated: forwardAction()
    }

    // UI sizes ////////////////////////////////////////////////////////////////

    property bool headerUnicolor: (Theme.colorHeader === Theme.colorBackground)

    property bool singleColumn: {
        if (isMobile) {
            if ((isPhone && screenOrientation === Qt.PortraitOrientation) ||
                (isTablet && width < 512)) { // can be a 2/3 split screen on tablet
                return true
            } else {
                return false
            }
        } else {
            return (appWindow.width < appWindow.height)
        }
    }

    property bool wideMode: (isDesktop && width >= 560) || (isTablet && width >= 480)
    property bool wideWideMode: (width >= 640)

    // QML /////////////////////////////////////////////////////////////////////

    FocusScope {
        id: appContent

        anchors.top: appHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: mobileMenu.height

        Keys.onBackPressed: {
            if (appContent.state === "ScreenTutorial" && screenTutorial.entryPoint === "ScreenMediaList") {
                // do nothing
                return
            }

            if (appContent.state === "ScreenMediaList") {
                if (screenMediaList.selectionList.length !== 0) {
                    screenMediaList.exitSelectionMode()
                } else {
                    if (mobileExit.enabled) {
                        if (mobileExit.timerRunning)
                            Qt.quit()
                        else
                            mobileExit.timerStart()
                    } else {
                        mobileUI.backToHomeScreen()
                    }
                }
            } else {
                backAction()
            }
        }

        ScreenTutorial {
            id: screenTutorial
        }
        ScreenMediaList {
            id: screenMediaList
        }
        ScreenMediaInfos {
            id: screenMediaInfos
        }
        ScreenSettings {
            id: screenSettings
        }
        ScreenAbout {
            id: screenAbout
        }
        MobilePermissions {
            id: screenAboutPermissions
        }

        // Start on the tutorial?
        Component.onCompleted: {
            if (settingsManager.firstLaunch) {
                screenTutorial.loadScreen()
            }
        }

        // Initial state
        state: "ScreenMediaList"

        onStateChanged: {
            screenMediaList.exitSelectionMode()

            if (state === "ScreenMediaList") {
                appHeader.leftMenuMode = "drawer"
            } else if (state === "ScreenTutorial") {
                appHeader.leftMenuMode = "close"
            } else {
                appHeader.leftMenuMode = "back"
            }

            focus = true
        }

        states: [
            State {
                name: "ScreenTutorial"
                PropertyChanges { target: appHeader; headerTitle: qsTr("Welcome"); }
                PropertyChanges { target: screenTutorial; enabled: true; visible: true; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenAboutPermissions; visible: false; enabled: false; }
            },
            State {
                name: "ScreenMediaList"
                PropertyChanges { target: appHeader; headerTitle: utilsApp.appName(); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: true; visible: true; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenAboutPermissions; visible: false; enabled: false; }
            },
            State {
                name: "ScreenMediaInfos"
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: true; visible: true; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenAboutPermissions; visible: false; enabled: false; }
            },
            State {
                name: "ScreenSettings"
                PropertyChanges { target: appHeader; headerTitle: qsTr("Settings"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: true; enabled: true; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenAboutPermissions; visible: false; enabled: false; }
            },
            State {
                name: "ScreenAbout"
                PropertyChanges { target: appHeader; headerTitle: qsTr("About"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: true; enabled: true; }
                PropertyChanges { target: screenAboutPermissions; visible: false; enabled: false; }
            },
            State {
                name: "ScreenAboutPermissions"
                PropertyChanges { target: appHeader; headerTitle: qsTr("Permissions"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
                PropertyChanges { target: screenAboutPermissions; visible: true; enabled: true; }
            }
        ]
    }

    ////////////////

    MobileExit {
        id: mobileExit
    }

    ////////////////

    MobileMenu {
        id: mobileMenu
    }

    ////////////////////////////////////////////////////////////////////////////
}
