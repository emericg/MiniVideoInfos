import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0

Item {
    id: itemNoFile
    anchors.fill: parent

    signal clicked()

    Column {
        anchors.left: parent.left
        anchors.leftMargin: 32
        anchors.right: parent.right
        anchors.rightMargin: 32
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -26
        spacing: 16

        ImageSvg {
            width: 200
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter

            source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
            fillMode: Image.PreserveAspectFit
            color: Theme.colorIcon
        }

        ButtonWireframe {
            height: 40
            anchors.horizontalCenter: parent.horizontalCenter

            primaryColor: Theme.colorPrimary
            text: qsTr("LOAD A MEDIA FILE")
            onClicked: itemNoFile.clicked();
        }
    }
}
