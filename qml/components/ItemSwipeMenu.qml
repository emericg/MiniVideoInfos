import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

Item {
    width: 64
    height: 48
    visible: (index > -1)

    property string title
    property string icon
    property int index: -1
    property bool selected: (mediaPages.currentIndex === index)

    MouseArea {
        anchors.fill: parent
        onClicked: mediaPages.currentIndex = index
    }

    ImageSvg {
        id: menuItemImg
        width: 26
        height: 26
        anchors.horizontalCenter: parent.horizontalCenter

        color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
        Behavior on color { ColorAnimation { duration: 133 } }

        source: {
            if (icon === "file")
                return "qrc:/assets/icons_material/outline-insert_drive_file-24px.svg"
            else if (icon === "video")
                return "qrc:/assets/icons_material/outline-local_movies-24px.svg"
            else if (icon === "audio")
                return "qrc:/assets/icons_material/outline-speaker-24px.svg"
            else if (icon === "subtitles")
                return "qrc:/assets/icons_material/outline-closed_caption-24px.svg"
            else if (icon === "audio_tags")
                return "qrc:/assets/icons_material/outline-insert_music-24px.svg"
            else if (icon === "image_tags")
                return "qrc:/assets/icons_material/outline-insert_photo-24px.svg"
            else if (icon === "map")
                return "qrc:/assets/icons_material/baseline-map-24px.svg"
            else if (icon === "export")
                return "qrc:/assets/icons_material/outline-archive-24px.svg"
            else
                return "qrc:/assets/icons_material/baseline-close-24px.svg"
        }
    }

    Text {
        id: menuItemTxt
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: menuItemImg.bottom
        anchors.topMargin: 0

        text: parent.title
        textFormat: Text.PlainText
        font.pixelSize: 12
        color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
        Behavior on color { ColorAnimation { duration: 133 } }
    }
}
