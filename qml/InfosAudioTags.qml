import QtQuick
import QtQuick.Controls

import ThemeEngine
import "qrc:/js/UtilsPath.js" as UtilsPath
import "qrc:/js/UtilsString.js" as UtilsString
import "qrc:/js/UtilsMedia.js" as UtilsMedia
import "qrc:/js/UtilsNumber.js" as UtilsNumber

Flickable {
    contentWidth: width
    contentHeight: columnMain.height

    ScrollBar.vertical: ScrollBar {}

    function loadTags(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        columnTags.visible = true // (mediaItem.cameraBrand || mediaItem.cameraModel || mediaItem.cameraSoftware)

        info_title.text = mediaItem.tag_title
        info_artist.text = mediaItem.tag_artist
        info_album.text = mediaItem.tag_album
        item_year.visible = (mediaItem.tag_year > 0)
        info_year.text = mediaItem.tag_year
        item_track.visible = (mediaItem.tag_track_nb > 0)
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
        bottomPadding: 16 + rectangleMenus.hhh
        spacing: 8

        ////////////////

        Column {
            id: columnTags
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item { ////
                id: titleTags
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
                    source: "qrc:/assets/icons_material/duotone-edit-24px.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("TAGS")
                    textFormat: Text.PlainText
                    color: Theme.colorPrimary
                    font.pixelSize: 18
                    font.bold: true
                }
            }

            Item { ////
                id: item_title
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                height: (info_title.height > 24) ? (info_title.height + 0) : 24
                visible: (info_title.text.length > 0)

                Text {
                    id: legend_title
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("title")
                    textFormat: Text.PlainText
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
                id: item_artist
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_artist.text.length > 0)

                Text {
                    text: qsTr("artist")
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                }
                TextEditMVI {
                    id: info_artist
                }
            }
            Item { ////
                id: item_album
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                height: (info_album.height > 24) ? (info_album.height + 0) : 24
                visible: (info_album.text.length > 0)

                Text {
                    id: legend_album
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("album")
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_album
                    anchors.left: legend_album.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
            Row { ////
                id: item_year
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                //visible: (info_year.text.length > 0)

                Text {
                    text: qsTr("year")
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_year
                }
            }
            Row { ////
                id: item_track
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                //visible: (info_track.text.length > 0)

                Text {
                    text: qsTr("track")
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_track
                }
            }
            Row { ////
                id: item_genre
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_genre.text.length > 0)

                Text {
                    text: qsTr("genre")
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_genre
                }
            }
            Item { ////
                id: item_comment
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                height: (info_comment.height > 24) ? (info_comment.height + 0) : 24
                visible: (info_comment.text.length > 0)

                Text {
                    id: legend_comment
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("comment")
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_comment
                    anchors.left: legend_comment.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
            }
        }

        ////////////////

        Column {
            id: columnThumbnail
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item {
                id: titleThumbnail
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
                    source: "qrc:/assets/icons_material/outline-insert_photo-24px.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("TUMBNAIL")
                    textFormat: Text.PlainText
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
                    text: qsTr("size")
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_thumb_size
                }
            }
        }
    }
}
