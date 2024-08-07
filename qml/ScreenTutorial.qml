import QtQuick
import QtQuick.Controls

import ThemeEngine

Rectangle {
    anchors.fill: parent

    color: Theme.colorHeader

    property string entryPoint: "ScreenMediaList"

    ////////////////////////////////////////////////////////////////////////////

    function loadScreen() {
        entryPoint = "ScreenMediaList"
        appContent.state = "ScreenTutorial"
    }

    function loadScreenFrom(screenname) {
        entryPoint = screenname
        appContent.state = "ScreenTutorial"
    }

    ////////////////////////////////////////////////////////////////////////////

    Loader {
        id: tutorialLoader
        anchors.fill: parent

        active: (appContent.state === "ScreenTutorial")

        asynchronous: true
        sourceComponent: Item {
            id: itemTutorial

            function reset() {
                tutorialPages.disableAnimation()
                tutorialPages.currentIndex = 0
                tutorialPages.enableAnimation()
            }

            ////////////////

            SwipeView {
                id: tutorialPages
                anchors.fill: parent
                anchors.leftMargin: screenPaddingLeft
                anchors.rightMargin: screenPaddingRight
                anchors.bottomMargin: 56

                property int margins: isPhone ? 24 : 40

                currentIndex: 0
                onCurrentIndexChanged: {
                    if (currentIndex < 0) currentIndex = 0
                    if (currentIndex > count-1) {
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
                            anchors.rightMargin: tutorialPages.margins
                            anchors.left: parent.left
                            anchors.leftMargin: tutorialPages.margins

                            text: qsTr("<b>MiniVideo Infos</b> extract a maximum of information and metadata from <b>multimedia files</b>.")
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            font.pixelSize: Theme.fontSizeContentBig
                            color: Theme.colorIcon
                            horizontalAlignment: Text.AlignHCenter
                        }
                        IconSvg {
                            width: tutorialPages.width * (tutorialPages.height > tutorialPages.width ? 0.8 : 0.4)
                            height: width*0.666
                            anchors.horizontalCenter: parent.horizontalCenter

                            source: "qrc:/assets/icons/fontawesome/photo-video-duotone.svg"
                            fillMode: Image.PreserveAspectFit
                            color: Theme.colorIcon
                            smooth: true
                        }
                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: tutorialPages.margins
                            anchors.left: parent.left
                            anchors.leftMargin: tutorialPages.margins

                            text: qsTr("It works with <b>pictures</b> (with EXIF), <b>audio</b> (with various tags) and <b>video</b> files!")
                            color: Theme.colorIcon
                            font.pixelSize: Theme.fontSizeContentBig
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        }
                    }
                }

                ////////

                Item {
                    id: page2

                    Column {
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 32

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: tutorialPages.margins
                            anchors.left: parent.left
                            anchors.leftMargin: tutorialPages.margins

                            text: qsTr("To use <b>MiniVideo Infos</b>, open file directly from the application or use the \"open with\" feature of your device!")
                            color: Theme.colorIcon
                            font.pixelSize: Theme.fontSizeContentBig
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignHCenter
                        }
                        IconSvg {
                            width: tutorialPages.width * (tutorialPages.height > tutorialPages.width ? 0.8 : 0.4)
                            height: width*0.666
                            anchors.horizontalCenter: parent.horizontalCenter

                            source: "qrc:/assets/icons/material-icons/duotone/library_add.svg"
                            color: Theme.colorIcon
                            smooth: true
                        }
                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: tutorialPages.margins
                            anchors.left: parent.left
                            anchors.leftMargin: tutorialPages.margins

                            text: qsTr("You can have many files open at the same time.")
                            textFormat: Text.StyledText
                            font.pixelSize: Theme.fontSizeContentBig
                            color: Theme.colorIcon
                            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }

                ////////

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
                            font.pixelSize: Theme.fontSizeContentBig
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons/material-symbols/media/4k.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Codec parameters")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: Theme.fontSizeContentBig
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons/material-icons/duotone/aspect_ratio.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Image geometry")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: Theme.fontSizeContentBig
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons/material-icons/duotone/insert_chart.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Audio/Video bitrate graphs")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: Theme.fontSizeContentBig
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons/material-symbols/media/speaker.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Audio channels mapping")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: Theme.fontSizeContentBig
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons/material-symbols/media/audio_file.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("Audio tags")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: Theme.fontSizeContentBig
                            }
                        }
                        Row {
                            anchors.left: parent.left
                            anchors.leftMargin: 40
                            spacing: 16

                            IconSvg {
                                width: 32
                                height: width
                                source: "qrc:/assets/icons/material-icons/duotone/pin_drop.svg"
                                color: Theme.colorIcon
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: qsTr("GPS location map")
                                textFormat: Text.PlainText
                                color: Theme.colorIcon
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: Theme.fontSizeContentBig
                            }
                        }
                    }
                }

                ////////
            }

            ////////////////

            Text {
                id: pagePrevious
                anchors.left: parent.left
                anchors.leftMargin: tutorialPages.margins
                anchors.verticalCenter: pageIndicator.verticalCenter

                visible: (tutorialPages.currentIndex !== 0)

                text: qsTr("Previous")
                textFormat: Text.PlainText
                color: Theme.colorHeaderContent
                font.bold: true
                font.pixelSize: Theme.fontSizeContent

                opacity: 0.8
                Behavior on opacity { OpacityAnimator { duration: 133 } }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.opacity = 1
                    onExited: parent.opacity = 0.8
                    onCanceled: parent.opacity = 0.8
                    onClicked: tutorialPages.currentIndex--
                }
            }

            PageIndicatorThemed {
                id: pageIndicator
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: tutorialPages.margins/2

                count: tutorialPages.count
                currentIndex: tutorialPages.currentIndex
            }

            Text {
                id: pageNext
                anchors.right: parent.right
                anchors.rightMargin: tutorialPages.margins
                anchors.verticalCenter: pageIndicator.verticalCenter

                text: (tutorialPages.currentIndex === tutorialPages.count-1) ? qsTr("Start") : qsTr("Next")
                textFormat: Text.PlainText
                color: Theme.colorHeaderContent
                font.bold: true
                font.pixelSize: Theme.fontSizeContent

                opacity: 0.8
                Behavior on opacity { OpacityAnimator { duration: 133 } }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.opacity = 1
                    onExited: parent.opacity = 0.8
                    onCanceled: parent.opacity = 0.8
                    onClicked: tutorialPages.currentIndex++
                }
            }

            ////////////////
        }
    }
}
