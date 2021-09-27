import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

Popup {
    id: itemLoading
    width: parent.width
    height: parent.height

    enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 133; } }
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

            ImageSvg {
                width: 128
                height: 128
                source: "qrc:/assets/icons_material/baseline-hourglass_empty-24px.svg"
                color: Theme.colorSubText
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
