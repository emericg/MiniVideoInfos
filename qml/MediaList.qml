import QtQuick
import QtQuick.Controls

import ThemeEngine
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
        function onMediaUpdated() {
            if (mediaManager.areMediaAvailable()) {
                subheader.visible = true
                itemNoFile.visible = false
                mediaView.visible = true
            } else {
                subheader.visible = false
                itemNoFile.visible = true
                mediaView.visible = false
            }
        }
    }

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
        interval: 140
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
    property string dialogHeaderSaved: appHeader.appName

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

    Rectangle {
        id: subheader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        z: 5
        height: visible ? 68 : 0
        visible: false
        color: Theme.colorHeader

        // prevent clicks below this area
        MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

        IconSvg {
            id: image
            width: 64
            height: 64
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -2

            source: "qrc:/assets/icons_fontawesome/photo-video-duotone.svg"
            fillMode: Image.PreserveAspectFit
            color: Theme.colorIcon
            smooth: true
        }

        ButtonWireframe {
            height: 36
            anchors.left: image.right
            anchors.leftMargin: 32
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -2

            primaryColor: Theme.colorPrimary
            text: qsTr("OPEN ANOTHER MEDIA")
            onClicked: openDialog()
        }
    }
    Rectangle { // separator
        anchors.top: subheader.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        visible: subheader.visible
        height: 2
        opacity: 0.66
        color: Theme.colorHeaderHighlight

        Rectangle { // shadow
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: 8
            opacity: 0.66

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.colorHeaderHighlight; }
                GradientStop { position: 1.0; color: "transparent"; }
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Column {
        id: bars
        anchors.top: subheader.bottom
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

                ButtonWireframeIcon {
                    id: buttonUpdate2
                    height: 32
                    anchors.verticalCenter: parent.verticalCenter

                    fullColor: true
                    primaryColor: Theme.colorActionbarHighlight
                    text: qsTr("Update")
                    onClicked: updateSelectedMedia()
                    source: "qrc:/assets/icons_material/baseline-refresh-24px.svg"
                }

                ButtonWireframeIcon {
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
                RoundButtonIcon {
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
