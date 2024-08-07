import QtQuick
import QtQuick.Effects
import QtQuick.Controls

import ThemeEngine
import "qrc:/utils/UtilsPath.js" as UtilsPath
import "qrc:/utils/UtilsString.js" as UtilsString
import "qrc:/utils/UtilsMedia.js" as UtilsMedia
import "qrc:/utils/UtilsNumber.js" as UtilsNumber

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

        for (var i = 0; i < mediaItem.videoTracksCount; i++) {
            dataSize += mediaItem.getVideoTrack(i).size
            trackCurrent = [mediaItem.getVideoTrack(i).type, i, (mediaItem.getVideoTrack(i).size / mediaItem.size) * 1]
            trackTable.push(trackCurrent)
        }
        for (i = 0; i < mediaItem.audioTracksCount; i++) {
            dataSize += mediaItem.getAudioTrack(i).size
            trackCurrent = [mediaItem.getAudioTrack(i).type, i, (mediaItem.getAudioTrack(i).size / mediaItem.size) * 1]
            trackTable.push(trackCurrent)
        }

        var otherSize = 0
        for (i = 0; i < mediaItem.subtitlesTrackCount; i++) {
            otherSize += mediaItem.getSubtitlesTrack(i).size
        }
        for (i = 0; i < mediaItem.otherTrackCount; i++) {
            otherSize += mediaItem.getOtherTrack(i).size
        }

        trackCurrent = [0, 0, ((mediaItem.size - dataSize) / mediaItem.size) * 1]
        trackTable.push(trackCurrent)

        //console.log(trackTable)
        repeaterTrack.model = trackTable
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
                        if (modelData[0] === 1)
                            return Theme.colorMaterialOrange
                        else if (modelData[0] === 2)
                            return Theme.colorMaterialBlue
                        else
                            return Theme.colorSubText
                    }
                }
            }
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskInverted: false
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
            maskSpreadAtMax: 0.0
            maskSource: ShaderEffectSource {
                sourceItem: Rectangle {
                    x: rectangleTracks.x
                    y: rectangleTracks.y
                    width: rectangleTracks.width
                    height: rectangleTracks.height
                    radius: rectangleTracks.radius
                }
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
            textFormat: Text.PlainText
            color: Theme.colorMaterialBlue
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            id: legendAudio
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("audio")
            textFormat: Text.PlainText
            color: Theme.colorMaterialOrange
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            id: legendOther
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("other")
            textFormat: Text.PlainText
            color: Theme.colorSubText
            font.pixelSize: 14
            font.bold: true
        }
    }

    ////////
}
