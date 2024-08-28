import QtQuick
import QtQuick.Controls

import QtCharts

import ThemeEngine
import "qrc:/utils/UtilsPath.js" as UtilsPath
import "qrc:/utils/UtilsString.js" as UtilsString
import "qrc:/utils/UtilsMedia.js" as UtilsMedia
import "qrc:/utils/UtilsNumber.js" as UtilsNumber

Flickable {
    contentWidth: width
    contentHeight: columnMain.height

    ScrollBar.vertical: ScrollBar {
        visible: isDesktop
        policy: ScrollBar.AsNeeded
    }

    ////////////////////////////////////////////////////////////////////////////

    function loadTrack(trackItem) {
        if (typeof trackItem === "undefined" || !trackItem) return

        // track
        titleTrack.text = (trackItem.type === 1 ? qsTr("AUDIO") : qsTr("VIDEO")) + " " + qsTr("TRACK")
        info_id.text = trackItem.id
        info_size.text = UtilsString.bytesToString_short(trackItem.size, settingsManager.unitSizes)
        info_duration.text = UtilsString.durationToString_long(trackItem.duration)
        info_delay.visible = (trackItem.delay !== 0)
        info_delay.text = UtilsString.durationToString_short(trackItem.delay)

        info_title.text = trackItem.title
        info_language.text = trackItem.language

        info_visible.visible = (trackItem.visible)
        info_visible.text = trackItem.visible
        info_forced.visible = (trackItem.forced)
        info_forced.text = trackItem.forced

        // video
        if (trackItem.type === 2) { // stream_VIDEO
            columnVideo.visible = true
            columnAudio.visible = false

            // Codec
            info_vcodecfcc.text = trackItem.fcc
            info_vcodec.text = trackItem.codec
            info_vcodecprofile.text = trackItem.codecProfileAndLevel
            info_vcodecfeatures.text = trackItem.codecFeatures

            //console.log("GEOMETRY : " + trackItem.width + " * " + trackItem.height)
            //console.log("VISIBLE : " + trackItem.widthVisible + " * " + trackItem.heightVisible)
            //console.log("CROP : " + trackItem.cropTop + " - " + trackItem.cropBottom + " - " +
            //                        trackItem.cropLeft + " - " + trackItem.cropRight)

            // Geometry
            info_vdefinition.text = trackItem.width + " x " + trackItem.height
            info_sar.text = UtilsMedia.varToString(trackItem.width, trackItem.height)
            var ardesc = UtilsMedia.varToDescString(trackItem.width, trackItem.height)
            if (ardesc.length > 0) info_sar.text += "  (" + ardesc + ")"

            // Geometry // transformations
            var geomismatch = ((trackItem.widthVisible + trackItem.heightVisible) > 0 &&
                               (trackItem.widthVisible !== trackItem.width || trackItem.heightVisible !== trackItem.height))

            var geovisible = true

            info_vdefinition_display.visible = geomismatch
            info_dar.visible = geomismatch
            item_resBox.visible = (geomismatch || geovisible)

            if (geomismatch || geovisible) {
                info_vdefinition_display.text = trackItem.widthVisible + " x " + trackItem.heightVisible
                info_dar.text = UtilsMedia.varToString(trackItem.widthVisible, trackItem.heightVisible)
            }
            item_resBox.compute(trackItem)

            // Geometry // PAR
            info_par.visible = (trackItem.par != 1.0)
            info_par.text = trackItem.par.toFixed(2).replace(/[.,]00$/, "") + ":1"
            item_parBox.visible = (trackItem.par != 1.0)
            item_parBox.www = 1 * (item_parBox.height/3) * trackItem.par
            item_parBox.hhh = 1 * (item_parBox.height/3)

            // Geometry // projection
            info_vprojection.visible = (trackItem.projection > 0)
            info_vprojection.text = UtilsMedia.projectionToString(trackItem.projection)
            info_vorientation.visible = (trackItem.orientation > 0)
            info_vorientation.text = UtilsMedia.orientationMp4ToString(trackItem.orientation)

            info_vscan.visible = (trackItem.scanmode > 0)
            info_vscan.text = UtilsMedia.scanmodeToString(trackItem.scanmode)

            // HDR
            if (trackItem.hdrMode) {
                info_hdrmode.text = trackItem.hdrMode_str
            }

            // Colors
            info_vcolordepth.visible = (trackItem.colorDepth > 0)
            info_vcolorrange.visible = (trackItem.colorDepth > 0)

            info_vchromasubsampling.text = trackItem.chromaSubsampling_str
            info_vchromalocation.text = trackItem.chromaLocation_str

            info_vchromaformat.chromaSubsampling_str = trackItem.chromaSubsampling_str
            info_vchromaformat.chromaLocation_str = trackItem.chromaLocation_str

            if (trackItem.colorDepth > 0) {
                info_vcolordepth.text = trackItem.colorDepth + " bits"

                if (trackItem.colorRange)
                    info_vcolorrange.text = qsTr("full")
                else
                    info_vcolorrange.text = qsTr("limited")
            }
            if (trackItem.colorPrimaries > 0 && trackItem.colorTransfer > 0) {
                info_vcolorprimaries.text = trackItem.colorPrimaries_str
                info_vcolortransfer.text = trackItem.colorTransfer_str
                info_vcolormatrix.text = trackItem.colorMatrix_str
            }

            // Framerate
            info_vframerate.text = trackItem.framerate.toFixed(3) + " FPS"
            info_vframeduration.text = trackItem.frameDuration.toFixed(2) + " ms"
        }

        // audio
        if (trackItem.type === 1) { // stream_AUDIO
            columnVideo.visible = false
            columnAudio.visible = true

            info_acodecfcc.text = trackItem.fcc
            info_acodec.text = trackItem.codec
            info_acodecprofile.text = trackItem.codecProfile

            info_achannels.text = trackItem.audioChannels
            info_asamplerate.text = trackItem.audioSamplerate + " Hz"
            info_abpp.text = trackItem.audioBitPerSample + " bpp"
            info_aframeduration.visible = true
            info_aframeduration.text = (trackItem.duration / trackItem.sampleCount).toFixed(2) + " ms"
            info_asampleduration.visible = true
            info_asampleduration.text = trackItem.sampleDuration.toFixed(2) + " µs"
            info_asampleperframe.visible = (trackItem.audioSamplePerFrame > 0)
            info_asampleperframe.text = trackItem.audioSamplePerFrame

            item_speakerBox.visible = true
            item_speakerBox.channelCount = trackItem.audioChannels
            item_speakerBox.channelMode = trackItem.audioChannelsMode
        }

        // data
        info_bitrate.text = UtilsMedia.bitrateToString(trackItem.bitrate_avg)
        info_bitrate.text += "  (" + UtilsMedia.bitrateModeToString(trackItem.bitrateMode) + ")"
        info_compression.text = trackItem.compressionRatio + ":1"

        info_samplecount.visible = (trackItem.sampleCount !== trackItem.frameCount)
        info_samplecount.text = trackItem.sampleCount

        info_framecount.visible = true
        info_framecount.text = trackItem.frameCount

        if (trackItem.frameCountIdr > 0 && trackItem.frameCountIdr !== trackItem.frameCount) {
            info_idr.visible = true
            info_idr.text = trackItem.frameCountIdr

            var idr_ratio = (trackItem.frameCountIdr / trackItem.frameCount) * 100
            info_idr.text += "  (" + idr_ratio.toFixed(1) + "% of the frames)"
        } else {
            info_idr.visible = false
        }

        // graph (if VBR stream)
        bitrateGraphItem.visible = (trackItem.bitrateMode > 1)
        if (trackItem.bitrateMode > 1) {

            // Data
            bitrateData.clear()
            bitrateMean.clear()
            trackItem.getBitrateData(bitrateData, bitrateMean, 12)

            // Axis
            axisX0.min = 0
            axisX0.max = bitrateData.count

            axisX1.min = 0
            axisX1.max = 1

            var minmax_of_array = 0
            for (var i = 0; i < bitrateData.count; i++)
                if (bitrateData.at(i).y > minmax_of_array)
                    minmax_of_array = bitrateData.at(i).y

            if (trackItem.type === 1) { // audio
                axisBitrateData.min = 0
                axisBitrateData.max = minmax_of_array
            } else {
                axisBitrateData.min = 0
                axisBitrateData.max = minmax_of_array
            }
        }

        // data (min/max is only available after the graph is done)
        info_bitrate_minmax.visible = (trackItem.bitrateMode > 1)
        info_bitrate_minmax.text1 = UtilsMedia.bitrateToString(trackItem.bitrate_min)
        info_bitrate_minmax.text2 = UtilsMedia.bitrateToString(trackItem.bitrate_max)
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        id: columnMain
        anchors.left: parent.left
        anchors.right: parent.right

        topPadding: 16
        bottomPadding: 16 + mobileMenu.height
        spacing: 8

        ////////////////

        Column {
            id: columnTrack
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                id: titleTrack
                source: "qrc:/assets/icons/material-icons/duotone/list.svg"
                text: qsTr("TAGS")
            }

            InfoRow { ////
                id: info_id
                legend: qsTr("internal id")
            }
            InfoRow { ////
                id: info_size
                legend: qsTr("data size")
            }
            InfoRow { ////
                id: info_duration
                legend: qsTr("duration")
            }
            InfoRow { ////
                id: info_delay
                legend: qsTr("delay")
            }
            InfoRow { ////
                id: info_title
                legend: qsTr("title")
            }
            InfoRow { ////
                id: info_language
                legend: qsTr("language")
            }
            InfoRow { ////
                id: info_visible
                legend: qsTr("track visible")
            }
            InfoRow { ////
                id: info_forced
                legend: qsTr("track forced")
            }
        }

        ////////////////

        Column {
            id: columnVideo
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/media/movie.svg"
                text: qsTr("VIDEO")
            }

            InfoRow { ////
                id: info_vcodecfcc
                legend: qsTr("codec fourcc")
            }
            InfoRow { ////
                id: info_vcodec
                legend: qsTr("codec")
            }
            InfoRow { ////
                id: info_vcodecprofile
                legend: qsTr("profile")
            }
            InfoRow { ////
                id: info_vcodecfeatures
                legend: qsTr("features")
            }

            Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_vdefinition
                legend: qsTr("definition")
            }
            InfoRow { ////
                id: info_sar
                legend: qsTr("aspect ratio")
            }
            InfoRow { ////
                id: info_vprojection
                legend: qsTr("projection")
            }
            InfoRow { ////
                id: info_vorientation
                legend: qsTr("orientation")
            }

            //Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_vdefinition_display
                legend: qsTr("display definition")
            }
            InfoRow { ////
                id: info_dar
                legend: qsTr("display aspect ratio")
            }

            GeometryWidget {
                id: item_resBox
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 24
            }

            InfoRow { ////
                id: info_par
                legend: qsTr("pixel aspect ratio")
            }

            PixelFormatWidget {
                id: item_parBox
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 24
            }

            //Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_vscan
                legend: qsTr("scan type")
            }

            Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_vframerate
                legend: qsTr("framerate")
            }
            InfoRow { ////
                id: info_vframeduration
                legend: qsTr("frame duration")
            }

            Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_hdrmode
                legend: qsTr("HDR mode")
            }

            InfoRow { ////
                id: info_vcolordepth
                legend: qsTr("color depth")
            }
            InfoRow { ////
                id: info_vcolorrange
                legend: qsTr("color range")
            }
            InfoRow { ////
                id: info_vchromasubsampling
                legend: qsTr("chroma subsampling")
            }
            InfoRow { ////
                id: info_vchromalocation
                legend: qsTr("chroma location")
            }

            ChromaFormatWidget {
                id: info_vchromaformat
            }
            Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_vcolorprimaries
                legend: qsTr("color primaries")
            }
            InfoRow { ////
                id: info_vcolortransfer
                legend: qsTr("transfer characteristics")
            }
            InfoRow { ////
                id: info_vcolormatrix
                legend: qsTr("color matrix")
            }
        }

        ////////////////

        Column {
            id: columnAudio
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/media/speaker.svg"
                text: qsTr("AUDIO")
            }

            InfoRow { ////
                id: info_acodecfcc
                legend: qsTr("codec fourcc")
            }
            InfoRow { ////
                id: info_acodec
                legend: qsTr("codec")
            }
            InfoRow { ////
                id: info_acodecprofile
                legend: qsTr("profile")
            }

            Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_asamplerate
                legend: qsTr("samplerate")
            }
            InfoRow { ////
                id: info_abpp
                legend: qsTr("bit per sample")
            }
            InfoRow { ////
                id: info_aframeduration
                legend: qsTr("frame duration")
            }
            InfoRow { ////
                id: info_asampleduration
                legend: qsTr("sample duration")
            }
            InfoRow { ////
                id: info_asampleperframe
                legend: qsTr("sample per frame")
            }

            Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_achannels
                legend: qsTr("channels")
            }
            SpeakerWidget { ////
                id: item_speakerBox
                anchors.left: parent.left
                anchors.leftMargin: 56
            }
        }

        ////////////////

        Column {
            id: columnData
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-icons/duotone/sd_card.svg"
                text: qsTr("DATA")
            }

            InfoRow { ////
                id: info_samplecount
                legend: qsTr("sample count")
            }
            InfoRow { ////
                id: info_framecount
                legend: qsTr("frame count")
            }
            InfoRow { ////
                id: info_idr
                legend: qsTr("frame sync count")
            }
            InfoRow { ////
                id: info_compression
                legend: qsTr("compression ratio")
            }

            Item { width: 4; height: 4; } // spacer

            InfoRow { ////
                id: info_bitrate
                legend: qsTr("bitrate")
            }
            InfoFlow { ////
                id: info_bitrate_minmax
                legend1: qsTr("min")
                legend2: qsTr("max")
            }

            Item {
                id: bitrateGraphItem
                anchors.left: parent.left
                anchors.leftMargin: 24
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
                    animationOptions: ChartView.SeriesAnimations

                    Rectangle {
                        id: legend_area_under
                        width: bitrateGraph.plotArea.width
                        height: bitrateGraph.plotArea.height
                        x: bitrateGraph.plotArea.x
                        y: bitrateGraph.plotArea.y
                        z: -1
                        color: Theme.colorComponentBackground
                        opacity: 0.66
                    }

                    ValueAxis { id: axisX0; visible: true; gridVisible: false;
                        labelsVisible: false; labelsFont.pixelSize: 0; labelFormat: "" }
                    ValueAxis { id: axisBitrateData; visible: true; gridVisible: false;
                        labelsVisible: false; labelsFont.pixelSize: 0; labelFormat: "" }

                    ValueAxis { id: axisX1; visible: false; gridVisible: false;
                        labelsVisible: false; labelsFont.pixelSize: 0; labelFormat: "" }
                    ValueAxis { id: axisBitrateMean; visible: false; gridVisible: false;
                        labelsVisible: false; labelsFont.pixelSize: 0; labelFormat: "" }

                    LineSeries {
                        id: bitrateData
                        //useOpenGL: true

                        color: Theme.colorSecondary
                        width: 1
                        visible: true

                        axisX: axisX0
                        axisY: axisBitrateData
                    }
                    LineSeries {
                        id: bitrateMean
                        //useOpenGL: true

                        color: Theme.colorRed
                        width: 1
                        visible: true

                        axisX: axisX1
                        axisY: axisBitrateMean
                    }
                }
            }
        }

        ////////////////
    }

    ////////////////////////////////////////////////////////////////////////////
}
