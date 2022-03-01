import QtQuick 2.15
import QtQuick.Controls 2.15

import ThemeEngine 1.0

Item {
    id: screenMediaInfos
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenPaddingLeft
    anchors.rightMargin: screenPaddingRight

    property var mediaItem: null
    property var content: null

    function loadMediaInfos(newmedia) {
        if (typeof newmedia === "undefined" || !newmedia) { return; }
        if (newmedia === mediaItem) { appContent.state = "MediaInfos"; return; }

        //console.log("screenMediaInfos.loadMediaInfos(" + newmedia + ")")
        mediaItem = newmedia

        // View loader
        if (contentLoader.status != Loader.Ready) {
            if (isPhone)
                contentLoader.source = "MediaInfos_swipeview.qml"
            else
                contentLoader.source = "MediaInfos_row.qml"

            content = contentLoader.item
        }

        //
        content.loadHeader()
        if (isPhone) content.loadSwipeView()
        else content.loadRowView()

        // Change screen
        appContent.state = "MediaInfos"

        // Set header title
        if (!isPhone || mediaItem.name.length < 24) {
            appHeader.title = mediaItem.name + "." + mediaItem.ext
        } else {
            appHeader.title = appHeader.appName
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Loader {
        id: contentLoader
        anchors.fill: parent
    }
}
