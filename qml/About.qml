import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0

Item {
    id: aboutScreen
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenLeftPadding
    anchors.rightMargin: screenRightPadding

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleHeader
        color: Theme.colorForeground
        height: 96
        z: 5

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Image {
            id: imageLogo
            width: 64
            height: 64
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            source: "qrc:/assets/logos/logo.svg"
            sourceSize: Qt.size(width, height)
        }

        Column {
            anchors.left: imageLogo.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 2

            Text {
                id: textName

                text: "MiniVideo Infos"
                color: Theme.colorText
                font.pixelSize: 28
            }

            Text {
                id: textVersion

                text: qsTr("version %1").arg(utilsApp.appVersion())
                color: Theme.colorSubText
                font.pixelSize: 18
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ScrollView {
        id: scrollView
        contentWidth: -1

        anchors.top: rectangleHeader.bottom
        anchors.topMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.right: parent.right

        Column {
            id: column
            spacing: 8
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.rightMargin: 16
            anchors.leftMargin: 16
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
            Row {
                id: websiteANDgithub
                height: 56

                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                //visible: isMobile
                spacing: 16

                onWidthChanged: {
                    var ww = (scrollView.width - 48 - screenLeftPadding - screenRightPadding) / 2
                    if (ww > 0) { websiteBtn.width = ww ; supportBtn.width = ww }
                }

                ButtonWireframeImage {
                    id: websiteBtn
                    width: 180
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("WEBSITE")
                    imgSize: 26
                    fullColor: true
                    primaryColor: Theme.colorHeaderContent
                    source: "qrc:/assets/icons_material/baseline-insert_link-24px.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos")
                }
                ButtonWireframeImage {
                    id: supportBtn
                    width: 180
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("SUPPORT")
                    imgSize: 20
                    fullColor: true
                    primaryColor: Theme.colorHeaderContent
                    source: "qrc:/assets/icons_material/outline-mail_outline-24px.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos/support.html")
                }
            }

            Item {
                id: desc
                height: 48
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
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/outline-info-24px.svg"
                    color: Theme.colorText
                }

                TextArea {
                    id: description
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorText
                    text: qsTr("Get detailed informations about all kind of multimedia files!")
                    wrapMode: Text.WordWrap
                    readOnly: true
                    font.pixelSize: 16
                }
            }

            Item {
                id: authors
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: authorImg
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
                    font.pixelSize: 16
                    text: qsTr("Application by <a href=\"https://emeric.io\">Emeric Grange</a>")
                    onLinkActivated: Qt.openUrlExternally(link)

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton
                        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
            }

            Item {
                id: rate
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                //visible: (Qt.platform.os === "android" || Qt.platform.os === "ios")

                ImageSvg {
                    id: rateImg
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
                    color: Theme.colorText
                    font.pixelSize: 16

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
            }

            Item {
                id: tuto
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: tutoImg
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
                    color: Theme.colorText
                    font.pixelSize: 16

                    MouseArea {
                        anchors.fill: parent
                        onClicked: screenTutorial.reopen("About")
                    }
                }
            }

            ////////

            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
            }

            ////////

            Item {
                id: dependencies
                height: 96
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: dependenciesImg
                    width: 27
                    height: 27
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    anchors.top: parent.top
                    anchors.topMargin: 12

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

                    text: qsTr("This application is made possible thanks to a  couple of third party open source projects:")
                    wrapMode: Text.WordWrap
                    color: Theme.colorText
                    font.pixelSize: 16
                }

                Column {
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

                        text: qsTr("- Material Icons and FontAwesome")
                        wrapMode: Text.WordWrap
                        color: Theme.colorText
                        font.pixelSize: 16
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: qsTr("- MiniVideo framework")
                        color: Theme.colorText
                        font.pixelSize: 16
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: qsTr("- TagLib")
                        color: Theme.colorText
                        font.pixelSize: 16
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: qsTr("- libexif")
                        color: Theme.colorText
                        font.pixelSize: 16
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.rightMargin: 12

                        text: qsTr("- Qt")
                        color: Theme.colorText
                        font.pixelSize: 16
                    }
                }
            }
        }
    }
}
