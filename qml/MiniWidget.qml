import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Rectangle {
    id: miniWidget
    implicitWidth: 640
    height: 48
    anchors.left: parent.left
    anchors.right: parent.right

    property var mediaMiniWidget: null
    color: (appContent.state === "MediaInfos" && mediaMiniWidget === screenMediaInfos.mediaItem) ? Theme.colorForeground : "transparent"

    Component.onCompleted: initBoxData()

    function initBoxData() {
        if (mediaMiniWidget.fileType === 1)
            imageMedia.source = "qrc:/assets/icons_material/outline-insert_music-24px.svg"
        else if (mediaMiniWidget.fileType === 2)
            imageMedia.source = "qrc:/assets/icons_material/outline-local_movies-24px.svg"
        else if (mediaMiniWidget.fileType === 3)
            imageMedia.source = "qrc:/assets/icons_material/outline-insert_photo-24px.svg" // icons_material/baseline-photo-24px.svg
        else
            imageMedia.source = "qrc:/assets/icons_material/baseline-broken_image-24px.svg"

        mediaFilename.text = mediaMiniWidget.name + "." + mediaMiniWidget.ext
    }

    ////////////////////////////////////////////////////////////////////////////

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        onClicked: {
            if (typeof mediaMiniWidget === "undefined" || !mediaMiniWidget) return

            // regular click
            screenMediaInfos.loadMediaInfos(mediaMiniWidget)
            appDrawer.close()
        }
    }

    ImageSvg {
        id: imageMedia
        width: 24
        height: 24
        anchors.left: parent.left
        anchors.leftMargin: screenPaddingLeft + 16
        anchors.verticalCenter: parent.verticalCenter

        color: Theme.colorIcon
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: mediaFilename
        anchors.left: parent.left
        anchors.leftMargin: screenPaddingLeft + 56
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter

        color: Theme.colorText
        font.pixelSize: 14
        font.bold: false
        elide: Text.ElideMiddle
    }

    ////////////////
/*
    Rectangle {
        id: bottomSeparator
        color: Theme.colorSeparator
        height: 1

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
*/
}
