import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

Item {
    id: itemNoFile

    signal clicked()

    Column {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 16

        ImageSvg {
            width: 200
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter

            source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
            fillMode: Image.PreserveAspectFit
            color: Theme.colorIcon
        }

        ButtonWireframe {
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter

            primaryColor: Theme.colorPrimary
            text: qsTr("OPEN MEDIA FILE")
            onClicked: itemNoFile.clicked()
        }
    }
}
