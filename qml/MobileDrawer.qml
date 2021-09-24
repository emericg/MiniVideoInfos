import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

Drawer {
    width: parent.width*0.8
    height: parent.height

    ////////////////////////////////////////////////////////////////////////////

    background: Rectangle {
        color: Theme.colorBackground

        Rectangle {
            x: parent.width - 1
            width: 1
            height: parent.height
            color: Theme.colorSeparator
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    contentItem: Item {

        Column {
            id: rectangleHeader
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            z: 5

            Connections {
                target: appWindow
                onScreenPaddingStatusbarChanged: rectangleHeader.updateIOSHeader()
            }
            Connections {
                target: Theme
                onCurrentThemeChanged: rectangleHeader.updateIOSHeader()
            }

            function updateIOSHeader() {
                if (Qt.platform.os === "ios") {
                    if (screenPaddingStatusbar != 0)
                        rectangleStatusbar.height = screenPaddingStatusbar
                    else
                        rectangleStatusbar.height = 0
                }
            }

            ////////

            Rectangle {
                id: rectangleStatusbar
                anchors.left: parent.left
                anchors.right: parent.right
                color: Theme.colorBackground // "red" // to hide scrollview content
                height: screenPaddingStatusbar
            }
            Rectangle {
                id: rectangleNotch
                anchors.left: parent.left
                anchors.right: parent.right
                color: Theme.colorBackground // "yellow" // to hide scrollview content
                height: screenPaddingNotch
            }
            Rectangle {
                id: rectangleLogo
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                color: Theme.colorBackground
                height: 80

                Image {
                    id: imageHeader
                    width: 40
                    height: 40
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/logos/logo.svg"
                    sourceSize: Qt.size(width, height)
                }
                Text {
                    id: textHeader
                    anchors.top: imageHeader.top
                    anchors.left: imageHeader.right
                    anchors.leftMargin: 12
                    anchors.bottom: imageHeader.bottom

                    text: "MiniVideo Infos"
                    color: Theme.colorText
                    font.bold: true
                    font.pixelSize: Theme.fontSizeHeader
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        MouseArea { anchors.fill: rectangleHeader; acceptedButtons: Qt.AllButtons; }

        ////////////////

        ScrollView {
            id: scrollView
            contentWidth: -1

            anchors.top: rectangleHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Column {
                anchors.fill: parent

                ////////

                Rectangle {
                    id: rectangleLoad
                    height: 48
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: (appContent.state === "MediaList" && screenMediaList.dialogIsOpen) ? Theme.colorForeground : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            appContent.state = "MediaList"
                            screenMediaList.openDialog()
                            appDrawer.close()
                        }
                    }

                    ImageSvg {
                        id: buttonLoadImg
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 16
                        anchors.verticalCenter: parent.verticalCenter

                        source: "qrc:/assets/icons_material/duotone-library_add-24px.svg"
                        color: Theme.colorText
                    }
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("Open media")
                        font.pixelSize: 13
                        font.bold: true
                        color: Theme.colorText
                    }
                }

                ////////

                Rectangle {
                    id: rectangleHome
                    height: 48
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: (appContent.state === "MediaList" && !screenMediaList.dialogIsOpen) ? Theme.colorForeground : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            appContent.state = "MediaList"
                            screenMediaList.closeDialog()
                            appDrawer.close()
                        }
                    }

                    ImageSvg {
                        id: buttonMediaImg
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 16
                        anchors.verticalCenter: parent.verticalCenter

                        source: "qrc:/assets/icons_material/outline-insert_photo-24px.svg"
                        color: Theme.colorText
                    }
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("Media")
                        font.pixelSize: 13
                        font.bold: true
                        color: Theme.colorText
                    }
                }

                ////////

                Loader {
                    id: miniList
                    anchors.left: parent.left
                    anchors.right: parent.right
                    source: isPhone ? "" : "MiniList.qml"
                    visible: !isPhone && mediaManager.mediaList.length
                }

                ////////

                Item { // spacer
                    height: 8
                    anchors.left: parent.left
                    anchors.right: parent.right
                }
                Rectangle {
                    height: 1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: Theme.colorSeparator
                }
                Item {
                    height: 8
                    anchors.left: parent.left
                    anchors.right: parent.right
                }

                ////////
/*
                Rectangle {
                    id: rectangleTool1
                    height: 48
                    anchors.right: parent.right
                    anchors.left: parent.left
                    color: (appContent.state === "Tool1") ? Theme.colorForeground : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            appContent.state = "Tool1"
                            appDrawer.close()
                        }
                    }

                    ImageSvg {
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 16
                        anchors.verticalCenter: parent.verticalCenter

                        source: "qrc:/assets/icons_material/outline-settings-24px.svg"
                        color: Theme.colorText
                    }
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("Tool1")
                        font.pixelSize: 13
                        font.bold: true
                        color: Theme.colorText
                    }
                }

                Rectangle {
                    id: rectangleTool2
                    height: 48
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: (appContent.state === "Tool2") ? Theme.colorForeground : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            appContent.state = "Tool2"
                            appDrawer.close()
                        }
                    }

                    ImageSvg {
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 16
                        anchors.verticalCenter: parent.verticalCenter

                        source: "qrc:/assets/icons_material/outline-settings-24px.svg"
                        color: Theme.colorText
                    }
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("Tool2")
                        font.pixelSize: 13
                        font.bold: true
                        color: Theme.colorText
                    }
                }

                Item { // spacer
                    height: 8
                    anchors.right: parent.right
                    anchors.left: parent.left
                }
                Rectangle {
                    height: 1
                    anchors.right: parent.right
                    anchors.left: parent.left
                    color: Theme.colorSeparator
                }
                Item {
                    height: 8
                    anchors.right: parent.right
                    anchors.left: parent.left
                }
*/
                ////////

                Rectangle {
                    id: rectangleSettings
                    height: 48
                    anchors.right: parent.right
                    anchors.left: parent.left
                    color: (appContent.state === "Settings") ? Theme.colorForeground : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            appContent.state = "Settings"
                            appDrawer.close()
                        }
                    }

                    ImageSvg {
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 16
                        anchors.verticalCenter: parent.verticalCenter

                        source: "qrc:/assets/icons_material/outline-settings-24px.svg"
                        color: Theme.colorText
                    }
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("Settings")
                        font.pixelSize: 13
                        font.bold: true
                        color: Theme.colorText
                    }
                }

                ////////

                Rectangle {
                    id: rectangleAbout
                    height: 48
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: (appContent.state === "About") ? Theme.colorForeground : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            appContent.state = "About"
                            appDrawer.close()
                        }
                    }

                    ImageSvg {
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 16
                        anchors.verticalCenter: parent.verticalCenter

                        source: "qrc:/assets/icons_material/outline-info-24px.svg"
                        color: Theme.colorText
                    }
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("About")
                        font.pixelSize: 13
                        font.bold: true
                        color: Theme.colorText
                    }
                }

                ////////

                Item { // spacer
                    height: 8
                    anchors.left: parent.left
                    anchors.right: parent.right
                    visible: isDesktop
                }
                Rectangle {
                    height: 1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: Theme.colorSeparator
                    visible: isDesktop
                }
                Item {
                    height: 8
                    anchors.left: parent.left
                    anchors.right: parent.right
                    visible: isDesktop
                }

                ////////

                Item {
                    id: rectangleExit
                    height: 48
                    anchors.right: parent.right
                    anchors.left: parent.left
                    visible: isDesktop

                    MouseArea {
                        anchors.fill: parent
                        onClicked: utilsApp.appExit()
                    }

                    ImageSvg {
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 16
                        anchors.verticalCenter: parent.verticalCenter

                        source: "qrc:/assets/icons_material/duotone-exit_to_app-24px.svg"
                        color: Theme.colorText
                    }
                    Label {
                        anchors.left: parent.left
                        anchors.leftMargin: screenPaddingLeft + 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("Exit")
                        font.pixelSize: 13
                        font.bold: true
                        color: Theme.colorText
                    }
                }
            }
        }
    }
}
