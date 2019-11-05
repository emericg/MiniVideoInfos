import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Item { ////
    id: elementTracks
    anchors.left: parent.left
    anchors.leftMargin: 56
    anchors.right: parent.right
    anchors.rightMargin: 12
    height: 32

    function load(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return
        //console.log("elementTracks.(" + mediaItem.name + ")")

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

    Rectangle {
        id: rectangleTracks
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.right: parent.right

        clip: true
        height: 8
        radius: 3
        color: "transparent" // Theme.colorForeground

        Row {
            Repeater {
                id: repeaterTrack
                //model: trackTable

                Rectangle {
                    height: 8//parent.height
                    width: {
                        var www = Math.floor(modelData[2] * rectangleTracks.width)
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
    }

    Row {
        id: row ////
        anchors.top: rectangleTracks.bottom
        anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 24

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("video")
            color: Theme.colorMaterialBlue
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("audio")
            color: Theme.colorMaterialOrange
            font.pixelSize: 14
            font.bold: true
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("other")
            color: Theme.colorSubText
            font.pixelSize: 14
            font.bold: true
        }
    }
}
