import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

import ThemeEngine 1.0
import MobileUI 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath

ApplicationWindow {
    id: appWindow
    minimumWidth: 400
    minimumHeight: 800

    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint
    color: Theme.colorBackground
    visible: true

    property bool isHdpi: (utilsScreen.screenDpi > 128)
    property bool isDesktop: (Qt.platform.os !== "ios" && Qt.platform.os !== "android")
    property bool isMobile: (Qt.platform.os === "ios" || Qt.platform.os === "android")
    property bool isPhone: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (utilsScreen.screenSize < 7.0))
    property bool isTablet: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (utilsScreen.screenSize >= 7.0))

    // Mobile stuff ////////////////////////////////////////////////////////////

    // 1 = Qt.PortraitOrientation, 2 = Qt.LandscapeOrientation
    // 4 = Qt.InvertedPortraitOrientation, 8 = Qt.InvertedLandscapeOrientation
    property int screenOrientation: Screen.primaryOrientation
    property int screenOrientationFull: Screen.orientation
    onScreenOrientationChanged: handleNotchesTimer.restart()

    property int screenPaddingStatusbar: 0
    property int screenPaddingNotch: 0
    property int screenPaddingLeft: 0
    property int screenPaddingRight: 0
    property int screenPaddingBottom: 0

    Timer {
        id: handleNotchesTimer
        interval: 33
        repeat: false
        onTriggered: handleNotches()
    }

    function handleNotches() {
/*
        console.log("handleNotches()")
        console.log("screen width : " + Screen.width)
        console.log("screen width avail  : " + Screen.desktopAvailableWidth)
        console.log("screen height : " + Screen.height)
        console.log("screen height avail  : " + Screen.desktopAvailableHeight)
        console.log("screen orientation: " + Screen.orientation)
        console.log("screen orientation (primary): " + Screen.primaryOrientation)
*/
        if (Qt.platform.os !== "ios") return
        if (typeof quickWindow === "undefined" || !quickWindow) {
            handleNotchesTimer.restart();
            return;
        }

        // Statusbar text color hack
        mobileUI.statusbarTheme = (Theme.themeStatusbar === 0) ? 1 : 0
        mobileUI.statusbarTheme = Theme.themeStatusbar

        // Margins
        var safeMargins = utilsScreen.getSafeAreaMargins(quickWindow)
        if (safeMargins["total"] === safeMargins["top"]) {
            screenPaddingStatusbar = safeMargins["top"]
            screenPaddingNotch = 0
            screenPaddingLeft = 0
            screenPaddingRight = 0
            screenPaddingBottom = 0
        } else if (safeMargins["total"] > 0) {
            if (Screen.orientation === Qt.PortraitOrientation) {
                screenPaddingStatusbar = 20
                screenPaddingNotch = 12
                screenPaddingLeft = 0
                screenPaddingRight = 0
                screenPaddingBottom = 6
            } else if (Screen.orientation === Qt.InvertedPortraitOrientation) {
                screenPaddingStatusbar = 12
                screenPaddingNotch = 20
                screenPaddingLeft = 0
                screenPaddingRight = 0
                screenPaddingBottom = 6
            } else if (Screen.orientation === Qt.LandscapeOrientation) {
                screenPaddingStatusbar = 0
                screenPaddingNotch = 0
                screenPaddingLeft = 32
                screenPaddingRight = 0
                screenPaddingBottom = 0
            } else if (Screen.orientation === Qt.InvertedLandscapeOrientation) {
                screenPaddingStatusbar = 0
                screenPaddingNotch = 0
                screenPaddingLeft = 0
                screenPaddingRight = 32
                screenPaddingBottom = 0
            } else {
                screenPaddingStatusbar = 0
                screenPaddingNotch = 0
                screenPaddingLeft = 0
                screenPaddingRight = 0
                screenPaddingBottom = 0
            }
        } else {
            screenPaddingStatusbar = 0
            screenPaddingNotch = 0
            screenPaddingLeft = 0
            screenPaddingRight = 0
            screenPaddingBottom = 0
        }
/*
        console.log("total:" + safeMargins["total"])
        console.log("top:" + safeMargins["top"])
        console.log("left:" + safeMargins["left"])
        console.log("right:" + safeMargins["right"])
        console.log("bottom:" + safeMargins["bottom"])

        console.log("RECAP screenPaddingStatusbar:" + screenPaddingStatusbar)
        console.log("RECAP screenPaddingNotch:" + screenPaddingNotch)
        console.log("RECAP screenPaddingLeft:" + screenPaddingLeft)
        console.log("RECAP screenPaddingRight:" + screenPaddingRight)
        console.log("RECAP screenPaddingBottom:" + screenPaddingBottom)
*/
    }

    MobileUI {
        id: mobileUI
        property bool isLoading: true

        statusbarTheme: Theme.themeStatusbar
        statusbarColor: isLoading ? "white" : Theme.colorStatusbar
        navbarColor: {
            if (isLoading) return "white"
            if (appContent.state === "Tutorial") return Theme.colorHeader
            if ((appContent.state === "MediaList" && screenMediaList.dialogIsOpen) ||
                (appContent.state === "MediaInfos" && isPhone) ||
                tabletMenuScreen.visible)
                return Theme.colorForeground

            return Theme.colorBackground
        }
    }

    MobileHeader {
        id: appHeader
        width: parent.width
        anchors.top: parent.top
    }

    MobileDrawer {
        id: appDrawer
        width: (Screen.primaryOrientation === 1 || parent.width < 480) ? 0.80 * parent.width : 0.50 * parent.width
        height: parent.height
    }

    // Sharing handling ////////////////////////////////////////////////////////

    Connections {
        target: utilsShare
        onFileUrlReceived: {
            console.log("onFileUrlReceived + " + url)
            screenMediaList.loadMedia(url)
        }
        onFileReceivedAndSaved: {
            console.log("onFileReceivedAndSaved + " + url)
            screenMediaList.loadMedia(url)
        }
    }

    // Events handling /////////////////////////////////////////////////////////

    Component.onCompleted: {
        handleNotchesTimer.restart()
        mobileUI.isLoading = false

        if (isDesktop) {
            width = 1280
            height = 720
        }
    }

    Connections {
        target: Qt.application
        onStateChanged: {
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
        onLeftMenuClicked: {
            if (appHeader.leftMenuMode === "drawer") {
                appDrawer.open()
            } else {
                backAction()
            }
        }
        onRightMenuClicked: {
            //
        }
    }

    function backAction() {
        if (appContent.state === "Tutorial") {
            appContent.state = screenTutorial.exitTo
        } else if (appContent.state === "Permissions") {
            appContent.state = "About"
        } else {
            appContent.state = "MediaList"
            screenMediaList.closeDialog()
        }
    }
    function forwardAction() {
        if (appContent.state === "MediaList") {
            if (screenMediaInfos.mediaItem != null) {
                appContent.state = "MediaInfos"
            }
        }
    }

    Shortcut {
        sequence: StandardKey.Back
        onActivated: backAction()
    }
    Shortcut {
        sequence: StandardKey.Forward
        onActivated: forwardAction()
    }

    Timer {
        id: exitTimer
        interval: 3000
        repeat: false
        onRunningChanged: exitWarning.opacity = running
    }

    // QML /////////////////////////////////////////////////////////////////////

    FocusScope {
        id: appContent
        anchors.top: appHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: appTabletMenu.visible ? appTabletMenu.height : 0

        focus: true
        Keys.onBackPressed: {
            if (appContent.state === "Tutorial" && screenTutorial.exitTo === "MediaList") return; // do nothing

            if (appContent.state === "MediaList") {
                if (screenMediaList.selectionList.length !== 0) {
                    screenMediaList.exitSelectionMode()
                } else {
                    if (exitTimer.running)
                        Qt.quit()
                    else
                        exitTimer.start()
                }
            } else {
                backAction()
            }
        }

        Tutorial {
            anchors.fill: parent
            id: screenTutorial
        }
        MediaList {
            anchors.fill: parent
            id: screenMediaList
        }
        MediaInfos {
            anchors.fill: parent
            id: screenMediaInfos
        }
        Settings {
            anchors.fill: parent
            id: screenSettings
        }
        Permissions {
            anchors.fill: parent
            id: screenPermissions
        }
        About {
            anchors.fill: parent
            id: screenAbout
        }

        // Initial state
        state: settingsManager.firstLaunch ? "Tutorial" : "MediaList"

        onStateChanged: {
            if (state === "MediaList") {
                appHeader.leftMenuMode = "drawer";
            } else if (state === "Tutorial")
                appHeader.leftMenuMode = "close";
            else
                appHeader.leftMenuMode = "back";

            if (state === "Tutorial")
                appDrawer.interactive = false;
            else
                appDrawer.interactive = true;
        }

        states: [
            State {
                name: "Tutorial"
                PropertyChanges { target: appHeader; title: qsTr("Welcome"); }
                PropertyChanges { target: screenTutorial; enabled: true; visible: true; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenPermissions; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "MediaList"
                PropertyChanges { target: appHeader; title: appHeader.appName; }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: true; visible: true; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenPermissions; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "MediaInfos"
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: true; visible: true; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenPermissions; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "Settings"
                PropertyChanges { target: appHeader; title: qsTr("Settings"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: true; enabled: true; }
                PropertyChanges { target: screenPermissions; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "Permissions"
                PropertyChanges { target: appHeader; title: qsTr("Permissions"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenPermissions; visible: true; enabled: true; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "About"
                PropertyChanges { target: appHeader; title: qsTr("About"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenPermissions; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: true; enabled: true; }
            }
        ]
    }

    ////////////////////////////////////////////////////////////////////////////

    DropArea {
        id: dropArea
        anchors.fill: parent

        enabled: isDesktop
        //keys: ["text/plain"]

        onEntered: {
            if (drag.hasUrls) {
                dropAreaIndicator.color = Theme.colorWarning
                dropAreaImage.source = "qrc:/assets/icons_material_media/baseline-broken_image-24px.svg"
                dropAreaIndicator.opacity = 1

                for (var i = 0; i < drag.urls.length; i++) {
                    if (UtilsPath.isMediaFile(drag.urls[i])) {
                        dropAreaImage.source = "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                        dropAreaIndicator.color = Theme.colorGreen
                        break;
                    }
                }
            }
        }
        onExited: {
            dropAreaIndicator.opacity = 0
        }
        onDropped: {
            dropAreaIndicator.opacity = 0

            if (drop.hasUrls) {
                for (var i = 0; i < drop.urls.length; i++) {
                    //console.log("dropped URL: " + drop.urls[i])
                    var fp = UtilsPath.cleanUrl(drop.urls[i]);

                    if (UtilsPath.isMediaFile(fp)) {
                        screenMediaList.loadMedia(fp)
                        break;
                    }
                }
            }
        }

        Rectangle {
            id: dropAreaIndicator
            width: 320
            height: 320
            radius: 320
            anchors.centerIn: parent

            color: Theme.colorForeground
            opacity: 0
            Behavior on opacity { OpacityAnimator { duration: 200 } }

            ImageSvg {
                id: dropAreaImage
                anchors.fill: parent
                anchors.margins: 48
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                source: ""
                color: "white"
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        enabled: isDesktop
        acceptedButtons: Qt.BackButton | Qt.ForwardButton
        onClicked: {
            if (mouse.button === Qt.BackButton) {
                backAction()
            } else if (mouse.button === Qt.ForwardButton) {
                forwardAction()
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: appTabletMenu
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        color: Theme.colorTabletmenu
        width: parent.width
        height: 48

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            opacity: 0.5
            color: Theme.colorTabletmenuContent
        }

        visible: (isDesktop || isTablet) && (appContent.state != "Tutorial" && appContent.state != "MediaInfos")

        Row {
            id: tabletMenuScreen
            spacing: 24
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            visible: (appContent.state === "MediaList" ||
                      appContent.state === "Settings" ||
                      appContent.state === "About")

            ItemMenuButton {
                id: menuMedia
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("Media")
                selected: (appContent.state === "MediaList")
                source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                onClicked: appContent.state = "MediaList"
            }
            ItemMenuButton {
                id: menuSettings
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("Settings")
                selected: (appContent.state === "Settings")
                source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                onClicked: appContent.state = "Settings"
            }
            ItemMenuButton {
                id: menuAbout
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("About")
                selected: (appContent.state === "About")
                source: "qrc:/assets/icons_material/outline-info-24px.svg"
                onClicked: appContent.state = "About"
            }
        }
    }

    ////////////////

    Text {
        id: exitWarning
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        anchors.horizontalCenter: parent.horizontalCenter

        opacity: 0
        Behavior on opacity { OpacityAnimator { duration: 333 } }

        text: qsTr("Press one more time to exit...")
        textFormat: Text.PlainText
        font.pixelSize: Theme.fontSizeContent
        color: Theme.colorForeground

        Rectangle {
            anchors.fill: parent
            anchors.margins: -8
            z: -1
            radius: 4
            color: Theme.colorSubText
        }
    }
}
