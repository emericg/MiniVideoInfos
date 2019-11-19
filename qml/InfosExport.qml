import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item {
    id: infos_export
    width: 480
    height: 720

    function loadExport(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        buttonExport.primaryColor = Theme.colorPrimary
        buttonExport.text =  qsTr("SAVE")

        textArea.text = mediaItem.getExportString()
    }

    Item { ////
        id: titleExport
        x: 0
        y: 16
        height: 32
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left

        ImageSvg {
            width: 32
            height: 32
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            color: Theme.colorPrimary
            source: "qrc:/assets/icons_material/outline-archive-24px.svg"
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 56
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("EXPORT")
            color: Theme.colorPrimary
            font.pixelSize: 18
            font.bold: true
        }

        ButtonWireframe {
            id: buttonExport
            width: 96
            height: 32
            anchors.right: parent.right
            anchors.rightMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("SAVE")

            onClicked: {
                if (mediaItem.saveExportString() === true) {
                    buttonExport.primaryColor = Theme.colorGreen
                    buttonExport.text =  qsTr("SAVED")
                } else {
                    buttonExport.primaryColor = Theme.colorRed
                    buttonExport.text =  qsTr("ERROR")
                }
                buttonExport.fullColor = true
            }
        }
    }

    Rectangle {
        id: scrollArea
        anchors.top: titleExport.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 68

        color: "transparent"
        border.color: Theme.colorSeparator

        ScrollView {
            anchors.fill: parent
            //anchors.margins: -8

            TextArea {
                id: textArea
                text: ""
                color: Theme.colorText
                font.family: {
                    if (Qt.platform.os === "android")
                        return "Droid Sans Mono"
                    else if (Qt.platform.os === "ios")
                        return "Monospace"
                    else
                        return "Monospace"
                }
                readOnly: true
            }
        }
    }
}
