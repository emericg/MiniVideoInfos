import QtQuick
import QtQuick.Controls

import ThemeEngine

Item {
    id: itemNoFile

    signal clicked()

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 16

        IconSvg {
            width: 200
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter

            source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
            color: Theme.colorIcon
        }

        ButtonWireframe {
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter

            fullColor: false
            primaryColor: Theme.colorPrimary

            text: qsTr("OPEN MEDIA FILE")
            onClicked: itemNoFile.clicked()
        }
    }
}
