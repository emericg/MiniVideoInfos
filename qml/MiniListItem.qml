import QtQuick
import QtQuick.Controls

import ThemeEngine

Rectangle {
    id: miniListItem
    anchors.left: parent.left
    anchors.right: parent.right
    height: 48

    color: (appContent.state === "ScreenMediaInfos" && modelData === screenMediaInfos.mediaItem)
            ? Theme.colorForeground : Theme.colorBackground

    ////////////////////////////////////////////////////////////////////////////

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        onClicked: {
            if (typeof modelData === "undefined" || !modelData) return

            // regular click
            screenMediaInfos.loadMediaInfos(modelData)
            appDrawer.close()
        }
    }

    IconSvg { // mediaIcon
        width: 24
        height: 24
        anchors.left: parent.left
        anchors.leftMargin: screenPaddingLeft + 16
        anchors.verticalCenter: parent.verticalCenter

        source: {
            if (modelData.fileType === 1) return "qrc:/assets/icons/material-symbols/media/album.svg"
            if (modelData.fileType === 2) return "qrc:/assets/icons/material-symbols/media/movie.svg"
            if (modelData.fileType === 3) return "qrc:/assets/icons/material-symbols/media/image.svg"
            return "qrc:/assets/icons/material-symbols/media/broken_image.svg"
        }
        color: Theme.colorIcon
    }

    Text { // mediaFilename
        anchors.left: parent.left
        anchors.leftMargin: screenPaddingLeft + 56
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter

        text: modelData.name + "." + modelData.ext
        textFormat: Text.PlainText
        font.pixelSize: Theme.fontSizeContentSmall
        font.bold: false
        color: Theme.colorText
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
