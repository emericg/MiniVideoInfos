import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item {
    id: infos_subtitles
    implicitWidth: 480
    implicitHeight: 720

    function loadSubtitles(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        cbSubtitles.clear()
        var tracks = mediaItem.getSubtitlesTracks()
        for (var i = 0; i < tracks.length; i++) {
            var txt = ""
            if (tracks[i].title.length) txt += tracks[i].title
            if (tracks[i].language.length) {
                if (txt.length) txt += " / "
                txt += tracks[i].language
            }
            if (!tracks[i].title.length && !tracks[i].language.length) txt += qsTr("Unknown")
            if (tracks[i].codec.length) txt += " (" + tracks[i].codec + ")"

            var entry = { text: txt };
            cbSubtitles.append(entry)
        }
        comboboxSubtitles.currentIndex = 0
    }

    function loadSubtitlesTrack(tid) {
        textArea.text = mediaItem.getSubtitlesString(tid)
    }

    ////////////////////////////////////////////////////////////////////////////

    Item {
        id: titleSubtitles
        height: 32
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.right: parent.right

        ImageSvg {
            width: 32
            height: 32
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            color: Theme.colorPrimary
            source: "qrc:/assets/icons_material_media/outline-closed_caption-24px.svg"
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 56
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("SUBTITLES")
            color: Theme.colorPrimary
            font.pixelSize: 18
            font.bold: true
        }
    }

    Item {
        id: selectorSubtitles
        height: 32
        anchors.top: titleSubtitles.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.right: parent.right

        ComboBoxThemed {
            id: comboboxSubtitles
            height: 32
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: buttonExport.left
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter

            model: ListModel {
                id: cbSubtitles
                ListElement { text: "srt"; }
            }

            onCurrentIndexChanged: {
                buttonExport.primaryColor = Theme.colorPrimary
                buttonExport.fullColor = false
                buttonExport.text = qsTr("SAVE")
                loadSubtitlesTrack(currentIndex)
            }
        }

        ButtonWireframe {
            id: buttonExport
            width: 128
            height: 32
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("SAVE")

            onClicked: {
                if (mediaItem.saveSubtitlesString(comboboxSubtitles.currentIndex) === true) {
                    buttonExport.primaryColor = Theme.colorGreen
                    buttonExport.text = qsTr("SAVED")
                } else {
                    buttonExport.primaryColor = Theme.colorRed
                    buttonExport.text = qsTr("ERROR")
                }
                buttonExport.fullColor = true
            }
        }
    }

    ////////////////

    Rectangle {
        id: scrollArea
        anchors.top: selectorSubtitles.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12 + rectangleMenus.height

        clip: true
        color: "transparent"
        border.color: Theme.colorSeparator

        ScrollView {
            anchors.fill: parent
            //anchors.margins: -8

            TextArea {
                id: textArea
                readOnly: true
                text: ""
                color: Theme.colorText
                font.family: {
                    if (Qt.platform.os === "android")
                        return "Droid Sans Mono"
                    else if (Qt.platform.os === "ios")
                        return "Menlo-Regular"
                    else if (Qt.platform.os === "osx")
                        return "Andale Mono"
                    else if (Qt.platform.os === "windows")
                        return "Lucida Console"
                    else
                        return "Monospace"
                }
            }
        }
    }
}
