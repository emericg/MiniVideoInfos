import QtQuick
import QtQuick.Controls

import ThemeEngine
import "qrc:/utils/UtilsPath.js" as UtilsPath
import "qrc:/utils/UtilsString.js" as UtilsString
import "qrc:/utils/UtilsMedia.js" as UtilsMedia
import "qrc:/utils/UtilsNumber.js" as UtilsNumber

Flickable {
    contentWidth: width
    contentHeight: columnMain.height

    ScrollBar.vertical: ScrollBar { visible: isDesktop }

    ////////////////////////////////////////////////////////////////////////////

    function loadTags(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        columnTags.visible = true
        info_title.text = mediaItem.tag_title
        info_artist.text = mediaItem.tag_artist
        info_album.text = mediaItem.tag_album
        info_year.visible = (mediaItem.tag_year > 0)
        info_year.text = mediaItem.tag_year
        info_track.visible = (mediaItem.tag_track_nb > 0)
        info_track.text = mediaItem.tag_track_nb
        if (mediaItem.tag_track_total > 0) info_track.text += " / " + mediaItem.tag_track_total
        info_genre.text = mediaItem.tag_genre
        info_comment.text = mediaItem.tag_comment

        columnThumbnail.visible = false
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
            id: columnTags
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-icons/duotone/edit.svg"
                text: qsTr("TAGS")
            }

            InfoRow { ////
                id: info_title
                legend: qsTr("title")
            }
            InfoRow { ////
                id: info_artist
                legend: qsTr("artist")
            }
            InfoRow { ////
                id: info_album
                legend: qsTr("album")
            }
            InfoRow { ////
                id: info_year
                legend: qsTr("year")
            }
            InfoRow { ////
                id: info_track
                legend: qsTr("track")
            }
            InfoRow { ////
                id: info_genre
                legend: qsTr("genre")
            }
            InfoRow { ////
                id: info_comment
                legend: qsTr("comment")
            }
        }

        ////////////////

        Column {
            id: columnThumbnail
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/media/image.svg"
                text: qsTr("TUMBNAIL")
            }

            InfoRow { ////
                id: info_thumb_size
                legend: qsTr("size")
            }
        }

        ////////////////
    }

    ////////////////////////////////////////////////////////////////////////////
}
