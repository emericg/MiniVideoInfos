import QtQuick

import ComponentLibrary
import MiniVideoInfos

Item {
    id: desktopHeader

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    height: headerHeight
    z: 10

    property int headerHeight: isHdpi ? 48 : 56

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

        color: Theme.colorHeader

        Row { // left area
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            visible: (screenMediaInfos.mediaItem !== null)
            spacing: isHdpi ? 4 : 12

            ////

            ButtonFlat { // open
                height: 34
                //colorHighlight: Theme.colorGreen
                text: wideWideMode ? qsTr("Open") : ""
                source: "qrc:/IconLibrary/material-symbols/add_circle.svg"
                onClicked: screenMediaList.openDialog()
            }

            ButtonFlat { // reload
                height: 34
                //colorHighlight: Theme.colorYellow
                text: wideWideMode ? qsTr("Reload") : ""
                source: "qrc:/IconLibrary/material-symbols/refresh.svg"
                onClicked: {
                    mediaManager.openMedia(screenMediaInfos.mediaItem.fullpath)
                }
            }

            ButtonFlat { // close
                height: 34
                //colorHighlight: Theme.colorRed
                text: wideWideMode ? qsTr("Close") : ""
                source: "qrc:/IconLibrary/material-symbols/cancel_circle.svg"
                onClicked: {
                    mediaManager.closeMedia(screenMediaInfos.mediaItem.fullpath)
                    appContent.state = "ScreenMediaList"
                }
            }

            ////

            ButtonFlat { // open externaly
                height: 34
                //colorHighlight: Theme.colorRed
                text: wideWideMode ? qsTr("Open in new instance") : ""
                source: "qrc:/IconLibrary/material-icons/duotone/launch.svg"
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

            DesktopHeaderItem { // menuMedia
                height: headerHeight

                text: wideWideMode ? qsTr("Media") : ""
                source: "qrc:/IconLibrary/fontawesome5/duotone/photo-video.svg"
                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight

                highlighted: (appContent.state === "ScreenMediaList" ||
                              appContent.state === "ScreenMediaInfos")
                onClicked: {
                    if (mediaManager.mediaList.length) appContent.state = "ScreenMediaInfos"
                    else appContent.state = "ScreenMediaList"

                    if (appContent.state !== "ScreenMediaInfos")
                        appContent.state = "ScreenMediaList"
                }
            }
            DesktopHeaderItem { // menuSettings
                height: headerHeight

                text: wideWideMode ? qsTr("Settings") : ""
                source: "qrc:/IconLibrary/material-icons/duotone/tune.svg"
                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight

                highlighted: (appContent.state === "ScreenSettings")
                onClicked: {
                    //if (appContent.state === "ScreenSettings") backAction()
                    //else screenSettings.loadScreen()
                    screenSettings.loadScreen()
                }
            }

            DesktopHeaderItem { // exit button
                height: headerHeight

                text: wideWideMode ? qsTr("Exit") : ""
                source: "qrc:/IconLibrary/material-icons/duotone/exit_to_app.svg"
                colorContent: Theme.colorHeaderContent
                colorHighlight: Theme.colorHeaderHighlight
                //colorHighlight: Theme.colorRed

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
