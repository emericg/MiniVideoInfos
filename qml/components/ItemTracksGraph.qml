import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item {
    id: elementTracks
    implicitHeight: 32

    function load(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return
        //console.log("elementTracks.(" + mediaItem.name + ")")

        legendVideo.visible = mediaItem.hasVideo
        legendAudio.visible = mediaItem.hasAudio

        var trackCurrent = []
        var trackTable = []
        var dataSize = 0

        for (var i = 0; i < mediaItem.getVideoTrackCount(); i++) {
            dataSize += mediaItem.getVideoTrack(i).size
            trackCurrent = [mediaItem.getVideoTrack(i).type, i, (mediaItem.getVideoTrack(i).size / mediaItem.size) * 1]
            trackTable.push(trackCurrent)
        }
        for (i = 0; i < mediaItem.getAudioTrackCount(); i++) {
            dataSize += mediaItem.getAudioTrack(i).size
            trackCurrent = [mediaItem.getAudioTrack(i).type, i, (mediaItem.getAudioTrack(i).size / mediaItem.size) * 1]
            trackTable.push(trackCurrent)
        }
/*
        var otherSize = 0
        for (i = 0; i < mediaItem.getSubtitlesTrackCount(); i++) {
            otherSize += mediaItem.getSubtitlesTrack(i).size
        }
        for (i = 0; i < mediaItem.getOtherTrackCount(); i++) {
            otherSize += mediaItem.getOtherTrack(i).size
        }
*/
        trackCurrent = [0, 0, ((mediaItem.size - dataSize) / mediaItem.size) * 1]
        trackTable.push(trackCurrent)

        repeaterTrack.model = trackTable
        //console.log(trackTable)
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleTracks
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.right: parent.right

        height: 10
        radius: 10
        color: Theme.colorForeground

        Row {
            Repeater {
                id: repeaterTrack
                //model: trackTable

                Rectangle {
                    height: rectangleTracks.height
                    width: {
                        var www = Math.round(modelData[2] * rectangleTracks.width)
                        return ((www > 1) ? www : 1)
                    }
                    opacity: (modelData[1] % 2) ? 0.66 : 1
                    color: {
                        if (modelData[0] === 0)
                            return Theme.colorSubText
                        else if (modelData[0] === 1)
                            return Theme.colorMaterialOrange
                        else if (modelData[0] === 2)
                            return Theme.colorMaterialBlue
                    }
                }
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                x: rectangleTracks.x
                y: rectangleTracks.y
                width: rectangleTracks.width
                height: rectangleTracks.height
                radius: rectangleTracks.radius
            }
        }
    }

    ////////

    Row {
        id: rowTrackSize
        anchors.top: rectangleTracks.bottom
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 24

        Text {
            id: legendVideo
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("video")
            color: Theme.colorMaterialBlue
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            id: legendAudio
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("audio")
            color: Theme.colorMaterialOrange
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            id: legendOther
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("other")
            color: Theme.colorSubText
            font.pixelSize: 14
            font.bold: true
        }
    }
}
