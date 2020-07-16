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

    // 1 = Qt::PortraitOrientation, 2 = Qt::LandscapeOrientation
    property int screenOrientation: Screen.primaryOrientation
    onScreenOrientationChanged: handleNotches()

    property int screenStatusbarPadding: 0
    property int screenNotchPadding: 0
    property int screenLeftPadding: 0
    property int screenRightPadding: 0

    Timer {
        id: firstHandleNotches
        interval: 100
        repeat: false
        onTriggered: handleNotches()
    }

    function handleNotches() {
        if (Qt.platform.os !== "ios") return
        if (typeof quickWindow === "undefined" || !quickWindow) return

        var screenPadding = (Screen.height - Screen.desktopAvailableHeight)
        //console.log("screen height : " + Screen.height)
        //console.log("screen avail  : " + Screen.desktopAvailableHeight)
        //console.log("screen padding: " + screenPadding)

        var safeMargins = utilsScreen.getSafeAreaMargins(quickWindow)
        //console.log("top:" + safeMargins["top"])
        //console.log("right:" + safeMargins["right"])
        //console.log("bottom:" + safeMargins["bottom"])
        //console.log("left:" + safeMargins["left"])

        if (safeMargins["total"] !== safeMargins["top"]) {
            if (Screen.primaryOrientation === Qt.PortraitOrientation) {
                screenStatusbarPadding = 20
                screenNotchPadding = 12
            } else {
                screenStatusbarPadding = 0
                screenNotchPadding = 0
            }

            if (Screen.primaryOrientation === Qt.LandscapeOrientation) {
                // TODO left or right ???
                screenLeftPadding = 32
                screenRightPadding = 0
            } else {
                screenLeftPadding = 0
                screenRightPadding = 0
            }
        } else {
            screenStatusbarPadding = 20
            screenNotchPadding = 0
        }
/*
        console.log("RECAP screenStatusbarPadding:" + screenStatusbarPadding)
        console.log("RECAP screenNotchPadding:" + screenNotchPadding)
        console.log("RECAP screenLeftPadding:" + screenLeftPadding)
        console.log("RECAP screenRightPadding:" + screenRightPadding)
*/
    }

    MobileUI {
        statusbarColor: Theme.colorStatusbar
        statusbarTheme: Theme.themeStatusbar
        navbarColor: {
            if (appContent.state === "Tutorial")
                return Theme.colorHeader
            else if ((appContent.state === "MediaList" && screenMediaList.dialogIsOpen) ||
                     (appContent.state === "MediaInfos" && isPhone) ||
                      tabletMenuScreen.visible)
                return Theme.colorForeground
            else
                return Theme.colorBackground
        }
    }

    MobileHeader {
        id: appHeader
        width: parent.width
        anchors.top: parent.top
    }

    Drawer {
        id: appDrawer
        width: (Screen.primaryOrientation === 1 || appWindow.width < 480) ? 0.80 * appWindow.width : 0.50 * appWindow.width
        height: appWindow.height

        background: Rectangle {
            color: Theme.colorBackground

            Rectangle {
                x: parent.width - 1
                width: 1
                height: parent.height
                color: Theme.colorSeparator
            }
        }

        MobileDrawer { id: drawerscreen }
    }

    // Sharing handling /////////////////////////////////////////////////////////

    Connections {
        target: utilsShare
        onFileUrlReceived: {
            console.log("onFileUrlReceived + " + url)
            screenMediaList.loadMedia(url)
        }
    }
    Connections {
        target: utilsShare
        onFileReceivedAndSaved: {
            console.log("onFileReceivedAndSaved + " + url)
            screenMediaList.loadMedia(url)
        }
    }

    // Events handling /////////////////////////////////////////////////////////

    Component.onCompleted: {
        firstHandleNotches.restart()
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
        if (appContent.state === "Tutorial" && screenTutorial.exitTo === "MediaList") return; // do nothing

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
                Theme.loadTheme(settingsManager.appTheme);

                break
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
            if (state === "MediaList")
                appHeader.leftMenuMode = "drawer";
            else if (state === "Tutorial")
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
                PropertyChanges { target: appHeader; title: "MiniVideo Infos"; }
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
        //keys: ["text/plain"]

        onEntered: {
            if (drag.hasUrls) {
                dropAreaIndicator.color = Theme.colorError
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
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0

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
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

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

        visible: isTablet && (appContent.state != "Tutorial" && appContent.state != "MediaInfos")

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
                source: "qrc:/assets/icons_fontawesome/photo-video-duotone"
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

    Rectangle {
        id: exitWarning
        width: exitWarningText.width + 16
        height: exitWarningText.height + 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        anchors.horizontalCenter: parent.horizontalCenter

        radius: 4
        color: Theme.colorSubText
        opacity: 0
        Behavior on opacity { OpacityAnimator { duration: 333 } }

        Text {
            id: exitWarningText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("Press one more time to exit...")
            font.pixelSize: 16
            color: Theme.colorForeground
        }
    }
}
