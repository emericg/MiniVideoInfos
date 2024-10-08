import QtCore
import QtQuick
import QtQuick.Controls

import ThemeEngine
import "qrc:/utils/UtilsPath.js" as UtilsPath

Item {
    id: screenMediaList
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    property bool selectionMode: false
    property var selectionList: []
    property int selectionCount: 0

    function selectMedia(index) {
        selectionMode = true
        selectionList.push(index)
        selectionCount++
    }
    function deselectMedia(index) {
        var i = selectionList.indexOf(index)
        if (i > -1) { selectionList.splice(i, 1); selectionCount--; }
        if (selectionList.length === 0) selectionMode = false
    }
    function exitSelectionMode() {
        if (selectionList.length === 0) return

        for (var child in mediaView.contentItem.children) {
            if (mediaView.contentItem.children[child].selected) {
                mediaView.contentItem.children[child].selected = false
            }
        }

        selectionMode = false
        selectionList = []
        selectionCount = 0
    }

    function updateSelectedMedia() {
        for (var child in mediaView.contentItem.children) {
            if (mediaView.contentItem.children[child].selected) {
                mediaManager.openMedia(mediaView.contentItem.children[child].mediaItem.fullpath)
            }
        }
        exitSelectionMode()
    }
    function removeSelectedMedia() {
        var mediaPaths = []
        for (var child in mediaView.contentItem.children) {
            if (mediaView.contentItem.children[child].selected) {
                mediaPaths.push(mediaView.contentItem.children[child].mediaItem.fullpath)
            }
        }
        for (var count = 0; count < mediaPaths.length; count++) {
            mediaManager.closeMedia(mediaPaths[count])
        }
        exitSelectionMode()
    }

    function backAction() {
        if (screenMediaList.dialogIsOpen) {
            screenMediaList.closeDialog()
            return
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    PopupLoading {
        id: popupLoading
    }

    property string pathToLoad: ""
    Timer {
        id: ttt
        interval: 66
        running: false
        repeat: false
        onTriggered: loadMedia2()
    }

    function loadMedia(path) {
        //console.log("loadMedia() << " + path)
        popupLoading.open()
        pathToLoad = path
        ttt.start()
    }
    function loadMedia2() {
        //console.log("loadMedia2() << " + pathToLoad)
        if (mediaManager.openMedia(pathToLoad) === true) {
            errorBar.hideError()
            screenMediaInfos.loadMediaInfos(mediaManager.mediaList[0])
            popupLoading.close()
        } else {
            errorBar.showError(pathToLoad)
            popupLoading.close()
        }
        pathToLoad = ""
    }

    ////////////////////////////////////////////////////////////////////////////

    property bool dialogIsOpen: false
    property string dialogHeaderSaved: utilsApp.appName()

    FileDialog { // custom chooser
        id: fileDialog
        anchors.fill: parent

        z: 10
        title: qsTr("Media file selection")

        onAccepted: (fileUrl) => {
            //console.log("FileDialog::onAccepted() << " + fileUrl)
            loadMedia(UtilsPath.cleanUrl(fileUrl))
            closeDialog()
        }
        onRejected: {
            //console.log("FileDialog::onRejected()")
            closeDialog()
        }
    }

    function openDialog() {
        //console.log("FileDialog::openDialog()")
        if (!dialogIsOpen) {
            if (Qt.platform.os === "android" && !fileDialog.usePlatformDialog) {
                dialogHeaderSaved = appHeader.headerTitle
                appHeader.headerTitle = qsTr("Media file selection")
                appHeader.leftMenuMode = "back"
                dialogIsOpen = true
            }
            if (isDesktop) {
                fileDialog.folder = StandardPaths.writableLocation(StandardPaths.HomeLocation)
            }
            fileDialog.open()
        }
    }
    function closeDialog() {
        //console.log("FileDialog::closeDialog()")
        if (dialogIsOpen) {
            if (Qt.platform.os === "android" && !fileDialog.usePlatformDialog) {
                appHeader.headerTitle = dialogHeaderSaved
                appHeader.leftMenuMode = "drawer"
                dialogIsOpen = false
            }
            fileDialog.close()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        id: bars
        anchors.left: parent.left
        anchors.right: parent.right
        z: 4

        Rectangle {
            id: actionBar
            anchors.left: parent.left
            anchors.right: parent.right

            clip: true
            color: Theme.colorActionbar
            height: (screenMediaList.selectionCount) ? 48 : 0
            Behavior on height { NumberAnimation { duration: 133 } }

            // prevent clicks below this area
            MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

            Row {
                anchors.left: parent.left
                anchors.leftMargin: isPhone ? 6 : 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: isPhone ? 6 : 12

                ButtonFlat {
                    id: buttonUpdate2
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorActionbarHighlight
                    text: qsTr("Update")
                    onClicked: updateSelectedMedia()
                    source: "qrc:/assets/icons/material-symbols/refresh.svg"
                }

                ButtonFlat {
                    id: buttonClose2
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorActionbarHighlight
                    text: qsTr("Close")
                    onClicked: removeSelectedMedia()
                    source: "qrc:/assets/icons/material-symbols/close.svg"
                }
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: isPhone ? 8 : 12
                anchors.verticalCenter: parent.verticalCenter
                spacing: isPhone ? 8 : 12

                Text {
                    id: textActions
                    anchors.verticalCenter: parent.verticalCenter
                    visible: (actionBar.width >= 560)

                    text: qsTr("%n media(s) selected", "", screenMediaList.selectionCount)
                    color: Theme.colorActionbarContent
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.bold: isDesktop ? true : false
                    font.pixelSize: Theme.fontSizeContent
                }
                RoundButtonIcon {
                    id: buttonClear
                    width: 36
                    height: 36
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons/material-symbols/subdirectory_arrow_left.svg"
                    iconColor: Theme.colorActionbarContent
                    backgroundColor: Theme.colorActionbarHighlight
                    onClicked: screenMediaList.exitSelectionMode()
                }
            }
        }

        Rectangle {
            id: errorBar
            anchors.left: parent.left
            anchors.right: parent.right

            clip: true
            color: Theme.colorError
            height: 0
            Behavior on height { NumberAnimation { duration: 133 } }

            // prevent clicks below this area
            MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

            IconSvg {
                id: rectangleErrorImage
                width: 28
                height: 28
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter

                color: Theme.colorActionbarContent
                source: "qrc:/assets/icons/material-symbols/warning.svg"
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

                errorBar.height = 48
                rectangleErrorTimer.start()
            }
            function hideError() {
                errorBar.height = 0
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ItemNoFile {
        id: itemNoFile
        anchors.centerIn: parent
        anchors.verticalCenterOffset: isDesktop ? -26 : -13

        visible: !mediaManager.mediaAvailable
        onClicked: openDialog()
    }

    ////////

    ListView {
        id: mediaView
        anchors.top: bars.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: mediaManager.mediaAvailable
        model: mediaManager.mediaList
        delegate: MediaWidget { mediaItem: modelData; }
    }

    ////////

    ButtonFab {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: Theme.componentMarginXL
        z: 10

        visible: mediaManager.mediaAvailable && !screenMediaList.dialogIsOpen
        source: "qrc:/assets/icons/material-symbols/add.svg"

        onClicked: {
            openDialog()
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
