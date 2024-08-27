import QtQuick

import ThemeEngine

Row {
    id: chromaWidget

    anchors.left: parent.left
    anchors.leftMargin: 56

    width: ((pixelSize*4 + 1*3) + spacing) * 2
    height: (pixelSize*2 + 1*1)

    visible: chromaSubsampling_str.length

    spacing: 8

    property int pixelSize: 16

    ////////

    property string chromaSubsampling_str
    property string chromaLocation_str

    // luma

    property var luma: [1.0, 0.8, 1.0, 0.8,
                        0.8, 1.0, 0.8, 1.0]

    Rectangle {
        width: pixelSize*4 + 1*3
        height: pixelSize*2 + 1

        color: Theme.colorComponentBackground
        opacity: 0.8

        Grid {
            rows: 2
            columns: 4
            spacing: 1

            Repeater {
                model: 8

                Rectangle {
                    width: pixelSize
                    height: pixelSize
                    color: Theme.colorGrey
                    opacity: chromaWidget.luma[index]
                }
            }
        }
    }

    // chroma

    property string trtr: "transparent"
    property string clr1: Theme.colorBlue
    property string clr2: Theme.colorGreen
    property string clr3: Theme.colorRed
    property string clr4: Theme.colorOrange

    property var colors_420: [clr1, clr1, clr2, clr2,
                              clr1, clr1, clr2, clr2]

    property var colors_411: [clr1, clr1, clr1, clr1,
                              clr2, clr2, clr2, clr2]

    property var colors_422: [clr1, clr1, clr2, clr2,
                              clr3, clr3, clr4, clr4]

    property var colors_440: [clr1, clr2, clr3, clr4,
                              clr1, clr2, clr3, clr4]

    property var colors_444: [clr1, clr2, clr3, clr4,
                              "purple", "pink", "yellow", "teal"]

    property var chroma: {
        if (chromaSubsampling_str === "4:4:4") return colors_444
        if (chromaSubsampling_str === "4:2:2") return colors_422
        if (chromaSubsampling_str === "4:2:0") return colors_420
        if (chromaSubsampling_str === "4:1:1") return colors_411
        return colors_420
    }

    Rectangle {
        width: 16*4 + 1*3
        height: 16*2 + 1

        visible: chromaSubsampling_str !== "4:0:0"
        color: Theme.colorComponentBackground
        opacity: 0.8

        Grid {
            rows: 2
            columns: 4
            spacing: 1

            Repeater {
                model: (chromaSubsampling_str.length) ? 8 : 0

                Rectangle {
                    width: 16
                    height: 16
                    color: chromaWidget.chroma[index]
                    opacity: chromaWidget.luma[index]
                }
            }
        }
    }

    ////////

    property var ccolors_420: [clr1, trtr, clr2, trtr,
                              trtr, trtr, trtr, trtr]

    property var ccolors_411: [clr1, clr1, clr1, clr1,
                              clr2, clr2, clr2, clr2]

    property var ccolors_422: [clr1, trtr, clr2, trtr,
                              clr3, trtr, clr4, trtr]

    property var ccolors_440: [clr1, clr2, clr3, clr4,
                              trtr, trtr, trtr, trtr]

    property var ccolors_444: [clr1, clr2, clr3, clr4,
                              "purple", "pink", "yellow", "teal"]

    property var cchroma: {
        if (chromaSubsampling_str === "4:4:4") return ccolors_444
        if (chromaSubsampling_str === "4:2:2") return ccolors_422
        if (chromaSubsampling_str === "4:2:0") return ccolors_420
        if (chromaSubsampling_str === "4:1:1") return ccolors_411
        return ccolors_420
    }

    Item { // v2
        width: pixelSize*4 + 1*3
        height: pixelSize*2 + 1

        Rectangle {
            anchors.fill: parent
            color: Theme.colorComponentBackground
            opacity: 0.5

            Grid {
                rows: 2
                columns: 4
                spacing: 1

                Repeater {
                    model: 8

                    Rectangle {
                        width: pixelSize
                        height: pixelSize
                        color: Theme.colorGrey
                        opacity: chromaWidget.luma[index]
                    }
                }
            }
        }
        Grid {
            visible: chromaSubsampling_str !== "4:0:0"

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: {
                if (chromaSubsampling_str === "4:2:0") {
                    if (chromaLocation_str === "Left") return 0
                    if (chromaLocation_str === "Center") return (pixelSize/2)
                    if (chromaLocation_str === "Top left") return 0
                    if (chromaLocation_str === "Top") return (pixelSize/2)
                    if (chromaLocation_str === "Bottom left") return 0
                    if (chromaLocation_str === "Bottom") return (pixelSize/2)
                }
                return 0
            }
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: {
                if (chromaSubsampling_str === "4:2:0") {
                    if (chromaLocation_str === "Left") return (pixelSize/2)
                    if (chromaLocation_str === "Center") return (pixelSize/2)
                    if (chromaLocation_str === "Top left") return 0
                    if (chromaLocation_str === "Top") return 0
                    if (chromaLocation_str === "Bottom left") return (pixelSize)
                    if (chromaLocation_str === "Bottom") return (pixelSize)
                }
                return 0
            }

            rows: 2
            columns: 4
            spacing: 1

            Repeater {
                model: 8

                Item {
                    width: pixelSize
                    height: pixelSize

                    Rectangle {
                        anchors.centerIn: parent
                        width: (pixelSize*0.64)
                        height: width
                        radius: width
                        color: chromaWidget.cchroma[index]
                    }
                }
            }
        }
    }

    ////////
}
