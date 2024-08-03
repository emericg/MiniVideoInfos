import QtQuick
import QtQuick.Controls

import ThemeEngine

Loader {
    id: screenAbout
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    function loadScreen() {
        // load screen
        screenAbout.active = true

        // change screen
        appContent.state = "ScreenAbout"
    }

    function backAction() {
        if (screenAbout.status === Loader.Ready)
            screenAbout.item.backAction()
    }

    ////////////////////////////////////////////////////////////////////////////

    active: false
    asynchronous: false

    sourceComponent: Flickable {
        anchors.fill: parent
        contentWidth: -1
        contentHeight: contentColumn.height

        boundsBehavior: isDesktop ? Flickable.OvershootBounds : Flickable.DragAndOvershootBounds
        ScrollBar.vertical: ScrollBar { visible: false }

        function backAction() {
            //
        }

        Column {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right

            topPadding: 0
            bottomPadding: -1

            ////////////////

            Item { // header area
                anchors.left: parent.left
                anchors.right: parent.right

                height: 96

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.componentMargin
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 8

                    z: 2
                    height: 80
                    spacing: Theme.componentMargin

                    Image { // logo
                        anchors.verticalCenter: parent.verticalCenter
                        width: 80
                        height: 80

                        source: "qrc:/assets/gfx/logos/logo.svg"
                        sourceSize: Qt.size(width, height)
                    }

                    Column { // title
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 2

                        Text {
                            text: "MiniVideo Infos"
                            color: Theme.colorText
                            font.pixelSize: 28
                        }
                        Text {
                            color: Theme.colorSubText
                            text: qsTr("version %1 %2").arg(utilsApp.appVersion()).arg(utilsApp.appBuildMode())
                            font.pixelSize: Theme.fontSizeContentBig
                        }
                    }
                }

                ////////

                Row {
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.componentMargin
                    anchors.verticalCenter: parent.verticalCenter

                    visible: wideWideMode
                    spacing: Theme.componentMargin

                    ButtonFlat {
                        width: 160
                        sourceSize: 28

                        color: (Theme.currentTheme === ThemeEngine.THEME_NIGHT) ? Theme.colorHeader : "#5483EF"

                        text: qsTr("WEBSITE")
                        source: "qrc:/assets/icons/material-symbols/link.svg"
                        onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos")
                    }

                    ButtonFlat {
                        width: 160
                        sourceSize: 22

                        color: (Theme.currentTheme === ThemeEngine.THEME_NIGHT) ? Theme.colorHeader : "#5483EF"

                        text: qsTr("SUPPORT")
                        source: "qrc:/assets/icons/material-symbols/support.svg"
                        onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos/support.html")
                    }

                    ButtonFlat {
                        visible: (appWindow.width > 800)
                        width: 160
                        sourceSize: 22

                        color: (Theme.currentTheme === ThemeEngine.THEME_NIGHT) ? Theme.colorHeader : "#5483EF"

                        text: qsTr("GitHub")
                        source: "qrc:/assets/gfx/logos/github.svg"
                        onClicked: Qt.openUrlExternally("https://github.com/emericg/MiniVideoInfos")
                    }
                }
            }

            ////////////////

            Row { // buttons row
                height: 72

                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft + Theme.componentMargin
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight + Theme.componentMargin

                visible: !wideWideMode
                spacing: Theme.componentMargin

                ButtonFlat {
                    anchors.verticalCenter: parent.verticalCenter
                    width: ((parent.width - parent.spacing) / 2)

                    sourceSize: 28
                    color: Theme.colorHeaderContent

                    text: qsTr("WEBSITE")
                    source: "qrc:/assets/icons/material-symbols/link.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos")
                }
                ButtonFlat {
                    anchors.verticalCenter: parent.verticalCenter
                    width: ((parent.width - parent.spacing) / 2)

                    sourceSize: 22
                    color: Theme.colorHeaderContent

                    text: qsTr("SUPPORT")
                    source: "qrc:/assets/icons/material-symbols/support.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos/support.html")
                }
            }

            ////////////////

            ListItem { // description
                width: parent.width
                text: qsTr("Get detailed information about all kind of multimedia files!")
                source: "qrc:/assets/icons/material-symbols/info.svg"
            }

            ListItemClickable { // authors
                width: parent.width

                text: qsTr("Application by <a href=\"https://emeric.io\">Emeric Grange</a>")
                source: "qrc:/assets/icons/material-symbols/supervised_user_circle.svg"
                indicatorSource: "qrc:/assets/icons/material-icons/duotone/launch.svg"

                onClicked: Qt.openUrlExternally("https://emeric.io")
            }

            ListItemClickable { // rate
                width: parent.width
                visible: (Qt.platform.os === "android" || Qt.platform.os === "ios")

                text: qsTr("Rate the application")
                source: "qrc:/assets/icons/material-symbols/stars-fill.svg"
                indicatorSource: "qrc:/assets/icons/material-icons/duotone/launch.svg"

                onClicked: {
                    if (Qt.platform.os === "android")
                        Qt.openUrlExternally("market://details?id=com.minivideo.infos")
                    else if (Qt.platform.os === "ios")
                        Qt.openUrlExternally("itms-apps://itunes.apple.com/app/1476046123")
                    else
                        Qt.openUrlExternally("https://github.com/emericg/MiniVideoInfos/stargazers")
                }
            }

            ListItemClickable { // release notes
                width: parent.width

                text: qsTr("Release notes")
                source: "qrc:/assets/icons/material-symbols/new_releases.svg"
                sourceSize: 28
                indicatorSource: "qrc:/assets/icons/material-icons/duotone/launch.svg"

                onClicked: Qt.openUrlExternally("https://github.com/emericg/MiniVideoInfos/releases")
            }

            ////////////////

            ListSeparator { }

            ListItemClickable { // tutorial
                width: parent.width

                text: qsTr("Open the tutorial")
                source: "qrc:/assets/icons/material-symbols/import_contacts-fill.svg"
                sourceSize: 24
                indicatorSource: "qrc:/assets/icons/material-symbols/chevron_right.svg"

                onClicked: screenTutorial.loadScreenFrom("ScreenAbout")
            }

            ////////////////

            ListSeparator { visible: (Qt.platform.os === "android") }

            ListItemClickable { // permissions
                width: parent.width
                visible: (Qt.platform.os === "android")

                text: qsTr("About app permissions")
                sourceSize: 24
                source: "qrc:/assets/icons/material-symbols/flaky.svg"
                indicatorSource: "qrc:/assets/icons/material-symbols/chevron_right.svg"

                onClicked: screenAboutPermissions.loadScreenFrom("ScreenAbout")
            }

            ////////////////

            ListSeparator { }

            Item { // list dependencies
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft + Theme.componentMargin
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight + Theme.componentMargin

                height: 40 + dependenciesText.height + dependenciesColumn.height

                IconSvg {
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: dependenciesText.verticalCenter

                    source: "qrc:/assets/icons/material-symbols/settings.svg"
                    color: Theme.colorSubText
                }

                Text {
                    id: dependenciesText
                    anchors.top: parent.top
                    anchors.topMargin: 16
                    anchors.left: parent.left
                    anchors.leftMargin: appHeader.headerPosition - parent.anchors.leftMargin
                    anchors.right: parent.right
                    anchors.rightMargin: 8

                    text: qsTr("This application is made possible thanks to a couple of third party open source projects:")
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: Theme.fontSizeContent
                    wrapMode: Text.WordWrap
                }

                Column {
                    id: dependenciesColumn
                    anchors.top: dependenciesText.bottom
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: appHeader.headerPosition - parent.anchors.leftMargin
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    spacing: 4

                    Repeater {
                        model: [
                            "Qt6 (LGPL v3)",
                            "MiniVideo framework (GPL v3)",
                            "TagLib (LGPL v3)",
                            "libexif (LGPL v2.1)",
                            "MobileUI (MIT)",
                            "MobileSharing (MIT)",
                            "SingleApplication (MIT)",
                            "Google Material Icons (MIT)",
                            "FontAwesome Icons (CC BY 4.0)"
                        ]
                        delegate: Text {
                            width: parent.width
                            text: "- " + modelData
                            textFormat: Text.PlainText
                            color: Theme.colorSubText
                            font.pixelSize: Theme.fontSizeContent
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }

            ListSeparator { }

            ////////////////
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
