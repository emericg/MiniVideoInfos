import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import ThemeEngine

Loader {
    id: screenSettings
    anchors.fill: parent

    ////////////////

    function loadScreen() {
        screenSettings.active = true
        appContent.state = "ScreenSettings"
    }

    function backAction() {
        if (screenSettings.status === Loader.Ready)
            screenSettings.item.backAction()
    }

    ////////////////

    active: false
    asynchronous: true

    sourceComponent: Item {
        anchors.fill: parent

        function backAction() {
            if (exportDirectory.focus) {
                exportDirectory.focus = false
                return
            }
            if (ubertoothPath.focus) {
                ubertoothPath.focus = false
                return
            }

            screenScanner.loadScreen()
        }

        ////////////////////////////////////////////////////////////////////////

        Flickable {
            anchors.fill: parent

            contentWidth: -1
            contentHeight: settingsColumn.height

            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

            Column {
                id: settingsColumn
                anchors.left: parent.left
                anchors.right: parent.right

                topPadding: 0
                bottomPadding: Theme.componentMarginL
                spacing: Theme.componentMarginL

                property int flowElementWidth: (width >= 1080) ? (width / 3) - (spacing*1) - (spacing / 3)
                                                               : (width / 2) - (spacing*1) - (spacing / 2)

                ////////////////////////

                Rectangle {
                    id: settingsHeader
                    anchors.left: parent.left
                    anchors.right: parent.right

                    z: 5
                    clip: true
                    height: isHdpi ? 180 : 200
                    color: Theme.colorForeground

                    //Image { // background pattern
                    //    anchors.fill: parent
                    //    source: ""
                    //    fillMode: Image.Tile
                    //    opacity: 0.20
                    //}

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 56
                        spacing: 56

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 150
                            height: 150
                            source: "qrc:/assets/gfx/logos/logo.svg"
                            sourceSize: Qt.size(parent.width*2, parent.width*2)
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Row {
                                spacing: 32

                                Text {
                                    id: title
                                    anchors.bottom: parent.bottom

                                    text: "MiniVideo Infos"
                                    textFormat: Text.PlainText
                                    font.pixelSize: 32
                                    color: Theme.colorText
                                }

                                Text {
                                    anchors.baseline: title.baseline

                                    text: qsTr("version %1 %2").arg(utilsApp.appVersion()).arg(utilsApp.appBuildMode())
                                    textFormat: Text.PlainText
                                    font.pixelSize: Theme.fontSizeContentBig
                                    color: Theme.colorSubText
                                }

                                Text {
                                    anchors.baseline: title.baseline

                                    visible: utilsApp.isDebugBuild()
                                    text: qsTr("built on %1").arg(utilsApp.appBuildDateTime())
                                    textFormat: Text.PlainText
                                    font.pixelSize: Theme.fontSizeContentBig
                                    color: Theme.colorSubText
                                }
                            }

                            Text {
                                text: qsTr(" Get detailed informations about your audio, video and picture files! ")
                                font.pixelSize: Theme.fontSizeContentVeryVeryBig
                                color: Theme.colorSubText
                            }

                            Item { width: 8; height: 8; }

                            Row {
                                spacing: Theme.componentMarginL

                                ButtonSolid {
                                    width: 160
                                    height: 40
                                    color: "#5483EF"
                                    font.bold: true

                                    text: qsTr("WEBSITE")
                                    sourceSize: 28
                                    source: "qrc:/assets/icons/material-symbols/link.svg"
                                    onClicked: Qt.openUrlExternally("https://emeric.io/MiniVideoInfos/")
                                }

                                ButtonSolid {
                                    width: 160
                                    height: 40
                                    color: "#5483EF"
                                    font.bold: true

                                    text: qsTr("GitHub")
                                    sourceSize: 20
                                    source: "qrc:/assets/gfx/logos/github.svg"
                                    onClicked: Qt.openUrlExternally("https://github.com/emericg/MiniVideoInfos")
                                }

                                ButtonSolid {
                                    width: 160
                                    height: 40
                                    sourceSize: 22
                                    color: "#5483EF"
                                    font.bold: true

                                    text: qsTr("SUPPORT")
                                    source: "qrc:/assets/icons/material-symbols/support.svg"
                                    onClicked: Qt.openUrlExternally("https://github.com/emericg/MiniVideoInfos/issues")
                                }

                                ButtonSolid {
                                    height: 40
                                    sourceSize: 22
                                    color: "#5483EF"
                                    font.bold: true

                                    text: qsTr("RELEASE NOTES")
                                    source: "qrc:/assets/icons/material-symbols/new_releases.svg"
                                    onClicked: Qt.openUrlExternally("https://github.com/emericg/MiniVideoInfos/releases")
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom

                        height: 2
                        opacity: 1
                        color: Theme.colorSeparator
                    }
                }

                ////////////////////////

                Flow {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: Theme.componentMarginL

                    flow: Flow.LeftToRight // Flow.TopToBottom
                    spacing: Theme.componentMarginL

                    Column {
                        width: settingsColumn.flowElementWidth
                        spacing: 2

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorActionbar

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Application settings")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContentVeryBig
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            IconSvg {
                                width: 28
                                height: 28
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                source: "qrc:/assets/icons/material-icons/duotone/tune.svg"
                                color: Theme.colorIcon
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorForeground

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Theme")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContent
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            Row {
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.componentMargin
                                anchors.verticalCenter: parent.verticalCenter

                                z: 1
                                spacing: 10

                                Rectangle {
                                    id: rectangleLight
                                    width: 80
                                    height: Theme.componentHeight
                                    anchors.verticalCenter: parent.verticalCenter

                                    radius: 4
                                    color: "white"
                                    border.color: (settingsManager.appTheme === "THEME_DESKTOP_LIGHT") ? Theme.colorSecondary : "#757575"
                                    border.width: 2

                                    Text {
                                        anchors.centerIn: parent
                                        text: qsTr("light")
                                        textFormat: Text.PlainText
                                        color: (settingsManager.appTheme === "THEME_DESKTOP_LIGHT") ? Theme.colorPrimary : "#757575"
                                        font.bold: true
                                        font.pixelSize: Theme.fontSizeContentSmall
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: settingsManager.appTheme = "THEME_DESKTOP_LIGHT"
                                    }
                                }
                                Rectangle {
                                    id: rectangleDark
                                    width: 80
                                    height: Theme.componentHeight
                                    anchors.verticalCenter: parent.verticalCenter

                                    radius: 4
                                    color: "#555151"
                                    border.color: Theme.colorSecondary
                                    border.width: (settingsManager.appTheme === "THEME_MOBILE_DARK") ? 2 : 0

                                    Text {
                                        anchors.centerIn: parent
                                        text: qsTr("dark")
                                        textFormat: Text.PlainText
                                        color: (settingsManager.appTheme === "THEME_MOBILE_DARK") ? Theme.colorPrimary : "#ececec"
                                        font.bold: true
                                        font.pixelSize: Theme.fontSizeContentSmall
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: settingsManager.appTheme = "THEME_MOBILE_DARK"
                                    }
                                }
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorForeground

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Language")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContent
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            ComboBoxThemed {
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.componentMargin
                                anchors.verticalCenter: parent.verticalCenter

                                enabled: false
                                model: ["auto"]
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorForeground

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Unit system")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContent
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            SelectorMenuColorful {
                                height: 32
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.componentMargin
                                anchors.verticalCenter: parent.verticalCenter

                                model: ListModel {
                                    ListElement { idx: 0; txt: qsTr("metric"); src: ""; sz: 16; }
                                    ListElement { idx: 1; txt: qsTr("imperial"); src: ""; sz: 16; }
                                }

                                currentSelection: settingsManager.appUnits
                                onMenuSelected: (index) => {
                                    currentSelection = index
                                    settingsManager.appUnits = index
                                }
                            }
                        }
                    }

                    ////

                    Column {
                        width: settingsColumn.flowElementWidth
                        spacing: 2

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorActionbar

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Media")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContentVeryBig
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            IconSvg {
                                width: 28
                                height: 28
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                source: "qrc:/assets/icons/fontawesome/photo-video-duotone.svg"
                                color: Theme.colorIcon
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorForeground

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.right: parent.right
                                anchors.rightMargin: 64
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Preview media")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContent
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            SwitchThemedDesktop {
                                anchors.right: parent.right
                                anchors.rightMargin: 8
                                anchors.verticalCenter: parent.verticalCenter

                                checked: settingsManager.mediaPreview
                                onClicked: settingsManager.mediaPreview = checked
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorForeground

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.right: parent.right
                                anchors.rightMargin: 64
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Enable export tab")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContent
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            SwitchThemedDesktop {
                                anchors.right: parent.right
                                anchors.rightMargin: 8
                                anchors.verticalCenter: parent.verticalCenter

                                checked: settingsManager.exportEnabled
                                onClicked: settingsManager.exportEnabled = checked
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorForeground

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Size units")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContent
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            SelectorMenuColorful {
                                height: 32
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.componentMargin
                                anchors.verticalCenter: parent.verticalCenter

                                model: ListModel {
                                    ListElement { idx: 0; txt: qsTr("KB"); src: ""; sz: 16; }
                                    ListElement { idx: 1; txt: qsTr("KiB"); src: ""; sz: 16; }
                                }

                                currentSelection: settingsManager.unitSizes
                                onMenuSelected: (index) => {
                                    currentSelection = index
                                    settingsManager.unitSizes = index
                                }
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: legend_sizes.contentHeight + 12
                            color: Theme.colorForeground

                            Text {
                                id: legend_sizes
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.right: parent.right
                                anchors.rightMargin: 8
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("1 KB = 1000 bytes.\nUses powers of 10 (10^3) in decimal number system. SI unit.\n" +
                                           "1 KiB = 1024 bytes.\nUses powers of 2 (2^10) in binary number system.")
                                textFormat: Text.PlainText
                                wrapMode: Text.WordWrap
                                color: Theme.colorSubText
                                font.pixelSize: 14
                            }
                        }
                    }

                    ////

                    Column {
                        width: settingsColumn.flowElementWidth
                        spacing: 2

                        visible: (Qt.platform.os === "linux" || Qt.platform.os === "osx")

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorActionbar

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Something else?")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContentVeryBig
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }

                            IconSvg {
                                width: 28
                                height: 28
                                anchors.right: parent.right
                                anchors.rightMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                source: "qrc:/assets/icons/material-icons/duotone/microwave.svg"
                                color: Theme.colorIcon
                            }
                        }
                    }

                    ////
                }

                ////////////////////////

                Flow {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: Theme.componentMarginL
                    flow: Flow.LeftToRight // Flow.TopToBottom
                    spacing: Theme.componentMarginL

                    Column {
                        width: settingsColumn.flowElementWidth
                        spacing: 2

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorActionbar

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Third parties")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContentVeryBig
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorForeground

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.right: parent.right
                                anchors.rightMargin: 8
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("This application is made possible thanks to a couple of third party open source projects:")
                                textFormat: Text.PlainText
                                color: Theme.colorText
                                font.pixelSize: Theme.fontSizeContent
                                wrapMode: Text.WordWrap
                            }
                        }

                        Repeater {
                            model: ListModel {
                                ListElement { txt: "Qt6"; license: "LGPL v3"; link: "https://qt.io" }
                                ListElement { txt: "MiniVideo framework"; license: "LGPL v3"; link: "https://github.com/emericg/MiniVideo" }
                                ListElement { txt: "TagLib"; license: "LGPL v3"; link: "https://taglib.org/" }
                                ListElement { txt: "libexif"; license: "LGPL v2.1"; link: "https://libexif.github.io/" }
                                ListElement { txt: "Bootstrap Icons"; license: "MIT"; link: "https://icons.getbootstrap.com/" }
                                ListElement { txt: "FontAwesome Icons"; license: "CC BY 4.0"; link: "https://fontawesome.com/" }
                                ListElement { txt: "Google Material Icons"; license: "MIT"; link: "https://fonts.google.com/icons" }
                            }
                            delegate: Row {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                spacing: 2

                                Rectangle {
                                    width: parent.width * 0.66 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: Theme.componentMarginL
                                        anchors.verticalCenter: parent.verticalCenter

                                        text: "- " + txt
                                        textFormat: Text.PlainText
                                        color: Theme.colorText
                                        font.pixelSize: Theme.fontSizeContent
                                        wrapMode: Text.WordWrap
                                    }
                                }

                                Rectangle {
                                    width: parent.width * 0.24 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    Text {
                                        anchors.centerIn: parent

                                        text: license
                                        textFormat: Text.PlainText
                                        color: Theme.colorText
                                        font.pixelSize: Theme.fontSizeContent
                                        wrapMode: Text.WordWrap
                                    }
                                }

                                Rectangle {
                                    width: parent.width * 0.1 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: Qt.openUrlExternally(link)
                                        hoverEnabled: true

                                        IconSvg {
                                            anchors.centerIn: parent
                                            width: 20
                                            height: 20

                                            source: "qrc:/assets/icons/material-icons/duotone/launch.svg"
                                            color: parent.containsMouse ? Theme.colorPrimary : Theme.colorText
                                            Behavior on color { ColorAnimation { duration: 133 } }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    ////

                    Column {
                        width: settingsColumn.flowElementWidth
                        spacing: 2

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: 48
                            color: Theme.colorActionbar

                            Text {
                                anchors.left: parent.left
                                anchors.leftMargin: Theme.componentMarginL
                                anchors.verticalCenter: parent.verticalCenter

                                text: qsTr("Libraries info")
                                textFormat: Text.PlainText
                                font.pixelSize: Theme.fontSizeContentVeryBig
                                font.bold: false
                                color: Theme.colorText
                                wrapMode: Text.WordWrap
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Row {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            spacing: 2

                            Rectangle {
                                width: parent.width * 0.5 - 1
                                height: 32
                                color: Theme.colorForeground

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: Theme.componentMarginL
                                    anchors.verticalCenter: parent.verticalCenter

                                    text: "MiniVideo"
                                    textFormat: Text.PlainText
                                    color: Theme.colorText
                                    font.pixelSize: Theme.fontSizeContent
                                    wrapMode: Text.WordWrap
                                }
                            }

                            Rectangle {
                                width: parent.width * 0.5 - 1
                                height: 32
                                color: Theme.colorForeground

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: Theme.componentMarginL
                                    anchors.verticalCenter: parent.verticalCenter

                                    text: "0.5"
                                    textFormat: Text.PlainText
                                    color: Theme.colorText
                                    font.pixelSize: Theme.fontSizeContent
                                    wrapMode: Text.WordWrap
                                }
                            }
                        }
                    }

                    ////

                    Loader { // DEBUG PANEL
                        active: utilsApp.isDebugBuild()
                        asynchronous: true

                        sourceComponent: Column {
                            width: settingsColumn.flowElementWidth
                            spacing: 2

                            Rectangle {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 48
                                color: Theme.colorActionbar

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: Theme.componentMarginL
                                    anchors.verticalCenter: parent.verticalCenter

                                    text: qsTr("System info")
                                    textFormat: Text.PlainText
                                    font.pixelSize: Theme.fontSizeContentVeryBig
                                    font.bold: false
                                    color: Theme.colorText
                                    wrapMode: Text.WordWrap
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            Row {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                spacing: 2

                                Rectangle {
                                    width: parent.width * 0.5 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: Theme.componentMarginL
                                        anchors.verticalCenter: parent.verticalCenter

                                        text: {
                                            var txt = utilsSysInfo.getOsName()
                                            if (utilsSysInfo.getOsVersion() !== "unknown")
                                            {
                                                if (txt.length) txt += " "
                                                txt += utilsSysInfo.getOsVersion()
                                            }
                                            return txt
                                        }

                                        textFormat: Text.PlainText
                                        color: Theme.colorText
                                        font.pixelSize: Theme.fontSizeContent
                                        wrapMode: Text.WordWrap
                                    }
                                }

                                Rectangle {
                                    width: parent.width * 0.5 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    Text {
                                        anchors.centerIn: parent

                                        text: {
                                            var txt = utilsSysInfo.getOsDisplayServer()
                                            if (txt.length) txt += " / "
                                            txt += utilsApp.qtRhiBackend()
                                            return txt
                                        }
                                        textFormat: Text.PlainText
                                        color: Theme.colorText
                                        font.pixelSize: Theme.fontSizeContent
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            Row {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                spacing: 2

                                Rectangle {
                                    width: parent.width * 0.5 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: Theme.componentMarginL
                                        anchors.verticalCenter: parent.verticalCenter

                                        text: "Qt version"
                                        textFormat: Text.PlainText
                                        color: Theme.colorText
                                        font.pixelSize: Theme.fontSizeContent
                                        wrapMode: Text.WordWrap
                                    }
                                }

                                Rectangle {
                                    width: parent.width * 0.5 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    Text {
                                        anchors.centerIn: parent

                                        text: utilsApp.qtVersion()
                                        textFormat: Text.PlainText
                                        color: Theme.colorText
                                        font.pixelSize: Theme.fontSizeContent
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            Row {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                spacing: 2

                                Rectangle {
                                    width: parent.width * 0.5 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    Text {
                                        anchors.left: parent.left
                                        anchors.leftMargin: Theme.componentMarginL
                                        anchors.verticalCenter: parent.verticalCenter

                                        text: "Qt architecture"
                                        textFormat: Text.PlainText
                                        color: Theme.colorText
                                        font.pixelSize: Theme.fontSizeContent
                                        wrapMode: Text.WordWrap
                                    }
                                }

                                Rectangle {
                                    width: parent.width * 0.5 - 1
                                    height: 32
                                    color: Theme.colorForeground

                                    Text {
                                        anchors.centerIn: parent

                                        text: utilsApp.qtArchitecture()
                                        textFormat: Text.PlainText
                                        color: Theme.colorText
                                        font.pixelSize: Theme.fontSizeContent
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }
                    }

                    ////
                }

                ////////
            }
        }

        ////////////////////////////////////////////////////////////////////////
    }

    ////////////////
}
