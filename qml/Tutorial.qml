import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import ThemeEngine 1.0

Rectangle {
    width: 480
    height: 720
    anchors.fill: parent

    color: Theme.colorHeader

    property int lastPage: 2
    property string goBackTo: "MediaList"

    function reopen(goBackScreen) {
        tutorialPages.currentIndex = 0
        appContent.state = "Tutorial"
        goBackTo = goBackScreen
    }

    SwipeView {
        id: tutorialPages
        anchors.fill: parent
        anchors.bottomMargin: 56

        currentIndex: 0
        onCurrentIndexChanged: {
            if (currentIndex < 0) currentIndex = 0
            if (currentIndex > lastPage) {
                currentIndex = 0 // reset
                appContent.state = goBackTo
            }
        }

        ////////

        Item {
            id: page1

            Column {
                id: column
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
                ImageSvg {
                    width: tutorialPages.width * 0.5
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                    color: Theme.colorIcon
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
                ImageSvg {
                    width: tutorialPages.width * 0.5
                    height: width
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material/duotone-library_add-24px.svg"
                    color: Theme.colorIcon
                }
                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 32

                    text: qsTr("You can have many files open at the same time.")
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

                    ImageSvg {
                        width: 40
                        height: width
                        source: "qrc:/assets/icons_material/duotone-insert_chart_outlined-24px.svg"
                        color: Theme.colorIcon
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Audio/Video bitrate graphs")
                        color: Theme.colorIcon
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 20
                    }
                }
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    spacing: 16

                    ImageSvg {
                        width: 40
                        height: width
                        source: "qrc:/assets/icons_material_media/outline-speaker-24px.svg"
                        color: Theme.colorIcon
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Audio channels mapping")
                        color: Theme.colorIcon
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 20
                    }
                }
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    spacing: 16

                    ImageSvg {
                        width: 40
                        height: width
                        source: "qrc:/assets/icons_material/duotone-pin_drop-24px.svg"
                        color: Theme.colorIcon
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("GPS location map")
                        color: Theme.colorIcon
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 20
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
        color: Theme.colorHeaderContent
        font.bold: true
        font.pixelSize: 16

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

        text: (tutorialPages.currentIndex === lastPage) ? qsTr("Allright!") : qsTr("Next")
        color: Theme.colorHeaderContent
        font.bold: true
        font.pixelSize: 16

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
