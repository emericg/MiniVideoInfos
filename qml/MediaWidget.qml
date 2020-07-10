import QtQuick 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsNumber.js" as UtilsNumber

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
            imageMedia.source = "qrc:/assets/icons_material_media/outline-insert_music-24px.svg"
        else if (mediaItem.fileType === 2)
            imageMedia.source = "qrc:/assets/icons_material_media/outline-local_movies-24px.svg"
        else if (mediaItem.fileType === 3)
            imageMedia.source = "qrc:/assets/icons_material_media/outline-insert_photo-24px.svg" // icons_material_media/baseline-photo-24px.svg
        else
            imageMedia.source = "qrc:/assets/icons_material_media/baseline-broken_image-24px.svg"

        mediaFilename.text = mediaItem.name + "." + mediaItem.ext
        mediaPath.text = mediaItem.path
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: deviceWidgetRectangle
        anchors.rightMargin: 6
        anchors.leftMargin: 6
        anchors.bottomMargin: 6
        anchors.topMargin: 6
        anchors.fill: parent

        color: mediaWidget.selected ? Theme.colorSeparator : "transparent"
        border.width: 2
        border.color: (singleColumn) ? "transparent" : Theme.colorSeparator
        radius: 2

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

            onClicked: {
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
                        appContent.state = "MediaInfos"
                        screenMediaInfos.loadMediaInfos(mediaItem)
                    }
                }
            }
/*
            onPressAndHold: {
                // multi selection
                if (!selected) {
                    selected = true;
                    screenMediaList.selectMedia(index);
                } else {
                    selected = false;
                    screenMediaList.deselectMedia(index);
                }
            }
*/
        }

        ////////////////

        Item {
            id: rowLeft

            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: (singleColumn ? 6 : 14)
            anchors.right: parent.right
            anchors.rightMargin: 6

            //spacing: (singleColumn ? 12 : 10)

            ImageSvg {
                id: imageMedia
                width: 40
                height: 40
                anchors.verticalCenter: parent.verticalCenter

                color: Theme.colorIcon
                anchors.left: parent.left
                anchors.leftMargin: 6
                fillMode: Image.PreserveAspectFit
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
                    clip: true

                    text: mediaItem.name
                    color: Theme.colorText
                    font.pixelSize: 16
                    verticalAlignment: Text.AlignVCenter
                }
/*
                Item {
                    id: mediaFilename
                    height: 24
                    clip: true
                    anchors.left: parent.left
                    //anchors.right: parent.right

                    property string text: ""
                    property string spacing: "        "
                    property string combined: text + spacing
                    property string display: combined.substring(step) + combined.substring(0, step)
                    property int step: 0

                    Timer {
                        interval: 200
                        running: (mediaFilenameTxt.width > mediaFilename.width)
                        repeat: true
                        onTriggered: parent.step = (parent.step + 1) % parent.combined.length
                    }

                    Text {
                        id: mediaFilenameTxt
                        text: parent.display
                        color: Theme.colorText
                        font.pixelSize: 16
                        verticalAlignment: Text.AlignVCenter
                    }
                }*/
                Text {
                    id: mediaPath
                    anchors.top: mediaFilename.bottom
                    anchors.topMargin: 4
                    anchors.left: parent.left
                    anchors.right: parent.right
                    clip: true

                    text: mediaItem.path
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    verticalAlignment: Text.AlignVCenter
                }
/*
                Text {
                    id: mediaStatus
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    visible: false
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 14
                    color: Theme.colorGreen

                    SequentialAnimation on opacity {
                        id: opa
                        loops: Animation.Infinite
                        onStopped: mediaStatus.opacity = 1;

                        PropertyAnimation { to: 0.33; duration: 750; }
                        PropertyAnimation { to: 1; duration: 750; }
                    }
                }
*/
            }

            ImageSvg {
                id: imageGo
                width: 40
                height: 40
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.verticalCenter: parent.verticalCenter

                source: "qrc:/assets/icons_material/baseline-chevron_right-24px.svg"
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

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.leftMargin: -6
        anchors.rightMargin: -6
        anchors.left: parent.left
    }
}
