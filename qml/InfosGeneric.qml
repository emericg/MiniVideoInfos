import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

ScrollView {
    id: scrollView_generic
    width: 480
    height: 720
    contentWidth: -1

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
        item_clib.visible = (mediaItem.creation_lib.length > 0 &&
                             mediaItem.creation_lib !== mediaItem.creation_app)
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

        if (mediaItem.fileType === 2) { //// VIDEO

            elementTracks.visible = true
            elementTracks.load(mediaItem)

            columnVideo.visible = true

            info_vcodec.text = mediaItem.videoCodec
            info_vdefinition.text = mediaItem.width + " x " + mediaItem.height
            info_vaspectratio.text = UtilsMedia.varToString(mediaItem.width, mediaItem.height)

            var ardesc = UtilsMedia.varToDescString(mediaItem.width, mediaItem.height)
            if (ardesc.length > 0) info_vaspectratio.text += "  (" + ardesc + ")"

            if (mediaItem.projection > 0) {
                item_vprojection.visible = true
                info_vprojection.text = UtilsMedia.projectionToString(mediaItem.projection)
            } else {
                item_vprojection.visible = false
            }

            info_vframerate.text = UtilsMedia.framerateToString(mediaItem.vframerate)
            info_vbitrate.text = UtilsMedia.bitrateToString(mediaItem.vbitrate)
            info_vbitrate.text += "  (" + UtilsMedia.bitrateModeToString(mediaItem.vbitratemode) + ")"
        } else {
            columnVideo.visible = false
            elementTracks.visible = false
        }

        //
        columnAudio.model = mediaItem.getAudioTracks()

        //
        columnOther.visible = (mediaItem.getSubtitlesTrackCount() || mediaItem.getOtherTrackCount())
        repeaterSubtitles.model = mediaItem.getSubtitlesTracks()
        repeaterOther.model = mediaItem.getOtherTracks()
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        anchors.top: parent.top
        anchors.topMargin: 16
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom

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
                id: item_name
                height: (info_name.height > 24) ? (info_name.height + 4) : 24
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
            Item { ////
                id: item_path
                height: (info_path.height > 24) ? (info_path.height + 4) : 24
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
                id: item_container
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("container")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_container
                    color: Theme.colorText
                    font.pixelSize: 15
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
                height: (info_capp.height > 24) ? (info_capp.height + 4) : 24
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
                height: (info_clib.height > 24) ? (info_clib.height + 4) : 24
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
                MouseArea {
                    anchors.fill: parent
                    onPressAndHold: utilsApp.openWith(mediaItem.fullpath);
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
                    id: info_vaspectratio
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
                    text: qsTr("bitrate")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_vbitrate
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
        }

        ////////////////
/*
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
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/assets/icons_material_media/outline-speaker-24px.svg"
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
                    text: qsTr("bitrate")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                Text {
                    id: info_abitrate
                    color: Theme.colorText
                    font.pixelSize: 15
                }
            }
        }
*/
        Repeater {
            id: columnAudio
            anchors.left: parent.left
            anchors.right: parent.right
            //model: tracksAudio

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
                    height: 24
                    spacing: 16

                    Text {
                        text: qsTr("codec")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        text: modelData.codec
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
                        text: UtilsMedia.bitrateToString(modelData.bitrate_avg) + "  (" + UtilsMedia.bitrateModeToString(modelData.bitrateMode) + ")"
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
                //model: tracksSubtitles

                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 8

                    Text {
                        text: qsTr("subtitles track #") + (index + 1)
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
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
                    }
                }
            }
            Repeater {
                id: repeaterOther
                anchors.left: parent.left
                anchors.right: parent.right
                //model: tracksOther

                Row { ////
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    height: 24
                    spacing: 16

                    Text {
                        text: {
                            if (modelData.type === 4) // stream_MENU
                                return qsTr("menu track #") + modelData.id
                            if (modelData.type === 5) // stream_TMCD
                                return qsTr("SMPTE timecode")
                            if (modelData.type === 6) // stream_META
                                return qsTr("metadata track")
                            if (modelData.type === 7) // stream_HINT
                                return qsTr("hint track")
                        }
                        color: Theme.colorSubText
                        font.pixelSize: 15
                    }
                    Text {
                        text: {
                            if (modelData.type === 5) // stream_TMCD
                                return mediaItem.timecode
                            else
                                return modelData.title
                        }
                        color: Theme.colorText
                        font.pixelSize: 15
                    }
                }
            }
        }

        Item { // HACK
            width: 24
            height: 24 + rectangleMenus.height
        }
    }
}
