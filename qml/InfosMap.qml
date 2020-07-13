import QtQuick 2.12
import QtQuick.Controls 2.12

import QtLocation 5.12
import QtPositioning 5.12

import ThemeEngine 1.0
import "qrc:/js/UtilsString.js" as UtilsString

Item {
    id: infos_maps
    implicitWidth: 480
    implicitHeight: 720

    property var center: QtPositioning.coordinate(45.5, 6)

    function loadGps(mediaItem) {
        if (typeof mediaItem === "undefined" || !mediaItem) return

        if (mediaItem.latitude !== 0.0) {
            center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)

            mapPointGPS.center = center
            mapPointGPS.zoomLevel = 12
            mapMarker.visible = true
            mapMarker.coordinate = center
            button_map_dezoom.enabled = true
            button_map_zoom.enabled = true

            info_lat.text = mediaItem.latitudeString
            info_long.text = mediaItem.longitudeString
            info_altitude.text = UtilsString.altitudeToString(mediaItem.altitude, 0, settingsManager.appunits)
            item_altitude.visible = (mediaItem.altitude > 0)

            item_track.visible = false
            //info_track.text = mediaItem.gpscount
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Map {
        id: mapPointGPS
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

        gesture.enabled: false
        copyrightsVisible: false
/*
        plugin: Plugin {
            id: plugin_mapbox
            name: "mapboxgl" // "osm", "mapboxgl", "esri"
            PluginParameter { name: "mapbox.mapping.highdpi_tiles"; value: "false"; }
        }
*/
        plugin: Plugin {
            id: plugin_osm
            name: "osm" // "osm", "mapboxgl", "esri"
            PluginParameter { name: "osm.mapping.highdpi_tiles"; value: "true"; }
        }

        ////////////////

        MapQuickItem {
            id: mapMarker
            visible: false
            anchorPoint.x: mapMarkerImg.width/2
            anchorPoint.y: mapMarkerImg.height/2
            sourceItem: Image {
                id: mapMarkerImg
                source: "qrc:/assets/others/gps_marker.svg"
            }
        }

        ////////////////

        Rectangle {
            id: rectangleCoordinates
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: columnCoordinates.bottom
            anchors.bottomMargin: -12
            color: Theme.colorForeground
            opacity: 0.9
        }

        ImageSvg {
            width: 32
            height: 32
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: rectangleCoordinates.verticalCenter

            color: Theme.colorPrimary
            fillMode: Image.PreserveAspectFit
            source: "qrc:/assets/icons_material/duotone-pin_drop-24px.svg"
        }

        Column {
            id: columnCoordinates
            spacing: 2
            anchors.top: parent.top
            anchors.topMargin: 12
            anchors.right: parent.right
            anchors.left: parent.left

            Item {
                id: item_lat
                height: 20
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                Row {
                    anchors.verticalCenter: parent.verticalCenter ////
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    spacing: 16

                    Text {
                        text: qsTr("latitude")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        id: info_lat
                        color: Theme.colorText
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
                }
            }
            Item {
                id: item_long
                height: 20
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                Row {
                    anchors.verticalCenter: parent.verticalCenter ////
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    spacing: 16

                    Text {
                        text: qsTr("longitude")
                        color: Theme.colorSubText
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        id: info_long
                        color: Theme.colorText
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
                }
            }
            Item {
                id: item_altitude
                height: 20
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 0

                Row {
                    id: row1
                    anchors.verticalCenter: parent.verticalCenter ////
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    spacing: 16

                    Text {
                        text: qsTr("altitude")
                        anchors.verticalCenter: parent.verticalCenter
                        color: Theme.colorSubText
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        id: info_altitude
                        color: Theme.colorText
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
                }
            }
            Item {
                id: item_track
                anchors.rightMargin: 0
                anchors.leftMargin: 56
                anchors.left: parent.left
                anchors.right: parent.right
                height: 20

                Row {
                    id: row
                    anchors.verticalCenter: parent.verticalCenter ////
                    Text {
                        color: Theme.colorSubText
                        text: qsTr("track")
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }

                    Text {
                        id: info_track
                        color: Theme.colorText
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
                    anchors.leftMargin: 0
                    anchors.left: parent.left
                    spacing: 16
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onWheel: {
                if (wheel.angleDelta.y < 0)
                    mapPointGPS.zoomLevel--
                else
                    mapPointGPS.zoomLevel++

                mapPointGPS.center = center
            }
        }

        Row {
            anchors.top: rectangleCoordinates.bottom
            anchors.topMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            spacing: 16

            ItemImageButton {
                id: button_map_dezoom
                width: 40
                height: 40
                background: true

                source: "qrc:/assets/icons_material/baseline-zoom_out-24px.svg"
                onClicked: {
                    mapPointGPS.zoomLevel--
                    mapPointGPS.center = center
                }
            }

            ItemImageButton {
                id: button_map_zoom
                width: 40
                height: 40
                background: true

                source: "qrc:/assets/icons_material/baseline-zoom_in-24px.svg"
                onClicked: {
                    mapPointGPS.zoomLevel++
                    mapPointGPS.center = center
                }
            }
        }
    }
}
