import QtQuick
import QtQuick.Controls

import ThemeEngine

Drawer {
    width: (appWindow.screenOrientation === Qt.PortraitOrientation || appWindow.width < 480)
            ? 0.8 * appWindow.width : 0.5 * appWindow.width
    height: appWindow.height

    ////////////////////////////////////////////////////////////////////////////

    background: Rectangle {
        color: Theme.colorBackground

        Rectangle { // left border
            x: parent.width
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

            ////////

            Rectangle {
                id: rectangleStatusbar
                anchors.left: parent.left
                anchors.right: parent.right

                height: Math.max(screenPaddingTop, screenPaddingStatusbar)
                color: Theme.colorBackground // to hide flickable content
            }

            ////////

            Rectangle {
                id: rectangleLogo
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
                    textFormat: Text.PlainText
                    color: Theme.colorText
                    font.bold: true
                    font.pixelSize: Theme.fontSizeHeader
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        ////////////////

        Flickable {
            anchors.top: rectangleHeader.bottom
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

                DrawerItem {
                    highlighted: (appContent.state === "MediaList" && screenMediaList.dialogIsOpen)
                    text: qsTr("Open media")
                    iconSource: "qrc:/assets/icons_material/outline-insert_photo-24px.svg"

                    onClicked: {
                        appContent.state = "MediaList"
                        screenMediaList.openDialog()
                        appDrawer.close()
                    }
                }

                DrawerItem {
                    highlighted: (appContent.state === "MediaList" && !screenMediaList.dialogIsOpen)
                    text: qsTr("Media")
                    iconSource: "qrc:/assets/icons_material/outline-insert_photo-24px.svg"

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
                    iconSource: "qrc:/assets/icons_material/outline-settings-24px.svg"

                    onClicked: {
                        screenSettings.loadScreen()
                        appDrawer.close()
                    }
                }

                DrawerItem {
                    highlighted: (appContent.state === "ScreenAbout" || appContent.state === "ScreenAboutPermissions")
                    text: qsTr("About")
                    iconSource: "qrc:/assets/icons_material/outline-info-24px.svg"

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
    }

    ////////////////////////////////////////////////////////////////////////////
}
