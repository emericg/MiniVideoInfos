import QtQuick
import QtQuick.Controls

import ThemeEngine

Item {
    id: mobileMenu
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    height: (mainmenu.visible ? mainmenu.height : 0) + screenPaddingNavbar + screenPaddingBottom

    ////////////////////////////////////////////////////////////////////////////

    Rectangle { // background
        anchors.fill: parent

        opacity: (appContent.state === "Tutorial") ? 1 : 0.85
        color: (isPhone && Qt.platform.os === "ios") ? Theme.colorBackground : Theme.colorHeader

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2
            opacity: 0.33
            color: Theme.colorHeaderHighlight
            visible: mainmenu.visible
        }
    }

    // prevent clicks below this area
    MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

    ////////////////////////////////////////////////////////////////////////////

    Item { // main menu
        id: mainmenu
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: (appWindow.isPhone ? 34 : 48)
        visible: ((appContent.state === "MediaList" && !screenMediaList.dialogIsOpen) ||
                  appContent.state === "ScreenSettings" ||
                  appContent.state === "ScreenAbout")

        Row { // main menu
            anchors.centerIn: parent

            spacing: (!appWindow.wideMode || (appWindow.isPhone && utilsScreen.screenSize < 5.0)) ? -8 : 24

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

                highlighted: (appContent.state === "ScreenSettings")
                onClicked: screenSettings.loadScreen()
            }
            MobileMenuItem_horizontal {
                id: menuAbout

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
