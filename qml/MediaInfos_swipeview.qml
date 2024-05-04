import QtQuick
import QtQuick.Controls

import ThemeEngine
import "qrc:/utils/UtilsString.js" as UtilsString

Item {
    id: screenMediaInfos_swipeview
    width: 480
    height: 720
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    function loadHeader() {
        if (mediaItem.fileType === 1 || mediaItem.fileType === 2) {
            columnDuration.visible = true
            textDuration.text = UtilsString.durationToString_compact(mediaItem.duration)
        } else {
            columnDuration.visible = false
        }

        columnSize.visible = true
        textSize.text = UtilsString.bytesToString_short(mediaItem.size, settingsManager.unitSizes)

        if (mediaItem.fileType === 2 || mediaItem.fileType === 3) {
            columnGeometry.visible = true
            textGeometry.text = mediaItem.widthVisible + " x " + mediaItem.heightVisible
        } else {
            columnGeometry.visible = false
        }

        if (mediaItem.fileType === 1 || mediaItem.audioCodec.length) {
            columnChannels.visible = true
            if (mediaItem.audioChannels === 1)
                textChannels.text = qsTr("mono")
            else if (mediaItem.audioChannels === 2)
                textChannels.text = qsTr("stereo")
            else
                textChannels.text = mediaItem.audioChannels + " " + qsTr("chan.")
        } else {
            columnChannels.visible = false
        }

        columnGPS.visible = mediaItem.hasGPS

        computeColumnsSize()
    }

    onWidthChanged: computeColumnsSize()
    function computeColumnsSize() {
        var headercolumncount = 1
        if (mediaItem.fileType === 1 || mediaItem.fileType === 2) headercolumncount++;
        if (mediaItem.fileType === 2 || mediaItem.fileType === 3) headercolumncount++;
        if (mediaItem.fileType === 1 || mediaItem.audioCodec.length) headercolumncount++;
        if (mediaItem.hasGPS) headercolumncount++;

        var headercolumnwidth = ((subheader.width - 48) / headercolumncount)
        if (headercolumnwidth > 128) headercolumnwidth = 128
        columnDuration.width = headercolumnwidth
        columnSize.width = headercolumnwidth
        columnGeometry.width = headercolumnwidth
        columnChannels.width = headercolumnwidth
        columnGPS.width = headercolumnwidth
    }

    ////////

    function loadView() {
        mediaPages.disableAnimation()
        mediaPages.interactive = false
        mediaPages.currentIndex = 0

        mediaPages.removePage(pageVideo1)
        mediaPages.removePage(pageVideo2)
        mediaPages.removePage(pageAudio1)
        mediaPages.removePage(pageAudio2)
        mediaPages.removePage(pageAudio3)
        mediaPages.removePage(pageAudio4)
        mediaPages.removePage(pageSubtitles)
        mediaPages.removePage(pageAudioTags)
        mediaPages.removePage(pageImageTags)
        mapLoader.source = ""
        mediaPages.removePage(pageMap)
        mediaPages.removePage(pageExport)
        menuVideo1.index = -1
        menuVideo2.index = -1
        menuAudio1.index = -1
        menuAudio2.index = -1
        menuAudio3.index = -1
        menuAudio4.index = -1
        menuSubtitles.index = -1
        menuAudioTags.index = -1
        menuImageTags.index = -1
        menuMap.index = -1
        menuExport.index = -1

        content_generic.loadGeneric()

        if (mediaItem.hasVideo) {
            if (mediaItem.videoTracksCount >= 1) {
                content_video1.loadTrack(mediaItem.getVideoTrack(0))
                mediaPages.addPage(pageVideo1)
                menuVideo1.index = mediaPages.count-1
            }
            if (mediaItem.videoTracksCount >= 2) {
                content_video2.loadTrack(mediaItem.getVideoTrack(1))
                mediaPages.addPage(pageVideo2)
                menuVideo2.index = mediaPages.count-1
            }
        }

        if (mediaItem.hasAudio) {
            if (mediaItem.audioTracksCount >= 1) {
                content_audio1.loadTrack(mediaItem.getAudioTrack(0))
                mediaPages.addPage(pageAudio1)
                menuAudio1.index = mediaPages.count-1
            }
            if (mediaItem.audioTracksCount >= 2) {
                content_audio2.loadTrack(mediaItem.getAudioTrack(1))
                mediaPages.addPage(pageAudio2)
                menuAudio2.index = mediaPages.count-1
            }
            if (mediaItem.audioTracksCount >= 3) {
                content_audio3.loadTrack(mediaItem.getAudioTrack(1))
                mediaPages.addPage(pageAudio3)
                menuAudio3.index = mediaPages.count-1
            }
            if (mediaItem.audioTracksCount >= 4) {
                content_audio4.loadTrack(mediaItem.getAudioTrack(1))
                mediaPages.addPage(pageAudio4)
                menuAudio4.index = mediaPages.count-1
            }
        }

        if (mediaItem.hasSubtitles) {
            content_subtitles.loadSubtitles(mediaItem)
            mediaPages.addPage(pageSubtitles)
            menuSubtitles.index = mediaPages.count-1
        }

        if (mediaItem.hasAudioTags) {
            content_audio_tags.loadTags(mediaItem)
            mediaPages.addPage(pageAudioTags)
            menuAudioTags.index = mediaPages.count-1
        }

        if (mediaItem.hasEXIF) {
            content_image_tags.loadTags(mediaItem)
            mediaPages.addPage(pageImageTags)
            menuImageTags.index = mediaPages.count-1
        }

        if (mediaItem.hasGPS) {
            if (mapLoader.status != Loader.Ready) {
                mapLoader.source = "InfosMap.qml"
            }

            content_map.loadGps(mediaItem)
            mediaPages.addPage(pageMap)
            menuMap.index = mediaPages.count-1
        }

        if (settingsManager.exportEnabled && mediaItem.hasVideo) {
            content_export.loadExport(mediaItem)
            mediaPages.addPage(pageExport)
            menuExport.index = mediaPages.count-1
        }

        mediaPages.enableAnimation()
        mediaPages.interactive = true
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: subheader

        z: 5
        height: visible ? 60 : 0
        color: Theme.colorHeader
        visible: !(isPhone && appWindow.screenOrientation === Qt.LandscapeOrientation)

        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        // prevent clicks below this area
        MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            spacing: 10

            Row {
                id: rowIcons
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                Column {
                    id: columnDuration
                    width: 96

                    IconSvg {
                        width: 40
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter

                        color: Theme.colorIcon
                        source: "qrc:/assets/icons/material-icons/duotone/av_timer.svg"
                    }
                    Text {
                        id: textDuration
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0

                        color: Theme.colorIcon
                        text: ""
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                    }
                }
                Column {
                    id: columnSize
                    width: 96

                    IconSvg {
                        width: 40
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter

                        color: Theme.colorIcon
                        source: "qrc:/assets/icons/material-icons/duotone/data_usage.svg"
                    }
                    Text {
                        id: textSize
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0

                        color: Theme.colorIcon
                        text: ""
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                    }
                }
                Column {
                    id: columnGeometry
                    width: 96

                    IconSvg {
                        id: imgGeometry
                        width: 40
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter

                        color: Theme.colorIcon
                        source: "qrc:/assets/icons/material-icons/duotone/aspect_ratio.svg"
                    }
                    Text {
                        id: textGeometry
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0

                        text: ""
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.colorIcon
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                    }
                }
                Column {
                    id: columnChannels
                    width: 96

                    IconSvg {
                        width: 40
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter

                        color: Theme.colorIcon
                        source: "qrc:/assets/icons/material-icons/duotone/speaker.svg"
                    }
                    Text {
                        id: textChannels
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0

                        text: ""
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.colorIcon
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                    }
                }
                Column {
                    id: columnGPS
                    width: 96

                    IconSvg {
                        width: 40
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter

                        color: Theme.colorIcon
                        source: "qrc:/assets/icons/material-icons/duotone/pin_drop.svg"
                    }
                    Text {
                        id: textGPS
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0

                        text: qsTr("GPS")
                        horizontalAlignment: Text.AlignHCenter
                        color: Theme.colorIcon
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14
                    }
                }
            }
        }
    }

    ////////

    Rectangle { // separator
        anchors.top: subheader.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        z: 5
        height: 2
        opacity: 0.66
        color: Theme.colorHeaderHighlight

        Rectangle { // shadow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: 8
            opacity: 0.66

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.colorHeaderHighlight; }
                GradientStop { position: 1.0; color: "transparent"; }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    SwipeView {
        id: mediaPages

        anchors.top: parent.top
        anchors.topMargin: subheader.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        interactive: true

        function enableAnimation() {
            contentItem.highlightMoveDuration = 333
        }
        function disableAnimation() {
            contentItem.highlightMoveDuration = 0
        }

        function addPage(page) {
            addItem(page)
            page.visible = true
        }

        function removePage(page) {
            for (var n = 0; n < mediaPages.count; n++) { if (page === itemAt(n)) { removeItem(n) } }
            page.visible = false
        }

        function removePages() {
            for (var n = 0; n < mediaPages.count; n++) {
                itemAt(0).visible = false
                removeItem(0)
            }
        }

        onCurrentIndexChanged: {
            //mediaPages.interactive = true
        }

        Item {
            id: pageGeneric
            visible: true

            InfosGeneric {
                id: content_generic
                anchors.fill: parent
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Item {
        id: pageVideo1
        visible: false

        InfosAV {
            id: content_video1
            anchors.fill: parent
        }
    }
    Item {
        id: pageVideo2
        visible: false

        InfosAV {
            id: content_video2
            anchors.fill: parent
        }
    }

    Item {
        id: pageAudio1
        visible: false

        InfosAV {
            id: content_audio1
            anchors.fill: parent
        }
    }
    Item {
        id: pageAudio2
        visible: false

        InfosAV {
            id: content_audio2
            anchors.fill: parent
        }
    }
    Item {
        id: pageAudio3
        visible: false

        InfosAV {
            id: content_audio3
            anchors.fill: parent
        }
    }
    Item {
        id: pageAudio4
        visible: false

        InfosAV {
            id: content_audio4
            anchors.fill: parent
        }
    }

    Item {
        id: pageSubtitles
        visible: false

        InfosSubtitles {
            id: content_subtitles
            anchors.fill: parent
        }
    }

    Item {
        id: pageAudioTags
        visible: false

        InfosAudioTags {
            id: content_audio_tags
            anchors.fill: parent
        }
    }

    Item {
        id: pageImageTags
        visible: false

        InfosImageTags {
            id: content_image_tags
            anchors.fill: parent
        }
    }

    property alias content_map: mapLoader.item
    Item {
        id: pageMap
        visible: false

        Loader {
            id: mapLoader
            anchors.fill: parent
        }
    }

    Item {
        id: pageExport
        visible: false

        InfosExport {
            id: content_export
            anchors.fill: parent
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleMenus
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        z: 5
        height: 56
        opacity: 0.90
        color: mobileMenu.color
        visible: !(isPhone && appWindow.screenOrientation === Qt.LandscapeOrientation) && (mediaPages.count > 1)

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: isPhone ? 3 : 0

            spacing: Theme.componentMargin / 3

            MobileMenuItem_vertical {
                id: menuInfos
                width: 56
                height: 56

                text: qsTr("file")
                source: "qrc:/assets/icons/material-symbols/file.svg"

                property int index: 0
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuVideo1
                width: 56
                height: 56

                text: qsTr("video")
                source: "qrc:/assets/icons/material-symbols/media/movie.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuVideo2
                width: 56
                height: 56

                text: qsTr("video")
                source: "qrc:/assets/icons/material-symbols/media/movie.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuAudio1
                width: 56
                height: 56

                text: qsTr("audio")
                source: "qrc:/assets/icons/material-symbols/media/speaker.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuAudio2
                width: 56
                height: 56

                text: qsTr("audio")
                source: "qrc:/assets/icons/material-symbols/media/speaker.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuAudio3
                width: 56
                height: 56

                text: qsTr("audio")
                source: "qrc:/assets/icons/material-symbols/media/speaker.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuAudio4
                width: 56
                height: 56

                text: qsTr("audio")
                source: "qrc:/assets/icons/material-symbols/media/speaker.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuSubtitles
                width: 56
                height: 56

                text: qsTr("subtitles")
                source: "qrc:/assets/icons/material-symbols/media/closed_caption.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuAudioTags
                width: 56
                height: 56

                text: qsTr("tags")
                source: "qrc:/assets/icons/material-symbols/insert_music.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuImageTags
                width: 56
                height: 56

                text: qsTr("tags")
                source: "qrc:/assets/icons/material-symbols/media/image.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuMap
                width: 56
                height: 56

                text: qsTr("map")
                source: "qrc:/assets/icons/material-symbols/map.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
            MobileMenuItem_vertical {
                id: menuExport
                width: 56
                height: 56

                text: qsTr("export")
                source: "qrc:/assets/icons/material-symbols/archive.svg"

                property int index: -1
                visible: (index !== -1)
                highlighted: (mediaPages.currentIndex === index)
                onClicked: mediaPages.currentIndex = index
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
