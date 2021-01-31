import QtQuick 2.12
import QtQuick.Controls 2.12

import Qt.labs.folderlistmodel 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath

Rectangle {
    id: fileDialogMobile

    anchors.fill: parent
    visible: false
    color: Theme.colorBackground

    // compatibility
    property string title: "" // not supported
    property url folder: ""
    property bool sidebarVisible: false // not supported
    property bool selectExisting: true // not supported
    property bool selectFolder: false
    property bool selectMultiple: false // not supported

    property bool onlyShowMedia: settingsManager.mediaFilter
    property bool inited: false

    function open() {
        if (!inited) {
            folderListModel.rootFolder = fileDialogMobile.folder
            folderListModel.folder = fileDialogMobile.folder

            storageIcon.source = "qrc:/assets/icons_material/baseline-smartphone-24px.svg"
            updateHeaderText()
            inited = true
        }
/*
        if (utilsApp.getMobileStorageCount() > 1) {
            storageChooser.visible = true
            headerText.anchors.leftMargin = 48
        } else {
            storageChooser.visible = false
            headerText.anchors.leftMargin = 0
        }
*/
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
            parent.accepted(folderURL);
            parent.close();
        }
    }
    function onRowClick(index, fileURL) {
        if (folderListModel.isFolder(index)) {
            folderListModel.folder = fileURL;
            updateHeaderText();
        } else {
            parent.accepted(fileURL);
            parent.close();
        }
    }

    function onBackPressed() {
        if (folderListModel.folder === folderListModel.rootFolder) {
            close()
        } else {
            folderListModel.folder = folderListModel.parentFolder
            updateHeaderText()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: header
        height: 48
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        color: Theme.colorHeader

        // prevent clicks into this area
        MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

        Item {
            id: storageChooser
            width: 48
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter

            visible: true // (utilsApp.getMobileStorageCount() > 1)

            property int storageIndex: 0
            property int storageCount: utilsApp.getMobileStorageCount()

            ImageSvg {
                id: storageIcon
                width: 24
                height: 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                source: "qrc:/assets/icons_material/baseline-smartphone-24px.svg"
                color: Theme.colorIcon
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // try next storage
                    storageChooser.storageIndex++;
                    if (storageChooser.storageIndex >= storageChooser.storageCount)
                        storageChooser.storageIndex = 0

                    // change icons and set new storage root
                    if (storageChooser.storageIndex === 0) {
                        folderListModel.folder = "file://" + utilsApp.getMobileStorageInternal()
                        folderListModel.rootFolder = "file://" + utilsApp.getMobileStorageInternal()
                        storageIcon.source = "qrc:/assets/icons_material/baseline-smartphone-24px.svg"
                    } else {
                        folderListModel.folder = "file://" + utilsApp.getMobileStorageExternal()
                        folderListModel.rootFolder = "file://" + utilsApp.getMobileStorageExternal()
                        storageIcon.source = "qrc:/assets/icons_material/outline-sd_card-24px.svg"
                    }

                    updateHeaderText()
                }
            }
        }

        Text {
            id: headerText
            anchors.left: parent.left
            anchors.leftMargin: 56
            anchors.right: upButton.left
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter

            clip: true
            text: folderListModel.folder
            //onTextChanged: updateHeaderText()
            color: Theme.colorText
            font.pixelSize: 18
        }

        Item {
            id: upButton
            width: 48
            height: 48
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.verticalCenter: parent.verticalCenter

            ImageSvg {
                id: upIcon
                anchors.right: parent.right
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter

                color: Theme.colorIcon
                source: "qrc:/assets/icons_material/baseline-subdirectory_arrow_left-24px.svg"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (folderListModel.folder != folderListModel.rootFolder) {
                        folderListModel.folder = folderListModel.parentFolder
                        updateHeaderText()
                    }
                }
            }
        }

        Rectangle {
            height: 1
            color: Theme.colorSeparator
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ListView {
        id: list

        width: parent.width
        anchors.top: header.bottom
        anchors.bottom: mediaOnlyChooser.top
        clip: true

        model: FolderListModel {
            id: folderListModel
            caseSensitive: false

            showDirsFirst: true
            showDotAndDotDot: false
            showFiles: !selectFolder
        }

        delegate: Item {
            id: iii
            width: list.width
            height: 48

            ImageSvg {
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
                            source = "qrc:/assets/icons_material/baseline-folder-24px.svg"
                        else
                            source = "qrc:/assets/icons_material/outline-folder-24px.svg"
                    } else {
                        if (UtilsPath.isVideoFile(fileName)) {
                            source = "qrc:/assets/icons_material_media/baseline-slideshow-24px.svg"
                        } else if (UtilsPath.isAudioFile(fileName)) {
                            source = "qrc:/assets/icons_material_media/baseline-music-24px.svg"
                        } else if (UtilsPath.isPictureFile(fileName, )) {
                            source = "qrc:/assets/icons_material_media/baseline-photo-24px.svg"
                        } else {
                            if (onlyShowMedia) {
                                iii.visible = false
                                iii.height = 0
                            } else {
                                source = "qrc:/assets/icons_material/outline-insert_empty-24px.svg"
                            }
                        }
                    }
                }
            }

            Text {
                anchors.left: icon.right
                anchors.leftMargin: 12
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter

                text: fileName
                color: Theme.colorText
                font.pixelSize: 14
                elide: Text.ElideMiddle
            }

            //Rectangle { width: parent.width; height: 1; color: Theme.colorHeader; visible: index == 0; }
            Rectangle { width: parent.width; height: 1; anchors.bottom: parent.bottom; color: Theme.colorSeparator; opacity: 0.66; }
            MouseArea { anchors.fill: parent; onClicked: fileDialogMobile.onRowClick(index, fileURL); }

            ButtonWireframe {
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
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: !selectFolder
        color: Theme.colorHeader

        Text {
            id: rectangleErrorText
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            text: qsTr("Show media files only")
            color: Theme.colorSubText
            font.pixelSize: 14
        }

        SwitchThemedMobile {
            id: switch_mediaonly
            z: 1
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter

            Component.onCompleted: checked = onlyShowMedia
            onCheckedChanged: {
                onlyShowMedia = checked

                //var f = folderListModel.folder
                //folderListModel.folder = folderListModel.parentFolder
                //folderListModel.folder = f

                if (onlyShowMedia)
                    folderListModel.nameFilters = ["*.mov", "*.m4v", "*.mp4", "*.mp4v", "*.3gp", "*.3gpp", "*.mkv", "*.webm", "*.avi", "*.divx", "*.asf", "*.wmv",
                                                   "*.mp1", "*.mp2", "*.mp3", "*.m4a", "*.mp4a", "*.m4r", "*.aac", "*.mka", "*.wma", "*.amb", "*.wav", "*.wave", "*.flac", "*.ogg", "*.opus", "*.vorbis",
                                                    "*.jpg", "*.jpeg", "*.webp", "*.png", "*.gpr", "*.gif", "*.heif", "*.heic", "*.avif", "*.bmp", "*.tga", "*.tif", "*.tiff", "*.svg"]
                else
                    folderListModel.nameFilters = []
            }
        }
    }
}
