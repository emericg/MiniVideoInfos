import QtQuick
import QtQuick.Controls

import ThemeEngine

Item {
    id: screenMediaInfos
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    property var mediaItem: null
    property var content: null

    function loadMediaInfos(newmedia) {
        if (typeof newmedia === "undefined" || !newmedia) { return; }
        if (newmedia === mediaItem) { appContent.state = "ScreenMediaInfos"; return; }

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

        if (contentLoader.status === Loader.Ready) {
            content.loadHeader()
            content.loadView()
        }

        // Change screen
        appContent.state = "ScreenMediaInfos"

        // Set header title
        if (!isPhone || mediaItem.name.length < 24) {
            appHeader.headerTitle = mediaItem.name + "." + mediaItem.ext
        } else {
            appHeader.headerTitle = utilsApp.appName()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Loader {
        id: contentLoader
        anchors.fill: parent

        asynchronous: false
    }

    ////////////////////////////////////////////////////////////////////////////
}
