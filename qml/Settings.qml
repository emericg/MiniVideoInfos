import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

Item {
    id: settingsScreen
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenLeftPadding
    anchors.rightMargin: screenRightPadding

    Rectangle {
        id: rectangleHeader
        color: Theme.colorForeground
        height: 80
        z: 5

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            id: textTitle
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: parent.top
            anchors.topMargin: 12

            text: qsTr("Change persistent settings here!")
            font.pixelSize: 18
            color: Theme.colorText
        }

        Text {
            id: textSubtitle
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 14

            text: qsTr("Because everyone love settings...")
            font.pixelSize: 16
            color: Theme.colorSubText
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ScrollView {
        id: scrollView
        contentWidth: -1

        anchors.top: rectangleHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Column {
            id: column
            anchors.fill: parent

            topPadding: 12
            bottomPadding: 12
            spacing: 8

            ////////

            Item {
                id: element_theme
                height: 48
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                ImageSvg {
                    id: image_theme
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/duotone-style-24px.svg"
                }

                Text {
                    id: text_theme
                    height: 40
                    anchors.right: theme_selector.left
                    anchors.rightMargin: 16
                    anchors.left: image_theme.right
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Application theme")
                    font.pixelSize: 16
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
                        border.width: (Theme.currentTheme === ThemeEngine.THEME_LIGHT) ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settingsManager.appTheme = "light"
                            }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: qsTr("light")
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
                        border.width: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settingsManager.appTheme = "dark"
                            }
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            text: qsTr("dark")
                            color: "#dddddd"
                            font.pixelSize: 14
                        }
                    }
                }
            }

            ////////

            Item {
                id: element_autoDarkmode
                height: 48
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                visible: (settingsManager.appTheme !== "night")

                ImageSvg {
                    id: image_autoDarkmode
                    width: 24
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/duotone-brightness_4-24px.svg"
                }

                Text {
                    id: text_autoDarkmode
                    height: 40
                    anchors.right: switch_autoDarkmode.left
                    anchors.rightMargin: 16
                    anchors.left: image_autoDarkmode.right
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Automatic dark mode")
                    font.pixelSize: 16
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedMobile {
                    id: switch_autoDarkmode
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.autoDark
                    onCheckedChanged: {
                        settingsManager.autoDark = checked
                        Theme.loadTheme(settingsManager.appTheme)
                    }
                }
            }
            Text {
                id: legend_autoDarkmode
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 16
                topPadding: -12
                bottomPadding: 8

                visible: (element_autoDarkmode.visible)

                text: qsTr("Dark mode will switch on automatically between 9 PM and 9 AM.")
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }

            ////////

            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
            }

            ////////

            Item {
                id: element_mediaFilter
                height: 48
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                ImageSvg {
                    id: image_mediaFilter
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorText
                    source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
                }

                Text {
                    id: text_mediaFilter
                    height: 40
                    anchors.left: image_mediaFilter.right
                    anchors.leftMargin: 16
                    anchors.right: switch_mediaFilter.left
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Filter media in file chooser")
                    font.pixelSize: 16
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedMobile {
                    id: switch_mediaFilter
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.mediaFilter
                    onCheckedChanged: settingsManager.mediaFilter = checked
                }
            }

            ////////

            Item {
                id: element_mediaPreview
                height: 48
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                Text {
                    id: text_mediaPreview
                    height: 40
                    anchors.left: image_mediaPreview.right
                    anchors.leftMargin: 16
                    anchors.right: switch_mediaPreview.left
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Preview media")
                    font.pixelSize: 16
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedMobile {
                    id: switch_mediaPreview
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.mediaPreview
                    onCheckedChanged: settingsManager.mediaPreview = checked
                }

                ImageSvg {
                    id: image_mediaPreview
                    width: 24
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material_media/outline-insert_photo-24px.svg"
                }
            }

            ////////

            Item {
                id: element_mediaExport
                height: 48
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                ImageSvg {
                    id: image_mediaExport
                    width: 24
                    height: 24
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/outline-archive-24px.svg"
                }

                Text {
                    id: text_mediaExport
                    height: 40
                    anchors.right: switch_mediaExport.left
                    anchors.rightMargin: 16
                    anchors.left: image_mediaExport.right
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Enable export tab")
                    font.pixelSize: 16
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedMobile {
                    id: switch_mediaExport
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 8
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
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.leftMargin: 0

                ImageSvg {
                    id: image_unit
                    width: 24
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 16
                    anchors.left: parent.left

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/baseline-edit-24px.svg"
                }

                Text {
                    id: text_unit
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: image_unit.right
                    anchors.leftMargin: 16
                    anchors.right: radioDelegateMetric.left
                    anchors.rightMargin: 16

                    text: qsTr("Unit system")
                    wrapMode: Text.WordWrap
                    font.pixelSize: 16
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }

                RadioButtonThemed {
                    id: radioDelegateMetric
                    height: 40
                    anchors.right: radioDelegateImperial.left
                    anchors.verticalCenter: text_unit.verticalCenter

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
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

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

            ////////

            Item {
                id: element_sizes
                height: 48
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.leftMargin: 0

                ImageSvg {
                    id: image_sizes
                    width: 24
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 16
                    anchors.left: parent.left

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/outline-save-24px.svg"
                }

                Text {
                    id: text_sizes
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: image_sizes.right
                    anchors.leftMargin: 16
                    anchors.right: row_sizes.left
                    anchors.rightMargin: 16

                    text: qsTr("Sizes unit")
                    wrapMode: Text.WordWrap
                    font.pixelSize: 16
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }

                Row {
                    id: row_sizes
                    height: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

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
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 16
                topPadding: -12
                bottomPadding: 8

                visible: (element_sizes.visible)

                text: qsTr("1 KB = 1000 bytes. Uses powers of 10 (10^3) in decimal number system.\n" +
                           "1 KiB = 1024 bytes. Uses powers of 2 (2^10) in binary number system.")
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }
        }
    }
}
