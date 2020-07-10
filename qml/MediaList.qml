import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath

Item {
    id: screenMediaList
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenLeftPadding
    anchors.rightMargin: screenRightPadding

    Connections {
        target: mediaManager
        onMediaUpdated: {
            if (mediaManager.areMediaAvailable()) {
                rectangleHeader.visible = true
                rectangleHeader.height = 96
                itemNoFile.visible = false
                mediaView.visible = true
            } else {
                rectangleHeader.visible = false
                rectangleHeader.height = 0
                itemNoFile.visible = true
                mediaView.visible = false
            }
        }
    }

    property var selectionMode: false
    property var selectionList: []
    property var selectionCount: 0

    function selectMedia(index) {
        selectionMode = true;
        selectionList.push(index);
        selectionCount++;
    }
    function deselectMedia(index) {
        var i = selectionList.indexOf(index);
        if (i > -1) { selectionList.splice(i, 1); selectionCount--; }
        if (selectionList.length === 0) selectionMode = false;
    }
    function exitSelectionMode() {
        if (selectionList.length === 0) return;

        for (var child in mediaView.contentItem.children) {
            if (mediaView.contentItem.children[child].selected) {
                mediaView.contentItem.children[child].selected = false;
            }
        }

        selectionMode = false;
        selectionList = [];
        selectionCount = 0;
    }
/*
    function updateSelectedMedia() {
        for (var child in mediaView.contentItem.children) {
            if (mediaView.contentItem.children[child].selected) {
                deviceManager.updateMedia(mediaView.contentItem.children[child].boxDevice.deviceAddress)
            }
        }
        exitSelectionMode()
    }
    function removeSelectedMedia() {
        var devicesAddr = [];
        for (var child in mediaView.contentItem.children) {
            if (mediaView.contentItem.children[child].selected) {
                devicesAddr.push(mediaView.contentItem.children[child].boxDevice.deviceAddress)
            }
        }
        for (var count = 0; count < devicesAddr.length; count++) {
            deviceManager.removeDevice(devicesAddr[count])
        }
        exitSelectionMode()
    }
*/
    property string pathToLoad: ""
    Timer {
        id: ttt
        interval: 1
        running: false
        repeat: false
        onTriggered: loadMedia2()
    }

    function loadMedia(path) {
        //console.log("loadMedia() << " + path)
        itemLoading.open()
        pathToLoad = path
        ttt.start()
    }
    function loadMedia2() {
        //console.log("loadMedia2() << " + pathToLoad)
        if (mediaManager.openMedia(pathToLoad) === true) {
            rectangleError.hideError()
            screenMediaInfos.loadMediaInfos(mediaManager.mediaList[0])
            appContent.state = "MediaInfos"
            itemLoading.close()
        } else {
            rectangleError.showError(pathToLoad)
            itemLoading.close()
        }
        pathToLoad = ""
    }

    ItemLoading {
        id: itemLoading
    }

    ////////////////////////////////////////////////////////////////////////////

    property bool dialogIsOpen: false
    property string dialogHeaderSaved: ""
    FileDialog {
        id: fileDialog
        title: qsTr("Media file selection")

        z: 10
        onAccepted: {
            //console.log("FileDialog::onAccepted() << " + fileUrl)
            loadMedia(UtilsPath.cleanUrl(fileUrl))
            appHeader.title = dialogHeaderSaved
            appHeader.leftMenuMode = "drawer"
            dialogIsOpen = false
        }
        onRejected: {
            //console.log("FileDialog::onRejected()")
            appHeader.title = dialogHeaderSaved
            appHeader.leftMenuMode = "drawer"
            dialogIsOpen = false
        }
    }
    function openDialog() {
        if (!dialogIsOpen) {
            dialogHeaderSaved = appHeader.title
            appHeader.title = qsTr("Media file selection")
            appHeader.leftMenuMode = "back"
            dialogIsOpen = true
            fileDialog.open()
        }
    }
    function closeDialog() {
        if (dialogIsOpen) {
            appHeader.title = dialogHeaderSaved
            appHeader.leftMenuMode = "drawer"
            dialogIsOpen = false
            fileDialog.close()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleHeader
        height: 0 // 96

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        z: 5
        visible: false
        color: Theme.colorForeground

        ImageSvg {
            id: image
            width: 64
            height: 64
            anchors.left: parent.left
            anchors.leftMargin: 32
            anchors.verticalCenter: parent.verticalCenter

            color: Theme.colorIcon
            fillMode: Image.PreserveAspectFit
            source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
        }

        ButtonWireframe {
            height: 40
            anchors.left: image.right
            anchors.leftMargin: 32
            anchors.verticalCenter: parent.verticalCenter

            primaryColor: Theme.colorPrimary
            text: qsTr("LOAD ANOTHER MEDIA")
            onClicked: openDialog()
        }

        Rectangle {
            height: 1
            color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    Rectangle {
        id: rectangleError
        height: 0 // 48
        anchors.top: rectangleHeader.bottom
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        z: 5
        visible: false
        color: Theme.colorActionbar

        ImageSvg {
            id: rectangleErrorImage
            width: 28
            height: 28
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            color: Theme.colorActionbarContent
            fillMode: Image.PreserveAspectFit
            source: "qrc:/assets/icons_material/baseline-warning-24px.svg"
        }

        Text {
            id: rectangleErrorText
            anchors.left: rectangleErrorImage.right
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            color: Theme.colorActionbarContent
            font.pixelSize: 15
            font.bold: true
        }

        Timer {
            id: rectangleErrorTimer
            interval: 8000 // 8s
            repeat: false
            onTriggered: rectangleError.hideError()
        }

        function showError(filename) {
            if (filename.length > 24)
                rectangleErrorText.text = qsTr("Cannot open this file :(")
            else
                rectangleErrorText.text = qsTr("Cannot open '%1'").arg(filename)

            rectangleError.visible = true
            rectangleError.height = 48
            rectangleErrorTimer.start()
        }
        function hideError() {
            rectangleError.visible = false
            rectangleError.height = 0
        }
    }

    ////////

    ItemNoFile {
        id: itemNoFile
        width: 200
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        visible: true
        onClicked: openDialog()
    }

    ////////

    ListView {
        id: mediaView
        anchors.top: rectangleError.bottom
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0

        visible: false
        model: mediaManager.mediaList
        delegate: MediaWidget { mediaItem: modelData; }
    }
}
