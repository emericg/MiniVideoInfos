import QtQuick 2.15
import QtQuick.Controls 2.15

import ThemeEngine 1.0

Rectangle {
    id: miniListItem
    implicitWidth: 640
    height: 48
    anchors.left: parent.left
    anchors.right: parent.right

    color: (appContent.state === "MediaInfos" && modelData === screenMediaInfos.mediaItem) ? Theme.colorForeground : Theme.colorComponentBackground

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
            if (modelData.fileType === 1) return "qrc:/assets/icons_material/outline-insert_music-24px.svg"
            if (modelData.fileType === 2) return "qrc:/assets/icons_material/outline-local_movies-24px.svg"
            if (modelData.fileType === 3) return "qrc:/assets/icons_material/outline-insert_photo-24px.svg" // icons_material/baseline-photo-24px.svg
            return "qrc:/assets/icons_material/baseline-broken_image-24px.svg"
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
