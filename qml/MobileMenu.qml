import QtQuick

import ThemeEngine

Item {
    id: mobileMenu
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    height: mainmenu_tablet.visible + mainmenu_phone.height + screenPaddingNavbar + screenPaddingBottom

    property color color: {
        if (isPhone && Qt.platform.os === "ios") return Theme.colorBackground
        if (isPhone && Theme.currentTheme === Theme.THEME_DARK) return Theme.colorForeground
        if (isPhone) return "#f0f3f8"
        return Theme.colorHeader
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle { // background
        anchors.fill: parent

        opacity: (appContent.state === "Tutorial") ? 1 : 0.90
        color: mobileMenu.color

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            visible: mainmenu_tablet.visible

            height: 2
            opacity: 0.33
            color: Theme.colorHeaderHighlight
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
                 ((appContent.state === "MediaList" && !screenMediaList.dialogIsOpen) ||
                  appContent.state === "ScreenSettings" ||
                  appContent.state === "ScreenAbout")

        Row { // main menu
            anchors.centerIn: parent

            spacing: (!appWindow.wideMode || (appWindow.isPhone && utilsScreen.screenSize < 5.0)) ? -8 : 24

            MobileMenuItem_horizontal {
                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Media")
                source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                sourceSize: 24

                highlighted: (appContent.state === "MediaList")
                onClicked: appContent.state = "MediaList"
            }
            MobileMenuItem_horizontal {
                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Settings")
                source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenSettings")
                onClicked: screenSettings.loadScreen()
            }
            MobileMenuItem_horizontal {
                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("About")
                source: "qrc:/assets/icons_material/outline-info-24px.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenAbout")
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
                 ((appContent.state === "MediaList" && !screenMediaList.dialogIsOpen) ||
                  appContent.state === "ScreenSettings" ||
                  appContent.state === "ScreenAbout")

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
                source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                sourceSize: 24

                highlighted: (appContent.state === "MediaList")
                onClicked: appContent.state = "MediaList"
            }
            MobileMenuItem_vertical {
                width: 56
                height: 56

                colorContent: Theme.colorTabletmenuContent
                colorHighlight: Theme.colorTabletmenuHighlight

                text: qsTr("Settings")
                source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
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
                source: "qrc:/assets/icons_material/outline-info-24px.svg"
                sourceSize: 24

                highlighted: (appContent.state === "ScreenAbout")
                onClicked: screenAbout.loadScreen()
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
