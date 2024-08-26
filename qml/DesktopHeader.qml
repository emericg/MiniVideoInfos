import QtQuick

import ThemeEngine

Item {
    id: desktopHeader

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    height: headerHeight
    z: 10

    property int headerHeight: isHdpi ? 48 : 52

    property int headerPosition: 0

    property string headerTitle: "MiniVideo Infos"

    ////////////////////////////////////////////////////////////////////////////

    DragHandler {
        // make that surface draggable // also, prevent clicks below this area
        onActiveChanged: if (active) appWindow.startSystemMove()
        target: null
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: headerHeight

        color: "white" // Theme.colorHeader

        Row { // left area
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            visible: (screenMediaInfos.mediaItem !== null)
            spacing: isHdpi ? 4 : 12

            ////

            ButtonDesktop { // open
                //colorHighlight: Theme.colorGreen
                text: wideWideMode ? qsTr("Open") : ""
                source: "qrc:/assets/icons/material-symbols/add_circle.svg"
                onClicked: screenMediaList.openDialog()
            }

            ButtonDesktop { // reload
                //colorHighlight: Theme.colorYellow
                text: wideWideMode ? qsTr("Reload") : ""
                source: "qrc:/assets/icons/material-symbols/refresh.svg"
                onClicked: {
                    mediaManager.openMedia(screenMediaInfos.mediaItem.fullpath)
                }
            }

            ButtonDesktop { // close
                //colorHighlight: Theme.colorRed
                text: wideWideMode ? qsTr("Close") : ""
                source: "qrc:/assets/icons/material-symbols/cancel_circle.svg"
                onClicked: {
                    mediaManager.closeMedia(screenMediaInfos.mediaItem.fullpath)
                    appContent.state = "ScreenMediaList"
                }
            }

            ////

            ButtonDesktop { // open externaly
                //colorHighlight: Theme.colorRed
                text: wideWideMode ? qsTr("Open in new instance") : ""
                source: "qrc:/assets/icons/material-icons/duotone/launch.svg"
                onClicked: {
                    mediaManager.detach(screenMediaInfos.mediaItem.fullpath)
                    mediaManager.closeMedia(screenMediaInfos.mediaItem.fullpath)
                    appContent.state = "ScreenMediaList"
                }
            }

            ////
        }

        ////////////

        Row { // right area
            anchors.top: parent.top
            anchors.right: parent.right

            height: headerHeight
            spacing: isHdpi ? 4 : 12

            DesktopHeaderItem { // menuSettings
                height: headerHeight

                text: wideWideMode ? qsTr("Settings") : ""
                source: "qrc:/assets/icons/material-icons/duotone/tune.svg"
                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight

                highlighted: (appContent.state === "ScreenSettings")
                onClicked: {
                    if (appContent.state === "ScreenSettings")
                        backAction()
                    else
                        screenSettings.loadScreen()
                }
            }

            DesktopHeaderItem { // exit button
                height: headerHeight

                text: wideWideMode ? qsTr("Exit") : ""
                source: "qrc:/assets/icons/material-icons/duotone/exit_to_app.svg"
                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorRed

                onClicked: Qt.quit()
            }
        }

        ////////////

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 2
            opacity: 0.66
            color: Theme.colorHeaderHighlight
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
