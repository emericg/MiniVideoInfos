import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0

Rectangle {
    width: parent.width
    height: parent.height
    color: Theme.colorBackground

    Column {
        id: rectangleHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        z: 5

        Connections {
            target: applicationWindow
            onScreenStatusbarPaddingChanged: rectangleHeader.updateIOSHeader()
        }
        Connections {
            target: Theme
            onCurrentThemeChanged: rectangleHeader.updateIOSHeader()
        }

        function updateIOSHeader() {
            if (Qt.platform.os === "ios") {
                if (screenStatusbarPadding != 0 && Theme.currentTheme === ThemeEngine.THEME_DARK)
                    rectangleStatusbar.height = screenStatusbarPadding
                else
                    rectangleStatusbar.height = 0
            }
        }

        Rectangle {
            id: rectangleStatusbar
            anchors.left: parent.left
            anchors.right: parent.right
            color: Theme.colorBackground // "red" // to hide scrollview content
            height: screenStatusbarPadding
        }
        Rectangle {
            id: rectangleNotch
            anchors.left: parent.left
            anchors.right: parent.right
            color: Theme.colorBackground // "yellow" // to hide scrollview content
            height: screenNotchPadding
        }
        Rectangle {
            id: rectangleLogo
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            color: Theme.colorBackground
            height: 80

            Image {
                id: imageHeader
                width: 40
                height: 40
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                source: "qrc:/assets/logos/logo.svg"
                sourceSize: Qt.size(width, height)
            }
            Text {
                id: textHeader
                anchors.left: imageHeader.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 2

                text: "MiniVideo Infos"
                color: Theme.colorText
                font.bold: true
                font.pixelSize: 20
            }
        }
    }

    ScrollView {
        id: scrollView
        contentWidth: -1

        anchors.top: rectangleHeader.bottom
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        Column {
            id: row
            anchors.fill: parent

            Rectangle {
                id: rectangleLoad
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left
                color: (appContent.state === "MediaList" && screenMediaList.dialogIsOpen) ? Theme.colorForeground : "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appContent.state = "MediaList"
                        screenMediaList.openDialog()
                        appDrawer.close()
                    }
                }

                ImageSvg {
                    id: buttonLoadImg
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/duotone-library_add-24px.svg"
                    color: Theme.colorText
                }
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Load media")
                    font.pixelSize: 13
                    font.bold: true
                    color: Theme.colorText
                }
            }

            Rectangle {
                id: rectangleHome
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left
                color: (appContent.state === "MediaList" && !screenMediaList.dialogIsOpen) ? Theme.colorForeground : "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appContent.state = "MediaList"
                        screenMediaList.closeDialog()
                        appDrawer.close()
                    }
                }

                ImageSvg {
                    id: buttonMediasImg
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material_medias/outline-insert_photo-24px.svg"
                    color: Theme.colorText
                }
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Medias")
                    font.pixelSize: 13
                    font.bold: true
                    color: Theme.colorText
                }
            }

            Item { // spacer
                height: 8
                anchors.right: parent.right
                anchors.left: parent.left
            }
            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
            }
            Item {
                height: 8
                anchors.right: parent.right
                anchors.left: parent.left
            }
/*
            Rectangle {
                id: rectangleTool1
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left
                color: (appContent.state === "Tool1") ? Theme.colorForeground : "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appContent.state = "Tool1"
                        appDrawer.close()
                    }
                }

                ImageSvg {
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/outline-settings-24px.svg"
                    color: Theme.colorText
                }
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Tool1")
                    font.pixelSize: 13
                    font.bold: true
                    color: Theme.colorText
                }
            }

            Rectangle {
                id: rectangleTool2
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left
                color: (appContent.state === "Tool2") ? Theme.colorForeground : "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appContent.state = "Tool2"
                        appDrawer.close()
                    }
                }

                ImageSvg {
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/outline-settings-24px.svg"
                    color: Theme.colorText
                }
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Tool2")
                    font.pixelSize: 13
                    font.bold: true
                    color: Theme.colorText
                }
            }

            Item { // spacer
                height: 8
                anchors.right: parent.right
                anchors.left: parent.left
            }
            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
            }
            Item {
                height: 8
                anchors.right: parent.right
                anchors.left: parent.left
            }
*/
            Rectangle {
                id: rectangleSettings
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left
                color: (appContent.state === "Settings") ? Theme.colorForeground : "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appContent.state = "Settings"
                        appDrawer.close()
                    }
                }

                ImageSvg {
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/outline-settings-24px.svg"
                    color: Theme.colorText
                }
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Settings")
                    font.pixelSize: 13
                    font.bold: true
                    color: Theme.colorText
                }
            }

            Rectangle {
                id: rectangleAbout
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left
                color: (appContent.state === "About") ? Theme.colorForeground : "transparent"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appContent.state = "About"
                        appDrawer.close()
                    }
                }

                ImageSvg {
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/outline-info-24px.svg"
                    color: Theme.colorText
                }
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("About")
                    font.pixelSize: 13
                    font.bold: true
                    color: Theme.colorText
                }
            }
