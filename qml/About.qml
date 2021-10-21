import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item {
    id: aboutScreen
    width: 480
    height: 720
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleHeader
        color: Theme.colorForeground
        height: 80
        z: 5

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        // prevent clicks into this area
        MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

        Image {
            id: imageLogo
            width: 64
            height: 64
            anchors.left: parent.left
            anchors.leftMargin: screenPaddingLeft + 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -4

            source: "qrc:/assets/logos/logo.svg"
            sourceSize: Qt.size(width, height)
        }

        Column {
            anchors.left: imageLogo.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -4

            Text {
                text: "MiniVideo Infos"
                textFormat: Text.PlainText
                color: Theme.colorText
                font.pixelSize: 28
            }

            Text {
                text: qsTr("version %1 %2").arg(utilsApp.appVersion()).arg(utilsApp.appBuildMode())
                textFormat: Text.PlainText
                color: Theme.colorSubText
                font.pixelSize: 18
            }
        }

        Rectangle {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
        }
        SimpleShadow {
            height: 4
            anchors.top: parent.bottom
            anchors.topMargin: -height
            anchors.left: parent.left
            anchors.right: parent.right
            color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ScrollView {
        contentWidth: -1

        anchors.top: rectangleHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Column {
            anchors.fill: parent
            anchors.leftMargin: screenPaddingLeft + 16
            anchors.rightMargin: screenPaddingRight + 16

            topPadding: 8
            bottomPadding: 8
            spacing: 8

            ////////
/*
            ListView {
                // helper to list available fonts
                anchors.fill: parent;
                model: Qt.fontFamilies()

                delegate: Item {
                    height: 40;
                    width: ListView.view.width
                    Text {
                        anchors.centerIn: parent
                        text: modelData;
                    }
                }
            }
*/
            ////////

            Row {
                id: buttonsRow
                height: 56

                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                visible: isMobile || isDesktop
                spacing: 16

                ButtonWireframeImage {
                    id: websiteBtn
                    width: ((parent.width - 16) / 2)
                    anchors.verticalCenter: parent.verticalCenter

                    imgSize: 26
                    fullColor: true
                    primaryColor: Theme.colorHeaderContent

                    text: qsTr("WEBSITE")
                    source: "qrc:/assets/icons_material/baseline-insert_link-24px.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos")
                }
                ButtonWireframeImage {
                    id: supportBtn
                    width: ((parent.width - 16) / 2)
                    anchors.verticalCenter: parent.verticalCenter

                    imgSize: 20
                    fullColor: true
                    primaryColor: Theme.colorHeaderContent

                    text: qsTr("SUPPORT")
                    source: "qrc:/assets/icons_material/baseline-support-24px.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos/support.html")
                }
            }

            ////////

            Item { height: 1; width: 1; visible: isDesktop; } // spacer

            Item {
                id: desc
                height: Math.max(UtilsNumber.alignTo(description.contentHeight, 8), 48)
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: descImg
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: desc.verticalCenter

                    source: "qrc:/assets/icons_material/outline-info-24px.svg"
                    color: Theme.colorText
                }

                Text {
                    id: description
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: desc.verticalCenter

                    text: qsTr("Get detailed informations about all kind of multimedia files!")
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                    color: Theme.colorText
                    font.pixelSize: Theme.fontSizeContent
                }
            }

            ////////

            Item {
                id: tuto
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    width: 27
                    height: 27
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-import_contacts-24px.svg"
                    color: Theme.colorText
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Open the tutorial")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: screenTutorial.reopen()
                }
            }

            ////////

            Item {
                id: authors
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    width: 31
                    height: 31
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-supervised_user_circle-24px.svg"
                    color: Theme.colorText
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorText
                    linkColor: Theme.colorText
                    font.pixelSize: Theme.fontSizeContent
                    text: qsTr("Application by <a href=\"https://emeric.io\">Emeric Grange</a>")
                    onLinkActivated: Qt.openUrlExternally(link)

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -12
                        acceptedButtons: Qt.NoButton
                        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }

                ImageSvg {
                    width: 20
                    height: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    visible: singleColumn
                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/duotone-launch-24px.svg"
                }
            }

            ////////

            Item {
                id: rate
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                //visible: isMobile

                ImageSvg {
                    width: 31
                    height: 31
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-stars-24px.svg"
                    color: Theme.colorText
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Rate the application")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                }

                ImageSvg {
                    width: 20
                    height: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    visible: singleColumn
                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/duotone-launch-24px.svg"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (Qt.platform.os === "android")
                            Qt.openUrlExternally("market://details?id=com.minivideo.infos")
                        else if (Qt.platform.os === "ios")
                            Qt.openUrlExternally("itms-apps://itunes.apple.com/app/1476046123")
                        else
                            Qt.openUrlExternally("https://github.com/emericg/MiniVideoInfos/stargazers")
                    }
                }
            }

            ////////

            Item {
                height: 16
                anchors.left: parent.left
                anchors.right: parent.right

                visible: (Qt.platform.os === "android")

                Rectangle {
                    height: 1
                    color: Theme.colorSeparator
                    anchors.left: parent.left
                    anchors.leftMargin: -(screenPaddingLeft + 16)
                    anchors.right: parent.right
                    anchors.rightMargin: -(screenPaddingRight + 16)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: permissions
                height: 32
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                visible: (Qt.platform.os === "android")

                ImageSvg {
                    id: permissionsImg
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-flaky-24px.svg"
                    color: Theme.colorText
                }

                Text {
                    id: permissionsTxt
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("About permissions")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                }

                ImageSvg {
                    width: 24
                    height: 24
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-chevron_right-24px.svg"
                    color: Theme.colorText
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: screenPermissions.loadScreen()
                }
            }

            ////////

            Item {
                height: 16
                anchors.left: parent.left
                anchors.right: parent.right

                Rectangle {
                    height: 1
                    color: Theme.colorSeparator
                    anchors.left: parent.left
                    anchors.leftMargin: -(screenPaddingLeft + 16)
                    anchors.right: parent.right
                    anchors.rightMargin: -(screenPaddingRight + 16)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Item {
                id: dependencies
                height: 24 + dependenciesLabel.height + dependenciesColumn.height
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: dependenciesImg
                    width: 24
                    height: 24
                    anchors.top: parent.top
                    anchors.topMargin: 12
                    anchors.left: parent.left
                    anchors.leftMargin: 4

                    source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                    color: Theme.colorText
                }

                Text {
                    id: dependenciesLabel
                    anchors.top: parent.top
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    text: qsTr("This application is made possible thanks to a couple of third party open source projects:")
                    textFormat: Text.PlainText
                    color: Theme.colorText
                    font.pixelSize: Theme.fontSizeContent
                    wrapMode: Text.WordWrap
                }

                Column {
                    id: dependenciesColumn
                    anchors.top: dependenciesLabel.bottom
                    anchors.topMargin: 8
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    spacing: 4

                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: "- Material Icons and FontAwesome"
                        textFormat: Text.PlainText
                        color: Theme.colorText
                        font.pixelSize: Theme.fontSizeContent
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: "- MiniVideo framework"
                        textFormat: Text.PlainText
                        color: Theme.colorText
                        font.pixelSize: Theme.fontSizeContent
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: "- TagLib"
                        textFormat: Text.PlainText
                        color: Theme.colorText
                        font.pixelSize: Theme.fontSizeContent
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: "- libexif"
                        textFormat: Text.PlainText
                        color: Theme.colorText
                        font.pixelSize: Theme.fontSizeContent
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: "- Qt"
                        textFormat: Text.PlainText
                        color: Theme.colorText
                        font.pixelSize: Theme.fontSizeContent
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }
}
