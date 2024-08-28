import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ThemeEngine

RowLayout {
    id: control

    anchors.left: parent.left
    anchors.leftMargin: 12
    anchors.right: parent.right
    anchors.rightMargin: 12

    height: 32
    spacing: 12

    property alias source: i.source
    property int sourceSize: 28

    property alias text: t.text

    property color color: isDesktop ? Theme.colorGrey : Theme.colorPrimary

    Item {
        Layout.preferredWidth: 32
        Layout.preferredHeight: 32
        Layout.alignment: Qt.AlignVCenter

        IconSvg {
            id: i
            anchors.centerIn: parent
            width: control.sourceSize
            height: control.sourceSize
            color: control.color
        }
    }

    Text {
        id: t

        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter

        textFormat: Text.PlainText
        color: control.color
        font.pixelSize: 18
        font.bold: true
    }
}
