import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0

Button {
    id: control
    width: contentText.width + contentImage.width*3
    implicitHeight: Theme.componentHeight

    property url source: ""
    property int imgSize: height / 1.5

    property bool fullColor: false
    property string primaryColor: Theme.colorPrimary
    property string secondaryColor: Theme.colorComponentBorder

    font.pixelSize: 16
    font.bold: false

    contentItem: Item {
        ImageSvg {
            id: contentImage
            width: imgSize
            height: imgSize

            anchors.right: contentText.left
            anchors.rightMargin: imgSize/3
            anchors.verticalCenter: parent.verticalCenter

            opacity: enabled ? 1.0 : 0.3
            source: control.source
            color: fullColor ? "white" : control.primaryColor
        }
        Text {
            id: contentText
            height: parent.height

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: (imgSize/2)

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
