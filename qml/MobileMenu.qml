import QtQuick

import ThemeEngine

Item {
    id: mobileMenu

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    height: (appWindow.screenOrientation === Qt.PortraitOrientation) ?
                mainmenu_tablet.height + mainmenu_phone.height + screenPaddingNavbar + screenPaddingBottom : 0

    property color color: {
        if (appContent.state === "ScreenTutorial") return Theme.colorHeader
        if (isPhone && Qt.platform.os === "ios") return Theme.colorBackground
        if (isPhone && Theme.isDark) return Theme.colorForeground
        return Theme.colorTabletmenu
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle { // background
        anchors.fill: parent

        opacity: 0.95
        color: mobileMenu.color

        Rectangle { // tablet separator
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2

            visible: mainmenu_tablet.visible
            color: Theme.colorHeaderHighlight
            opacity: 0.33
        }
        Rectangle { // phone separator
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2

            visible: mainmenu_phone.visible
            color: Theme.colorSeparator
        }
    }

    // prevent clicks below this area
    MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

    ////////////////////////////////////////////////////////////////////////////

    Item { // menu area (tablet)
        id: mainmenu_tablet
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: visible ? 48 : 0
        visible: isTablet &&
                 ((appContent.state === "ScreenMediaList" && !screenMediaList.dialogIsOpen) ||
                  appContent.state === "ScreenSettings" ||
                  appContent.state === "ScreenAbout" ||
                  appContent.state === "ScreenAboutPermissions")

        Row { // main menu
            anchors.centerIn: parent

            spacing: (!appWindow.wideMode || (appWindow.isPhone && utilsScreen.screenSize < 5.0)) ? -8 : 24

            MobileMenuItem_horizontal {
                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Media")
                source: "qrc:/assets/icons/fontawesome/photo-video-duotone.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenMediaList")
                onClicked: appContent.state = "ScreenMediaList"
            }
            MobileMenuItem_horizontal {
                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Settings")
                source: "qrc:/assets/icons/material-icons/duotone/tune.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenSettings")
                onClicked: screenSettings.loadScreen()
            }
            MobileMenuItem_horizontal {
                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("About")
                source: "qrc:/assets/icons/material-symbols/info.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenAbout" ||
                              appContent.state === "ScreenAboutPermissions")
                onClicked: screenAbout.loadScreen()
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Item { // menu area (phone)
        id: mainmenu_phone
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: visible ? 56 : 0
        visible: isPhone &&
                 ((appContent.state === "ScreenMediaList" && !screenMediaList.dialogIsOpen) ||
                  appContent.state === "ScreenSettings" ||
                  appContent.state === "ScreenAbout" ||
                  appContent.state === "ScreenAboutPermissions")

        Row { // main menu
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: isPhone ? 3 : 0

            spacing: Theme.componentMargin

            MobileMenuItem_vertical {
                width: 56
                height: 56

                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Media")
                source: "qrc:/assets/icons/fontawesome/photo-video-duotone.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenMediaList")
                onClicked: appContent.state = "ScreenMediaList"
            }
            MobileMenuItem_vertical {
                width: 56
                height: 56

                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Settings")
                source: "qrc:/assets/icons/material-icons/duotone/tune.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenSettings")
                onClicked: screenSettings.loadScreen()
            }
            MobileMenuItem_vertical {
                width: 56
                height: 56

                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("About")
                source: "qrc:/assets/icons/material-symbols/info.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenAbout" ||
                              appContent.state === "ScreenAboutPermissions")
                onClicked: screenAbout.loadScreen()
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
