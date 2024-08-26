import QtQuick
import QtQuick.Controls
import QtQuick.Window

import ThemeEngine

import "qrc:/utils/UtilsPath.js" as UtilsPath

ApplicationWindow {
    id: appWindow
    flags: Qt.Window
    color: Theme.colorBackground

    property bool isHdpi: (utilsScreen.screenDpi >= 128 || utilsScreen.screenPar >= 2.0)
    property bool isDesktop: true
    property bool isMobile: false
    property bool isPhone: false
    property bool isTablet: false

    // Desktop stuff ///////////////////////////////////////////////////////////

    minimumWidth: isHdpi ? 480 : 560
    minimumHeight: isHdpi ? 720 : 800

    width: {
        if (settingsManager.initialSize.width > 0)
            return settingsManager.initialSize.width
    }
    height: {
        if (settingsManager.initialSize.height > 0)
            return settingsManager.initialSize.height
    }
    x: settingsManager.initialPosition.width
    y: settingsManager.initialPosition.height
    visibility: settingsManager.initialVisibility
    visible: true

    WindowGeometrySaver {
        windowInstance: appWindow
    }

    // Mobile stuff // compatibility ///////////////////////////////////////////

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

    Item { id: mobileMenu }

    // Desktop stuff ///////////////////////////////////////////////////////////

    DesktopHeader {
        id: appHeader
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

    function backAction() {
        if (appContent.state === "ScreenMediaList") {
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
    property bool singleColumn: (appWindow.width < appWindow.height)
    property bool wideMode: (width >= 560)
    property bool wideWideMode: (width >= 640)

    // QML /////////////////////////////////////////////////////////////////////

    FocusScope {
        id: appContent

        anchors.top: appHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        ScreenMediaList {
            id: screenMediaList
        }
        ScreenMediaInfos {
            id: screenMediaInfos
        }
        DesktopSettings {
            id: screenSettings
        }

        // Initial state
        state: "ScreenMediaList"

        onStateChanged: {
            //
        }

        states: [
            State {
                name: "ScreenMediaList"
                PropertyChanges { target: screenMediaList; enabled: true; visible: true; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
            },
            State {
                name: "ScreenMediaInfos"
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: true; visible: true; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
            },
            State {
                name: "ScreenSettings"
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: true; enabled: true; }
            }
        ]
    }

    ////////////////

    DropArea {
        id: dropArea
        anchors.fill: parent

        enabled: isDesktop
        //keys: ["text/plain"]

        onEntered: (drag) => {
            if (drag.hasUrls) {
                dropAreaIndicator.color = Theme.colorWarning
                dropAreaImage.source = "qrc:/assets/icons/material-symbols/media/broken_image.svg"
                dropAreaIndicator.opacity = 1

                for (var i = 0; i < drag.urls.length; i++) {
                    if (UtilsPath.isMediaFile(drag.urls[i])) {
                        dropAreaImage.source = "qrc:/assets/icons/fontawesome/photo-video-duotone.svg"
                        dropAreaIndicator.color = Theme.colorGreen
                        break
                    }
                }
            }
        }
        onExited: {
            dropAreaIndicator.opacity = 0
        }
        onDropped: (drop) => {
            dropAreaIndicator.opacity = 0

            if (drop.hasUrls) {
                for (var i = 0; i < drop.urls.length; i++) {
                    //console.log("dropped URL: " + drop.urls[i])
                    var fp = UtilsPath.cleanUrl(drop.urls[i])

                    if (UtilsPath.isMediaFile(fp)) {
                        screenMediaList.loadMedia(fp)
                        break
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

            IconSvg {
                id: dropAreaImage
                anchors.fill: parent
                anchors.margins: 48
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                fillMode: Image.PreserveAspectFit
                color: "white"
                smooth: true
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        enabled: isDesktop
        acceptedButtons: Qt.BackButton | Qt.ForwardButton
        onClicked: (mouse) => {
            if (mouse.button === Qt.BackButton) {
                backAction()
            } else if (mouse.button === Qt.ForwardButton) {
                forwardAction()
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
