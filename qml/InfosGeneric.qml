import QtQuick
import QtQuick.Controls

import ThemeEngine
import "qrc:/utils/UtilsPath.js" as UtilsPath
import "qrc:/utils/UtilsString.js" as UtilsString
import "qrc:/utils/UtilsMedia.js" as UtilsMedia
import "qrc:/utils/UtilsNumber.js" as UtilsNumber

Flickable {
    contentWidth: width
    contentHeight: columnMain.height

    ScrollBar.vertical: ScrollBar { visible: isDesktop }

    ////////////////////////////////////////////////////////////////////////////

    function loadGeneric() {
        info_name.text = mediaItem.name
        info_path.text = mediaItem.path
        info_extension.text = mediaItem.ext
        item_extension_mismatch.visible = mediaItem.extensionMismatch
        info_extension_mismatch.text = qsTr("should be %1").arg(mediaItem.containerExt)
        info_date.text = mediaItem.date.toLocaleDateString()
        info_time.text = mediaItem.date.toLocaleTimeString()
        info_duration.visible = (mediaItem.duration > 0)
        info_duration.text = UtilsString.durationToString_long(mediaItem.duration)
        info_size.text = UtilsString.bytesToString(mediaItem.size, settingsManager.unitSizes)
        info_timecode.text = mediaItem.timecode

        info_capp.text = mediaItem.creation_app
        info_clib.visible = (mediaItem.creation_lib.length > 0 && mediaItem.creation_lib !== mediaItem.creation_app)
        info_clib.text = mediaItem.creation_lib

        info_container.text = mediaItem.container
        info_containerprofile.text = mediaItem.containerProfile

        if (mediaItem.projection > 0)
            imgGeometry.source = "qrc:/assets/icons/material-icons/duotone/spherical.svg"
        else
            imgGeometry.source = "qrc:/assets/icons/material-icons/duotone/aspect_ratio.svg"

        if (mediaItem.fileType === 3) { //// IMAGE
            columnImage.visible = true

            info_icodec.text = mediaItem.videoCodec
            info_impix.text = ((mediaItem.widthVisible * mediaItem.heightVisible) / 1000000).toFixed(1) + " " + qsTr("MP")
            info_idefinition.text = mediaItem.widthVisible + " x " + mediaItem.heightVisible
            if (mediaItem.width !== mediaItem.widthVisible || mediaItem.height !== mediaItem.heightVisible) {
                if (mediaItem.transformation > 3) {
                    info_idefinition.text += " (" + qsTr("rotated") + ")"
                }
            }
            info_iaspectratio.text = UtilsMedia.varToString(mediaItem.widthVisible, mediaItem.heightVisible)
            info_iresolution.text = (mediaItem.resolution) ? (mediaItem.resolution + " " + qsTr("dpi")) : ""
            info_iorientation.visible = (mediaItem.transformation !== 0)
            info_iorientation.text = UtilsMedia.orientationQtToString(mediaItem.transformation)
            info_iprojection.visible = (mediaItem.projection > 0)
            info_iprojection.text = UtilsMedia.projectionToString(mediaItem.projection)
            info_idepth.visible = (mediaItem.depth > 0)
            info_idepth.text = mediaItem.depth
            info_ialpha.visible = mediaItem.alpha
            info_ialpha.text = mediaItem.alpha

            if (settingsManager.mediaPreview) {
                var w = info_preview.width
                var h = info_preview.width / (mediaItem.widthVisible / mediaItem.heightVisible)
                info_preview.sourceSize.width = w*2
                info_preview.sourceSize.height = h*2
                info_preview.source = "file://" + mediaItem.fullpath
                item_preview.height = h
                item_preview.visible = true
            } else {
                item_preview.visible = false
            }
        } else {
            columnImage.visible = false
            columnVideo.visible = false
        }

        // Track sizes graph
        if (mediaItem.videoTracksCount + mediaItem.audioTracksCount > 0) {
            elementTracks.visible = true
            elementTracks.load(mediaItem)
        } else {
            elementTracks.visible = false
        }

        // Video tracks
        columnVideo.model = mediaItem.videoTracks

        // Audio tracks
        columnAudio.model = mediaItem.audioTracks

        // Subtitles tracks
        columnSubtitles.visible = mediaItem.subtitlesTracksCount
        repeaterSubtitles.model = mediaItem.subtitlesTracks

        // Chapters
        columnChapters.visible = mediaItem.chaptersCount
        repeaterChapters.model = mediaItem.chapters

        // Other tracks
        columnOther.visible = mediaItem.otherTracksCount
        repeaterOther.model = mediaItem.otherTracks
    }

    function loadSubHeader() {
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

    ////////////////////////////////////////////////////////////////////////////

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

    Column {
        id: columnMain
        anchors.left: parent.left
        anchors.right: parent.right

        topPadding: 16
        bottomPadding: 16 + mobileMenu.height
        spacing: 8

        ////////////////

        Rectangle {
            id: subheader
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16

            clip: true
            height: 80
            radius: 8
            color: Theme.colorHeader
            visible: (isPhone && appWindow.screenOrientation === Qt.PortraitOrientation)

            Row {
                anchors.centerIn: parent
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

        ////////////////

        Column {
            id: columnFile
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/file.svg"
                text: qsTr("FILE")
            }

            InfoRow { ////
                id: info_path
                legend: qsTr("path")
            }
            InfoRow { ////
                id: info_name
                legend: qsTr("name")
            }
            InfoRow { ////
                id: info_extension
                legend: qsTr("extension")
            }
            Row { ////
                id: item_extension_mismatch
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 12

                Text {
                    text: qsTr("extension mismatch")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                IconSvg {
                    width: 24
                    height: 24
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    source: "qrc:/assets/icons/material-symbols/warning.svg"
                    color: Theme.colorWarning
                }
                TextEditMVI {
                    id: info_extension_mismatch
                    color: Theme.colorText
                    font.pixelSize: 15
                    font.capitalization: Font.AllLowercase
                }
            }

            InfoRow { ////
                id: info_date
                legend: qsTr("date")
            }
            InfoRow { ////
                id: info_time
                legend: qsTr("time")
            }
            InfoRow { ////
                id: info_duration
                legend: qsTr("duration")
            }
            InfoRow { ////
                id: info_size
                legend: qsTr("size")
            }
            InfoRow { ////
                id: info_timecode
                legend: qsTr("SMPTE timecode")
            }
            InfoRow { ////
                id: info_container
                legend: qsTr("container")
            }
            InfoRow { ////
                id: info_containerprofile
                legend: qsTr("profile")
            }
            InfoRow { ////
                id: info_capp
                legend: qsTr("creation app.")
            }
            InfoRow { ////
                id: info_clib
                legend: qsTr("creation lib.")
            }

            ItemTracksGraph {
                id: elementTracks
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 12
                height: 32
            }
        }

        ////////////////

        Column {
            id: columnImage
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/media/image.svg"
                text: qsTr("IMAGE")
            }

            InfoRow { ////
                id: info_icodec
                legend: qsTr("codec")
            }
            InfoRow { ////
                id: info_impix
                legend: qsTr("megapixel")
            }
            InfoRow { ////
                id: info_iresolution
                legend: qsTr("resolution")
            }
            InfoRow { ////
                id: info_idefinition
                legend: qsTr("definition")
            }
            InfoRow { ////
                id: info_iaspectratio
                legend: qsTr("aspect ratio")
            }
            InfoRow { ////
                id: info_iorientation
                legend: qsTr("orientation")
            }
            InfoRow { ////
                id: info_iprojection
                legend: qsTr("projection")
            }
            InfoRow { ////
                id: info_idepth
                legend: qsTr("bit depth")
            }
            InfoRow { ////
                id: info_ialpha
                legend: qsTr("alpha channel")
            }

            Item {
                id: item_preview ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 12
                height: 24

                Image {
                    id: info_preview
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    horizontalAlignment: Image.AlignLeft
                    autoTransform: true
                    fillMode: Image.PreserveAspectFit

                    PopupImage {
                        id: popupImage
                    }
                }
                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        if (isMobile) {
                            popupImage.source = info_preview.source
                            popupImage.open()
                        }
                    }
                    onDoubleClicked: {
                        if (isDesktop) {
                            popupImage.source = info_preview.source
                            popupImage.open()
                        }
                    }
                    onPressAndHold: {
                        if (isDesktop) {
                            utilsApp.openWith(mediaItem.fullpath)
                        } else {
                            utilsApp.vibrate(25)
                            var mimetype = "image/" + mediaItem.videoCodec
                            //if (mediaItem.videoCodec === "") mimetype =
                            utilsShare.sendFile(mediaItem.fullpath, "Open file", mimetype, 0)
                        }
                    }
                }
            }
        }

        ////////////////

        Repeater {
            id: columnVideo
            anchors.left: parent.left
            anchors.right: parent.right
            //model: mediaItem.getVideoTracks()

            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 2

                InfoTitle { ////
                    source: "qrc:/assets/icons/material-symbols/media/movie.svg"
                    text: qsTr("VIDEO")
                }

                InfoRow { ////
                    legend: qsTr("codec")
                    text: modelData.codec
                }
                InfoRow { ////
                    legend: qsTr("definition")
                    text: {
                        var txt = modelData.widthVisible + " x " + modelData.heightVisible
                        if (modelData.width !== modelData.widthVisible ||
                            modelData.height !== modelData.heightVisible) {
                            if (modelData.orientation) {
                                txt += " (" + qsTr("rotated") + ")"
                            } else {
                                txt += " (" + qsTr("stretched") + ")"
                            }
                        }
                        return txt
                    }
                }
                InfoRow { ////
                    legend: qsTr("aspect ratio")
                    text: {
                        var txt = UtilsMedia.varToString(modelData.widthVisible, modelData.heightVisible)
                        var ardesc = UtilsMedia.varToDescString(modelData.widthVisible, modelData.heightVisible)
                        if (ardesc.length > 0) txt += "  (" + ardesc + ")"
                        return txt
                    }
                }
                InfoRow { ////
                    visible: (modelData.projection > 0)
                    legend: qsTr("projection")
                    text: UtilsMedia.projectionToString(modelData.projection)
                }
                InfoRow { ////
                    visible: (modelData.orientation > 0)
                    legend: qsTr("orientation")
                    text: UtilsMedia.orientationMp4ToString(modelData.orientation)
                }
                InfoRow { ////
                    legend: qsTr("framerate")
                    text: UtilsMedia.framerateToString(modelData.framerate)
                }
                InfoRow { ////
                    legend: qsTr("bitrate")
                    text: UtilsMedia.bitrateToString(modelData.bitrate_avg) +
                          "  (" + UtilsMedia.bitrateModeToString(modelData.bitrateMode) + ")"
                }
            }
        }

        ////////

        Repeater {
            id: columnAudio
            anchors.left: parent.left
            anchors.right: parent.right
            //model: mediaItem.getAudioTracks()

            Column {
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 2

                InfoTitle { ////
                    source: "qrc:/assets/icons/material-symbols/media/speaker.svg"
                    text: {
                        if (columnAudio.model.length > 1)
                            return qsTr("AUDIO") + " #" + (index + 1)
                        else
                            return qsTr("AUDIO")
                    }
                }

                InfoRow { ////
                    legend: qsTr("codec")
                    text: modelData.codec
                }
                InfoRow { ////
                    legend: qsTr("channels")
                    text: modelData.audioChannels
                }
                InfoRow { ////
                    legend: qsTr("samplerate")
                    text: modelData.audioSamplerate + " Hz"
                }
                InfoRow { ////
                    legend: qsTr("bitrate")
                    text: UtilsMedia.bitrateToString(modelData.bitrate_avg) +
                          "  (" + UtilsMedia.bitrateModeToString(modelData.bitrateMode) + ")"
                }
            }
        }

        ////////////////

        Column {
            id: columnSubtitles
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/media/closed_caption.svg"
                text: qsTr("SUBTITLES")
            }

            Repeater {
                id: repeaterSubtitles
                anchors.left: parent.left
                anchors.right: parent.right

                InfoRow { ////
                    legend: qsTr("#") + (index + 1)
                    text: {
                        var txt = ""
                        if (modelData.codec.length) {
                            if (txt.length) txt += " / "
                            txt += modelData.codec
                        }
                        if (modelData.language.length) {
                            if (txt.length) txt += " / "
                            txt += modelData.language
                        }
                        if (modelData.title.length) {
                            if (txt.length) txt += " / "
                            txt += modelData.title
                        }
                        return txt
                    }
                }
            }
        }

        ////////////////

        Column {
            id: columnOther
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-icons/duotone/list.svg"
                text: qsTr("OTHER")
            }

            Repeater {
                id: repeaterOther
                anchors.left: parent.left
                anchors.right: parent.right
                //model: mediaItem.getOtherTracks()

                InfoRow { ////
                    legend: {
                        if (modelData.type === 5) // MiniVideo.stream_MENU
                            return qsTr("menu track #") + modelData.id
                        else if (modelData.type === 6) // MiniVideo.stream_TMCD
                            return qsTr("SMPTE timecode")
                        else if (modelData.type === 7) // MiniVideo.stream_META
                            return qsTr("metadata track")
                        else if (modelData.type === 8) // MiniVideo.stream_HINT
                            return qsTr("hint track")
                        else
                            return qsTr("Unknown track type")
                    }
                    text: {
                        if (modelData.type === 6) // MiniVideo.stream_TMCD
                            return mediaItem.timecode
                        else
                            return modelData.title
                    }
                }
            }
        }

        ////////////////

        Column {
            id: columnChapters
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/label_important.svg"
                text: qsTr("CHAPTERS")
            }

            Repeater {
                id: repeaterChapters
                anchors.left: parent.left
                anchors.right: parent.right

                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    height: 24
                    spacing: 8

                    Text {
                        id: trackChapterId
                        text: "#" + (index + 1)
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        id: trackChapterName
                        visible: modelData.name.length
                        text: modelData.name
                    }
                    Text {
                        text: "@"
                        color: Theme.colorText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        id: trackChapterTimestamp
                        text: UtilsString.durationToString_ISO8601_compact(modelData.pts)
                        color: Theme.colorSubText
                    }
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
