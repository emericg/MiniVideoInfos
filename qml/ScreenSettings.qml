import QtQuick
import QtQuick.Controls

import ThemeEngine

Loader {
    id: settingsScreen
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    function loadScreen() {
        // load screen
        settingsScreen.active = true

        // change screen
        appContent.state = "ScreenSettings"
    }

    function backAction() {
        if (settingsScreen.status === Loader.Ready)
            settingsScreen.item.backAction()
    }

    ////////////////////////////////////////////////////////////////////////////

    active: false
    asynchronous: false

    sourceComponent: Flickable {
        anchors.fill: parent

        contentWidth: -1
        contentHeight: contentColumn.height

        boundsBehavior: isDesktop ? Flickable.OvershootBounds : Flickable.DragAndOvershootBounds
        ScrollBar.vertical: ScrollBar { visible: isDesktop; }

        function backAction() {
            //
        }

        Column {
            id: contentColumn
            anchors.left: parent.left
            anchors.leftMargin: screenPaddingLeft
            anchors.right: parent.right
            anchors.rightMargin: screenPaddingRight

            topPadding: Theme.componentMargin + 8
            bottomPadding: Theme.componentMargin
            spacing: 8

            property int padIcon: singleColumn ? Theme.componentMarginL : Theme.componentMarginL
            property int padText: appHeader.headerPosition

            ////////////////

            ListTitle {
                text: qsTr("User interface")
                source: "qrc:/assets/icons/material-symbols/settings.svg"
            }

            ////////////////

            Item {
                id: element_appTheme
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: image_appTheme
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons/material-icons/duotone/style.svg"
                }

                Text {
                    id: text_appTheme
                    height: 40
                    anchors.left: image_appTheme.right
                    anchors.leftMargin: 16
                    anchors.right: theme_selector.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Application theme")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                Row {
                    id: theme_selector
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    z: 1
                    spacing: 10

                    Rectangle {
                        id: rectangleLight
                        width: 64
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 2
                        color: Theme.isLight ? Theme.colorForeground : "#dddddd"
                        border.color: Theme.colorSecondary
                        border.width: (settingsManager.appTheme === "THEME_MOBILE_LIGHT") ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: settingsManager.appTheme = "THEME_MOBILE_LIGHT"
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: qsTr("light")
                            textFormat: Text.PlainText
                            color: "#313236"
                            font.pixelSize: 14
                        }
                    }
                    Rectangle {
                        id: rectangleDark
                        width: 64
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 2
                        color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorForeground : "#313236"
                        border.color: Theme.colorSecondary
                        border.width: (settingsManager.appTheme === "THEME_MOBILE_DARK") ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: settingsManager.appTheme = "THEME_MOBILE_DARK"
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            text: qsTr("dark")
                            textFormat: Text.PlainText
                            color: "#dddddd"
                            font.pixelSize: 14
                        }
                    }
                }
            }

            ////////

            Item {
                id: element_appThemeAuto
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                visible: (settingsManager.appTheme !== "night")

                IconSvg {
                    id: image_appThemeAuto
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons/material-icons/duotone/brightness_4.svg"
                }

                Text {
                    id: text_appThemeAuto
                    height: 40
                    anchors.left: image_appThemeAuto.right
                    anchors.leftMargin: 16
                    anchors.right: switch_appThemeAuto.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Automatic dark mode")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedDesktop {
                    id: switch_appThemeAuto
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.appThemeAuto
                    onCheckedChanged: {
                        settingsManager.appThemeAuto = checked
                        Theme.loadTheme(settingsManager.appTheme)
                    }
                }
            }
            Text {
                id: legend_appThemeAuto
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft + 56
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight + 8
                topPadding: -12
                bottomPadding: 8

                visible: (element_appThemeAuto.visible)

                text: qsTr("Dark mode will switch on automatically between 9 PM and 9 AM.")
                textFormat: Text.PlainText
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }

            ////////////////

            ListTitle {
                text: qsTr("File chooser")
                source: "qrc:/assets/icons/material-symbols/folder_open.svg"
            }

            ////////////////

            Item {
                id: element_mediaFilter
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: image_mediaFilter
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons/fontawesome/photo-video-duotone.svg"
                    fillMode: Image.PreserveAspectFit
                    color: Theme.colorIcon
                    smooth: true
                }

                Text {
                    id: text_mediaFilter
                    height: 40
                    anchors.left: image_mediaFilter.right
                    anchors.leftMargin: 16
                    anchors.right: switch_mediaFilter.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Filter media files")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedDesktop {
                    id: switch_mediaFilter
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.mediaFilter
                    onCheckedChanged: settingsManager.mediaFilter = checked
                }
            }

            Item {
                id: element_nativeChooser
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: image_nativeChooser
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons/fontawesome/photo-video-duotone.svg"
                    fillMode: Image.PreserveAspectFit
                    color: Theme.colorIcon
                    smooth: true
                }

                Text {
                    id: text_nativeChooser
                    height: 40
                    anchors.left: image_nativeChooser.right
                    anchors.leftMargin: 16
                    anchors.right: switch_nativeChooser.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Use native file chooser")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedDesktop {
                    id: switch_nativeChooser
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.mediaNativeFilePicker
                    onCheckedChanged: settingsManager.mediaNativeFilePicker = checked
                }
            }

            ////////////////

            ListTitle {
                text: qsTr("Media")
                source: "qrc:/assets/icons/material-symbols/media/photo_camera.svg"
            }

            ////////////////

            Item {
                id: element_mediaPreview
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: image_mediaPreview
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons/material-symbols/media/image.svg"
                }

                Text {
                    id: text_mediaPreview
                    height: 40
                    anchors.left: image_mediaPreview.right
                    anchors.leftMargin: 16
                    anchors.right: switch_mediaPreview.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Preview media")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedDesktop {
                    id: switch_mediaPreview
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.mediaPreview
                    onCheckedChanged: settingsManager.mediaPreview = checked
                }
            }

            ////////

            Item {
                id: element_mediaExport
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: image_mediaExport
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons/material-symbols/archive.svg"
                }

                Text {
                    id: text_mediaExport
                    anchors.left: image_mediaExport.right
                    anchors.leftMargin: 16
                    anchors.right: switch_mediaExport.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter
                    height: 40

                    text: qsTr("Enable export tab")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedDesktop {
                    id: switch_mediaExport
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.exportEnabled
                    onCheckedChanged: settingsManager.exportEnabled = checked
                }
            }

            ////////

            Item {
                id: element_unit
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight
                height: 48

                IconSvg {
                    id: image_unit
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons/material-icons/duotone/edit.svg"
                }

                Text {
                    id: text_unit
                    height: 40
                    anchors.left: image_unit.right
                    anchors.leftMargin: 16
                    anchors.right: row_unit.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Unit system")
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }

                SelectorMenuColorful {
                    id: row_unit
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.componentMargin
                    anchors.verticalCenter: parent.verticalCenter
                    height: 32

                    model: ListModel {
                        ListElement { idx: 0; txt: qsTr("Metric"); src: ""; sz: 16; }
                        ListElement { idx: 1; txt: qsTr("Imperial"); src: ""; sz: 16; }
                    }

                    currentSelection: settingsManager.unitSystem
                    onMenuSelected: (index) => {
                        currentSelection = index
                        settingsManager.unitSystem = index
                    }
                }
            }

            ////////

            Item {
                id: element_sizes
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight
                height: 48

                IconSvg {
                    id: image_sizes
                    width: 24
                    height: 24
                    anchors.leftMargin: 16
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons/material-symbols/save.svg"
                }

                Text {
                    id: text_sizes
                    height: 40
                    anchors.left: image_sizes.right
                    anchors.leftMargin: 16
                    anchors.right: row_sizes.left
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Sizes unit")
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }

                SelectorMenuColorful {
                    id: row_sizes
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.componentMargin
                    anchors.verticalCenter: parent.verticalCenter
                    height: 32

                    model: ListModel {
                        ListElement { idx: 0; txt: qsTr("KB"); src: ""; sz: 16; }
                        ListElement { idx: 1; txt: qsTr("KiB"); src: ""; sz: 16; }
                        //ListElement { idx: 2; txt: qsTr("Both"); src: ""; sz: 16; }
                    }

                    currentSelection: settingsManager.unitSizes
                    onMenuSelected: (index) => {
                        currentSelection = index
                        settingsManager.unitSizes = index
                    }
                }

            }
            Text {
                id: legend_sizes
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft + 56
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight + 8

                topPadding: -12
                bottomPadding: 8
                visible: (element_sizes.visible)

                text: qsTr("1 KB = 1000 bytes.\nUses powers of 10 (10^3) in decimal number system. SI unit.\n" +
                           "1 KiB = 1024 bytes.\nUses powers of 2 (2^10) in binary number system.")
                textFormat: Text.PlainText
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }
        }

        ////////
    }

    ////////////////////////////////////////////////////////////////////////////
}
