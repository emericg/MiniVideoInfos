import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import ThemeEngine 1.0
import MobileUI 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath

ApplicationWindow {
    id: appWindow
    minimumWidth: 400
    minimumHeight: 720

    //flags: (Qt.platform.os === "ios") ? Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint : Qt.Window
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

    property int screenPaddingStatusbar: 0
    property int screenPaddingNavbar: 0

    property int screenPaddingTop: 0
    property int screenPaddingLeft: 0
    property int screenPaddingRight: 0
    property int screenPaddingBottom: 0

    onScreenOrientationChanged: handleSafeAreas()
    onVisibilityChanged: handleSafeAreas()

    function handleSafeAreas() {
        // safe areas are only taken into account when using maximized geometry / full screen mode
        if (appWindow.visibility === ApplicationWindow.FullScreen ||
            appWindow.flags & Qt.MaximizeUsingFullscreenGeometryHint) {

            screenPaddingStatusbar = mobileUI.statusbarHeight
            screenPaddingNavbar = mobileUI.navbarHeight

            screenPaddingTop = mobileUI.safeAreaTop
            screenPaddingLeft = mobileUI.safeAreaLeft
            screenPaddingRight = mobileUI.safeAreaRight
            screenPaddingBottom = mobileUI.safeAreaBottom

            // hacks
            if (Qt.platform.os === "android") {
                if (Screen.primaryOrientation === Qt.PortraitOrientation) {
                    screenPaddingStatusbar = mobileUI.safeAreaTop
                    screenPaddingTop = 0
                } else {
                    screenPaddingNavbar = 0
                }
            }
            if (Qt.platform.os === "ios") {
                //
            }
            if (visibility === ApplicationWindow.FullScreen) {
                screenPaddingStatusbar = 0
                screenPaddingNavbar = 0
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
        console.log("- screen width:        " + Screen.width)
        console.log("- screen width avail:  " + Screen.desktopAvailableWidth)
        console.log("- screen height:       " + Screen.height)
        console.log("- screen height avail: " + Screen.desktopAvailableHeight)
        console.log("- screen orientation:  " + Screen.orientation)
        console.log("- screen orientation (primary): " + Screen.primaryOrientation)
        console.log("- screenSizeStatusbar: " + screenPaddingStatusbar)
        console.log("- screenSizeNavbar:    " + screenPaddingNavbar)
        console.log("- screenPaddingTop:    " + screenPaddingTop)
        console.log("- screenPaddingLeft:   " + screenPaddingLeft)
        console.log("- screenPaddingRight:  " + screenPaddingRight)
        console.log("- screenPaddingBottom: " + screenPaddingBottom)
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
                mobileMenu.visible)
                return Theme.colorForeground

            return Theme.colorBackground
        }
    }

    MobileHeader {
        id: appHeader
    }
    Rectangle { // separator
        anchors.top: appHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        height: 2
        opacity: 0.66
        color: Theme.colorHeaderHighlight

        Rectangle { // shadow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: 8
            opacity: 0.66

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.colorHeaderHighlight; }
                GradientStop { position: 1.0; color: "transparent"; }
            }
        }
    }

    MobileDrawer {
        id: appDrawer
        width: (appWindow.screenOrientation === Qt.PortraitOrientation || appWindow.width < 480) ? 0.8 * appWindow.width : 0.5 * appWindow.width
        height: appWindow.height
        interactive: (appContent.state !== "Tutorial")
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

    Component.onCompleted: {
        mobileUI.isLoading = false

        if (isDesktop) {
            width = 1280
            height = 720
        }
    }

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
        if (appContent.state === "Tutorial" && screenTutorial.entryPoint === "MediaList") {
            // do nothing
            return
        }

        if (appContent.state === "Tutorial") {
            appContent.state = screenTutorial.entryPoint
        } else if (appContent.state === "Permissions") {
            appContent.state = screenPermissions.entryPoint
        } else if (appContent.state === "MediaList") {
            screenMediaList.backAction()
        } else {
            appContent.state = "MediaList"
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
        anchors.bottomMargin: mobileMenu.visible ? mobileMenu.height : 0

        focus: true
        Keys.onBackPressed: {
            if (appContent.state === "Tutorial" && screenTutorial.entryPoint === "MediaList") {
                // do nothing
                return
            }

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
        MobilePermissions {
            anchors.fill: parent
            id: screenPermissions
        }
        About {
            anchors.fill: parent
            id: screenAbout
        }

        // Start on the tutorial?
        Component.onCompleted: {
            if (settingsManager.firstLaunch) {
                screenTutorial.loadScreen()
            }
        }

        // Initial state
        state: "MediaList"

        onStateChanged: {
            screenMediaList.exitSelectionMode()

            if (state === "MediaList") {
                appHeader.leftMenuMode = "drawer"
            } else if (state === "Tutorial") {
                appHeader.leftMenuMode = "close"
            } else {
                appHeader.leftMenuMode = "back"
            }
        }

        states: [
            State {
                name: "Tutorial"
                PropertyChanges { target: appHeader; headerTitle: qsTr("Welcome"); }
                PropertyChanges { target: screenTutorial; enabled: true; visible: true; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenPermissions; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "MediaList"
                PropertyChanges { target: appHeader; headerTitle: appHeader.appName; }
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
                PropertyChanges { target: appHeader; headerTitle: qsTr("Settings"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: true; enabled: true; }
                PropertyChanges { target: screenPermissions; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "Permissions"
                PropertyChanges { target: appHeader; headerTitle: qsTr("Permissions"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenPermissions; visible: true; enabled: true; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "About"
                PropertyChanges { target: appHeader; headerTitle: qsTr("About"); }
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

        onEntered: (drag) => {
            if (drag.hasUrls) {
                dropAreaIndicator.color = Theme.colorWarning
                dropAreaImage.source = "qrc:/assets/icons_material/baseline-broken_image-24px.svg"
                dropAreaIndicator.opacity = 1

                for (var i = 0; i < drag.urls.length; i++) {
                    if (UtilsPath.isMediaFile(drag.urls[i])) {
                        dropAreaImage.source = "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                        dropAreaIndicator.color = Theme.colorGreen
                        break
                    }
                }
            }
        }
        onExited: {
            dropAreaIndicator.opacity = 0
        }
        onDropped: (drop) =>{
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

    Item {
        id: mobileMenu
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        property int hhh: (appWindow.isPhone ? 36 : 48)
        property int hhi: (hhh * 0.666)
        property int hhv: visible ? hhh : 0

        z: 10
        height: hhh + screenPaddingNavbar + screenPaddingBottom

        ////////////////////////////////////////////////////////////////////////////

        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: appWindow.isTablet ? Theme.colorTabletmenu : Theme.colorBackground
        }

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            opacity: 0.66
            visible: !appWindow.isPhone
            color: Theme.colorTabletmenuContent
        }

        // prevent clicks below this area
        MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

        ////////////////////////////////////////////////////////////////////////////

        visible: (isDesktop || isTablet) &&
                 (appContent.state !== "Tutorial" && appContent.state !== "MediaInfos")

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: (-screenPaddingNavbar -screenPaddingBottom) / 2
            spacing: (!appWindow.wideMode || (appWindow.isPhone && utilsScreen.screenSize < 5.0)) ? -8 : 24

            visible: (appContent.state === "MediaList" ||
                      appContent.state === "Settings" ||
                      appContent.state === "About")

            MobileMenuItem_horizontal {
                id: menuMedia

                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Media")
                source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                sourceSize: 24

                highlighted: (appContent.state === "MediaList")
                onClicked: appContent.state = "MediaList"
            }
            MobileMenuItem_horizontal {
                id: menuSettings

                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Settings")
                source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                sourceSize: 24

                highlighted: (appContent.state === "Settings")
                onClicked: screenSettings.loadScreen()
            }
            MobileMenuItem_horizontal {
                id: menuAbout

                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("About")
                source: "qrc:/assets/icons_material/outline-info-24px.svg"
                sourceSize: 24

                highlighted: (appContent.state === "About")
                onClicked: screenAbout.loadScreen()
            }
        }
    }

    ////////////////

    Timer {
        id: exitTimer
        interval: 3333
        running: false
        repeat: false
    }
    Rectangle {
        id: exitWarning

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.componentMargin + screenPaddingBottom

        height: Theme.componentHeight
        radius: Theme.componentRadius

        color: Theme.colorComponentBackground
        border.color: Theme.colorSeparator
        border.width: Theme.componentBorderWidth

        opacity: exitTimer.running ? 1 : 0
        Behavior on opacity { OpacityAnimator { duration: 233 } }

        Text {
            anchors.centerIn: parent

            text: qsTr("Press one more time to exit...")
            textFormat: Text.PlainText
            font.pixelSize: Theme.fontSizeContent
            color: Theme.colorText
        }
    }

    ////////////////
}
