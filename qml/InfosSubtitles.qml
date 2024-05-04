import QtQuick
import QtQuick.Controls

import ThemeEngine
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item {
    id: infos_subtitles
    implicitWidth: 480
    implicitHeight: 720

    ////////////////////////////////////////////////////////////////////////////

    function loadSubtitles(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        buttonExport.exportState = 0

        cbSubtitles.clear()
        var tracks = mediaItem.subtitlesTracks
        for (var i = 0; i < tracks.length; i++) {
            var txt = ""
            if (tracks[i].title.length) txt += tracks[i].title
            if (tracks[i].language.length) {
                if (txt.length) txt += " / "
                txt += tracks[i].language
            }
            if (!tracks[i].title.length && !tracks[i].language.length) txt += qsTr("Unknown")
            if (tracks[i].codec.length) txt += " (" + tracks[i].codec + ")"

            var entry = { text: txt }
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

        IconSvg {
            width: 32
            height: 32
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            color: Theme.colorPrimary
            source: "qrc:/assets/icons/material-symbols/media/closed_caption.svg"
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 56
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("SUBTITLES")
            textFormat: Text.PlainText
            color: Theme.colorPrimary
            font.pixelSize: 18
            font.bold: true
        }

        ////

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 16
            spacing: 16

            ButtonWireframe {
                id: buttonOpen
                height: 32
                anchors.verticalCenter: parent.verticalCenter

                visible: isMobile
                text: qsTr("OPEN")

                onClicked: {
                    var file = mediaItem.openSubtitlesString(comboboxSubtitles.currentIndex)
                    utilsShare.sendFile(file, "Open file", "text/plain", 0)
                }
            }

            ButtonWireframe {
                id: buttonExport
                height: 32
                anchors.verticalCenter: parent.verticalCenter

                property int exportState: 0

                fullColor: (exportState === 0) ? false : true
                primaryColor: {
                    if (exportState === 0) return Theme.colorPrimary
                    if (exportState === 1) return Theme.colorGreen
                    if (exportState === 2) return Theme.colorRed
                }
                text: {
                    if (exportState === 0) return qsTr("SAVE")
                    if (exportState === 1) return qsTr("SAVED")
                    if (exportState === 2) return qsTr("ERROR")
                }

                onClicked: {
                    if (mediaItem.saveSubtitlesString(comboboxSubtitles.currentIndex) === true) {
                        exportState = 1
                    } else {
                        exportState = 2
                    }
                }
            }
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
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter

            model: ListModel {
                id: cbSubtitles
                ListElement { text: "srt"; }
            }

            onCurrentIndexChanged: {
                buttonExport.exportState = 0
                loadSubtitlesTrack(currentIndex)
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
        anchors.bottomMargin: 12 + rectangleMenus.hhh

        clip: true
        color: Theme.colorBackground
        border.color: Theme.colorSeparator

        ScrollView {
            anchors.fill: parent

            TextArea {
                id: textArea

                textFormat: Text.PlainText
                color: Theme.colorText
                readOnly: true

                font.pixelSize: Theme.componentFontSize
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

    ////////////////////////////////////////////////////////////////////////////
}
