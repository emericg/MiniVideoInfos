import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item {
    id: screenMediasInfos
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenLeftPadding
    anchors.rightMargin: screenRightPadding

    property var mediaItem: null

    function loadMediaInfos(newmedia) {
        if (typeof newmedia === "undefined" || !newmedia) return
        if (newmedia === mediaItem) return

        mediaPages.currentIndex = 0
        mediaItem = newmedia

        //console.log("screenMediasInfos.loadMediaInfos(" + mediaItem.name + ")")

        // Title
        if (mediaItem.name.length < 24)
            appHeader.title = mediaItem.name + "." + mediaItem.ext
        else
            appHeader.title = "MiniVideo Infos"

        // Header
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
                textChannels.text = mediaItem.audioChannels + qsTr(" chan.")
        } else {
            columnChannels.visible = false
        }

        columnGPS.visible = mediaItem.hasGPS

        ////

        content_generic.loadGeneric()

        pageVideo.visible = mediaItem.hasVideo
        menuVideo.visible = mediaItem.hasVideo
        if (mediaItem.hasVideo) content_video.loadTrack(mediaItem.getVideoTrack(0))

        pageAudio.visible = mediaItem.hasAudio
        menuAudio.visible = mediaItem.hasAudio
        if (mediaItem.hasAudio) content_audio.loadTrack(mediaItem.getAudioTrack(0))

        pageAudioTags.visible = mediaItem.hasAudioTags
        menuAudioTags.visible = mediaItem.hasAudioTags
        if (mediaItem.hasAudioTags) content_audio_tags.loadTags(mediaItem)

        pageImageTags.visible = mediaItem.hasEXIF
        menuImageTags.visible = mediaItem.hasEXIF
        if (mediaItem.hasEXIF) content_image_tags.loadTags(mediaItem)

        pageMap.visible = mediaItem.hasGPS
        menuMap.visible = mediaItem.hasGPS
        if (mediaItem.hasGPS) content_map.loadGps(mediaItem)

        pageExport.visible = (settingsManager.exportEnabled && mediaItem.hasVideo)
        menuExport.visible = (settingsManager.exportEnabled && mediaItem.hasVideo)
        if (settingsManager.exportEnabled && mediaItem.hasVideo) content_export.loadExport(mediaItem)

        rectangleMenus.visible = (mediaItem.hasVideo || mediaItem.hasVideo ||
                                  mediaItem.hasAudioTags || mediaItem.hasEXIF ||
                                  mediaItem.hasGPS)

        ////

        var headercolumncount = 1
        if (mediaItem.fileType === 1 || mediaItem.fileType === 2) headercolumncount++;
        if (mediaItem.fileType === 2 || mediaItem.fileType === 3) headercolumncount++;
        if (mediaItem.fileType === 1 || mediaItem.audioCodec.length) headercolumncount++;
        if (mediaItem.hasGPS) headercolumncount++;
        var headercolumnwidth = ((rectangleHeader.width - 48) / headercolumncount)
        if (headercolumnwidth > 128) headercolumnwidth = 128
        columnDuration.width = headercolumnwidth
        columnSize.width = headercolumnwidth
        columnGeometry.width = headercolumnwidth
        columnChannels.width = headercolumnwidth
        columnGPS.width = headercolumnwidth
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleHeader
        color: Theme.colorForeground
        height: 72
        z: 5

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Column {
            id: column
            anchors.verticalCenterOffset: -4
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.left: parent.left
            spacing: 10

            Row {
                id: rowIcons
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                Column {
                    id: columnDuration
                    width: 96

                    ImageSvg {
                        width: 40
                        height: 40
                        anchors.horizontalCenter: parent.horizontalCenter

                        color: Theme.colorIcon
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/assets/icons_material_medias/duotone-av_timer-24px.svg"
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
                        source: "qrc:/assets/icons_material_medias/duotone-aspect_ratio-24px.svg"
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
                        source: "qrc:/assets/icons_material_medias/duotone-speaker-24px.svg"
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

        Rectangle {
            height: 1
            color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    SwipeView {
        id: mediaPages

        anchors.top: rectangleHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0 // (rectangleMenus.visible) ? rectangleMenus.height : 0

        interactive: false
        currentIndex: 0
        onCurrentIndexChanged: {
            //
        }

        Item {
            id: pageGeneric
            clip: true

            InfosGeneric {
                id: content_generic
                anchors.fill: parent
            }
        }

        Item {
            id: pageVideo
            clip: true
            //visible: false

            InfosAV {
                id: content_video
                anchors.fill: parent
            }
        }

        Item {
            id: pageAudio
            clip: true

            InfosAV {
                id: content_audio
                anchors.fill: parent
            }
        }
        Item {
            id: pageAudioTags
            clip: true

            InfosAudioTags {
                id: content_audio_tags
                anchors.fill: parent
            }
        }

        Item {
            id: pageImageTags
            clip: true

            InfosImageTags {
                id: content_image_tags
                anchors.fill: parent
            }
        }

        Item {
            id: pageMap
            clip: true

            InfosMap {
                id: content_map
                anchors.fill: parent
            }
        }

        Item {
            id: pageExport
            clip: true

            InfosExport {
                id: content_export
                anchors.fill: parent
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleMenus
        height: 56
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        z: 5
        color: Theme.colorForeground
        opacity: 0.9

        Rectangle {
            height: 1
            color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
        }

        Row {
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                id: menuInfos
                width: 64
                height: 48

                property bool selected: (mediaPages.currentIndex === 0)

                MouseArea {
                    anchors.fill: parent
                    onClicked: mediaPages.currentIndex = 0
                }

                ImageSvg {
                    id: imageI
                    width: 26
                    height: 26
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material/outline-insert_drive_file-24px.svg"
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: imageI.bottom
                    anchors.topMargin: 0

                    text: qsTr("file")
                    font.pixelSize: 12
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
            }

            Item {
                id: menuVideo
                width: 64
                height: 48

                property bool selected: (mediaPages.currentIndex === 1)

                MouseArea {
                    anchors.fill: parent
                    onClicked: mediaPages.currentIndex = 1
                }

                ImageSvg {
                    id: imageV
                    width: 26
                    height: 26
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material_medias/outline-local_movies-24px.svg"
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
                Text {
                    anchors.top: imageV.bottom
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("video")
                    font.pixelSize: 12
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
            }

            Item {
                id: menuAudio
                width: 64
                height: 48

                property bool selected: (mediaPages.currentIndex === 2)

                MouseArea {
                    anchors.fill: parent
                    onClicked: mediaPages.currentIndex = 2
                }

                ImageSvg {
                    id: imageA
                    width: 26
                    height: 26
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material_medias/outline-speaker-24px.svg"
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }

                Text {
                    anchors.top: imageA.bottom
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("audio")
                    font.pixelSize: 12
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
            }

            Item {
                id: menuAudioTags
                width: 64
                height: 48

                property bool selected: (mediaPages.currentIndex === 3)

                MouseArea {
                    anchors.fill: parent
                    onClicked: mediaPages.currentIndex = 3
                }

                ImageSvg {
                    id: imageAT
                    width: 26
                    height: 26
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material_medias/outline-insert_music-24px.svg"
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }

                Text {
                    anchors.top: imageAT.bottom
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("tags")
                    font.pixelSize: 12
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
            }

            Item {
                id: menuImageTags
                width: 64
                height: 48

                property bool selected: (mediaPages.currentIndex === 4)

                MouseArea {
                    anchors.fill: parent
                    onClicked: mediaPages.currentIndex = 4
                }

                ImageSvg {
                    id: imageIT
                    width: 26
                    height: 26
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material_medias/outline-insert_photo-24px.svg"
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }

                Text {
                    anchors.top: imageIT.bottom
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("tags")
                    font.pixelSize: 12
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
            }

            Item {
                id: menuMap
                width: 64
                height: 48

                property bool selected: (mediaPages.currentIndex === 5)

                MouseArea {
                    anchors.fill: parent
                    onClicked: mediaPages.currentIndex = 5
                }

                ImageSvg {
                    id: imageMap
                    width: 26
                    height: 26
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material/baseline-map-24px.svg"
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }

                Text {
                    anchors.top: imageMap.bottom
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("map")
                    font.pixelSize: 12
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
            }

            Item {
                id: menuExport
                width: 64
                height: 48

                property bool selected: (mediaPages.currentIndex === 6)

                MouseArea {
                    anchors.fill: parent
                    onClicked: mediaPages.currentIndex = 6
                }

                ImageSvg {
                    id: imageExp
                    width: 26
                    height: 26
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material/outline-archive-24px.svg"
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }

                Text {
                    anchors.top: imageExp.bottom
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("export")
                    font.pixelSize: 12
                    color: (parent.selected) ? Theme.colorHeaderContent : Theme.colorIcon
                }
            }
        }
    }
}
