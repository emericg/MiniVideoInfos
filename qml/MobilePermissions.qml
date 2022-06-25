import QtQuick 2.15
import QtQuick.Controls 2.15

import ThemeEngine 1.0

Item {
    id: permissionsScreen
    anchors.fill: parent
    anchors.leftMargin: screenPaddingLeft
    anchors.rightMargin: screenPaddingRight

    property string entryPoint: "About"

    ////////////////////////////////////////////////////////////////////////////

    function loadScreen() {
        // Refresh permissions
        refreshPermissions()

        // Change screen
        appContent.state = "Permissions"
    }

    function loadScreenFrom(screenname) {
        entryPoint = screenname
        loadScreen()
    }

    function refreshPermissions() {
        // Refresh permissions
        button_storage_read_test.validperm = utilsApp.checkMobileStorageReadPermission()
        button_storage_write_test.validperm = utilsApp.checkMobileStorageWritePermission()
    }

    Timer {
        id: retryPermissions
        interval: 1000
        repeat: false
        onTriggered: refreshPermissions()
    }

    ////////////////////////////////////////////////////////////////////////////

    Flickable {
        anchors.fill: parent

        contentWidth: -1
        contentHeight: column.height

        Column {
            id: column
            anchors.left: parent.left
            anchors.right: parent.right

            topPadding: 16
            bottomPadding: 16
            spacing: 8

            ////////

            Item {
                id: element_network
                height: 24
                anchors.left: parent.left
                anchors.right: parent.right

                RoundButtonIcon {
                    id: button_network_test
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    z: 1

                    property bool validperm: true

                    source: (validperm) ? "qrc:/assets/icons_material/baseline-check-24px.svg" : "qrc:/assets/icons_material/baseline-close-24px.svg"
                    iconColor: (validperm) ? "white" : "white"
                    backgroundColor: (validperm) ? Theme.colorSuccess : Theme.colorSubText
                    background: true
                }

                Text {
                    id: text_network
                    height: 16
                    anchors.left: parent.left
                    anchors.leftMargin: 64
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Network access")
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                    font.pixelSize: 18
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Text {
                id: legend_network
                anchors.left: parent.left
                anchors.leftMargin: 64
                anchors.right: parent.right
                anchors.rightMargin: 16

                text: qsTr("Network state and internet permissions are used to load GPS maps.")
                textFormat: Text.PlainText
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: Theme.fontSizeContentSmall
            }

            ////////

            Item {
                height: 16
                anchors.right: parent.right
                anchors.left: parent.left

                Rectangle {
                    height: 1
                    color: Theme.colorSeparator
                    anchors.left: parent.left
                    anchors.leftMargin: -(screenPaddingLeft + 8)
                    anchors.right: parent.right
                    anchors.rightMargin: -(screenPaddingRight + 8)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ////////

            Item {
                id: element_storage_read
                height: 24
                anchors.left: parent.left
                anchors.right: parent.right

                RoundButtonIcon {
                    id: button_storage_read_test
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    z: 1

                    property bool validperm: false

                    source: (validperm) ? "qrc:/assets/icons_material/baseline-check-24px.svg" : "qrc:/assets/icons_material/baseline-close-24px.svg"
                    iconColor: (validperm) ? "white" : "white"
                    backgroundColor: (validperm) ? Theme.colorSuccess : Theme.colorError
                    background: true

                    onClicked: {
                        utilsApp.vibrate(25)
                        validperm = utilsApp.getMobileStorageReadPermission()
                        retryPermissions.start()
                    }
                }

                Text {
                    id: text_storage_read
                    height: 16
                    anchors.left: parent.left
                    anchors.leftMargin: 64
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Storage read")
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                    font.pixelSize: 18
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Text {
                id: legend_storage_read
                anchors.left: parent.left
                anchors.leftMargin: 64
                anchors.right: parent.right
                anchors.rightMargin: 16

                text: qsTr("Storage read permission is needed to read and analyze media files. The software won't work without it.")
                textFormat: Text.PlainText
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: Theme.fontSizeContentSmall
            }

            ////////

            Item {
                height: 16
                anchors.left: parent.left
                anchors.right: parent.right

                Rectangle {
                    height: 1
                    color: Theme.colorSeparator
                    anchors.left: parent.left
                    anchors.leftMargin: -(screenPaddingLeft + 8)
                    anchors.right: parent.right
                    anchors.rightMargin: -(screenPaddingRight + 8)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ////////

            Item {
                id: element_storage_write
                height: 24
                anchors.left: parent.left
                anchors.right: parent.right

                RoundButtonIcon {
                    id: button_storage_write_test
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter
                    z: 1

                    property bool validperm: false

                    source: (validperm) ? "qrc:/assets/icons_material/baseline-check-24px.svg" : "qrc:/assets/icons_material/baseline-close-24px.svg"
                    iconColor: (validperm) ? "white" : "white"
                    backgroundColor: (validperm) ? Theme.colorSuccess : Theme.colorSubText
                    background: true

                    onClicked: {
                        utilsApp.vibrate(25)
                        validperm = utilsApp.getMobileStorageWritePermission()
                        retryPermissions.start()
                    }
                }

                Text {
                    id: text_storage_write
                    height: 16
                    anchors.left: parent.left
                    anchors.leftMargin: 64
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Storage write")
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                    font.pixelSize: 18
                    color: Theme.colorText
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Text {
                id: legend_storage_write
                anchors.left: parent.left
                anchors.leftMargin: 64
                anchors.right: parent.right
                anchors.rightMargin: 16

                text: qsTr("Storage write permission is only needed to export subtitles file or metadata overview.")
                textFormat: Text.PlainText
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: Theme.fontSizeContentSmall
            }

            ////////

            Item {
                height: 16
                anchors.left: parent.left
                anchors.right: parent.right

                Rectangle {
                    height: 1
                    color: Theme.colorSeparator
                    anchors.left: parent.left
                    anchors.leftMargin: -(screenPaddingLeft + 8)
                    anchors.right: parent.right
                    anchors.rightMargin: -(screenPaddingRight + 8)
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ////////

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 64
                anchors.right: parent.right
                anchors.rightMargin: 12

                text: qsTr("Click on the icons to ask for permission.")
                textFormat: Text.StyledText
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: Theme.fontSizeContentSmall

                IconSvg {
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: -48
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/outline-info-24px.svg"
                    color: Theme.colorSubText
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 64
                anchors.right: parent.right
                anchors.rightMargin: 12

                text: qsTr("If it has no effect, you may have previously refused a permission and clicked on \"don't ask again\".") + "<br>" +
                      qsTr("You can go to the Android \"application info\" panel to change a permission manually.")
                textFormat: Text.StyledText
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: Theme.fontSizeContentSmall
            }

            ButtonWireframeIcon {
                height: 36
                anchors.left: parent.left
                anchors.leftMargin: 64

                primaryColor: Theme.colorPrimary
                secondaryColor: Theme.colorBackground

                text: qsTr("Application info")
                source: "qrc:/assets/icons_material/duotone-tune-24px.svg"
                sourceSize: 20

                onClicked: utilsApp.openAndroidAppInfo("com.minivideo.infos")
            }

            ////////
        }
    }
}
