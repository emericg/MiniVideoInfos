import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

Popup {
    id: popupImage
    x: 0
    y: -appWindow.height // go over app header
    width: appWindow.width
    height: appWindow.height

    margins: 0
    padding: 0

    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property string source: ""

    signal confirmed()

    ////////////////////////////////////////////////////////////////////////////

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200; }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 200; }
    }

    ////////////////////////////////////////////////////////////////////////////

    background: Rectangle {
        color: "black"
    }

    contentItem: Item {
        Image {
            anchors.fill: parent
            source: popupImage.source
            autoTransform: true
            fillMode: Image.PreserveAspectFit
        }
        MouseArea {
            anchors.fill: parent

            onClicked: {
                popupImage.close()
            }
        }
    }
}
