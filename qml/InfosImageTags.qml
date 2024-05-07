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
        //info_gps_alt.visible = (mediaItem.altitudeCorrected > 0)
        info_gps_alt.text = (mediaItem.altitudeCorrected > 0) ? UtilsString.altitudeToString(mediaItem.altitudeCorrected, 0, settingsManager.appunits) : ""
        //info_gps_alt_egm96.visible = (mediaItem.altitudeCorrected > 0)
        info_gps_alt_egm96.text1 =(mediaItem.altitudeCorrected > 0) ? UtilsString.altitudeToString(mediaItem.altitude, 0, settingsManager.appunits) : ""
        info_gps_alt_egm96.text2 =(mediaItem.altitudeCorrected > 0) ? UtilsString.altitudeToString(-mediaItem.altitudeCorrection, 0, settingsManager.appunits) : ""
        //item_gps_speed.visible = (mediaItem.speed > 0)
        info_gps_speed.text = (mediaItem.speed > 0) ? UtilsString.speedToString_km(mediaItem.speed, 1, settingsManager.appUnits) : ""

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
            id: columnCamera
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/media/photo_camera.svg"
                text: qsTr("CAMERA")
            }
            InfoRow { ////
                id: info_brand
                legend: qsTr("brand")
            }
            InfoRow { ////
                id: info_model
                legend: qsTr("model")
            }
            InfoRow { ////
                id: info_software
                legend: qsTr("software")
            }
        }

        ////////////////

        Column {
            id: columnImage
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-symbols/media/exposure.svg"
                text: qsTr("IMAGE")
            }
            InfoRow { ////
                id: info_mpix
                legend: qsTr("megapixel")
            }
            InfoRow { ////
                id: info_focal
                legend: qsTr("focal")
            }
            InfoRow { ////
                id: info_exposure
                legend: qsTr("exposure time")
            }
            InfoRow { ////
                id: info_exposureBias
                legend: qsTr("exposure bias")
            }
            InfoRow { ////
                id: info_iso
                legend: qsTr("ISO")
            }
            InfoRow { ////
                id: info_flash
                legend: qsTr("flash")
                visible: (info_flash.text !== "false")
            }
            InfoRow { ////
                id: info_lightSource
                legend: qsTr("light source")
            }
            InfoRow { ////
                id: info_meteringMode
                legend: qsTr("metering mode")
            }
        }

        ////////////////

        Column {
            id: columnGPS
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            InfoTitle { ////
                source: "qrc:/assets/icons/material-icons/duotone/pin_drop.svg"
                text: qsTr("GPS")
            }

            InfoRow { ////
                id: info_gps_version
                legend: qsTr("version")
            }
            InfoRow { ////
                id: info_gps_date
                legend: qsTr("date")
            }
            InfoRow { ////
                id: info_gps_lat
                legend: qsTr("latitude")
            }
            InfoRow { ////
                id: info_gps_long
                legend: qsTr("longitude")
            }
            InfoRow { ////
                id: info_gps_alt
                legend: qsTr("altitude")
            }
            InfoFlow { ////
                id: info_gps_alt_egm96
                legend1: qsTr("altitude metadata")
                legend2: qsTr("EGM96 correction")
            }
            InfoRow { ////
                id: info_gps_speed
                legend: qsTr("speed")
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
                id: info_thumb_compression
                legend: qsTr("compression")
            }
            InfoRow { ////
                id: info_thumb_orientation
                legend: qsTr("orientation")
            }
            InfoRow { ////
                id: info_thumb_size
                legend: qsTr("size")
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
