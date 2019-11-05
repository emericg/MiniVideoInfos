import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0

Popup {
    id: itemLoading
    width: parent.width
    height: parent.height

    background: Rectangle {
        color: Theme.colorBackground
        anchors.fill: parent
    }

    contentItem: Item {
        anchors.verticalCenterOffset: -26
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Column {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            ImageSvg {
                width: 128
                height: 128
                source: "qrc:/assets/icons_material/baseline-hourglass_empty-24px.svg"
                color: Theme.colorText
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: qsTr("Loading...")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
                color: Theme.colorText
            }
        }
    }
}
