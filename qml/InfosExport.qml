import QtQuick
import QtQuick.Controls

import ThemeEngine
import "qrc:/utils/UtilsPath.js" as UtilsPath
import "qrc:/utils/UtilsString.js" as UtilsString
import "qrc:/utils/UtilsMedia.js" as UtilsMedia
import "qrc:/utils/UtilsNumber.js" as UtilsNumber

Item {
    id: infos_export
    implicitWidth: 480
    implicitHeight: 720

    ////////////////////////////////////////////////////////////////////////////

    function loadExport(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        buttonExport.exportState = 0

        textArea.text = mediaItem.getExportString()
    }

    ////////////////////////////////////////////////////////////////////////////

    Item {
        id: titleExport

        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.right: parent.right
        height: 32

        InfoTitle { ////
            source: "qrc:/assets/icons/material-symbols/archive.svg"
            text: qsTr("EXPORT")
        }

        ////

        Row {
            anchors.right: parent.right
            anchors.rightMargin: 16
            spacing: 16

            ButtonClear {
                id: buttonOpen
                height: 32
                anchors.verticalCenter: parent.verticalCenter

                visible: isMobile
                text: qsTr("OPEN")

                onClicked: {
                    var file = mediaItem.openExportString()
                    utilsShare.sendFile(file, "Open file", "text/plain", 0)
                }
            }

            ButtonFlat {
                id: buttonExport
                height: 32
                anchors.verticalCenter: parent.verticalCenter

                property int exportState: 0

                color: {
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
                    if (mediaItem.saveExportString() === true) {
                        exportState = 1
                    } else {
                        exportState = 2
                    }
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ScrollView {
        anchors.top: titleExport.bottom
        anchors.topMargin: 16
        anchors.left: parent.left
        anchors.leftMargin: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16 + mobileMenu.height

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        TextAreaThemed {
            id: textArea

            textFormat: Text.PlainText
            color: Theme.colorText
            readOnly: true
            wrapMode: Text.WordWrap

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

    ////////////////////////////////////////////////////////////////////////////
}
