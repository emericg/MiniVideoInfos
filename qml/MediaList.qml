import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0
import "qrc:/js/UtilsPath.js" as UtilsPath

Item {
    id: screenMediaList
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenPaddingLeft
    anchors.rightMargin: screenPaddingRight

    ////////////////////////////////////////////////////////////////////////////

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

    property bool selectionMode: false
    property var selectionList: []
    property int selectionCount: 0

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

    function updateSelectedMedia() {
        for (var child in mediaView.contentItem.children) {
            if (mediaView.contentItem.children[child].selected) {
                mediaManager.openMedia(mediaView.contentItem.children[child].mediaItem.fullpath)
            }
        }
        exitSelectionMode()
    }
    function removeSelectedMedia() {
        var mediaPaths = [];
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

    ////////////////////////////////////////////////////////////////////////////

    ItemLoading {
        id: itemLoading
    }

    property string pathToLoad: ""
    Timer {
        id: ttt
        interval: 150
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
        } else {
            errorBar.showError(pathToLoad)
            itemLoading.close()
        }
        pathToLoad = ""
    }

    ////////////////////////////////////////////////////////////////////////////

    property bool dialogIsOpen: false
    property string dialogHeaderSaved: appHeader.appName

    FileDialog {
        id: fileDialog
        anchors.fill: parent

        z: 10
        title: qsTr("Media file selection")

        onAccepted: {
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
                dialogHeaderSaved = appHeader.title
                appHeader.title = qsTr("Media file selection")
                appHeader.leftMenuMode = "back"
                dialogIsOpen = true
            }
            fileDialog.open()
        }
    }
    function closeDialog() {
        //console.log("FileDialog::closeDialog()")
        if (dialogIsOpen) {
            if (Qt.platform.os === "android" && !fileDialog.usePlatformDialog) {
                appHeader.title = dialogHeaderSaved
                appHeader.leftMenuMode = "drawer"
                dialogIsOpen = false
            }
            fileDialog.close()
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        z: 5
        height: visible ? 80 : 0
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
            anchors.verticalCenterOffset: -4

            source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
            fillMode: Image.PreserveAspectFit
            color: Theme.colorIcon
        }

        ButtonWireframe {
            height: 40
            anchors.left: image.right
            anchors.leftMargin: 32
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -4

            primaryColor: Theme.colorPrimary
            text: qsTr("OPEN ANOTHER MEDIA")
            onClicked: openDialog()
        }
    }

    Rectangle {
        id: fakeHeader
        anchors.top: parent.top
        anchors.topMargin: (itemLoading.visible || !rectangleHeader.visible) ? -3 : 80 - 3
        anchors.left: parent.left
        anchors.right: parent.right

        z: 4
        height: 4
        color: Theme.colorForeground

        Rectangle {
            height: 1
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
        }
        SimpleShadow {
            height: 4
            anchors.top: parent.bottom
            anchors.topMargin: -height
            anchors.left: parent.left
            anchors.leftMargin: -screenPaddingLeft
            anchors.right: parent.right
            anchors.rightMargin: -screenPaddingRight
            color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        id: bars
        anchors.top: rectangleHeader.bottom
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

                ButtonWireframeImage {
                    id: buttonUpdate2
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter

                    fullColor: true
                    primaryColor: Theme.colorActionbarHighlight
                    text: qsTr("Update")
                    onClicked: updateSelectedMedia()
                    source: "qrc:/assets/icons_material/baseline-refresh-24px.svg"
                }

                ButtonWireframeImage {
                    id: buttonClose2
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter

                    fullColor: true
                    primaryColor: Theme.colorActionbarHighlight
                    text: qsTr("Close")
                    onClicked: removeSelectedMedia()
                    source: "qrc:/assets/icons_material/baseline-close-24px.svg"
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
                ItemImageButton {
                    id: buttonClear
                    width: 36
                    height: 36
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-backspace-24px.svg"
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

        visible: true
        onClicked: openDialog()
    }

    ////////

    ListView {
        id: mediaView
        anchors.top: bars.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        visible: false
        model: mediaManager.mediaList
        delegate: MediaWidget { mediaItem: modelData; }
    }
}
