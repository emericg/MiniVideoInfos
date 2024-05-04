import QtQuick
import QtQuick.Controls

import ThemeEngine

DrawerThemed {
    contentItem: Item {

        ////////////////

        Column {
            id: headerColumn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            z: 5

            ////////

            Rectangle { // statusbar area
                anchors.left: parent.left
                anchors.right: parent.right

                height: Math.max(screenPaddingTop, screenPaddingStatusbar)
                color: Theme.colorBackground // to hide flickable content
            }

            ////////

            Rectangle { // header area
                anchors.left: parent.left
                anchors.right: parent.right

                height: 80
                color: Theme.colorBackground

                Image {
                    id: imageHeader
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    width: 40
                    height: 40
                    source: "qrc:/assets/gfx/logos/logo.svg"
                    sourceSize: Qt.size(width, height)
                }
                Text {
                    id: textHeader
                    anchors.top: imageHeader.top
                    anchors.left: imageHeader.right
                    anchors.leftMargin: 12
                    anchors.bottom: imageHeader.bottom

                    text: "MiniVideo Infos"
                    textFormat: Text.PlainText
                    color: Theme.colorText
                    font.bold: true
                    font.pixelSize: Theme.fontSizeHeader
                    verticalAlignment: Text.AlignVCenter
                }
            }

            ////////
        }

        ////////////////

        Flickable {
            anchors.top: headerColumn.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            contentWidth: -1
            contentHeight: contentColumn.height

            Column {
                id: contentColumn
                anchors.left: parent.left
                anchors.right: parent.right

                ////////

                ListSeparatorPadded { }

                ////////

                DrawerItem {
                    highlighted: (appContent.state === "MediaList" && screenMediaList.dialogIsOpen)
                    text: qsTr("Open media")
                    iconSource: "qrc:/assets/icons/material-symbols/media/image.svg"

                    onClicked: {
                        appContent.state = "MediaList"
                        screenMediaList.openDialog()
                        appDrawer.close()
                    }
                }

                DrawerItem {
                    highlighted: (appContent.state === "MediaList" && !screenMediaList.dialogIsOpen)
                    text: qsTr("Media")
                    iconSource: "qrc:/assets/icons/material-symbols/media/image.svg"

                    onClicked: {
                        appContent.state = "MediaList"
                        screenMediaList.closeDialog()
                        appDrawer.close()
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

                ListSeparatorPadded { }

                ////////

                DrawerItem {
                    highlighted: (appContent.state === "ScreenSettings")
                    text: qsTr("Settings")
                    iconSource: "qrc:/assets/icons/material-icons/duotone/tune.svg"

                    onClicked: {
                        screenSettings.loadScreen()
                        appDrawer.close()
                    }
                }

                DrawerItem {
                    highlighted: (appContent.state === "ScreenAbout" || appContent.state === "ScreenAboutPermissions")
                    text: qsTr("About")
                    iconSource: "qrc:/assets/icons/material-icons/duotone/info.svg"

                    onClicked: {
                        screenAbout.loadScreen()
                        appDrawer.close()
                    }
                }

                ////////

                ListSeparatorPadded { }

                ////////
            }
        }

        ////////////////
    }
}