/*
            Item { // spacer
                height: 8
                anchors.right: parent.right
                anchors.left: parent.left
            }
            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
            }
            Item {
                height: 8
                anchors.right: parent.right
                anchors.left: parent.left
            }

            Item {
                id: rectangleRefresh
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left

                enabled: deviceManager.bluetooth

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (!deviceManager.scanning) {
                            if (deviceManager.refreshing) {
                                deviceManager.refreshDevices_stop()
                            } else {
                                deviceManager.refreshDevices_start()
                            }
                            appDrawer.close()
                        }
                    }
                }

                ImageSvg {
                    id: buttonRefresh
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-autorenew-24px.svg"
                    color: deviceManager.bluetooth ? Theme.colorText : Theme.colorSubText

                    NumberAnimation on rotation {
                        id: refreshAnimation
                        duration: 2000
                        from: 0
                        to: 360
                        loops: Animation.Infinite
                        running: deviceManager.refreshing
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
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Refresh sensors datas")
                    font.pixelSize: 13
                    font.bold: true
                    color: deviceManager.bluetooth ? Theme.colorText : Theme.colorSubText
                }
            }

            Item {
                id: rectangleScan
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left

                enabled: deviceManager.bluetooth

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (!deviceManager.scanning && !deviceManager.refreshing) {
                            deviceManager.scanDevices()
                            appDrawer.close()
                        }
                    }
                }

                ImageSvg {
                    id: buttonRescan
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-search-24px.svg"
                    color: deviceManager.bluetooth ? Theme.colorText : Theme.colorSubText

                    SequentialAnimation on opacity {
                        id: rescanAnimation
                        loops: Animation.Infinite
                        running: deviceManager.scanning
                        onStopped: buttonRescan.opacity = 1;

                        PropertyAnimation { to: 0.33; duration: 750; }
                        PropertyAnimation { to: 1; duration: 750; }
                    }
                }
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Search for new devices")
                    font.pixelSize: 13
                    font.bold: true
                    color: deviceManager.bluetooth ? Theme.colorText : Theme.colorSubText
                }
            }
*/
            Item { // spacer
                height: 8
                anchors.right: parent.right
                anchors.left: parent.left
                visible: (Qt.platform.os !== "android" && Qt.platform.os !== "ios")
            }
            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
                visible: (Qt.platform.os !== "android" && Qt.platform.os !== "ios")
            }
            Item {
                height: 8
                anchors.right: parent.right
                anchors.left: parent.left
                visible: (Qt.platform.os !== "android" && Qt.platform.os !== "ios")
            }

            Item {
                id: rectangleExit
                height: 48
                anchors.right: parent.right
                anchors.left: parent.left
                visible: (Qt.platform.os !== "android" && Qt.platform.os !== "ios")

                MouseArea {
                    anchors.fill: parent
                    onClicked: utils.appExit()
                }

                ImageSvg {
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/duotone-exit_to_app-24px.svg"
                    color: Theme.colorText
                }
                Label {
                    anchors.left: parent.left
                    anchors.leftMargin: screenLeftPadding + 56
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Exit")
                    font.pixelSize: 13
                    font.bold: true
                    color: Theme.colorText
                }
            }
        }
    }
}
