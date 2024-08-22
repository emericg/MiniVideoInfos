import QtQuick
import QtQuick.Controls

import Qt.labs.folderlistmodel

import ThemeEngine
import "qrc:/utils/UtilsPath.js" as UtilsPath
import "qrc:/utils/UtilsString.js" as UtilsString

Rectangle {
    id: fileDialogMobile
    anchors.fill: parent

    z: 20 // must be shown on top of everything
    visible: false
    color: Theme.colorBackground

    property bool inited: false

    signal accepted()
    signal rejected()

    // compatibility
    property string title: "" // not supported
    property url folder: ""
    property bool sidebarVisible: false // not supported
    property bool selectExisting: true // not supported
    property bool selectFolder: false
    property bool selectMultiple: false // not supported

    ////////////////////////////////////////////////////////////////////////////

    function open() {

        utilsApp.getMobileStorageReadPermission()

        if (!inited) {
            //folderListModel.rootFolder = fileDialogMobile.folder
            //folderListModel.folder = fileDialogMobile.folder

            folderListModel.folder = "file://" + utilsApp.getMobileStorageInternal()
            folderListModel.rootFolder = "file://" + utilsApp.getMobileStorageInternal()

            updateHeaderText()
            inited = true
        }

        // Show the storage chooser?
        //if (utilsApp.getMobileStorageCount() > 1) {
        //    storageChooser.visible = true
        //    headerText.anchors.leftMargin = 48
        //} else {
        //    storageChooser.visible = false
        //    headerText.anchors.leftMargin = 0
        //}

        visible = true
    }

    function close() {
        visible = false
    }

    function updateHeaderText() {
        if (folderListModel.folder === folderListModel.rootFolder) {
            headerText.text = "/"
            upButton.visible = false
        } else {
            headerText.text = folderListModel.folder.toString()
            upButton.visible = true
        }

        if (headerText.text.startsWith("file://"))
            headerText.text = headerText.text.slice(7)
        if (headerText.text.startsWith("/storage"))
            headerText.text = headerText.text.slice(8)
        if (headerText.text.startsWith("/emulated"))
            headerText.text = headerText.text.slice(9)
        if (headerText.text.startsWith("/0") || headerText.text.startsWith("/1") ||
            headerText.text.startsWith("/2") || headerText.text.startsWith("/3"))
            headerText.text = headerText.text.slice(2)
    }

    function onRowChoose(index, folderURL) {
        if (folderListModel.isFolder(index)) {
            fileDialog.accepted(folderURL)
            fileDialog.close()
        }
    }
    function onRowClick(index, fileURL) {
        if (folderListModel.isFolder(index)) {
            folderListModel.folder = fileURL
            updateHeaderText()
        } else {
            fileDialog.accepted(fileURL)
            fileDialog.close()
        }
    }

    function onBackPressed() {
        if (folderListModel.folder === folderListModel.rootFolder) {
            fileDialog.rejected()
            fileDialog.close()
        } else {
            folderListModel.folder = folderListModel.parentFolder
            updateHeaderText()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: subheader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        z: 1
        height: 40
        color: Theme.colorHeader

        // prevent clicks below this area
        MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

        Item {
            id: storageChooser
            width: 40
            height: 40
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            visible: true // (utilsApp.getMobileStorageCount() > 1)

            property int storageIndex: 0
            property int storageCount: utilsApp.getMobileStorageCount()

            Rectangle {
                width: 38
                height: 38
                radius: 38
                anchors.centerIn: parent
                color: Theme.colorComponent
            }

            IconSvg {
                id: storageIcon
                width: 26
                height: 26
                anchors.centerIn: parent

                source: "qrc:/assets/icons/material-symbols/hardware/smartphone-fill.svg"
                color: Theme.colorIcon
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // try next storage
                    storageChooser.storageIndex++
                    if (storageChooser.storageIndex >= storageChooser.storageCount)
                        storageChooser.storageIndex = 0

                    // change icons and set new storage root
                    if (storageChooser.storageIndex === 0) {
                        folderListModel.folder = "file://" + utilsApp.getMobileStorageInternal()
                        folderListModel.rootFolder = "file://" + utilsApp.getMobileStorageInternal()
                        storageIcon.source = "qrc:/assets/icons/material-symbols/hardware/smartphone-fill.svg"
                    } else {
                        folderListModel.folder = "file://" + utilsApp.getMobileStorageExternal()
                        folderListModel.rootFolder = "file://" + utilsApp.getMobileStorageExternal()
                        storageIcon.source = "qrc:/assets/icons/material-icons/duotone/sd_card.svg"
                    }

                    updateHeaderText()
                }
            }
        }

        Text {
            id: headerText
            anchors.left: parent.left
            anchors.leftMargin: 64
            anchors.right: upButton.left
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            text: folderListModel.folder
            textFormat: Text.PlainText
            color: Theme.colorText
            font.pixelSize: Theme.fontSizeContent
            elide: Text.ElideMiddle
        }

        Item {
            id: upButton
            width: 40
            height: 40
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter

            IconSvg {
                id: upIcon
                anchors.centerIn: parent
                width: 24
                height: 24

                color: Theme.colorIcon
                source: "qrc:/assets/icons/material-symbols/subdirectory_arrow_left.svg"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (folderListModel.folder !== folderListModel.rootFolder) {
                        folderListModel.folder = folderListModel.parentFolder
                        updateHeaderText()
                    }
                }
            }
        }
    }

    Rectangle { // separator
        anchors.top: subheader.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        height: 2
        opacity: 0.66
        color: Theme.colorSeparator

        Rectangle { // fake shadow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: 8
            opacity: 0.66

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.colorHeader; }
                GradientStop { position: 1.0; color: "transparent"; }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ListView {
        anchors.top: subheader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        topMargin: 2
        bottomMargin: -1 + mediaOnlyChooser.height

        model: FolderListModel {
            id: folderListModel
            caseSensitive: false

            showDirsFirst: true
            showDotAndDotDot: false
            showFiles: !selectFolder
        }

        delegate: ItemDelegate {
            id: listItem
            width: ListView.view.width
            height: 48

            RippleThemed {
                anchors.fill: listItem
                anchor: listItem

                clip: true
                pressed: listItem.pressed
                active: listItem.enabled && (listItem.down || listItem.hovered || listItem.visualFocus)
                color: Qt.rgba(Theme.colorForeground.r, Theme.colorForeground.g, Theme.colorForeground.b, 0.08)
            }

            IconSvg {
                id: icon
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                width: 36
                height: 36
                color: Theme.colorIcon
                source: {
                    if (fileIsDir) {
                        if (fileName === "DCIM" || fileName === "Download" ||
                            fileName === "Movies" || fileName === "Pictures" || fileName === "Music")
                            source = "qrc:/assets/icons/material-symbols/folder-fill.svg"
                        else
                            source = "qrc:/assets/icons/material-symbols/folder.svg"
                    } else {
                        if (UtilsPath.isVideoFile(fileName)) {
                            source = "qrc:/assets/icons/material-symbols/media/slideshow-fill.svg"
                        } else if (UtilsPath.isAudioFile(fileName)) {
                            source = "qrc:/assets/icons/material-symbols/media/album-fill.svg"
                        } else if (UtilsPath.isPictureFile(fileName)) {
                            source = "qrc:/assets/icons/material-symbols/media/image-fill.svg"
                        } else {
                            if (settingsManager.mediaFilter) {
                                listItem.visible = false
                                listItem.height = 0
                            } else {
                                source = "qrc:/assets/icons/material-symbols/file.svg"
                            }
                        }
                    }
                }
            }

            Column {
                anchors.left: icon.right
                anchors.leftMargin: 16
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right

                    text: fileName
                    textFormat: Text.PlainText
                    color: Theme.colorText
                    font.pixelSize: Theme.fontSizeContentSmall
                    elide: Text.ElideMiddle
                }
                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    visible: !fileIsDir

                    text: UtilsString.bytesToString_short(fileSize)
                    textFormat: Text.PlainText
                    color: Theme.colorSubText
                    font.pixelSize: 11
                    elide: Text.ElideMiddle
                }
            }

            //Rectangle { width: parent.width; height: 1; color: Theme.colorHeader; visible: index == 0; }
            Rectangle { width: parent.width; height: 1; anchors.bottom: parent.bottom; color: Theme.colorSeparator; opacity: 0.66; }
            //MouseArea { anchors.fill: parent; onClicked: fileDialogMobile.onRowClick(index, fileURL); }

            onClicked: fileDialogMobile.onRowClick(index, fileURL);

            ButtonClear {
                width: 72
                height: 28
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                visible: selectFolder
                text: qsTr("choose")
                onClicked: fileDialogMobile.onRowChoose(index, fileURL)
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: mediaOnlyChooser
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        z: 1
        height: 40
        visible: !selectFolder

        opacity: 0.95
        color: mobileMenu.color

        Rectangle { // tablet separator
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2

            visible: isTablet
            color: Theme.colorHeaderHighlight
            opacity: 0.33
        }
        Rectangle { // phone separator
            anchors.left: parent.left
            anchors.right: parent.right
            height: 2

            visible: isPhone
            color: Theme.colorSeparator
        }

        Text {
            id: rectangleErrorText
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("Show media files only")
            textFormat: Text.PlainText
            color: Theme.colorSubText
            font.pixelSize: Theme.fontSizeContentSmall
        }

        SwitchThemedDesktop {
            id: switch_mediaonly
            z: 1
            anchors.right: parent.right
            anchors.rightMargin: screenPaddingRight + 8
            anchors.verticalCenter: parent.verticalCenter

            checked: settingsManager.mediaFilter
            onCheckedChanged: {
                settingsManager.mediaFilter = checked

                //var f = folderListModel.folder
                //folderListModel.folder = folderListModel.parentFolder
                //folderListModel.folder = f

                if (settingsManager.mediaFilter) {
                    folderListModel.nameFilters = ["*.mov", "*.m4v", "*.mp4", "*.mp4v", "*.3gp", "*.3gpp", "*.mkv", "*.webm", "*.avi", "*.divx", "*.asf", "*.wmv",
                                                   "*.mp1", "*.mp2", "*.mp3", "*.m4a", "*.mp4a", "*.m4r", "*.aac", "*.mka", "*.wma", "*.amb", "*.wav", "*.wave", "*.flac", "*.ogg", "*.opus", "*.vorbis",
                                                    "*.jpg", "*.jpeg", "*.webp", "*.png", "*.gpr", "*.gif", "*.heif", "*.heic", "*.avif", "*.bmp", "*.tga", "*.tif", "*.tiff", "*.svg"]
                } else {
                    folderListModel.nameFilters = []
                }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
