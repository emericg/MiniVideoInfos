import QtQuick 2.15
import QtQuick.Controls 2.15

import QtLocation
import QtPositioning

import ThemeEngine 1.0
import "qrc:/js/UtilsString.js" as UtilsString

Item {
    id: infosMap
    implicitWidth: 480
    implicitHeight: 720

    function loadGps(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        if (mediaItem.latitude !== 0.0) {

            // center view
            map.center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)
            map.moove = false
            map.zoomLevel = 12

            // buttons
            button_map_dezoom.enabled = true
            button_map_zoom.enabled = true

            // map marker
            mapMarker.visible = true
            mapMarker.rotation = mediaItem.direction
            mapMarker.coordinate = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)

            // legend
            info_lat.text = mediaItem.latitudeString
            info_long.text = mediaItem.longitudeString
            info_altitude.text = UtilsString.altitudeToString(mediaItem.altitudeCorrected, 0, settingsManager.appunits)
            row_altitude.visible = (mediaItem.altitudeCorrected > 0)
            info_speed.text = UtilsString.speedToString_km(mediaItem.speed, 1, settingsManager.appUnits)
            row_speed.visible = (mediaItem.speed > 0)
            row_altspd.visible = (mediaItem.altitudeCorrected > 0 || mediaItem.speed > 0)
            item_track.visible = false
            //info_track.text = mediaItem.gpscount

            // scale indicator
            calculateScale()
        }
    }

    property variant scaleLengths: [5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000, 200000, 500000, 1000000, 2000000]

    function calculateScale() {
        //console.log("calculateScale(zoom: " + map.zoomLevel + ")")

        var coord1, coord2, dist, f
        f = 0
        coord1 = map.toCoordinate(Qt.point(0, mapScale.y))
        coord2 = map.toCoordinate(Qt.point(100, mapScale.y))
        dist = Math.round(coord1.distanceTo(coord2))

        if (dist === 0) {
            mapScale.visible = false
            mapScale.width = 100
        } else {
            for (var i = 0; i < scaleLengths.length-1; i++) {
                if (dist < (scaleLengths[i] + scaleLengths[i+1]) / 2 ) {
                    f = scaleLengths[i] / dist
                    dist = scaleLengths[i]
                    break
                }
            }
            if (f === 0) {
                f = dist / scaleLengths[i]
                dist = scaleLengths[i]
            }

            mapScale.visible = true
            mapScale.width = 100 * f
            mapScaleText.text = UtilsString.distanceToString(dist, 0, settingsManager.appUnits)
        }
    }

    function zoomIn() {
        if (map.zoomLevel < Math.round(map.maximumZoomLevel)) {
            map.zoomLevel = Math.round(map.zoomLevel + 1)
            if (!map.moove) map.center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)
            calculateScale()
        }
    }

    function zoomOut() {
        if (map.zoomLevel > Math.round(map.minimumZoomLevel)) {
            map.zoomLevel = Math.round(map.zoomLevel - 1)
            if (!map.moove) map.center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)
            calculateScale()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Map {
        id: map
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        //z: parent.z + 1

        tilt: 0
        fieldOfView: 45
        zoomLevel: 9
        center: QtPositioning.coordinate(45.5, 6)
        //activeMapType: MapType.TerrainMap

        property bool moove: false
        //gesture.enabled: moove
        copyrightsVisible: false

        plugin: Plugin {
            preferred: ["maplibregl", "osm", "esri"]
            PluginParameter { name: "osm.mapping.highdpi_tiles"; value: "true"; }
        }

        ////////////////

        MouseArea {
            anchors.fill: parent
            onWheel: (wheel) => {
                if (wheel.angleDelta.y < 0) zoomOut()
                else if (wheel.angleDelta.y > 0) zoomIn()
            }
        }

        ////////////////

        MapQuickItem {
            id: mapMarker
            visible: false
            anchorPoint.x: (mapMarkerImg.width / 2)
            anchorPoint.y: (mapMarkerImg.height / 2)
            sourceItem: Image {
                id: mapMarkerImg
                width: 64
                height: 64
                source: {
                    if (mediaItem.direction) return "qrc:/assets/others/gps_marker_direction.svg"
                    return "qrc:/assets/others/gps_marker.svg"
                }
                sourceSize: Qt.size(width, height)
            }
        }

        MapPolyline {
            id: mapTrace
            visible: false
            line.width: 3
            line.color: Theme.colorPrimary
        }

        ////////////////

        Row {
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            spacing: 16

            RoundButtonIcon {
                id: button_map_moove
                width: 40
                height: 40

                background: true
                backgroundColor: Theme.colorHeader
                highlightMode: "color"
                iconColor: map.moove ? Theme.colorHeaderContent : Theme.colorText
                source: "qrc:/assets/icons_material/baseline-open_with-24px.svg"

                selected: map.moove
                onClicked: {
                    map.moove = !map.moove

                    // also disable swiping through tabs?
                    //mediaPages.interactive = !map.moove
                }
            }
            RoundButtonIcon {
                id: button_map_center
                width: 40
                height: 40

                visible: (opacity > 0)
                opacity: (map.center !== QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)) ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }

                background: true
                backgroundColor: Theme.colorHeader
                highlightMode: "color"
                iconColor: Theme.colorText
                source: "qrc:/assets/icons_material/baseline-gps_fixed-24px.svg"

                onClicked: map.center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)
            }
        }

        Row {
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            spacing: 16

            RoundButtonIcon {
                id: button_map_dezoom
                width: 40
                height: 40

                highlightMode: "color"
                iconColor: Theme.colorText
                background: true
                backgroundColor: Theme.colorHeader

                source: "qrc:/assets/icons_material/baseline-zoom_out-24px.svg"
                onClicked: zoomOut()
            }

            RoundButtonIcon {
                id: button_map_zoom
                width: 40
                height: 40

                highlightMode: "color"
                iconColor: Theme.colorText
                background: true
                backgroundColor: Theme.colorHeader

                source: "qrc:/assets/icons_material/baseline-zoom_in-24px.svg"
                onClicked: zoomIn()
            }
        }

        ////////////////

        Item {
            id: mapScale
            width: 100
            height: 16
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: rectangleCoordinates.top
            anchors.bottomMargin: 16

            Text {
                id: mapScaleText
                anchors.centerIn: parent
                text: "100m"
                color: "#555"
                font.pixelSize: 12
            }

            Rectangle {
                width: 2; height: 6;
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                color: "#555"
            }
            Rectangle {
                width: parent.width; height: 2;
                anchors.bottom: parent.bottom
                color: "#555"
            }
            Rectangle {
                width: 2; height: 6;
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "#555"
            }
        }

        ////////////////

        Rectangle {
            id: rectangleCoordinates
            height: columnCoordinates.height + 16
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: rectangleMenus.hhh
            color: Theme.colorForeground
            opacity: 0.9

            IconSvg {
                width: 32
                height: 32
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                color: Theme.colorPrimary
                source: "qrc:/assets/icons_material/duotone-pin_drop-24px.svg"
            }

            Column {
                id: columnCoordinates
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right

                Item { ////
                    id: item_lat
                    height: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 16

                        Text {
                            text: qsTr("latitude")
                            textFormat: Text.PlainText
                            color: Theme.colorSubText
                            font.pixelSize: 15
                            wrapMode: Text.WordWrap
                        }
                        TextEditMVI {
                            id: info_lat
                        }
                    }
                }
                Item { ////
                    id: item_long
                    height: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    Row {
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 16

                        Text {
                            text: qsTr("longitude")
                            textFormat: Text.PlainText
                            color: Theme.colorSubText
                            font.pixelSize: 15
                            wrapMode: Text.WordWrap
                        }
                        TextEditMVI {
                            id: info_long
                        }
                    }
                }
                Row { ////
                    id: row_altspd
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    height: 20
                    spacing: 24

                    Row {
                        id: row_altitude
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 16

                        Text {
                            text: qsTr("altitude")
                            textFormat: Text.PlainText
                            color: Theme.colorSubText
                            font.pixelSize: 15
                            wrapMode: Text.WordWrap
                        }
                        TextEditMVI {
                            id: info_altitude
                        }
                    }

                    Row {
                        id: row_speed
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 16

                        Text {
                            text: qsTr("speed")
                            textFormat: Text.PlainText
                            color: Theme.colorSubText
                            font.pixelSize: 15
                            wrapMode: Text.WordWrap
                        }
                        TextEditMVI {
                            id: info_speed
                        }
                    }
                }
                Item { ////
                    id: item_track
                    height: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 56
                    anchors.right: parent.right
                    anchors.rightMargin: 0

                    Row {
                        id: row_track
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 16

                        Text {
                            text: qsTr("track")
                            textFormat: Text.PlainText
                            color: Theme.colorSubText
                            font.pixelSize: 15
                            wrapMode: Text.WordWrap
                        }
                        TextEditMVI {
                            id: info_track
                        }
                    }
                }
            }
        }
    }
}
