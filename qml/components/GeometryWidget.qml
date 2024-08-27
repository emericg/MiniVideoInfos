import QtQuick

import ThemeEngine
import "qrc:/utils/UtilsMedia.js" as UtilsMedia

Item { ////
    id: item_resBox
    height: 160

    ////////

    function compute(trackItem) {
        // Geometry // transformations
        var geomismatch = ((trackItem.widthVisible + trackItem.heightVisible) > 0 &&
                           (trackItem.widthVisible !== trackItem.width || trackItem.heightVisible !== trackItem.height))

        var geovisible = true

        info_vdefinition_display.visible = geomismatch
        info_dar.visible = geomismatch
        item_resBox.visible = (geomismatch || geovisible)

        img_display_rotate.visible = false
        img_display_resize.visible = false

        if (geomismatch || geovisible) {
            info_vdefinition_display.text = trackItem.widthVisible + " x " + trackItem.heightVisible
            info_dar.text = UtilsMedia.varToString(trackItem.widthVisible, trackItem.heightVisible)

            rect_display.visible = geovisible
            rect_geo.visible = geomismatch

            var maxWidth = item_resBox.width
            var maxHeight = item_resBox.height

            var rect_geo_width = 200
            var rect_geo_height_vert = 160
            var rect_display_width = geomismatch ? 160 : 220
            var rect_display_height_vert = geomismatch ? 160 : 220

            if (((trackItem.width / trackItem.height) > 1) &&
                ((trackItem.widthVisible / trackItem.heightVisible) > 1)) {

                //console.log("LEFT geo / LEFT disp");
                img_display_rotate.visible = false
                img_display_resize.visible = true

                if (trackItem.widthVisible > trackItem.width) {
                    rect_display.width = maxWidth
                    rect_display.height = rect_display.width / trackItem.dar
                    rect_geo.width = rect_display.width * (trackItem.width / trackItem.widthVisible)
                    rect_geo.height = rect_display.height * (trackItem.height / trackItem.heightVisible)
                } else {
                    rect_geo.width = rect_geo_width
                    rect_geo.height = rect_geo.width / trackItem.var
                    rect_display.width = rect_display_width
                    rect_display.height = rect_display.width / trackItem.dar
                }

            } else if (((trackItem.width / trackItem.height) < 1) &&
                       ((trackItem.widthVisible / trackItem.heightVisible) < 1)) {

                //console.log("UP geo / UP disp");
                img_display_rotate.visible = false
                img_display_resize.visible = true

            } else {

                //console.log("UP / LEFT")
                img_display_rotate.visible = true
                img_display_resize.visible = false

                if ((trackItem.width / trackItem.height) < 1) {
                    rect_geo.width = (160 * (trackItem.width/trackItem.height))
                    rect_geo.height = 160
                } else {
                    rect_geo.width = 160
                    rect_geo.height = (160 / (trackItem.width/trackItem.height))
                }
                if ((trackItem.widthVisible / trackItem.heightVisible) < 1) {
                    rect_display.width = (160 * (trackItem.widthVisible/trackItem.heightVisible))
                    rect_display.height = 160
                } else {
                    rect_display.width = 160
                    rect_display.height = (160 / (trackItem.widthVisible/trackItem.heightVisible))
                }

            }

            item_resBox.height = Math.max(rect_geo.height, rect_display.height)
        }

        // Geometry // crop
        if (trackItem.cropTop || trackItem.cropBottom || trackItem.cropLeft || trackItem.cropRight) {
            rect_crop.visible = true
        } else {
            rect_crop.visible = false
        }
    }

    ////////

    Rectangle {
        id: rect_geo
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: 160/(16/9)
        width: 160
        color: "#22999999"
        border.width: 2
        border.color: Theme.colorIcon
    }
    Rectangle {
        id: rect_display
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: 160
        width: 160/(16/9)
        color: "transparent"
        border.width: 2
        border.color: Theme.colorPrimary

        Rectangle { // background
            anchors.fill: parent
            z: -1
            color: Theme.colorComponentBackground
            opacity: 0.66
        }

        IconSvg {
            id: img_display_rotate
            width: 24
            height: 24
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            color: Theme.colorPrimary
            source: "qrc:/assets/icons/material-icons/duotone/rotate_90_degrees_ccw.svg"
        }
        IconSvg {
            id: img_display_resize
            width: 24
            height: 24
            anchors.top: parent.top
            anchors.topMargin: 4
            anchors.right: parent.right
            anchors.rightMargin: 6
            color: Theme.colorPrimary
            source: "qrc:/assets/icons/material-icons/duotone/aspect_ratio.svg"
        }
    }
    Rectangle {
        id: rect_crop
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: 160
        width: 160
        color: "transparent"
        border.width: 2
        border.color: Theme.colorWarning

        IconSvg {
            id: img_crop
            width: 24
            height: 24
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            color: Theme.colorWarning
            source: "qrc:/assets/icons/material-icons/duotone/settings_overscan.svg"
        }
    }

    ////////
}
