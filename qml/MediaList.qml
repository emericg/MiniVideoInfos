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
                itemNoFile.visible = false
                mediaView.visible = true
            } else {
                rectangleHeader.visible = false
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
                mediaManager.updateMedia(mediaView.contentItem.children[child].boxDevice.deviceAddress)
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
            mediaManager.removeDevice(devicesAddr[count])
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
            errorBar.hideError()
            screenMediaInfos.loadMediaInfos(mediaManager.mediaList[0])
            itemLoading.close()
            appContent.state = "MediaInfos"
        } else {
            errorBar.showError(pathToLoad)
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

            if (Qt.platform.os === "android" && !fileDialog.usePlatformDialog) {
                appHeader.title = dialogHeaderSaved
                appHeader.leftMenuMode = "drawer"
                dialogIsOpen = false
            }
        }
        onRejected: {
            //console.log("FileDialog::onRejected()")
            if (Qt.platform.os === "android" && !fileDialog.usePlatformDialog) {
                appHeader.title = dialogHeaderSaved
                appHeader.leftMenuMode = "drawer"
                dialogIsOpen = false
            }
        }
    }
    function openDialog() {
        if (!dialogIsOpen) {
            if (Qt.platform.os === "android" && !fileDialog.usePlatformDialog) {
                dialogHeaderSaved = appHeader.title
                appHeader.title = qsTr("Media file selection")
                appHeader.leftMenuMode = "back"
                dialogIsOpen = true
            }
            fileDialog.open()
        }
    }
    function closeDialog() {
        if (dialogIsOpen) {
            if (Qt.platform.os === "android" && !fileDialog.usePlatformDialog) {
                appHeader.title = dialogHeaderSaved
                appHeader.leftMenuMode = "drawer"
                dialogIsOpen = false
            }
        }
        fileDialog.close()
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        id: bars
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        z: 5

        Rectangle {
            id: rectangleHeader
            anchors.left: parent.left
            anchors.right: parent.right

            height: 80
            visible: false
            color: Theme.colorForeground

            // prevent clicks into this area
            MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

            ImageSvg {
                id: image
                width: 64
                height: 64
                anchors.left: parent.left
                anchors.leftMargin: 16
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
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
            }
        }

        Rectangle {
            id: actionBar
            anchors.left: parent.left
            anchors.right: parent.right

            height: 48
            color: Theme.colorActionbar
            visible: (screenMediaList.selectionCount)

            // prevent clicks into this area
            MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                ItemImageButton {
                    id: buttonClear
                    width: 36
                    height: 36
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-close-24px.svg"
                    iconColor: Theme.colorActionbarContent
                    backgroundColor: Theme.colorActionbarHighlight
                    onClicked: screenMediaList.exitSelectionMode()
                }

                Text {
                    id: textActions
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("%n media(s) selected", "", screenMediaList.selectionCount)
                    color: Theme.colorActionbarContent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.bold: isDesktop ? true : false
                    font.pixelSize: 16
                }
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                property bool useBigButtons: (!isPhone && actionBar.width >= 560)

                ItemImageButton {
                    id: buttonClose1
                    width: 36
                    height: 36
                    anchors.verticalCenter: parent.verticalCenter

                    visible: !parent.useBigButtons
                    iconColor: Theme.colorActionbarContent
                    backgroundColor: Theme.colorActionbarHighlight
                    //onClicked:
                    source: "qrc:/assets/icons_material/baseline-close-24px.svg"
                }
                ButtonWireframeImage {
                    id: buttonClose2
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter

                    visible: parent.useBigButtons
                    fullColor: true
                    primaryColor: Theme.colorActionbarHighlight
                    text: qsTr("Close")
                    //onClicked:
                    source: "qrc:/assets/icons_material/baseline-close-24px.svg"
                }
            }
        }

        Rectangle {
            id: errorBar
            anchors.left: parent.left
            anchors.right: parent.right

            height: 48
            visible: false
            color: Theme.colorError

            // prevent clicks into this area
            MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

            ImageSvg {
                id: rectangleErrorImage
                width: 28
                height: 28
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter

                color: Theme.colorActionbarContent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/assets/icons_material/baseline-warning-24px.svg"
            }

            Text {
                id: rectangleErrorText
                anchors.left: rectangleErrorImage.right
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter

                color: Theme.colorActionbarContent
                font.pixelSize: 15
                font.bold: true
            }

            Timer {
                id: rectangleErrorTimer
                interval: 8000 // 8s
                repeat: false
                onTriggered: errorBar.hideError()
            }

            function showError(filename) {
                if (filename.length > 24)
                    rectangleErrorText.text = qsTr("Cannot open this file :(")
                else
                    rectangleErrorText.text = qsTr("Cannot open '%1'").arg(filename)

                errorBar.visible = true
                errorBar.height = 48
                rectangleErrorTimer.start()
            }
            function hideError() {
                errorBar.visible = false
                errorBar.height = 0
            }
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
        anchors.top: bars.bottom
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
