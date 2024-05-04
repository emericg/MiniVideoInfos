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

    ScrollBar.vertical: ScrollBar { visible: isDesktop }

    ////////////////////////////////////////////////////////////////////////////

    function loadTags(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        columnCamera.visible = (mediaItem.cameraBrand || mediaItem.cameraModel || mediaItem.cameraSoftware)
        info_brand.text = mediaItem.cameraBrand
        info_model.text = mediaItem.cameraModel
        info_software.text = mediaItem.cameraSoftware

        info_mpix.text = ((mediaItem.width * mediaItem.height) / 1000000).toFixed(1)
        info_iso.text = mediaItem.iso
        info_focal.text = mediaItem.focal
        info_exposure.text = mediaItem.exposure
        info_exposureBias.text = mediaItem.exposureBias
        info_flash.text = mediaItem.flash
        info_lightSource.text = mediaItem.lightSource
        info_meteringMode.text = mediaItem.meteringMode

        columnGPS.visible = mediaItem.hasGPS
        info_gps_version.text = mediaItem.gpsVersion
        info_gps_date.text = mediaItem.dateGPS
        info_gps_lat.text = mediaItem.latitudeString
        info_gps_long.text = mediaItem.longitudeString
        item_gps_alt.visible = (mediaItem.altitudeCorrected > 0)
        info_gps_alt.text = UtilsString.altitudeToString(mediaItem.altitudeCorrected, 0, settingsManager.appunits)
        item_gps_alt_egm96.visible = (mediaItem.altitudeCorrected > 0)
        info_gps_alt_stored.text = UtilsString.altitudeToString(mediaItem.altitude, 0, settingsManager.appunits)
        info_gps_alt_egm96.text = UtilsString.altitudeToString(-mediaItem.altitudeCorrection, 0, settingsManager.appunits)
        item_gps_speed.visible =(mediaItem.speed > 0)
        info_gps_speed.text = UtilsString.speedToString_km(mediaItem.speed, 1, settingsManager.appUnits)
        item_gps_speed.visible =(mediaItem.speed > 0)
        info_gps_speed.text = UtilsString.speedToString_km(mediaItem.speed, 1, settingsManager.appUnits)

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
            id: columnCamera
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item { ////
                id: titleCamera
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
                    source: "qrc:/assets/icons/material-symbols/media/photo_camera.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("CAMERA")
                    color: Theme.colorPrimary
                    font.pixelSize: 18
                    font.bold: true
                }
            }
            Row { ////
                id: item_brand
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_brand.text.length > 0)

                Text {
                    text: qsTr("brand")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_brand
                }
            }
            Row { ////
                id: item_model
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_model.text.length > 0)

                Text {
                    text: qsTr("model")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                }
                TextEditMVI {
                    id: info_model
                }
            }
            Item { ////
                id: item_software
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                height: (info_software.height > 24) ? (info_software.height + 0) : 24
                visible: (info_software.text.length > 0)

                Text {
                    id: legend_software
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 0

                    text: qsTr("software")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_software
                    anchors.left: legend_software.right
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                }
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

                IconSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons/material-symbols/media/exposure.svg"
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
                    text: qsTr("megapixel")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_mpix
                }
            }
            Row { ////
                id: item_focal
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_focal.text.length > 0)

                Text {
                    text: qsTr("focal")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_focal
                }
            }
            Row { ////
                id: item_exposure
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_exposure.text.length > 0)

                Text {
                    text: qsTr("exposure time")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_exposure
                }
            }
            Row { ////
                id: item_exposureBias
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_exposureBias.text.length > 0)

                Text {
                    text: qsTr("exposure bias")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_exposureBias
                }
            }
            Row { ////
                id: item_iso
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_iso.text.length > 0)

                Text {
                    text: qsTr("ISO")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_iso
                }
            }
            Row { ////
                id: item_flash
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_flash.text !== "false")

                Text {
                    text: qsTr("flash")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_flash
                }
            }
            Row { ////
                id: item_lightSource
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_lightSource.text.length > 0)

                Text {
                    text: qsTr("light source")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_lightSource
                }
            }
            Row { ////
                id: item_meteringMode
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_meteringMode.text.length > 0)

                Text {
                    text: qsTr("metering mode")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_meteringMode
                }
            }
        }

        ////////////////

        Column {
            id: columnGPS
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            Item { ////
                id: titleGPS
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
                    source: "qrc:/assets/icons/material-icons/duotone/pin_drop.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("GPS")
                    font.pixelSize: 18
                    font.bold: true
                    color: Theme.colorPrimary
                }
            }

            Row { ////
                id: item_gps_version
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16
                visible: (info_gps_version.length > 0)

                Text {
                    text: qsTr("version")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_gps_version
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
                TextEditMVI {
                    id: info_gps_date
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("latitude")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_gps_lat
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("longitude")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                }
                TextEditMVI {
                    id: info_gps_long
                }
            }
            Row { ////
                id: item_gps_alt
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("altitude")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                }
                TextEditMVI {
                    id: info_gps_alt
                }
            }
            Row { ////
                id: item_gps_alt_egm96
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 12

                Text {
                    text: qsTr("altitude metadata")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                }
                TextEditMVI {
                    id: info_gps_alt_stored
                }
                Text {
                    text: qsTr("EGM96 correction")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                }
                TextEditMVI {
                    id: info_gps_alt_egm96
                }
            }
            Row { ////
                id: item_gps_speed
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("speed")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                }
                TextEditMVI {
                    id: info_gps_speed
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
                    source: "qrc:/assets/icons/material-symbols/media/image.svg"
                }
                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("TUMBNAIL")
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
                    text: qsTr("compression")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_thumb_compression
                }
            }
            Row { ////
                anchors.left: parent.left
                anchors.leftMargin: 56
                height: 24
                spacing: 16

                Text {
                    text: qsTr("orientation")
                    color: Theme.colorSubText
                    font.pixelSize: 15
                }
                TextEditMVI {
                    id: info_thumb_orientation
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
                TextEditMVI {
                    id: info_thumb_size
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
