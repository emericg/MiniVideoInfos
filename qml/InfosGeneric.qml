import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

ScrollView {
    id: scrollView_generic
    implicitWidth: 480
    implicitHeight: 720
    contentWidth: -1

    ScrollBar.vertical.policy: ScrollBar.AsNeeded
    ScrollBar.vertical.interactive: true

    function loadGeneric() {
        info_name.text = mediaItem.name
        info_path.text = mediaItem.path
        info_extension.text = mediaItem.ext
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
            imgGeometry.source = "qrc:/assets/icons_material_media/duotone-spherical-24px.svg"
        else
            imgGeometry.source = "qrc:/assets/icons_material_media/duotone-aspect_ratio-24px.svg"

        if (mediaItem.fileType === 3) { //// IMAGE
            columnImage.visible = true

            info_icodec.text = mediaItem.videoCodec
            info_impix.text = ((mediaItem.width * mediaItem.height) / 1000000).toFixed(1)
            info_idefinition.text = mediaItem.width + " x " + mediaItem.height
            info_iaspectratio.text = UtilsMedia.varToString(mediaItem.width, mediaItem.height)
            info_iresolution.text = (mediaItem.resolution) ? (mediaItem.resolution + " " + qsTr("dpi")) : ""
            item_iorientation.visible = (mediaItem.orientation !== 0)
            info_iorientation.text = UtilsMedia.orientationToString(mediaItem.orientation)
            item_iprojection.visible = (mediaItem.projection > 0)
            info_iprojection.text = UtilsMedia.projectionToString(mediaItem.projection)
            item_idepth.visible = (mediaItem.depth > 0)
            info_idepth.text = mediaItem.depth
            item_ialpha.visible = mediaItem.alpha
            info_ialpha.text = mediaItem.alpha

            if (settingsManager.mediaPreview) {
                var w = info_preview.width
                var h = info_preview.width / (mediaItem.width / mediaItem.height)
                info_preview.sourceSize.width = w*2
                info_preview.sourceSize.height = h*2
                info_preview.source = "file://" + mediaItem.fullpath
                item_preview.height = (mediaItem.orientation > 3) ? w : h
                item_preview.visible = true
            } else {
                item_preview.visible = false
            }
        } else {
            columnImage.visible = false
            columnVideo.visible = false
        }

        // Track sizes graph
        if (mediaItem.getVideoTracks() + mediaItem.getAudioTracks() > 0) {
            elementTracks.visible = true
            elementTracks.load(mediaItem)
        } else {
            elementTracks.visible = false
        }

        // VIDEO tracks
        columnVideo.model = mediaItem.getVideoTracks()

        // Audio tracks
        columnAudio.model = mediaItem.getAudioTracks()

        // Other tracks
        columnOther.visible = (mediaItem.getSubtitlesTrackCount() || mediaItem.getOtherTrackCount())
        repeaterSubtitles.model = mediaItem.getSubtitlesTracks()
        repeaterOther.model = mediaItem.getOtherTracks()
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        topPadding: 16
        bottomPadding: 16 + rectangleMenus.height
        spacing: 8

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

                ImageSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/assets/icons_material/outline-insert_drive_file-24px.svg"
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
                Text {
                    id: info_path
                    anchors.left: legend_path.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8

                    color: Theme.colorText
                    font.pixelSize: 15
                    wrapMode: Text.WrapAnywhere
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
                Text {
                    id: info_name
                    anchors.left: legend_name.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8

                    color: Theme.colorText
                    font.pixelSize: 15
                    wrapMode: Text.WrapAnywhere
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
                Text {
                    id: info_extension
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
                    text: qsTr("date")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_date
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
                    text: qsTr("time")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_time
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_duration
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
                    text: qsTr("size")
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
                Text {
                    id: info_timecode
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_container
                    anchors.left: legend_container.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8

                    color: Theme.colorText
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
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
                Text {
                    id: info_containerprofile
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_capp
                    anchors.left: legend_capp.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8

                    color: Theme.colorText
                    font.pixelSize: 15
                    wrapMode: Text.WrapAnywhere
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
                Text {
                    id: info_clib
                    anchors.left: legend_clib.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8

                    color: Theme.colorText
                    font.pixelSize: 15
                    wrapMode: Text.WrapAnywhere
                }
            }
            ItemTracksGraph {
                id: elementTracks
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

                ImageSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/assets/icons_material_media/outline-insert_photo-24px.svg"
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
                Text {
                    id: info_icodec
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
                    text: qsTr("megapixel")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_impix
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
                    text: qsTr("aspect ratio")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_iaspectratio
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
                    text: qsTr("definition")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_idefinition
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_iresolution
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_iorientation
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_iprojection
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_idepth
                    color: Theme.colorText
                    font.pixelSize: 15
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
                Text {
                    id: info_ialpha
                    color: Theme.colorText
                    font.pixelSize: 15
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
                }
                /*MouseArea {
                    anchors.fill: parent
                    onPressAndHold: utilsApp.openWith(mediaItem.fullpath);
                }*/
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

                    ImageSvg {
                        width: 32
                        height: 32
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter

                        color: Theme.colorPrimary
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/assets/icons_material_media/outline-local_movies-24px.svg"
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
                    Text {
                        id: videoCodecText
                        width: parent.width - parent.spacing - videoCodecLegend.width
                        text: modelData.codec
                        color: Theme.colorText
                        font.pixelSize: 15
                        wrapMode: Text.WrapAnywhere
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
                    Text {
                        text: modelData.width + " x " + modelData.height
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
                        text: qsTr("aspect ratio")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        text: {
                            var txt = UtilsMedia.varToString(modelData.width, modelData.height)
                            var ardesc = UtilsMedia.varToDescString(modelData.width, modelData.height)
                            if (ardesc.length > 0) txt += "  (" + ardesc + ")"
                            return txt
                        }
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

                    visible: (modelData.projection > 0)

                    Text {
                        text: qsTr("projection")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        text: UtilsMedia.projectionToString(modelData.projection)
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
                        text: qsTr("framerate")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        text: UtilsMedia.framerateToString(modelData.framerate)
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
                        text: UtilsMedia.bitrateToString(modelData.bitrate_avg) +
                              "  (" + UtilsMedia.bitrateModeToString(modelData.bitrateMode) + ")"
                        color: Theme.colorText
                        font.pixelSize: 15
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

                    ImageSvg {
                        width: 32
                        height: 32
                        anchors.left: parent.left
                        anchors.leftMargin: 12
                        anchors.verticalCenter: parent.verticalCenter

                        color: Theme.colorPrimary
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/assets/icons_material_media/outline-speaker-24px.svg"
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
                    anchors.rightMargin: 0
                    height: Math.max(UtilsNumber.alignTo(audioCodecText.height + 4, 4), 24)
                    spacing: 16

                    Text {
                        id: audioCodecLegend
                        text: qsTr("codec")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        id: audioCodecText
                        width: parent.width - parent.spacing - audioCodecLegend.width

                        text: modelData.codec
                        color: Theme.colorText
                        font.pixelSize: 15
                        wrapMode: Text.WrapAnywhere
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
                    Text {
                        text: modelData.audioChannels
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
                        text: qsTr("samplerate")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        text: modelData.audioSamplerate + " Hz"
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
                        text: UtilsMedia.bitrateToString(modelData.bitrate_avg) +
                              "  (" + UtilsMedia.bitrateModeToString(modelData.bitrateMode) + ")"
                        color: Theme.colorText
                        font.pixelSize: 15
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

                ImageSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/assets/icons_material/baseline-list-24px.svg"
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
                id: repeaterSubtitles
                anchors.left: parent.left
                anchors.right: parent.right
                //model: mediaItem.getSubtitlesTracks()

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
                        id: trackSubtitleTitle
                        width: parent.width - parent.spacing - trackSubtitleId.contentWidth

                        text: {
                            var txt = ""
                            if (modelData.codec.length)
                                txt = "/ " + modelData.codec
                            if (modelData.language.length)
                                txt += " / " + modelData.language
                            if (modelData.title.length)
                                txt += " / " + modelData.title
                            return txt
                        }
                        color: Theme.colorText
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
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
                            if (modelData.type === 4) // stream_MENU
                                return qsTr("menu track #") + modelData.id
                            else if (modelData.type === 5) // stream_TMCD
                                return qsTr("SMPTE timecode")
                            else if (modelData.type === 6) // stream_META
                                return qsTr("metadata track")
                            else if (modelData.type === 7) // stream_HINT
                                return qsTr("hint track")
                            else
                                return qsTr("Unknown track type")
                        }
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        id: trackOtherTitle
                        width: parent.width - parent.spacing - trackOtherId.contentWidth

                        text: {
                            if (modelData.type === 5) // stream_TMCD
                                return mediaItem.timecode
                            else
                                return modelData.title
                        }
                        color: Theme.colorText
                        font.pixelSize: 15
                        wrapMode: Text.WrapAnywhere
                    }
                }
            }
        }
    }
}
