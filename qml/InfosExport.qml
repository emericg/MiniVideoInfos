import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item {
    id: infos_export
    implicitWidth: 480
    implicitHeight: 720

    function loadExport(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        buttonExport.primaryColor = Theme.colorPrimary
        buttonExport.text =  qsTr("SAVE")

        textArea.text = mediaItem.getExportString()
    }

    ////////////////////////////////////////////////////////////////////////////

    Item {
        id: titleExport
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
            width: 128
            height: 32
            anchors.right: parent.right
            anchors.rightMargin: 16
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

    ////////////////

    Rectangle {
        id: scrollArea
        anchors.top: titleExport.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12 + rectangleMenus.height

        color: "transparent"
        border.color: Theme.colorSeparator

        ScrollView {
            anchors.fill: parent
            //anchors.margins: -8

            TextArea {
                id: textArea
                readOnly: true
                clip: true
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
