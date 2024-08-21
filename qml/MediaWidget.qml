import QtQuick

import ThemeEngine
import "qrc:/utils/UtilsNumber.js" as UtilsNumber

Item {
    id: mediaWidget
    implicitWidth: 640
    implicitHeight: 100
    anchors.left: parent.left
    anchors.right: parent.right

    property var mediaItem: null

    property bool singleColumn: true
    property bool selected: false

    Component.onCompleted: initBoxData()

    function initBoxData() {
        if (mediaItem.fileType === 1)
            imageMedia.source = "qrc:/assets/icons/material-symbols/media/album.svg"
        else if (mediaItem.fileType === 2)
            imageMedia.source = "qrc:/assets/icons/material-symbols/media/movie.svg"
        else if (mediaItem.fileType === 3)
            imageMedia.source = "qrc:/assets/icons/material-symbols/media/image.svg"
        else
            imageMedia.source = "qrc:/assets/icons/material-symbols/media/broken_image.svg"

        mediaFilename.text = mediaItem.name + "." + mediaItem.ext
        mediaPath.text = mediaItem.path
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: deviceWidgetRectangle
        anchors.fill: parent

        color: mediaWidget.selected ? Theme.colorSeparator : "transparent"
        Behavior on color { ColorAnimation { duration: 133 } }

        RippleThemed {
            anchors.fill: mousearea
            anchor: mousearea

            clip: true
            pressed: mousearea.containsPress
            color: Qt.rgba(Theme.colorForeground.r, Theme.colorForeground.g, Theme.colorForeground.b, 1)
        }

        MouseArea {
            id: mousearea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

            onClicked: (mouse) => {
                if (typeof mediaItem === "undefined" || !mediaItem) return

                // multi selection
                if (mouse.button === Qt.MiddleButton) {
                    if (!selected) {
                        selected = true;
                        screenMediaList.selectMedia(index);
                    } else {
                        selected = false;
                        screenMediaList.deselectMedia(index);
                    }
                    return;
                }

                if (mouse.button === Qt.LeftButton) {
                    // multi selection
                    if ((mouse.modifiers & Qt.ControlModifier) ||
                            (screenMediaList.selectionMode)) {
                        if (!selected) {
                            selected = true;
                            screenMediaList.selectMedia(index);
                        } else {
                            selected = false;
                            screenMediaList.deselectMedia(index);
                        }
                        return;
                    }

                    // regular click
                    if (mediaItem.valid) {
                        screenMediaInfos.loadMediaInfos(mediaItem)
                    }
                }
            }

            onPressAndHold: {
                if (typeof mediaItem === "undefined" || !mediaItem) return

                // multi selection
                if (!selected) {
                    utilsApp.vibrate(25)
                    selected = true
                    screenMediaList.selectMedia(index)
                } else {
                    selected = false
                    screenMediaList.deselectMedia(index)
                }
            }
        }

        ////////////////

        Item {
            id: rowLeft
            anchors.fill: parent
            anchors.margins: 8

            IconSvg {
                id: imageMedia
                width: 40
                height: 40
                anchors.left: parent.left
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter

                color: Theme.colorIcon
            }

            Item {
                id: column
                height: 48
                anchors.left: imageMedia.right
                anchors.leftMargin: 12
                anchors.right: imageGo.left
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: mediaFilename
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    anchors.left: parent.left
                    anchors.right: parent.right

                    text: mediaItem.name
                    color: Theme.colorText
                    font.pixelSize: Theme.fontSizeContent
                    elide: Text.ElideMiddle
                    verticalAlignment: Text.AlignVCenter
                }

                Text {
                    id: mediaPath
                    anchors.top: mediaFilename.bottom
                    anchors.topMargin: 4
                    anchors.left: parent.left
                    anchors.right: parent.right

                    text: mediaItem.path
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    elide: Text.ElideMiddle
                    verticalAlignment: Text.AlignVCenter
                }
            }

            IconSvg {
                id: imageGo
                width: 32
                height: 32
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter

                source: "qrc:/assets/icons/material-symbols/chevron_right.svg"
                color: Theme.colorIcon
                fillMode: Image.PreserveAspectFit
            }
        }
    }

    ////////////////

    Rectangle {
        id: bottomSeparator
        color: Theme.colorSeparator
        visible: singleColumn
        height: 1

        anchors.left: parent.left
        anchors.leftMargin: -6
        anchors.right: parent.right
        anchors.rightMargin: -6
        anchors.bottom: parent.bottom
    }

    ////////////////
}
