import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import ThemeEngine

RowLayout {
    anchors.left: parent.left
    anchors.leftMargin: 56
    anchors.right: parent.right
    anchors.rightMargin: 8

    visible: (text.length > 0)
    spacing: 16

    property alias legend: l.text
    property alias text: t.text

    Text {
        id: l

        Layout.minimumHeight: 24
        Layout.alignment: Qt.AlignVCenter

        color: Theme.colorSubText
        font.pixelSize: 15
        wrapMode: Text.WordWrap
    }

    TextEditMVI {
        id: t

        Layout.maximumWidth: parent.width - l.width - 16
        Layout.minimumHeight: 24
        Layout.alignment: Qt.AlignVCenter
    }

    Item {
        Layout.minimumWidth: 0
        Layout.minimumHeight: 24
        Layout.fillWidth: true
    }
}
