import QtQuick
import QtQuick.Shapes

import ThemeEngine

Item {
    id: speakerWidget
    width: 200
    height: (channelCount > 3) ? 200 : 128
    clip: true

    property int channelCount: 0
    property int channelMap: 0
    property int channelMode: 0

    ////////

    Shape {
        //visible: (channelMode > 0 && channelMode < 64)
        opacity: 0.8

        ShapePath {
            strokeWidth: 2
            strokeColor: Theme.colorSeparator
            fillColor: "transparent"

            strokeStyle: ShapePath.DashLine
            dashPattern: [2, 4]

            startX: 0
            startY: 0
            PathLine { x: speakerWidget.width; y: speakerWidget.width }
        }
        ShapePath {
            strokeWidth: 2
            strokeColor: Theme.colorSeparator
            fillColor: "transparent"

            strokeStyle: ShapePath.DashLine
            dashPattern: [2, 4]

            startX: speakerWidget.width
            startY: 0
            PathLine { x: 0; y: speakerWidget.width }
        }
        ShapePath {
            strokeWidth: 2
            strokeColor: Theme.colorSeparator
            fillColor: "transparent"

            strokeStyle: ShapePath.DashLine
            dashPattern: [2, 4]

            startX: 0
            startY: (speakerWidget.width / 2)
            PathLine { x: speakerWidget.width; y: (speakerWidget.width / 2);}
        }
        ShapePath {
            strokeWidth: 2
            strokeColor: Theme.colorSeparator
            fillColor: "transparent"

            strokeStyle: ShapePath.DashLine
            dashPattern: [2, 4]

            startX: (speakerWidget.width / 2)
            startY: 0
            PathLine { x: (speakerWidget.width / 2); y: speakerWidget.width; }
        }
    }

    ////////

    ARRC { // background
        arcOffset: 0
        arcValue: 360
        arcOpacity: 0.8
        arcColor: Theme.colorComponentBackground
    }

    ARRC { // C // center
        azimut: 0
        size: 10

        visible: (channelCount == 1 || // mono
                  channelCount == 6 || channelCount == 7 || channelCount == 8) // 5.1 // 6.1 // 7.1
    }

    ARRC { // L // left
        azimut: -40
        size: 30

        visible: (channelCount == 2 || channelCount == 3 || // stereo // 2.1
                  channelCount == 6 || channelCount == 7 || channelCount == 8) // 5.1 // 6.1 // 7.1
    }
    ARRC { // R // right
        azimut: 40
        size: 30

        visible: (channelCount == 2 || channelCount == 3 || // stereo // 2.1
                  channelCount == 6 || channelCount == 7 || channelCount == 8) // 5.1 // 6.1 // 7.1
    }

    ARRC { // Lc // left center
        azimut: -22
        size: 10
        arcColor: Theme.colorPrimary
        visible: false
    }
    ARRC { // Rc // right center
        azimut: 22
        size: 10
        arcColor: Theme.colorPrimary
        visible: false
    }

    ARRC { // Lw // left front wide
        azimut: -60
        size: 10
        arcColor: Theme.colorPrimary
        visible: false
    }
    ARRC { // Rw // right front wide
        azimut: 60
        size: 10
        arcColor: Theme.colorPrimary
        visible: false
    }
    ARRC { // Lss // left side surround
        azimut: -90
        size: 10
        arcColor: Theme.colorPrimary

        visible: (channelCount == 6 || channelCount == 7 || channelCount == 8) // 5.1 // 6.1 // 7.1
    }
    ARRC { // Rss // right side surround
        azimut: 90
        size: 10
        arcColor: Theme.colorPrimary

        visible: (channelCount == 6 || channelCount == 7 || channelCount == 8) // 5.1 // 6.1 // 7.1
    }
    ARRC { // Ls // left surround
        azimut: -110
        size: 20
        visible: false
    }
    ARRC { // Rs // right surround
        azimut: 110
        size: 20
        visible: false
    }
    ARRC { // Lb // left rear surround
        azimut: -135
        size: 20
        arcColor: Theme.colorPrimary

        visible: (channelCount == 8) // 7.1
    }
    ARRC { // Rb // right rear surround
        azimut: 135
        size: 20
        arcColor: Theme.colorPrimary

        visible: (channelCount == 8) // 7.1
    }

    ARRC { // cb // center back
        azimut: 180
        size: 10
        arcColor: Theme.colorPrimary

        visible: (channelCount == 7) // 6.1
    }

    ////////

    Rectangle { // LFE
        x: 0 // speakerWidget.width * 0.25
        y: 0 // speakerWidget.width * 0.166
        width: speakerWidget.width*0.111
        height: width*0.85
        color: Theme.colorGrey

        visible: (channelCount == 3 || // 2.1
                  channelCount == 6 || channelCount == 7 || channelCount == 8) // 5.1 // 6.1 // 7.1
    }
    Rectangle { // LFE(2)
        x: parent.width - width // speakerWidget.width * 0.75 - width
        y: 0 // speakerWidget.width * 0.166
        width: speakerWidget.width*0.111
        height: width*0.85
        color: Theme.colorGrey

        visible: false
    }

    ////////

    component ARRC: Item {
        id: control
        width: parent.width
        height: width

        property int azimut: 0
        property int size: 10

        property real arcWidth: 14
        property real arcOpacity: 1
        property color arcColor: Theme.colorSecondary

        // private
        property real arcOffset: control.azimut - control.size/2
        property real arcValue: control.size
        property real arcBegin: 0
        property real arcEnd: 360

        Canvas {
            id: canvas
            anchors.fill: parent

            onPaint: {
                var x = (width / 2)
                var y = (width / 2)
                var start_value = Math.PI * ((control.arcBegin + control.arcOffset + -90) / 180)
                var end_value = Math.PI * ((control.arcValue + control.arcOffset + -90) / 180)

                var ctx = getContext("2d")
                ctx.reset()
                ctx.lineCap = "butt"

                ctx.beginPath()
                ctx.globalAlpha = control.arcOpacity
                ctx.arc(x, y, (width / 2) - (control.arcWidth / 2), start_value, end_value, false)
                ctx.lineWidth = control.arcWidth
                ctx.strokeStyle = control.arcColor
                ctx.stroke()
            }
        }
    }

    ////////
}
