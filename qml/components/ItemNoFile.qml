import QtQuick
import QtQuick.Controls

import ComponentLibrary

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

            source: "qrc:/IconLibrary/fontawesome5/duotone/photo-video.svg"
            color: Theme.colorIcon
        }

        ButtonClear {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 40
            text: qsTr("OPEN MEDIA FILE")
            onClicked: itemNoFile.clicked()
        }
    }
}
