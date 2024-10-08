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
            anchors.leftMargin: screenPaddingLeft
            anchors.right: parent.right
            anchors.rightMargin: screenPaddingRight

            topPadding: 0
            bottomPadding: -1

            ////////////////

            Item { // header area (tablet?)
                anchors.left: parent.left
                anchors.right: parent.right

                height: 96
                visible: !isPhone

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
                        width: isPhone ? 150 : 160

                        text: qsTr("WEBSITE")
                        source: "qrc:/assets/icons/material-symbols/link.svg"
                        sourceSize: 28
                        color: (Theme.currentTheme === ThemeEngine.THEME_NIGHT) ? Theme.colorHeader : "#5483EF"

                        onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos")
                    }

                    ButtonFlat {
                        width: isPhone ? 150 : 160

                        text: qsTr("SUPPORT")
                        source: "qrc:/assets/icons/material-symbols/support.svg"
                        sourceSize: 22
                        color: (Theme.currentTheme === ThemeEngine.THEME_NIGHT) ? Theme.colorHeader : "#5483EF"

                        onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos/support.html")
                    }

                    ButtonFlat {
                        width: isPhone ? 150 : 160
                        visible: (appWindow.width > 800)

                        text: qsTr("GitHub")
                        source: "qrc:/assets/gfx/logos/github.svg"
                        sourceSize: 22
                        color: (Theme.currentTheme === ThemeEngine.THEME_NIGHT) ? Theme.colorHeader : "#5483EF"

                        onClicked: Qt.openUrlExternally("https://github.com/emericg/MiniVideoInfos")
                    }
                }
            }

            Item { // header area (mobile)
                anchors.left: parent.left
                anchors.leftMargin: Theme.componentMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.componentMargin
                height: 112

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 88
                    radius: 6
                    color: Theme.colorForeground

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter

                        z: 2
                        height: 72
                        spacing: Theme.componentMargin

                        Image { // logo
                            width: 72
                            height: 72

                            source: "qrc:/assets/gfx/logos/logo.svg"
                            sourceSize: Qt.size(width, height)
                        }

                        Column { // title
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 0

                            Text {
                                text: utilsApp.appName()
                                textFormat: Text.PlainText
                                color: Theme.colorText
                                font.pixelSize: Theme.fontSizeTitle
                            }
                            Text {
                                color: Theme.colorSubText
                                text: qsTr("version %1 %2").arg(utilsApp.appVersion()).arg(utilsApp.appBuildMode())
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContentBig
                            }
                        }
                    }
                }
            }

            ////////////////

            Row { // buttons row
                height: 72

                anchors.left: parent.left
                anchors.leftMargin: Theme.componentMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.componentMargin

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

            ListSeparator { }

            ////////////////

            ListItemClickable { // tutorial
                width: parent.width

                text: qsTr("Open the tutorial")
                source: "qrc:/assets/icons/material-symbols/import_contacts-fill.svg"
                sourceSize: 24
                indicatorSource: "qrc:/assets/icons/material-symbols/chevron_right.svg"

                onClicked: screenTutorial.loadScreenFrom("ScreenAbout")
            }

            ListSeparator { }

            ////////////////

            ListItemClickable { // permissions
                width: parent.width
                visible: (Qt.platform.os === "android")

                text: qsTr("About app permissions")
                sourceSize: 24
                source: "qrc:/assets/icons/material-symbols/flaky.svg"
                indicatorSource: "qrc:/assets/icons/material-symbols/chevron_right.svg"

                onClicked: screenAboutPermissions.loadScreenFrom("ScreenAbout")
            }

            ListSeparator { visible: (Qt.platform.os === "android") }

            ////////////////

            Item { // list dependencies
                anchors.left: parent.left
                anchors.leftMargin: Theme.componentMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.componentMargin

                height: 32 + dependenciesText.height + dependenciesColumn.height

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
                            "Bootstrap Icons (MIT)",
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

            Item { // list debug infos
                anchors.left: parent.left
                anchors.leftMargin: Theme.componentMargin
                anchors.right: parent.right
                anchors.rightMargin: Theme.componentMargin

                height: 32 + debugColumn.height
                visible: utilsApp.isDebug

                IconSvg {
                    anchors.top: debugColumn.top
                    anchors.topMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    width: 24
                    height: 24

                    source: "qrc:/assets/icons/material-symbols/info.svg"
                    color: Theme.colorSubText
                }

                Column {
                    id: debugColumn
                    anchors.left: parent.left
                    anchors.leftMargin: appHeader.headerPosition - parent.anchors.leftMargin
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    spacing: Theme.componentMargin * 0.33

                    Text {
                        color: Theme.colorSubText
                        text: "App name: %1".arg(utilsApp.appName())
                        textFormat: Text.PlainText
                        font.pixelSize: Theme.fontSizeContent
                    }
                    Text {
                        color: Theme.colorSubText
                        text: "App version: %1".arg(utilsApp.appVersion())
                        textFormat: Text.PlainText
                        font.pixelSize: Theme.fontSizeContent
                    }
                    Text {
                        color: Theme.colorSubText
                        text: "Build mode: %1".arg(utilsApp.appBuildModeFull())
                        textFormat: Text.PlainText
                        font.pixelSize: Theme.fontSizeContent
                    }
                    Text {
                        color: Theme.colorSubText
                        text: "Build architecture: %1".arg(utilsApp.qtArchitecture())
                        textFormat: Text.PlainText
                        font.pixelSize: Theme.fontSizeContent
                    }
                    Text {
                        color: Theme.colorSubText
                        text: "Build date: %1".arg(utilsApp.appBuildDateTime())
                        textFormat: Text.PlainText
                        font.pixelSize: Theme.fontSizeContent
                    }
                    Text {
                        color: Theme.colorSubText
                        text: "Qt version: %1".arg(utilsApp.qtVersion())
                        textFormat: Text.PlainText
                        font.pixelSize: Theme.fontSizeContent
                    }
                }
            }

            ListSeparator { visible: utilsApp.isDebug }

            ////////////////
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
