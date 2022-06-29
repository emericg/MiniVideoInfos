import QtQuick 2.15
import QtQuick.Controls 2.15

import QtCharts

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

        //item_title.height = (info_title.height > 24) ? info_title.height + 4 : 24
        item_title.visible = (trackItem.title.length > 0)
        info_title.text = trackItem.title

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

            item_vdefinition_display.visible = geomismatch
            item_dar.visible = geomismatch
            item_resBox.visible = geomismatch

            if (geomismatch) {
                info_vdefinition_display.text = trackItem.widthVisible + " x " + trackItem.heightVisible
                info_dar.text = UtilsMedia.varToString(trackItem.widthVisible, trackItem.heightVisible)

                var maxWidth = item_resBox.width
                var maxHeight = item_resBox.height

                if (((trackItem.width / trackItem.height) > 1) &&
                    ((trackItem.widthVisible / trackItem.heightVisible) > 1)) {
                    //console.log("LEFT geo"); console.log("LEFT disp");
                    img_display_rotate.visible = false
                    img_display_resize.visible = true

                    if (trackItem.widthVisible > trackItem.width) {
                        rect_display.width = maxWidth
                        rect_display.height = rect_display.width / trackItem.dar
                        rect_geo.width = rect_display.width * (trackItem.width / trackItem.widthVisible)
                        rect_geo.height = rect_display.height * (trackItem.height / trackItem.heightVisible)
                    } else {
                        rect_geo.width = 200
                        rect_geo.height = rect_geo.width / trackItem.var
                        rect_display.width = 160
                        rect_display.height = rect_display.width / trackItem.dar
                    }
                } else if (((trackItem.width / trackItem.height) < 1) &&
                           ((trackItem.widthVisible / trackItem.heightVisible) < 1)) {
                    //console.log("UP geo"); console.log("UP disp");
                    img_display_rotate.visible = false
                    img_display_resize.visible = true

                } else {
                    //console.log("UP / LEFT")
                    img_display_rotate.visible = true
                    img_display_resize.visible = false

                    if ((trackItem.width / trackItem.height) < 1) {
                        rect_geo.width = (160 * (trackItem.width/trackItem.height))
                        rect_geo.height = 160
                    } else {
                        rect_geo.width = 160
                        rect_geo.height = (160 / (trackItem.width/trackItem.height))
                    }
                    if ((trackItem.widthVisible / trackItem.heightVisible) < 1) {
                        rect_display.width = (160 * (trackItem.widthVisible/trackItem.heightVisible))
                        rect_display.height = 160
                    } else {
                        rect_display.width = 160
                        rect_display.height = (160 / (trackItem.widthVisible/trackItem.heightVisible))
                    }
                }

                item_resBox.height = Math.max(rect_geo.height, rect_display.height)
            }

            // Geometry // crop
            if (trackItem.cropTop || trackItem.cropBottom || trackItem.cropLeft || trackItem.cropRight) {
                rect_crop.visible = true
            } else {
                rect_crop.visible = false
            }

            // Geometry // PAR
            item_par.visible = (trackItem.par != 1.0)
            info_par.text = trackItem.par.toFixed(2).replace(/[.,]00$/, "") + ":1"
            item_parBox.visible = (trackItem.par != 1.0)
            item_parBox.www = 1 * (item_parBox.height/3) * trackItem.par
            item_parBox.hhh = 1 * (item_parBox.height/3)

            // Geometry // projection
            item_vprojection.visible = (trackItem.projection > 0)
            info_vprojection.text = UtilsMedia.projectionToString(trackItem.projection)
            item_vorientation.visible = (trackItem.orientation > 0)
            info_vorientation.text = UtilsMedia.orientationMp4ToString(trackItem.orientation)

            item_vscan.visible = (trackItem.scanmode > 0)
            info_vscan.text = UtilsMedia.scanmodeToString(trackItem.scanmode)

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

            item_speakerBox.visible = true
            speakers.visible = true
            speakers_lfe.visible = trackItem.audioChannels > 5

            if (trackItem.audioChannels === 10) {
                speakers.source = "qrc:/speakers/9_0_surround.svg"
            } else if (trackItem.audioChannels === 8) {
                speakers.source = "qrc:/speakers/7_0_surround.svg"
            } else if (trackItem.audioChannels === 6) {
                speakers.source = "qrc:/speakers/5_0_surround.svg"
            } else if (trackItem.audioChannels === 4) {
                speakers.source = "qrc:/speakers/4_0_quad.svg"
            } else if (trackItem.audioChannels === 2) {
                speakers.source = "qrc:/speakers/2_0_stereo.svg"
            } else if (trackItem.audioChannels === 1) {
                speakers.source = "qrc:/speakers/1_0.svg"
            } else {
                item_speakerBox.visible = false
                speakers.visible = false
                speakers_lfe.visible = false
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

        // graph (if VBR stream)
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
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        id: columnMain
        anchors.left: parent.left
        anchors.right: parent.right

        topPadding: 16
        bottomPadding: 16 + rectangleMenus.hhh
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

                IconSvg {
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
                TextEditMVI {
                    id: info_id
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
                TextEditMVI {
                    id: info_size
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
                TextEditMVI {
                    id: info_duration
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
                TextEditMVI {
                    id: info_delay
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
                TextEditMVI {
                    id: info_title
                    anchors.left: legend_title.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
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
                TextEditMVI {
                    id: info_language
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
                TextEditMVI {
                    id: info_visible
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
                TextEditMVI {
                    id: info_forced
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

                IconSvg {
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

            Item { ////
                id: item_vcodec
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: Math.max(UtilsNumber.alignTo(info_vcodec.contentHeight + 4, 4), 24)

                Text {
                    id: legend_vcodec
                    height: 24
                    text: qsTr("codec")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_vcodec
                    anchors.left: legend_vcodec.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
            Item { ////
                id: item_vcodecprofile
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: Math.max(UtilsNumber.alignTo(info_vcodecprofile.contentHeight + 4, 4), 24)

                Text {
                    id: legend_vcodecprofile
                    height: 24
                    text: qsTr("profile")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_vcodecprofile
                    anchors.left: legend_vcodecprofile.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
            Item { ////
                id: item_vcodecfeatures
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: Math.max(UtilsNumber.alignTo(info_vcodecfeatures.contentHeight + 4, 4), 24)

                Text {
                    id: legend_vcodecfeatures
                    height: 24
                    text: qsTr("features")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_vcodecfeatures
                    anchors.left: legend_vcodecfeatures.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
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
                TextEditMVI {
                    id: info_vdefinition
                }
            }
            Row { ////
                id: itemSar
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    id: legend_sar
                    text: qsTr("aspect ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_sar
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
                TextEditMVI {
                    id: info_vprojection
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
                TextEditMVI {
                    id: info_vorientation
                }
            }

            //Item { width: 4; height: 4; } // spacer

            Row { ////
                id: item_vdefinition_display
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("display definition")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vdefinition_display
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }

            Row { ////
                id: item_dar
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("display aspect ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_dar
                }
            }

            Item { ////
                id: item_resBox
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 24
                height: 160

                Rectangle {
                    id: rect_geo
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    height: 160/(16/9)
                    width: 160
                    color: "#22999999"
                    border.width: 2
                    border.color: Theme.colorIcon
                }
                Rectangle {
                    id: rect_display
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    height: 160
                    width: 160/(16/9)
                    color: "transparent"
                    border.width: 2
                    border.color: Theme.colorPrimary

                    IconSvg {
                        id: img_display_rotate
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: 4
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 4
                        color: Theme.colorPrimary
                        source: "qrc:/assets/icons_material/duotone-rotate_90_degrees_ccw-24px.svg"
                    }
                    IconSvg {
                        id: img_display_resize
                        width: 24
                        height: 24
                        anchors.top: parent.top
                        anchors.topMargin: 4
                        anchors.right: parent.right
                        anchors.rightMargin: 4
                        color: Theme.colorPrimary
                        source: "qrc:/assets/icons_material/duotone-aspect_ratio-24px.svg"
                    }
                }
                Rectangle {
                    id: rect_crop
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    height: 160
                    width: 160
                    color: "transparent"
                    border.width: 2
                    border.color: Theme.colorWarning

                    IconSvg {
                        id: img_crop
                        width: 24
                        height: 24
                        anchors.left: parent.left
                        anchors.leftMargin: 4
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 4
                        color: Theme.colorWarning
                        source: "qrc:/assets/icons_material/duotone-settings_overscan-24px.svg"
                    }
                }
            }

            Row { ////
                id: item_par
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("pixel aspect ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_par
                }
            }

            Grid { ////
                id: item_parBox
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 24

                height: 96
                rows: 3
                columns: 3

                property int www: 1 * (item_parBox.height/3)
                property int hhh: 1 * (item_parBox.height/3)

                Rectangle { width: parent.www; height: parent.hhh; color: "#9377a6"; }
                Rectangle { width: parent.www; height: parent.hhh; color: "#dda1be"; }
                Rectangle { width: parent.www; height: parent.hhh; color: "#ffa6ca"; }
                Rectangle { width: parent.www; height: parent.hhh; color: "#707cad"; }
                Rectangle { width: parent.www; height: parent.hhh; color: "#9593b5";
                            border.width: 2; border.color: "white"; }
                Rectangle { width: parent.www; height: parent.hhh; color: "#c99fc7"; }
                Rectangle { width: parent.www; height: parent.hhh; color: "#6f77a4"; }
                Rectangle { width: parent.www; height: parent.hhh; color: "#7784ad"; }
                Rectangle { width: parent.www; height: parent.hhh; color: "#8e97c1"; }
            }

            //Item { width: 4; height: 4; } // spacer

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
                TextEditMVI {
                    id: info_vscan
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
                TextEditMVI {
                    id: info_vframerate
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
                TextEditMVI {
                    id: info_vframeduration
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
                TextEditMVI {
                    id: info_vcolordepth
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
                TextEditMVI {
                    id: info_vcolorrange
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
                TextEditMVI {
                    id: info_vcolorprimaries
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
                TextEditMVI {
                    id: info_vcolortransfer
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
                TextEditMVI {
                    id: info_vcolormatrix
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

                IconSvg {
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
            Item { ////
                id: item_acodec
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: Math.max(UtilsNumber.alignTo(info_acodec.contentHeight + 4, 4), 24)

                Text {
                    id: legend_acodec
                    text: qsTr("codec")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_acodec
                    anchors.left: legend_acodec.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
            Item { ////
                id: item_acodecprofile
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0
                height: Math.max(UtilsNumber.alignTo(info_acodecprofile.contentHeight + 4, 4), 24)

                Text {
                    id: legend_acodecprofile
                    text: qsTr("profile")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_acodecprofile
                    anchors.left: legend_acodecprofile.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
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
                TextEditMVI {
                    id: info_asamplerate
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
                TextEditMVI {
                    id: info_abpp
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
                TextEditMVI {
                    id: info_aframeduration
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
                TextEditMVI {
                    id: info_asampleduration
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
                TextEditMVI {
                    id: info_asampleperframe
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
                TextEditMVI {
                    id: info_achannels
                }
            }
            Item { ////
                id: item_speakerBox
                anchors.left: parent.left
                anchors.leftMargin: 56
                width: 160
                height: 160

                IconSvg {
                    id: speakers_lfe
                    anchors.fill: parent
                    source: "qrc:/speakers/LFE.svg"
                    color: Theme.colorIcon
                }
                IconSvg {
                    id: speakers
                    anchors.fill: parent
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

                IconSvg {
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
                TextEditMVI {
                    id: info_samplecount
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
                TextEditMVI {
                    id: info_framecount
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
                TextEditMVI {
                    id: info_idr
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
                TextEditMVI {
                    id: info_compression
                }
            }

            Item { width: 4; height: 4; } // spacer

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
                    id: info_bitrate
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
                TextEditMVI {
                    id: info_bitrate_min
                }
                Text {
                    text: qsTr("max")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_bitrate_max
                }
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
                    backgroundColor: "transparent" // Theme.colorBackground
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
        }
    }
}
