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
            textGeometry.text = mediaItem.width + "x" + mediaItem.height
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

        videoRepeater.model = mediaItem.getVideoTrackCount()
        audioRepeater.model = mediaItem.getAudioTrackCount()

        item_subtitles.visible = mediaItem.hasSubtitles
        if (mediaItem.hasSubtitles) content_subtitles.loadSubtitles(mediaItem)

        item_audio_tags.visible = mediaItem.hasAudioTags
        if (mediaItem.hasAudioTags) content_audio_tags.loadTags(mediaItem)

        item_image_tags.visible = mediaItem.hasEXIF
        if (mediaItem.hasEXIF) content_image_tags.loadTags(mediaItem)

        item_export.visible = (settingsManager.exportEnabled && mediaItem.hasVideo)
        if (settingsManager.exportEnabled && mediaItem.hasVideo) content_export.loadExport(mediaItem)

        item_map.visible = mediaItem.hasGPS
        if (mediaItem.hasGPS) {
            if (mapLoader.status != Loader.Ready) {
                mapLoader.source = "InfosMap.qml"
            }
            item_map.content_map.loadGps(mediaItem)
        }
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
            spacing: 0

            property int colsize: 480
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

            ////////////////////////////////////////////////////////////////////

            InfosGeneric {
                id: content_generic
                width: row.colsize
                height: parent.height
            }

            ////////

            Repeater {
                id: videoRepeater
                height: parent.height

                Item {
                    id: item_video
                    width: row.colsize
                    height: parent.height

                    Rectangle {
                        anchors.fill: parent
                        opacity: 0.4
                        color: Theme.colorForeground
                        visible: (index % 2 === 0)
                    }
                    InfosAV {
                        id: content_video
                        anchors.fill: parent
                        Component.onCompleted: loadTrack(mediaItem.getVideoTrack(index))
                    }
                }
            }

            ////////

            Repeater {
                id: audioRepeater
                height: parent.height

                Item {
                    id: item_audio
                    width: row.colsize
                    height: parent.height

                    Rectangle {
                        anchors.fill: parent
                        opacity: 0.4
                        color: Theme.colorForeground
                        visible: ((mediaItem.getVideoTrackCount() + index) % 2 === 0)
                    }
                    InfosAV {
                        id: content_audio
                        anchors.fill: parent
                        Component.onCompleted: loadTrack(mediaItem.getAudioTrack(index))
                    }
                }
            }

            ////////

            Item {
                id: item_subtitles
                width: row.colsize
                height: parent.height

                Rectangle {
                    anchors.fill: parent
                    opacity: 0.4
                    color: Theme.colorForeground
                    visible: ((mediaItem.getVideoTrackCount() + mediaItem.getAudioTrackCount()) % 2 === 0)
                }
                InfosSubtitles {
                    id: content_subtitles
                    anchors.fill: parent
                }
            }

            ////////

            Item {
                id: item_audio_tags
                width: row.colsize
                height: parent.height

                Rectangle {
                    id: content_audio_tags_bg
                    anchors.fill: parent
                    opacity: 0.4
                    color: Theme.colorForeground
                    visible: ((mediaItem.getVideoTrackCount() + mediaItem.getAudioTrackCount()) % 2 === 0)
                }
                InfosAudioTags {
                    id: content_audio_tags
                    anchors.fill: parent
                }
            }

            ////////

            Item {
                id: item_image_tags
                width: row.colsize
                height: parent.height

                Rectangle {
                    id: content_image_tags_bg
                    anchors.fill: parent
                    opacity: 0.4
                    color: Theme.colorForeground
                    visible: ((mediaItem.getVideoTrackCount() + mediaItem.getAudioTrackCount()) % 2 === 0)
                }
                InfosImageTags {
                    id: content_image_tags
                    anchors.fill: parent
                }
            }

            ////////

            Item {
                id: item_export
                width: row.mapsize
                height: parent.height

                Rectangle {
                    id: content_export_bg
                    anchors.fill: parent
                    opacity: 0.4
                    color: Theme.colorForeground
                    visible: ((mediaItem.getVideoTrackCount() + mediaItem.getAudioTrackCount()) % 2 === 0)
                }
                InfosExport {
                    id: content_export
                    anchors.fill: parent
                }
            }

            ////////

            Item {
                id: item_map
                width: row.mapsize
                height: parent.height

                property alias content_map: mapLoader.item

                Loader {
                    id: mapLoader
                    anchors.fill: parent
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Item { // compatibility
        id: rectangleMenus
        height: 0
        visible: false
    }
}
