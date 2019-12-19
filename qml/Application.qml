import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.0
import QtQuick.Window 2.2

import ThemeEngine 1.0
import StatusBar 0.1
import "qrc:/js/UtilsPath.js" as UtilsPath

ApplicationWindow {
    id: applicationWindow
    minimumWidth: 480
    minimumHeight: 900

    visible: true
    color: Theme.colorBackground
    flags: Qt.Window

    property bool isHdpi: (screen.screenDpi > 128)
    property bool isDesktop: (Qt.platform.os !== "ios" && Qt.platform.os !== "android")
    property bool isMobile: (Qt.platform.os === "ios" || Qt.platform.os === "android")
    property bool isPhone: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (screen.screenSize < 7.0))
    property bool isTablet: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (screen.screenSize >= 7.0))

    // Mobile stuff ////////////////////////////////////////////////////////////

    // 1 = Qt::PortraitOrientation, 2 = Qt::LandscapeOrientation
    property int screenOrientation: Screen.primaryOrientation

    property int screenStatusbarPadding: 0
    property int screenNotchPadding: 0
    property int screenLeftPadding: 0
    property int screenRightPadding: 0

    onScreenOrientationChanged: handleNotches()

    Component.onCompleted: firstHandleNotches.restart()
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

        var safeMargins = settingsManager.getSafeAreaMargins(quickWindow)
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

    StatusBar {
        id: statusbar
        theme: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Material.Dark : Material.Light
        color: Theme.colorHeaderStatusbar
    }

    MobileHeader {
        id: appHeader
        width: parent.width
        anchors.top: parent.top
    }

    Drawer {
        id: appDrawer
        width: (Screen.primaryOrientation === 1) ? 0.80 * applicationWindow.width : 0.60 * applicationWindow.width
        height: applicationWindow.height

        background: Rectangle {
            Rectangle {
                x: parent.width - 1
                width: 1
                height: parent.height
                color: Theme.colorSeparator
            }
        }

        MobileDrawer { id: drawerscreen }
    }

    // Events handling /////////////////////////////////////////////////////////

    Connections {
        target: appHeader
        onLeftMenuClicked: {
            if (appHeader.leftMenuMode === "drawer")
                appDrawer.open()
            else {
                appContent.state = "MediaList"
                screenMediaList.closeDialog()
            }
        }
        onRightMenuClicked: {
            //
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
            if (Qt.platform.os === "android" || Qt.platform.os === "ios") {
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
                    appContent.state = "MediaList"
                }
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
        About {
            anchors.fill: parent
            id: screenAbout
        }

        // Initial state
        state: settingsManager.firstLaunch ? "Tutorial" : "MediaList"

        onStateChanged: {
            if (state === "MediaList")
                appHeader.leftMenuMode = "drawer"
            else if (state === "Tutorial")
                appHeader.leftMenuMode = "close"
            else
                appHeader.leftMenuMode = "back"

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
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "MediaList"
                PropertyChanges { target: appHeader; title: "MiniVideo Infos"; }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: true; visible: true; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "MediaInfos"
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: true; visible: true; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "Settings"
                PropertyChanges { target: appHeader; title: qsTr("Settings"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: true; enabled: true; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "About"
                PropertyChanges { target: appHeader; title: qsTr("About"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaList; enabled: false; visible: false; }
                PropertyChanges { target: screenMediaInfos; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: true; enabled: true; }
            }
        ]
    }

    ////////////////

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton | Qt.ForwardButton
        onClicked: {
            if (appContent.state === "Tutorial") return;

            if (mouse.button === Qt.BackButton) {
                appContent.state = "MediaList"
            } else if (mouse.button === Qt.ForwardButton) {
                if (appContent.state === "MediaList")
                    //if (currentDevice)
                        appContent.state = "MediaInfos"
            }
        }
    }
    Shortcut {
        sequence: StandardKey.Back
        onActivated: {
            if (appContent.state === "Tutorial" || appContent.state === "MediaList") return;
            appContent.state = "MediaList"
        }
    }
    Shortcut {
        sequence: StandardKey.Forward
        onActivated: {
            if (appContent.state !== "MediaList") return;
            appContent.state = "MediaInfos"
        }
    }

    ////////////////

    DropArea {
        id: dropArea
        anchors.fill: parent
        //keys: ["text/plain"]

        onEntered: {
            if (drag.hasUrls) {
                dropAreaIndicator.color = Theme.colorRed
                dropAreaImage.source = "qrc:/assets/icons_material_medias/baseline-broken_image-24px.svg"
                dropAreaIndicator.visible = true
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
            dropAreaIndicator.visible = false
            dropAreaIndicator.opacity = 0

            if (drop.hasUrls) {
                for (var i = 0; i < drop.urls.length; i++) {
                    if (UtilsPath.isMediaFile(drop.urls[i])) {
                        //console.log("DropArea::onDropped() << " + drop.urls[i])
                        screenMediaList.loadMedia(UtilsPath.cleanUrl(drop.urls[i]))
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
            //anchors.verticalCenterOffset: 0

            color: Theme.colorForeground
            opacity: 0
            Behavior on opacity { OpacityAnimator { duration: 333 } }

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

    ////////////////

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

        visible: isTablet && (appContent.state != "Tutorial" && appContent.state != "DeviceThermo")

        Row {
            id: tabletMenuScreen
            spacing: 24
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            visible: (appContent.state === "MediaList" ||
                      appContent.state === "Settings" ||
                      appContent.state === "About")

            ItemMenuButton {
                id: menuMedias
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("Medias")
                selected: (appContent.state === "MediaList")
                source: "qrc:/assets/logos/logo.svg"
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
/*
        Row {
            id: tabletMenuDevice
            spacing: 24
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            signal deviceDatasButtonClicked()
            signal deviceHistoryButtonClicked()
            signal deviceSettingsButtonClicked()

            visible: (appContent.state === "DeviceSensor")

            function setActiveDeviceDatas() {
                menuDeviceDatas.selected = true
                menuDeviceHistory.selected = false
                menuDeviceSettings.selected = false
            }
            function setActiveDeviceHistory() {
                menuDeviceDatas.selected = false
                menuDeviceHistory.selected = true
                menuDeviceSettings.selected = false
            }
            function setActiveDeviceSettings() {
                menuDeviceDatas.selected = false
                menuDeviceHistory.selected = false
                menuDeviceSettings.selected = true
            }

            ItemMenuButton {
                id: menuDeviceDatas
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("My plants")
                selected: (appContent.state === "DeviceSensor" && appContent.state === "MediaList")
                source: "qrc:/assets/icons_material/duotone-insert_chart_outlined-24px.svg"
                onClicked: tabletMenuDevice.deviceDatasButtonClicked()
            }
            ItemMenuButton {
                id: menuDeviceHistory
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("History")
                selected: (appContent.state === "About")
                source: "qrc:/assets/icons_material/baseline-date_range-24px.svg"
                onClicked: tabletMenuDevice.deviceHistoryButtonClicked()
            }
            ItemMenuButton {
                id: menuDeviceSettings
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("Settings")
                selected: (appContent.state === "About")
                source: "qrc:/assets/icons_material_medias/baseline-iso-24px.svg"
                onClicked: tabletMenuDevice.deviceSettingsButtonClicked()
            }
        }
*/
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
