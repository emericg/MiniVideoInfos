import QtQuick
import QtQuick.Controls.impl
import QtQuick.Templates as T

import ComponentLibrary

T.ComboBox {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding)

    leftPadding: 16
    rightPadding: 16

    font.pixelSize: Theme.componentFontSize

    ////////////////

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: Theme.componentHeight

        radius: Theme.componentRadius
        opacity: control.enabled ? 1 : 0.66
        color: control.down ? Theme.colorComponentDown : Theme.colorComponent
        border.width: 2
        border.color: Theme.colorComponentBorder
    }

    ////////////////

    contentItem: Text {
        IconSvg {
            width: 24
            height: 24
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.colorIcon
            source: {
                if (mediaManager.mediaAvailable) {
                    if (mediaManager.mediaList[currentIndex].fileType == 1)
                        return "qrc:/IconLibrary/material-symbols/media/album.svg"
                    if (mediaManager.mediaList[currentIndex].fileType == 2)
                        return "qrc:/IconLibrary/material-symbols/media/movie.svg"
                    if (mediaManager.mediaList[currentIndex].fileType == 3)
                        return "qrc:/IconLibrary/material-symbols/media/panorama.svg"
                }
                return "qrc:/IconLibrary/material-symbols/media/movie.svg"
            }
        }
        leftPadding: 24 + control.leftPadding

        text: control.displayText
        textFormat: Text.PlainText

        font: control.font
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter

        opacity: control.enabled ? 1 : 0.66
        color: Theme.colorComponentContent
    }

    ////////////////

    indicator: Canvas {
        x: control.width - width - control.rightPadding
        y: control.topPadding + ((control.availableHeight - height) / 2)
        width: 12
        height: 8
        opacity: control.enabled ? 1 : 0.66
        rotation: control.popup.visible ? 180 : 0

        Connections {
            target: Theme
            function onCurrentThemeChanged() { indicator.requestPaint() }
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.moveTo(0, 0)
            ctx.lineTo(width, 0)
            ctx.lineTo(width / 2, height)
            ctx.closePath()
            ctx.fillStyle = Theme.colorIcon
            ctx.fill()
        }
    }

    ////////////////

    delegate: T.ItemDelegate {
        width: control.width - 2
        height: control.height
        highlighted: (control.highlightedIndex === index)

        background: Rectangle {
            implicitWidth: 200
            implicitHeight: Theme.componentHeight

            radius: Theme.componentRadius
            color: highlighted ? "#F6F6F6" : "white"
        }

        contentItem: Text {
            IconSvg {
                x: control.leftPadding
                anchors.verticalCenter: parent.verticalCenter
                width: 24
                height: 24

                color: Theme.colorIcon
                source: {
                    if (modelData.fileType == 1)
                        return "qrc:/IconLibrary/material-symbols/media/album.svg"
                    if (modelData.fileType == 3)
                        return "qrc:/IconLibrary/material-symbols/media/panorama.svg"
                    return "qrc:/IconLibrary/material-symbols/media/movie.svg"
                }
            }

            leftPadding: control.leftPadding + 24 + 8
            rightPadding: control.rightPadding
            text: modelData.fullpath
            color: highlighted ? "black" : Theme.colorSubText
            font.pixelSize: Theme.componentFontSize
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
    }

    ////////////////

    popup: T.Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: (contentItem.implicitHeight) ? contentItem.implicitHeight + 2 : 0
        padding: 1

        contentItem: ListView {
            implicitHeight: contentHeight
            clip: true
            currentIndex: control.highlightedIndex
            model: control.popup.visible ? control.delegateModel : null
        }

        background: Rectangle {
            radius: Theme.componentRadius
            color: "white"
            border.color: Theme.colorComponentBorder
            border.width: control.visualFocus ? 0 : 1
        }
    }

    ////////////////
}
