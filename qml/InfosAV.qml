import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Flickable {
    contentWidth: width
    contentHeight: columnMain.height

    ScrollBar.vertical: ScrollBar {}

    function loadTrack(trackItem) {
        if (typeof trackItem === "undefined" || !trackItem) return

        // track
        titleTrackText.text = (trackItem.type === 1 ? qsTr("AUDIO") : qsTr("VIDEO")) + " " + qsTr("TRACK")
        info_id.text = trackItem.id
        info_size.text = UtilsString.bytesToString_short(trackItem.size, settingsManager.unitSizes)
        info_duration.text = UtilsString.durationToString_long(trackItem.duration)
        item_delay.visible = (trackItem.delay !== 0)
        info_delay.text = UtilsString.durationToString_short(trackItem.delay)

        item_title.visible = (trackItem.title.length > 0)
        info_title.text = trackItem.title
        //item_title.height = (info_title.height > 24) ? info_title.height + 4 : 24

        item_language.visible = (trackItem.language.length > 0)
        info_language.text = trackItem.language

        item_visible.visible = (trackItem.visible)
        info_visible.text = trackItem.visible
        item_forced.visible = (trackItem.forced)
        info_forced.text = trackItem.forced

        // video
        if (trackItem.type === 2) { // stream_VIDEO
            columnVideo.visible = true
            columnAudio.visible = false

            // Codec
            info_vcodec.text = trackItem.codec
            item_vcodecprofile.visible = (trackItem.codecProfileAndLevel.length > 0)
            info_vcodecprofile.text = trackItem.codecProfileAndLevel
            item_vcodecfeatures.visible = (trackItem.codecFeatures.length > 0)
            info_vcodecfeatures.text = trackItem.codecFeatures

            // Geometry
            info_vdefinition.text = trackItem.width + " x " + trackItem.height
            item_vdefinition_visible.visible = ((trackItem.width_visible + trackItem.height_visible) > 0 &&
                                                (trackItem.width_visible !== trackItem.width || trackItem.height_visible !== trackItem.height))
            info_vdefinition_visible.text = trackItem.width_visible + " x " + trackItem.height_visible

            info_dar.text = UtilsMedia.varToString(trackItem.width, trackItem.height)
            var ardesc = UtilsMedia.varToDescString(trackItem.width, trackItem.height)
            if (ardesc.length > 0) info_dar.text += "  (" + ardesc + ")"

            item_vprojection.visible = (trackItem.projection > 0)
            info_vprojection.text = UtilsMedia.projectionToString(trackItem.projection)
            item_vorientation.visible = (trackItem.orientation > 0)
            info_vorientation.text = UtilsMedia.orientationMp4ToString(trackItem.orientation)

            item_vscan.visible = (trackItem.scanmode > 0)
            info_vscan.text = UtilsMedia.scanmodeToString(trackItem.scanmode)

            itemDar.visible = true
            itemPar.visible = false
            itemVar.visible = false

            // Colors
            item_vcolordepth.visible = (trackItem.colorDepth > 0)
            item_vcolorrange.visible = (trackItem.colorDepth > 0)
            item_vcolorprimaries.visible = (trackItem.colorPrimaries.length > 0 && trackItem.colorTransfer.length > 0)
            item_vcolortransfer.visible = (trackItem.colorPrimaries.length > 0 && trackItem.colorTransfer.length > 0)
            item_vcolormatrix.visible = (trackItem.colorPrimaries.length > 0 && trackItem.colorTransfer.length > 0)

            if (trackItem.colorDepth > 0) {
                info_vcolordepth.text = trackItem.colorDepth + " bits"

                if (trackItem.colorRange)
                    info_vcolorrange.text = qsTr("full")
                else
                    info_vcolorrange.text = qsTr("limited")
            }
            if (trackItem.colorPrimaries.length > 0 && trackItem.colorTransfer.length > 0) {
                info_vcolorprimaries.text = trackItem.colorPrimaries
                info_vcolortransfer.text = trackItem.colorTransfer
                info_vcolormatrix.text = trackItem.colorMatrix
            }

            // Framerate
            info_vframerate.text = trackItem.framerate.toFixed(3) + " fps"
            info_vframeduration.text = trackItem.frameDuration.toFixed(2) + " ms"
        }

        // audio
        if (trackItem.type === 1) { // stream_AUDIO
            columnVideo.visible = false
            columnAudio.visible = true

            info_acodec.text = trackItem.codec
            item_acodecprofile.visible = (trackItem.codecProfile.length > 0)
            info_acodecprofile.text = trackItem.codecProfile

            info_achannels.text = trackItem.audioChannels
            info_asamplerate.text = trackItem.audioSamplerate + " Hz"
            info_abpp.text = trackItem.audioBitPerSample + " bpp"
            item_aframeduration.visible = true
            info_aframeduration.text = (trackItem.duration / trackItem.sampleCount).toFixed(2) + " ms"
            item_asampleduration.visible = true
            info_asampleduration.text = trackItem.sampleDuration.toFixed(2) + " µs"
            item_asampleperframe.visible = (trackItem.audioSamplePerFrame > 0)
            info_asampleperframe.text = trackItem.audioSamplePerFrame

            speakers.visible = true
            speakers_lfe.visible = trackItem.audioChannels > 5
            if (trackItem.audioChannels === 6)
                speakers.source = "qrc:/speakers/5_0.svg"
            else if (trackItem.audioChannels === 2)
                speakers.source = "qrc:/speakers/2_0_stereo.svg"
            else if (trackItem.audioChannels === 1)
                speakers.source = "qrc:/speakers/1_0.svg"
            else
                speakers.visible = false
        }

        // Graph (if VBR stream)
        bitrateGraphItem.visible = (trackItem.bitrateMode > 1)
        if (trackItem.bitrateMode > 1) {
            bitrateData.clear()
            trackItem.getBitrateDataFps(bitrateData, 96);

            // Axis
            axisX0.min = 0;
            axisX0.max = bitrateData.count
            var minmax_of_array = 0
            for (var i = 0; i < bitrateData.count; i++)
                if (bitrateData.at(i).y > minmax_of_array)
                    minmax_of_array = bitrateData.at(i).y
            if (trackItem.type === 1) { // audio
                axisBitrate.min = 0;
                axisBitrate.max = minmax_of_array * 1.0;
            } else {
                axisBitrate.min = 0;
                axisBitrate.max = minmax_of_array * 1.0;
            }
        }

        // data
        item_bitrate_minmax.visible = (trackItem.bitrateMode > 1)
        info_bitrate.text = UtilsMedia.bitrateToString(trackItem.bitrate_avg)
        info_bitrate.text += "  (" + UtilsMedia.bitrateModeToString(trackItem.bitrateMode) + ")"
        info_bitrate_min.text = UtilsMedia.bitrateToString(trackItem.bitrate_min)
        info_bitrate_max.text = UtilsMedia.bitrateToString(trackItem.bitrate_max)
        info_compression.text = trackItem.compressionRatio + ":1"

        item_samplecount.visible = (trackItem.sampleCount !== trackItem.frameCount)
        info_samplecount.text = trackItem.sampleCount

        info_framecount.visible = true
        info_framecount.text = trackItem.frameCount

        if (trackItem.frameCountIdr > 0 && trackItem.frameCountIdr !== trackItem.frameCount) {
            item_idr.visible = true
            info_idr.text = trackItem.frameCountIdr

            var idr_ratio = (trackItem.frameCountIdr / trackItem.frameCount) * 100
            info_idr.text += "  (" + idr_ratio.toFixed(1) + "% of the frames)"
        } else {
            item_idr.visible = false
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        id: columnMain
        anchors.left: parent.left
        anchors.right: parent.right

        topPadding: 16
        bottomPadding: 16 + rectangleMenus.height
        spacing: 8

        ////////////////

        Column {
            id: columnTrack
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item { ////
                id: titleTrack
                height: 32
                anchors.left: parent.left
                anchors.right: parent.right

                ImageSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons_material/duotone-list-24px.svg"
                }
                Text {
                    id: titleTrackText
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    font.pixelSize: 18
                    font.bold: true
                }
            }

            ////////////////

            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("internal id")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_id
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("data size")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_size
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("duration")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_duration
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_delay
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("delay")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_delay
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Item { ////
                id: item_title
                height: (info_title.height > 24) ? (info_title.height + 0) : 24
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                Text {
                    id: legend_title
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("title")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_title
                    anchors.left: legend_title.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8

                    color: Theme.colorText
                    font.pixelSize: 15
                    wrapMode: Text.WrapAnywhere
                }
            }
            Row { ////
                id: item_language
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("language")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_language
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_visible
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("track visible")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_visible
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_forced
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("track forced")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_forced
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
        }

        ////////////////

        Column {
            id: columnVideo
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item { ////
                id: titleVideo
                height: 32
                anchors.left: parent.left
                anchors.right: parent.right

                ImageSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons_material/outline-local_movies-24px.svg"
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
                height: 24
                spacing: 16

                Text {
                    text: qsTr("codec")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vcodec
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vcodecprofile
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("profile")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vcodecprofile
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vcodecfeatures
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("features")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vcodecfeatures
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }

            Item { width: 4; height: 4; } // spacer

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
                Text {
                    id: info_vdefinition
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vdefinition_visible
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("definition (visible)")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vdefinition_visible
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: itemDar
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    id: legend_dar
                    text: qsTr("aspect ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_dar
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: itemVar
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("video aspect ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_var
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: itemPar
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("pixel aspect ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_par
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vprojection
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("projection")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vprojection
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vorientation
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("orientation")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vorientation
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vscan
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("scan type")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vscan
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }

            Item { width: 4; height: 4; } // spacer

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
                Text {
                    id: info_vframerate
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("frame duration")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vframeduration
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }

            Item { width: 4; height: 4; } // spacer

            Row { ////
                id: item_vcolordepth
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("color depth")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vcolordepth
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vcolorrange
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("color range")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vcolorrange
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vcolorprimaries
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("color primaries")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vcolorprimaries
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vcolortransfer
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("transfer characteristics")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vcolortransfer
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_vcolormatrix
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("color matrix")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vcolormatrix
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
        }

        ////////////////

        Column {
            id: columnAudio
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item {
                id: titleAudio
                height: 32
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons_material/outline-speaker-24px.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("AUDIO")
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
                Text {
                    id: info_acodec
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_acodecprofile
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("profile")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_acodecprofile
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }

            Item { width: 4; height: 4; } // spacer

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
                Text {
                    id: info_asamplerate
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("bit per sample")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_abpp
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_aframeduration
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("frame duration")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_aframeduration
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_asampleduration
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("sample duration")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_asampleduration
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_asampleperframe
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("sample per frame")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_asampleperframe
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }

            Item { width: 4; height: 4; } // spacer

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
                Text {
                    id: info_achannels
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Item { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                //anchors.right: parent.right
                //anchors.rightMargin: 12
                width: 160
                height: 160

                ImageSvg {
                    id: speakers_lfe
                    anchors.fill: parent
                    source: "qrc:/speakers/LFE.svg"
                    color: Theme.colorIcon
                }
                ImageSvg {
                    id: speakers
                    anchors.fill: parent
                    source: "qrc:/speakers/2_0_stereo.svg"
                    color: Theme.colorIcon
                }
            }
        }

        ////////////////

        Column {
            id: columnData
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item {
                id: titleData
                height: 32
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons_material/duotone-sd_card-24px.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("DATA")
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
                    text: qsTr("compression ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_compression
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_bitrate
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_bitrate_minmax
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("min")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_bitrate_min
                    color: Theme.colorText
                    font.pixelSize: 15
                }
                Text {
                    text: qsTr("max")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_bitrate_max
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }

            Item {
                id: bitrateGraphItem
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 12
                height: 180

                ChartView {
                    id: bitrateGraph
                    anchors.fill: parent
                    anchors.topMargin: -28
                    anchors.leftMargin: (isMobile) ? -34 : -38
                    anchors.rightMargin: -32
                    anchors.bottomMargin: -24

                    antialiasing: true
                    legend.visible: false

                    backgroundRoundness: 0
                    backgroundColor: "transparent"
                    //animationOptions: ChartView.SeriesAnimations
                    ValueAxis { id: axisX0; visible: true; gridVisible: false;
                        labelsVisible: false; labelsFont.pixelSize: 1; labelFormat: ""}
                    ValueAxis { id: axisBitrate; visible: true; gridVisible: false;
                        labelsVisible: false; labelsFont.pixelSize: 1; labelFormat: "" }

                    LineSeries {
                        id: bitrateData
                        //useOpenGL: true

                        color: Theme.colorSecondary
                        width: 1
                        visible: true

                        axisX: axisX0
                        axisY: axisBitrate
                    }
                }
            }

            Row { ////
                id: item_samplecount
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("sample count")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_samplecount
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_framecount
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("frame count")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_framecount
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
            Row { ////
                id: item_idr
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("frame sync count")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_idr
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
        }
    }
}
