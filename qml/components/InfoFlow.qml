import QtQuick
import QtQuick.Controls

import ThemeEngine

Flow {
    anchors.left: parent.left
    anchors.leftMargin: 56
    anchors.right: parent.right
    anchors.rightMargin: 8

    visible: (text1.length > 0 || text2.length > 0)
    spacing: ((row1.width + row2.width + 16) > width) ? 2 : 16

    property alias legend1: l1.text
    property alias text1: i1.text

    property alias legend2: l2.text
    property alias text2: i2.text

    Row {
        id: row1

        height: 24
        spacing: 12
        visible: (text1.length > 0)

        Text {
            id: l1

            color: Theme.colorSubText
            font.pixelSize: 15
            wrapMode: Text.WordWrap
        }
        TextEditMVI {
            id: i1
        }
    }

    Row {
        id: row2

        height: 24
        spacing: 12
        visible: (text2.length > 0)

        Text {
            id: l2

            color: Theme.colorSubText
            font.pixelSize: 15
            wrapMode: Text.WordWrap
        }
        TextEditMVI {
            id: i2
        }
    }
}
