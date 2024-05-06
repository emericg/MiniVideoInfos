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
        item_duration.visible = (mediaItem.duration > 0)
        info_duration.text = UtilsString.durationToString_long(mediaItem.duration)
        info_size.text = UtilsString.bytesToString(mediaItem.size, settingsManager.unitSizes)
        item_timecode.visible = (mediaItem.timecode.length > 0)
        info_timecode.text = mediaItem.timecode

        item_capp.visible = (mediaItem.creation_app.length > 0)
        info_capp.text = mediaItem.creation_app
        item_clib.visible = (mediaItem.creation_lib.length > 0 && mediaItem.creation_lib !== mediaItem.creation_app)
        info_clib.text = mediaItem.creation_lib

        item_container.visible = (mediaItem.container.length > 0)
        info_container.text = mediaItem.container
        item_containerprofile.visible = (mediaItem.containerProfile.length > 0)
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
            item_iorientation.visible = (mediaItem.transformation !== 0)
            info_iorientation.text = UtilsMedia.orientationQtToString(mediaItem.transformation)
            item_iprojection.visible = (mediaItem.projection > 0)
            info_iprojection.text = UtilsMedia.projectionToString(mediaItem.projection)
            item_idepth.visible = (mediaItem.depth > 0)
            info_idepth.text = mediaItem.depth
            item_ialpha.visible = mediaItem.alpha
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
            height: 72
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

            Item { ////
                id: titleFile
                height: 32
                anchors.left: parent.left
                anchors.right: parent.right

                IconSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons/material-symbols/file.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("FILE")
                    color: Theme.colorPrimary
                    font.pixelSize: 18
                    font.bold: true
                }
            }

            Item { ////
                id: item_path
                height: Math.max(UtilsNumber.alignTo(info_path.contentHeight + 4, 4), 24)
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                Text {
                    id: legend_path
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("path")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_path
                    anchors.left: legend_path.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
            Item { ////
                id: item_name
                height: Math.max(UtilsNumber.alignTo(info_name.contentHeight + 4, 4), 24)
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                Text {
                    id: legend_name
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("name")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_name
                    anchors.left: legend_name.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("extension")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_extension
                }
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

            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("date")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_date
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("time")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_time
                }
            }
            Row { ////
                id: item_duration
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("duration")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_duration
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("size")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_size
                }
            }
            Row { ////
                id: item_timecode
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("SMPTE timecode")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_timecode
                }
            }
            Item { ////
                id: item_container
                height: Math.max(UtilsNumber.alignTo(info_container.contentHeight + 4, 4), 24)
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right

                Text {
                    id: legend_container
                    height: 24
                    anchors.left: parent.left

                    text: qsTr("container")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_container
                    anchors.left: legend_container.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
            Row { ////
                id: item_containerprofile
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("profile")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_containerprofile
                }
            }
            Item { ////
                id: item_capp
                height: Math.max(UtilsNumber.alignTo(info_capp.contentHeight + 4, 4), 24)
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                Text {
                    id: legend_capp
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("creation app.")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_capp
                    anchors.left: legend_capp.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
            Item { ////
                id: item_clib
                height: Math.max(UtilsNumber.alignTo(info_clib.contentHeight + 4, 4), 24)
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                Text {
                    id: legend_clib
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("creation lib.")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_clib
                    anchors.left: legend_clib.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
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

            Item { ////
                id: titleImage
                height: 32
                anchors.left: parent.left
                anchors.right: parent.right

                IconSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons/material-symbols/media/image.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("IMAGE")
                    color: Theme.colorPrimary
                    font.pixelSize: 18
                    font.bold: true
                }
            }

            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("codec")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_icodec
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("megapixel")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_impix
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_iresolution.text.length > 0)

                Text {
                    text: qsTr("resolution")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_iresolution
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("definition")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_idefinition
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("aspect ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_iaspectratio
                }
            }
            Row { ////
                id: item_iorientation
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("orientation")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_iorientation
                }
            }
            Row { ////
                id: item_iprojection
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("projection")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_iprojection
                }
            }
            Row { ////
                id: item_idepth
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("bit depth")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_idepth
                }
            }
            Row { ////
                id: item_ialpha
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("alpha channel")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_ialpha
                }
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

                Item { ////
                    id: titleVideo
                    height: 32
                    anchors.left: parent.left
                    anchors.right: parent.right

                    IconSvg {
                        width: 32
                        height: 32
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter

                        color: Theme.colorPrimary
                        source: "qrc:/assets/icons/material-symbols/media/movie.svg"
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: qsTr("VIDEO")
                        color: Theme.colorPrimary
                        font.pixelSize: 18
                        font.bold: true
                    }
                }

                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    height: Math.max(UtilsNumber.alignTo(videoCodecText.height + 4, 4), 24)
                    spacing: 16

                    Text {
                        id: videoCodecLegend
                        text: qsTr("codec")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        id: videoCodecText
                        width: parent.width - parent.spacing - videoCodecLegend.width
                        text: modelData.codec
                    }
                }
                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    Text {
                        text: qsTr("definition")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
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
                }
                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    Text {
                        text: qsTr("aspect ratio")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        text: {
                            var txt = UtilsMedia.varToString(modelData.widthVisible, modelData.heightVisible)
                            var ardesc = UtilsMedia.varToDescString(modelData.widthVisible, modelData.heightVisible)
                            if (ardesc.length > 0) txt += "  (" + ardesc + ")"
                            return txt
                        }
                    }
                }
                Row { ////
                    id: item_vprojection
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    visible: (modelData.projection > 0)

                    Text {
                        text: qsTr("projection")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        text: UtilsMedia.projectionToString(modelData.projection)
                    }
                }
                Row { ////
                    id: item_vorientation
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    visible: (modelData.orientation > 0)

                    Text {
                        text: qsTr("orientation")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        text: UtilsMedia.orientationMp4ToString(modelData.orientation)
                    }
                }
                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    Text {
                        text: qsTr("framerate")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        text: UtilsMedia.framerateToString(modelData.framerate)
                    }
                }
                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    Text {
                        text: qsTr("bitrate")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        text: UtilsMedia.bitrateToString(modelData.bitrate_avg) +
                              "  (" + UtilsMedia.bitrateModeToString(modelData.bitrateMode) + ")"
                    }
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

                Item {
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    IconSvg {
                        width: 32
                        height: 32
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter

                        color: Theme.colorPrimary
                        source: "qrc:/assets/icons/material-symbols/media/speaker.svg"
                    }
                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 56
                        anchors.verticalCenter: parent.verticalCenter

                        text: {
                            if (columnAudio.model.length > 1)
                                return qsTr("AUDIO") + " #" + (index + 1)
                            else
                                return qsTr("AUDIO")
                        }
                        color: Theme.colorPrimary
                        font.pixelSize: 18
                        font.bold: true
                    }
                }
                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    height: Math.max(UtilsNumber.alignTo(audioCodecText.height + 4, 4), 24)
                    spacing: 16

                    Text {
                        id: audioCodecLegend
                        text: qsTr("codec")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        id: audioCodecText
                        width: parent.width - parent.spacing - audioCodecLegend.width
                        text: modelData.codec
                    }
                }
                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    Text {
                        text: qsTr("channels")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        text: modelData.audioChannels
                    }
                }
                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    Text {
                        text: qsTr("samplerate")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        text: modelData.audioSamplerate + " Hz"
                    }
                }
                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    Text {
                        text: qsTr("bitrate")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        text: UtilsMedia.bitrateToString(modelData.bitrate_avg) +
                              "  (" + UtilsMedia.bitrateModeToString(modelData.bitrateMode) + ")"
                    }
                }
            }
        }

        ////////////////

        Column {
            id: columnSubtitles
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item {
                id: titleSubtitles
                height: 32
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                IconSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons/material-symbols/media/closed_caption.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("SUBTITLES")
                    color: Theme.colorPrimary
                    font.pixelSize: 18
                    font.bold: true
                }
            }

            Repeater {
                id: repeaterSubtitles
                anchors.left: parent.left
                anchors.right: parent.right

                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    height: Math.max(UtilsNumber.alignTo(trackSubtitleTitle.contentHeight + 4, 4), 24)
                    spacing: 8

                    Text {
                        id: trackSubtitleId
                        text: qsTr("subtitles track #") + (index + 1)
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        visible: trackSubtitleTitle.text.length
                        text: "/"
                        color: Theme.colorText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        id: trackSubtitleTitle
                        width: parent.width - parent.spacing - trackSubtitleId.contentWidth

                        text: {
                            var txt = ""
                            if (modelData.codec.length) txt += modelData.codec
                            if (modelData.language.length) txt += modelData.language
                            if (modelData.title.length) txt += modelData.title
                            return txt
                        }
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

            Item {
                id: titleOther
                height: 32
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                IconSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons/material-icons/duotone/list.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("OTHER")
                    color: Theme.colorPrimary
                    font.pixelSize: 18
                    font.bold: true
                }
            }

            Repeater {
                id: repeaterOther
                anchors.left: parent.left
                anchors.right: parent.right
                //model: mediaItem.getOtherTracks()

                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    height: Math.max(UtilsNumber.alignTo(trackOtherTitle.contentHeight + 4, 4), 24)
                    spacing: 16

                    Text {
                        id: trackOtherId
                        text: {
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
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    TextEditMVI {
                        id: trackOtherTitle
                        width: parent.width - parent.spacing - trackOtherId.contentWidth
                        text: {
                            if (modelData.type === 6) // MiniVideo.stream_TMCD
                                return mediaItem.timecode
                            else
                                return modelData.title
                        }
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

            Item {
                id: titleChapters
                height: 32
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                IconSvg {
                    width: 28
                    height: 28
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    rotation: 90

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons/material-symbols/label_important.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("CHAPTERS")
                    color: Theme.colorPrimary
                    font.pixelSize: 18
                    font.bold: true
                }
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
