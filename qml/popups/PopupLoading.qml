import QtQuick
import QtQuick.Controls

import ThemeEngine

Popup {
    id: popupLoading
    width: parent.width
    height: parent.height

    //enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 133; } }
    exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 133; } }

    background: Rectangle {
        color: Theme.colorBackground
        anchors.fill: parent
        anchors.topMargin: 8
    }

    contentItem: Item {
        anchors.verticalCenterOffset: isDesktop ? -26 : -13
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Column {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            IconSvg {
                width: 128
                height: 128
                anchors.horizontalCenter: parent.horizontalCenter

                source: "qrc:/assets/icons/material-icons/outlined/hourglass_empty.svg"
                color: Theme.colorIcon
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Loading...")
                textFormat: Text.PlainText
                font.pixelSize: Theme.fontSizeContent
                color: Theme.colorText
            }
        }
    }
}
