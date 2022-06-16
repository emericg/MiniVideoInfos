import QtQuick 2.15
import QtQuick.Controls 2.15

import ThemeEngine 1.0

Rectangle {
    width: 480
    height: 720
    anchors.fill: parent

    color: Theme.colorHeader

    property string entryPoint: "MediaList"

    ////////////////////////////////////////////////////////////////////////////

    function loadScreen() {
        entryPoint = "MediaList"
        appContent.state = "Tutorial"
    }

    function loadScreenFrom(screenname) {
        entryPoint = screenname
        appContent.state = "Tutorial"
    }

    ////////////////////////////////////////////////////////////////////////////

    Loader {
        id: tutorialLoader
        anchors.fill: parent

        active: (appContent.state === "Tutorial")

        asynchronous: true
        sourceComponent: Item {
            id: itemTutorial

            function reset() {
                tutorialPages.disableAnimation()
                tutorialPages.currentIndex = 0
                tutorialPages.enableAnimation()
            }

            SwipeView {
                id: tutorialPages
                anchors.fill: parent
                anchors.leftMargin: screenPaddingLeft
                anchors.rightMargin: screenPaddingRight
                anchors.bottomMargin: 56

                currentIndex: 0
                onCurrentIndexChanged: {
                    if (currentIndex < 0) currentIndex = 0
                    if (currentIndex > count) {
                        currentIndex = 0 // reset
                        appContent.state = entryPoint
                    }
                }

                function enableAnimation() {
                    contentItem.highlightMoveDuration = 333
                }
                function disableAnimation() {
                    contentItem.highlightMoveDuration = 0
                }

                ////////

                Item {
                    id: page1

                    Column {
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 32

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 32
                            anchors.left: parent.left
                            anchors.leftMargin: 32

                            text: qsTr("<b>MiniVideo Infos</b> extract a maximum of informations and metadata from <b>multimedia files</b>.")
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            font.pixelSize: 18
                            color: Theme.colorIcon
                            horizontalAlignment: Text.AlignHCenter
                        }
                        IconSvg {
                            width: tutorialPages.width * (tutorialPages.height > tutorialPages.width ? 0.8 : 0.4)
                            height: width
                            anchors.horizontalCenter: parent.horizontalCenter

                            source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                            fillMode: Image.PreserveAspectFit
                            color: Theme.colorIcon
                            smooth: true
                        }
                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 32
                            anchors.left: parent.left
                            anchors.leftMargin: 32

                            text: qsTr("It works with <b>pictures</b> (with EXIF), <b>audio</b> (with various tags) and <b>video</b> files!")
                            color: Theme.colorIcon
                            font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        }
                    }
                }

                Item {
                    id: page2

                    Column {
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 32

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 32
                            anchors.left: parent.left
                            anchors.leftMargin: 32

                            text: qsTr("To use <b>MiniVideo Infos</b>, open file directly from the application or use the \"open with\" feature of your device!")
                            color: Theme.colorIcon
                            font.pixelSize: 18
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignHCenter
                        }
                        IconSvg {
                            width: tutorialPages.width * (tutorialPages.height > tutorialPages.width ? 0.8 : 0.4)
                            height: width
                            anchors.horizontalCenter: parent.horizontalCenter

                            source: "qrc:/assets/icons_material/duotone-library_add-24px.svg"
                            color: Theme.colorIcon
                            smooth: true
                        }
                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 32
                            anchors.left: parent.left
                            anchors.leftMargin: 32

                            text: qsTr("You can have many files open at the same time.")
                            textFormat: Text.PlainText
                            font.pixelSize: 18
                            color: Theme.colorIcon
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }

                Item {
                    id: page3

                    Column {
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 24

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 32
                            anchors.left: parent.left
                            anchors.leftMargin: 32

                            text: qsTr("MiniVideo Infos sports a couple of <b>cool features</b> for media analysis:")
                            color: Theme.colorIcon
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: 18
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons_material/baseline-4k-24px.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Codec parameters")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 18
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons_material/duotone-aspect_ratio-24px.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Image geometry")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 18
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons_material/duotone-insert_chart-24px.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Audio/Video bitrate graphs")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 18
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons_material/outline-speaker-24px.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Audio channels mapping")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 18
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons_material/outline-insert_music-24px.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Audio tags")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 18
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons_material/duotone-pin_drop-24px.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("GPS location map")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 18
                            }
                        }
                    }
                }
            }

            ////////

            Text {
                id: pagePrevious
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.verticalCenter: pageIndicator.verticalCenter

                visible: (tutorialPages.currentIndex != 0)

                text: qsTr("Previous")
                textFormat: Text.PlainText
                color: Theme.colorHeaderContent
                font.bold: true
                font.pixelSize: Theme.fontSizeContent

                Behavior on opacity { OpacityAnimator { duration: 100 } }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.opacity = 0.8
                    onExited: parent.opacity = 1
                    onClicked: tutorialPages.currentIndex--
                }
            }

            Text {
                id: pageNext
                anchors.right: parent.right
                anchors.rightMargin: 32
                anchors.verticalCenter: pageIndicator.verticalCenter

                text: (tutorialPages.currentIndex === tutorialPages.count-1) ? qsTr("All right!") : qsTr("Next")
                textFormat: Text.PlainText
                color: Theme.colorHeaderContent
                font.bold: true
                font.pixelSize: Theme.fontSizeContent

                Behavior on opacity { OpacityAnimator { duration: 100 } }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.opacity = 0.8
                    onExited: parent.opacity = 1
                    onClicked: tutorialPages.currentIndex++
                }
            }

            PageIndicatorThemed {
                id: pageIndicator
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16

                count: tutorialPages.count
                currentIndex: tutorialPages.currentIndex
            }
        }
    }
}
