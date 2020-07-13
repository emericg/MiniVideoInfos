import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsString.js" as UtilsString

Item {
    id: screenMediaInfos_row
    anchors.fill: parent

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
            textGeometry.text = mediaItem.width + " x " + mediaItem.height
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
    }

    ////////

    function loadRowView() {
        content_generic.loadGeneric()

        content_video.visible = mediaItem.hasVideo
        if (mediaItem.hasVideo) content_video.loadTrack(mediaItem.getVideoTrack(0))

        content_audio.visible = mediaItem.hasAudio
        if (mediaItem.hasAudio) content_audio.loadTrack(mediaItem.getAudioTrack(0))

        content_audio_tags.visible = mediaItem.hasAudioTags
        if (mediaItem.hasAudioTags) content_audio_tags.loadTags(mediaItem)

        content_image_tags.visible = mediaItem.hasEXIF
        if (mediaItem.hasEXIF) content_image_tags.loadTags(mediaItem)

        content_map.visible = mediaItem.hasGPS
        if (mediaItem.hasGPS) content_map.loadGps(mediaItem)

        content_export.visible = (settingsManager.exportEnabled && mediaItem.hasVideo)
        if (settingsManager.exportEnabled && mediaItem.hasVideo) content_export.loadExport(mediaItem)
    }

    ////////////////////////////////////////////////////////////////////////////

    ScrollView {
        id: scrollView
        anchors.fill: parent
        contentHeight: -1

        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.horizontal.interactive: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.interactive: false

        Row {
            id: row
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            topPadding: 0
            bottomPadding: 0
            spacing: 8

            property int colsize: 440
            property int mapsize: 720

            ////////

            Item {
                width: 96
                height: parent.height

                Rectangle {
                    anchors.fill: parent
                    opacity: 0.5
                    color: Theme.colorForeground
                }

                Column {
                    id: rowIcons
                    anchors.fill: parent

                    topPadding: 16
                    bottomPadding: 16
                    spacing: 16

                    Column {
                        id: columnDuration
                        width: 96

                        ImageSvg {
                            width: 40
                            height: 40
                            anchors.horizontalCenter: parent.horizontalCenter

                            color: Theme.colorIcon
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/assets/icons_material_media/duotone-av_timer-24px.svg"
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

                        ImageSvg {
                            width: 40
                            height: 40
                            anchors.horizontalCenter: parent.horizontalCenter

                            color: Theme.colorIcon
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/assets/icons_material/duotone-data_usage-24px.svg"
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

                        ImageSvg {
                            id: imgGeometry
                            width: 40
                            height: 40
                            anchors.horizontalCenter: parent.horizontalCenter

                            color: Theme.colorIcon
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/assets/icons_material_media/duotone-aspect_ratio-24px.svg"
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

                        ImageSvg {
                            width: 40
                            height: 40
                            anchors.horizontalCenter: parent.horizontalCenter

                            color: Theme.colorIcon
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/assets/icons_material_media/duotone-speaker-24px.svg"
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

                        ImageSvg {
                            width: 40
                            height: 40
                            anchors.horizontalCenter: parent.horizontalCenter

                            color: Theme.colorIcon
                            fillMode: Image.PreserveAspectFit
                            source: "qrc:/assets/icons_material/duotone-pin_drop-24px.svg"
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

            ////////

            InfosGeneric {
                id: content_generic
                width: row.colsize
                height: parent.height
            }

            ////////

            InfosAV {
                id: content_video
                width: row.colsize
                height: parent.height
/*
                Rectangle {
                    id: content_video_bg
                    anchors.fill: parent
                    z: -1
                    opacity: 0.5
                    color: Theme.colorForeground
                    visible: content_video.visible
                }*/
            }

            ////////

            InfosAV {
                id: content_audio
                width: row.colsize
                height: parent.height
/*
                Rectangle {
                    id: content_audio_bg
                    anchors.fill: parent
                    z: -1
                    opacity: 0.5
                    color: Theme.colorForeground
                    visible: !content_video.visible
                }*/
            }

            ////////

            InfosAudioTags {
                id: content_audio_tags
                width: row.colsize
                height: parent.height
            }

            ////////

            InfosImageTags {
                id: content_image_tags
                width: row.colsize
                height: parent.height
            }

            ////////

            InfosExport {
                id: content_export
                width: row.mapsize
                height: parent.height
            }

            ////////

            InfosMap {
                id: content_map
                width: row.mapsize
                height: parent.height
            }
        }
    }

    Item {
        id: rectangleMenus
        height: 0
    }
}
