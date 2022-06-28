import QtQuick 2.15
import QtQuick.Controls 2.15

import ThemeEngine 1.0

Item {
    id: settingsScreen
    width: 480
    height: 720
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    Flickable {
        anchors.fill: parent

        contentWidth: -1
        contentHeight: column.height

        boundsBehavior: isDesktop ? Flickable.OvershootBounds : Flickable.DragAndOvershootBounds
        ScrollBar.vertical: ScrollBar { visible: isDesktop; }

        Column {
            id: column
            anchors.left: parent.left
            anchors.leftMargin: screenPaddingLeft
            anchors.right: parent.right
            anchors.rightMargin: screenPaddingRight

            topPadding: 16
            bottomPadding: 16
            spacing: 8

            ////////////////

            Rectangle {
                height: 48
                anchors.left: parent.left
                anchors.right: parent.right

                color: Theme.colorForeground

                IconSvg {
                    id: image_appsettings
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenPaddingLeft + 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                }

                Text {
                    id: text_appsettings
                    anchors.left: image_appsettings.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Application")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    font.bold: false
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }
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
                    source: "qrc:/assets/icons_material/duotone-style-24px.svg"
                }

                Text {
                    id: text_appTheme
                    height: 40
                    anchors.left: image_appTheme.right
                    anchors.leftMargin: 24
                    anchors.right: theme_selector.left
                    anchors.rightMargin: 16
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
                        color: (Theme.currentTheme === ThemeEngine.THEME_LIGHT) ? Theme.colorForeground : "#dddddd"
                        border.color: Theme.colorSecondary
                        border.width: (settingsManager.appTheme === "light") ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: settingsManager.appTheme = "light"
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
                        border.width: (settingsManager.appTheme === "dark") ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: settingsManager.appTheme = "dark"
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
                    source: "qrc:/assets/icons_material/duotone-brightness_4-24px.svg"
                }

                Text {
                    id: text_appThemeAuto
                    height: 40
                    anchors.left: image_appThemeAuto.right
                    anchors.leftMargin: 24
                    anchors.right: switch_appThemeAuto.left
                    anchors.rightMargin: 16
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
                anchors.leftMargin: screenPaddingLeft + 64
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight + 16
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

            Rectangle {
                height: 48
                anchors.left: parent.left
                anchors.right: parent.right

                color: Theme.colorForeground

                IconSvg {
                    id: image_filechooser
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenPaddingLeft + 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons_material/baseline-folder_open-24px.svg"
                }

                Text {
                    id: text_filechooser
                    anchors.left: image_filechooser.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("File chooser")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    font.bold: false
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }
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

                    source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                    fillMode: Image.PreserveAspectFit
                    color: Theme.colorIcon
                    smooth: true
                }

                Text {
                    id: text_mediaFilter
                    height: 40
                    anchors.left: image_mediaFilter.right
                    anchors.leftMargin: 24
                    anchors.right: switch_mediaFilter.left
                    anchors.rightMargin: 16
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

            ////////////////

            Rectangle {
                height: 48
                anchors.left: parent.left
                anchors.right: parent.right

                color: Theme.colorForeground

                IconSvg {
                    id: image_mediasettings
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: screenPaddingLeft + 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons_material/baseline-photo_camera-24px.svg"
                }

                Text {
                    id: text_mediasettings
                    anchors.left: image_mediasettings.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Media")
                    textFormat: Text.PlainText
                    font.pixelSize: Theme.fontSizeContent
                    font.bold: false
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }
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
                    source: "qrc:/assets/icons_material/outline-insert_photo-24px.svg"
                }

                Text {
                    id: text_mediaPreview
                    height: 40
                    anchors.left: image_mediaPreview.right
                    anchors.leftMargin: 24
                    anchors.right: switch_mediaPreview.left
                    anchors.rightMargin: 16
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
                    source: "qrc:/assets/icons_material/outline-archive-24px.svg"
                }

                Text {
                    id: text_mediaExport
                    height: 40
                    anchors.right: switch_mediaExport.left
                    anchors.rightMargin: 16
                    anchors.left: image_mediaExport.right
                    anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter

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
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: image_unit
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons_material/duotone-edit-24px.svg"
                }

                Text {
                    id: text_unit
                    height: 40
                    anchors.left: image_unit.right
                    anchors.leftMargin: 24
                    anchors.right: row_unit.left
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Unit system")
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }

                Row {
                    id: row_unit
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    RadioButtonThemed {
                        id: radioDelegateMetric
                        height: 40

                        z: 1
                        text: qsTr("Metric")
                        font.pixelSize: 14

                        checked: {
                            if (settingsManager.unitSystem === 1) {
                                radioDelegateMetric.checked = true
                                radioDelegateImperial.checked = false
                            } else {
                                radioDelegateMetric.checked = false
                                radioDelegateImperial.checked = true
                            }
                        }
                        onCheckedChanged: {
                            if (checked === true) settingsManager.unitSystem = 1
                        }
                    }

                    RadioButtonThemed {
                        id: radioDelegateImperial
                        height: 40

                        z: 1
                        text: qsTr("Imperial")
                        font.pixelSize: 14

                        checked: {
                            if (settingsManager.unitSystem !== 1) {
                                radioDelegateMetric.checked = false
                                radioDelegateImperial.checked = true
                            } else {
                                radioDelegateImperial.checked = false
                                radioDelegateMetric.checked = true
                            }
                        }
                        onCheckedChanged: {
                            if (checked === true) settingsManager.unitSystem = 2
                        }
                    }
                }
            }

            ////////

            Item {
                id: element_sizes
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight

                IconSvg {
                    id: image_sizes
                    width: 24
                    height: 24
                    anchors.leftMargin: 16
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorIcon
                    source: "qrc:/assets/icons_material/outline-save-24px.svg"
                }

                Text {
                    id: text_sizes
                    height: 40
                    anchors.left: image_sizes.right
                    anchors.leftMargin: 24
                    anchors.right: row_sizes.left
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Sizes unit")
                    wrapMode: Text.WordWrap
                    font.pixelSize: Theme.fontSizeContent
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }

                Row {
                    id: row_sizes
                    height: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    RadioButtonThemed {
                        id: radioDelegateKB
                        height: 40
                        anchors.verticalCenter: parent.verticalCenter

                        z: 1
                        text: qsTr("KB")
                        font.pixelSize: 14

                        checked: {
                            if (settingsManager.unitSizes === 0) {
                                radioDelegateKB.checked = true
                                radioDelegateKiB.checked = false
                                radioDelegateBoth.checked = false
                            }
                        }
                        onCheckedChanged: {
                            if (checked === true) settingsManager.unitSizes = 0
                        }
                    }
                    RadioButtonThemed {
                        id: radioDelegateKiB
                        height: 40
                        anchors.verticalCenter: parent.verticalCenter

                        z: 1
                        text: qsTr("KiB")
                        font.pixelSize: 14

                        checked: {
                            if (settingsManager.unitSizes === 1) {
                                radioDelegateKB.checked = false
                                radioDelegateKiB.checked = true
                                radioDelegateBoth.checked = false
                            }
                        }
                        onCheckedChanged: {
                            if (checked === true) settingsManager.unitSizes = 1
                        }
                    }
                    RadioButtonThemed {
                        id: radioDelegateBoth
                        height: 40
                        anchors.verticalCenter: parent.verticalCenter

                        z: 1
                        text: qsTr("Both")
                        visible: false
                        font.pixelSize: 14

                        checked: {
                            if (settingsManager.unitSizes === 2) {
                                radioDelegateKB.checked = false
                                radioDelegateKiB.checked = false
                                radioDelegateBoth.checked = true
                            }
                        }
                        onCheckedChanged: {
                            if (checked === true) settingsManager.unitSizes = 2
                        }
                    }
                }
            }
            Text {
                id: legend_sizes
                anchors.left: parent.left
                anchors.leftMargin: screenPaddingLeft + 64
                anchors.right: parent.right
                anchors.rightMargin: screenPaddingRight + 16
                topPadding: -12
                bottomPadding: 8

                visible: (element_sizes.visible)

                text: qsTr("1 KB = 1000 bytes. Uses powers of 10 (10^3) in decimal number system.\n" +
                           "1 KiB = 1024 bytes. Uses powers of 2 (2^10) in binary number system.")
                textFormat: Text.PlainText
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }
        }
    }
}
