import QtQuick 2.15

import ThemeEngine 1.0

Column {
    id: miniList
    anchors.leftMargin: screenPaddingLeft
    anchors.rightMargin: screenPaddingRight

    visible: mediaManager.mediaList.length

    ////////

    Item { // spacer
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
    }
    Rectangle {
        height: 1
        anchors.left: parent.left
        anchors.right: parent.right
        color: Theme.colorSeparator
    }
    Item {
        height: 8
        anchors.left: parent.left
        anchors.right: parent.right
    }

    ////////

    ListView {
        id: miniView
        anchors.left: parent.left
        anchors.right: parent.right

        height: 48 * mediaManager.mediaList.length
        interactive: false

        model: mediaManager.mediaList
        delegate: MiniWidget { mediaMiniWidget: modelData; }
    }
}
