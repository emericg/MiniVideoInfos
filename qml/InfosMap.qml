import QtQuick
import QtQuick.Controls

import QtLocation
import QtPositioning
import Qt.labs.animation

import ThemeEngine
import "qrc:/utils/UtilsString.js" as UtilsString

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
            mapScale.computeScale()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Map {
        id: map
        anchors.fill: parent

        ////////////////

        property real zoomLevel_minimum: 14
        property real zoomLevel_maximum: 18

        property real tiltLevel_minimum: 0
        property real tiltLevel_maximum: 66

        property real fovLevel_minimum: 20
        property real fovLevel_maximum: 120

        property bool moove: false

        tilt: 0
        fieldOfView: 0
        zoomLevel: 9
        center: QtPositioning.coordinate(45.5, 6)

        ////////////////

        plugin: Plugin {
            preferred: ["maplibre", "osm"]

            PluginParameter { name: "maplibre.map.styles"; value: "https://tiles.versatiles.org/styles/colorful.json" }

            PluginParameter { name: "osm.mapping.highdpi_tiles"; value: "true" }
            //PluginParameter { name: "osm.mapping.custom.host"; value: "https://mappingcustomhost.org"; }
        }
        copyrightsVisible: false

        ////////////////

        function zoomIn() {
            if (map.zoomLevel < Math.round(map.maximumZoomLevel)) {
                map.zoomLevel = Math.round(map.zoomLevel + 1)
                if (!map.moove) map.center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)
                mapScale.computeScale()
            }
        }

        function zoomOut() {
            if (map.zoomLevel > Math.round(map.minimumZoomLevel)) {
                map.zoomLevel = Math.round(map.zoomLevel - 1)
                if (!map.moove) map.center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)
                mapScale.computeScale()
            }
        }

        Timer {
            id: reactivateSwipe
            interval: 333
            running: false
            repeat: false
            onTriggered: {
                mediaPages.interactive = true
            }
        }

        BoundaryRule on zoomLevel {
            id: br
            minimum: map.zoomLevel_minimum
            maximum: map.zoomLevel_maximum
        }

        Item {
            id: controlsArea
            anchors.fill: parent
            anchors.bottomMargin: 0

            property int controlSize: isPhone ? 44 : 48

            DragHandler {
                id: dragHandler
                target: null

                enabled: map.moove && !pinchHandler.active

                onActiveChanged: {
                    console.log("dragHandler.onActiveChanged")
                    if (active) {
                        mediaPages.interactive = false
                    } else {
                        reactivateSwipe.start()
                    }
                }
                onTranslationChanged: (delta) => {
                    //console.log("pan map: " + delta)

                    if (!pinchHandler.active) {
                        map.pan(-delta.x, -delta.y)
                    }
                }
            }
            PinchHandler {
                id: pinchHandler
                target: null

                onActiveChanged: {
                    console.log("pinchHandler.onActiveChanged")
                    if (active) {
                        mediaPages.interactive = false
                    } else {
                        reactivateSwipe.start()
                    }
                }
                onScaleChanged: (delta) => {
                    //console.log("zoom map: " + delta)

                    map.zoomLevel += Math.log2(delta)
                    mapScale.computeScale()
                }
                onRotationChanged: (delta) => {
                    map.bearing -= delta
                    //map.alignCoordinateToPoint(map.startCentroid, centroid.position)
                }
                //grabPermissions: PointerHandler.TakeOverForbidden
            }
        }
        WheelHandler {
            rotationScale: 1/120
            property: "zoomLevel"

            // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432
            acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                             ? PointerDevice.Mouse | PointerDevice.TouchPad
                             : PointerDevice.Mouse

            onWheel: (event) => {
                //console.log("rotation", event.angleDelta.y,
                //            "scaled", rotation, "@", point.position,
                //            "=>", parent.rotation)

                //map.zoomLevel += Math.log2(event.angleDelta.y) // TODO
                if (!map.moove) map.center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)
                mapScale.computeScale()
            }
        }

        ////////////////

        MapMarker {
            id: mapMarker
            visible: false

            source: "qrc:/assets/gfx/maps/gps_marker.svg"
            source_bearing:  "qrc:/assets/gfx/maps/gps_marker_bearing.svg"
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

            MapButton { // Moove
                width: controlsArea.controlSize
                height: controlsArea.controlSize

                source: "qrc:/assets/icons/material-symbols/open_with.svg"
                iconColor: map.moove ? Theme.colorHeaderContent : Theme.colorText

                onClicked: {
                    map.moove = !map.moove
                    mediaPages.interactive = !map.moove // disable swiping through tabs
                }
            }

            MapButton { // GPS
                width: controlsArea.controlSize
                height: controlsArea.controlSize

                visible: (opacity > 0)
                opacity: (map.center !== QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)) ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }

                source: "qrc:/assets/icons/material-symbols/location/my_location-fill.svg"

                onClicked: map.center = QtPositioning.coordinate(mediaItem.latitude, mediaItem.longitude)
            }
        }

        Column { // top-right
            anchors.top: parent.top
            anchors.topMargin: 16
            anchors.right: parent.right
            anchors.rightMargin: 16
            spacing: 16

            MapButtonCompass { // compass
                width: controlsArea.controlSize
                height: controlsArea.controlSize

                source_top: "qrc:/assets/gfx/maps/compass_top.svg"
                source_bottom: "qrc:/assets/gfx/maps/compass_bottom.svg"

                onClicked: map.bearing = 0
                sourceRotation: -map.bearing
            }

            MapButtonZoom { // zoom buttons
                width: controlsArea.controlSize
                height: controlsArea.controlSize*2

                zoomLevel: map.zoomLevel
                zoomLevel_minimum: map.zoomLevel_minimum
                zoomLevel_maximum: map.zoomLevel_maximum

                onMapZoomIn: map.zoomIn()
                onMapZoomOut: map.zoomOut()
            }
        }

        ////////////////

        Column { // bottom-left
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16 + mobileMenu.height
            spacing: 16

            MapScale {
                id: mapScale
                map: map
            }

            MapFrameArea {
                id: rectangleCoordinates

                width: Math.max(item_lat.width, item_long.width, row_altspd.width, item_track.width) + 80
                height: columnCoordinates.height + 12
                visible: false

                IconSvg {
                    width: 32
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorPrimary
                    source: "qrc:/assets/icons/material-icons/duotone/pin_drop.svg"
                }

                Column {
                    id: columnCoordinates
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.right: parent.right

                    Row { ////
                        id: item_lat

                        height: 20
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
                    Row { ////
                        id: item_long
                        height: 20
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
                    Row { ////
                        id: row_altspd
                        height: 20
                        spacing: 20

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
                    Row { ////
                        id: item_track
                        height: 20
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

        ////////////////
    }

    ////////////////////////////////////////////////////////////////////////////
}
