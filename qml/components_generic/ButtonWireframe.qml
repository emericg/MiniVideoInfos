import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0

Button {
    id: control
    width: contentText.width + contentText.width/3
    implicitHeight: Theme.componentHeight

    property bool fullColor: false
    property string primaryColor: Theme.colorPrimary
    property string secondaryColor: Theme.colorComponentBorder

    font.pixelSize: 16
    font.bold: false

    contentItem: Item {
        Text {
            id: contentText
            height: parent.height

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            text: control.text
            font: control.font
            opacity: enabled ? (control.down ? 0.9 : 1.0) : 0.3
            color: fullColor ? "white" : control.primaryColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    background: Rectangle {
        radius: Theme.componentRadius
        opacity: enabled ? (control.down ? 0.5 : 1.0) : 0.3
        color: fullColor ? control.primaryColor : Theme.colorComponentBackground
        border.width: 1
        border.color: fullColor ? control.primaryColor : control.secondaryColor
    }
}
