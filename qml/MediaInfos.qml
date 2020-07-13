import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

Item {
    id: screenMediaInfos
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenLeftPadding
    anchors.rightMargin: screenRightPadding

    property var mediaItem: null
    property var content: null

    function loadMediaInfos(newmedia) {
        if (typeof newmedia === "undefined" || !newmedia) return
        if (newmedia === mediaItem) return

        mediaItem = newmedia
        //console.log("screenMediaInfos.loadMediaInfos(" + mediaItem.name + ")")

        // Title
        if (!isPhone || mediaItem.name.length < 24)
            appHeader.title = mediaItem.name + "." + mediaItem.ext
        else
            appHeader.title = "MiniVideo Infos"

        if (contentLoader.status != Loader.Ready) {
            if (isPhone)
                contentLoader.source = "MediaInfos_swipeview.qml"
            else
                contentLoader.source = "MediaInfos_row.qml"

            content = contentLoader.item
        }

        if (isPhone) {
            content.loadHeader()
            content.loadSwipeView()
        } else {
            content.loadHeader()
            content.loadRowView()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Loader {
        id: contentLoader
        anchors.fill: parent
    }
}
