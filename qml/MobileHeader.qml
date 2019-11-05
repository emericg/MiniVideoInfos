import QtQuick 2.9

import ThemeEngine 1.0

Rectangle {
    width: parent.width
    height: screenStatusbarPadding + screenNotchPadding + headerHeight
    color: Theme.colorHeader
    z: 10

    property int headerHeight: 52

    property string title: "MiniVideo Infos"
    property string leftMenuMode: "drawer" // drawer / back / close

    signal leftMenuClicked()
    signal rightMenuClicked()
    signal deviceRefreshButtonClicked()

    onLeftMenuModeChanged: {
        if (leftMenuMode === "drawer")
            leftMenuImg.source = "qrc:/assets/icons_material/baseline-menu-24px.svg"
        else if (leftMenuMode === "close")
            leftMenuImg.source = "qrc:/assets/icons_material/baseline-close-24px.svg"
        else // back
            leftMenuImg.source = "qrc:/assets/icons_material/baseline-arrow_back-24px.svg"
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: screenStatusbarPadding + screenNotchPadding

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 64
            anchors.verticalCenter: parent.verticalCenter

            text: title
            color: Theme.colorHeaderContent
            font.bold: false
            font.pixelSize: Theme.fontSizeHeader
            font.capitalization: Font.Capitalize
        }

        MouseArea {
            id: leftArea
            width: headerHeight
            height: headerHeight
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            onClicked: leftMenuClicked()

            ImageSvg {
                id: leftMenuImg
                width: headerHeight/2
                height: headerHeight/2
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/icons_material/baseline-menu-24px.svg"
                color: Theme.colorHeaderContent
            }
        }

        Row {
            id: menu
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 8

            spacing: 0
            visible: true

            ////////////
/*
            MouseArea {
                id: refreshButton
                width: headerHeight
                height: headerHeight

                visible: (deviceManager.bluetooth && ((appContent.state === "DeviceSensor") || (appContent.state === "DeviceThermo")))
                onClicked: deviceRefreshButtonClicked()

                ImageSvg {
                    id: refreshButtonImg
                    width: headerHeight/2
                    height: headerHeight/2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-refresh-24px.svg"
                    color: Theme.colorHeaderContent

                    NumberAnimation on rotation {
                        id: refreshAnimation
                        duration: 2000
                        from: 0
                        to: 360
                        loops: Animation.Infinite
                        running: currentDevice.updating
                        onStopped: refreshAnimationStop.start()
                    }
                    NumberAnimation on rotation {
                        id: refreshAnimationStop
                        duration: 1000;
                        to: 360;
                        easing.type: Easing.Linear
                        running: false
                    }
                }
            }
*/
            MouseArea {
                id: rightMenu
                width: headerHeight
                height: headerHeight

                visible: false
                onClicked: rightMenuClicked()

                ImageSvg {
                    id: rightMenuImg
                    width: headerHeight/2
                    height: headerHeight/2
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-more_vert-24px.svg"
                    color: Theme.colorHeaderContent
                }
            }
        }
    }
}
