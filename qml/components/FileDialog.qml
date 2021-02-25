import QtQuick 2.12

Loader {
    id: fileDialog
    anchors.fill: parent

    property bool useMediaFilter: false //settingsManager.mediaFilter
    property bool usePlatformDialog: false //settingsManager.usePlatformDialog

    ////////

    // Emulate 'quick dialogs' API
    // https://doc.qt.io/qt-5/qml-qtquick-dialogs-filedialog.html
    property var title: ""
    property bool sidebarVisible: true
    property bool selectExisting: true
    property bool selectFolder: false
    property bool selectMultiple: false

    signal accepted(url fileUrl)
    signal rejected()

    ////////

    source: {
        if (Qt.platform.os === "ios") {
            usePlatformDialog = true
            return "FileDialog_platform.qml"
        } else if (Qt.platform.os === "android") {
            if (usePlatformDialog)
                return "FileDialog_platform.qml"
            else
                return "FileDialog_QML.qml"
        } else {
            if (usePlatformDialog)
                return "FileDialog_platform.qml"
            else
                return "FileDialog_quick.qml"
        }
    }

    Keys.onBackPressed: back()

    ////////

    function openFilter(filter) {
        //console.log("openFilter(" + filter + ")")
        fileDialog.item.title = title
        fileDialog.item.folder = utilsApp.getStandardPath_url(filter)
        fileDialog.item.sidebarVisible = sidebarVisible
        fileDialog.item.selectExisting = selectExisting
        fileDialog.item.selectFolder = selectFolder
        fileDialog.item.selectMultiple = selectMultiple
        fileDialog.item.visible = true
        fileDialog.item.open()
        fileDialog.focus = true
    }

    function openFolder(folder) {
        //console.log("openFolder(" + folder + ")")
        fileDialog.item.title = title
        fileDialog.item.folder = "file://" + folder
        fileDialog.item.sidebarVisible = sidebarVisible
        fileDialog.item.selectExisting = selectExisting
        fileDialog.item.selectFolder = selectFolder
        fileDialog.item.selectMultiple = selectMultiple
        fileDialog.item.visible = true
        fileDialog.item.open()
        fileDialog.focus = true
    }

    function open() {
        //console.log("open()")
        fileDialog.item.title = title
        fileDialog.item.folder = utilsApp.getStandardPath_url("")
        fileDialog.item.sidebarVisible = sidebarVisible
        fileDialog.item.selectExisting = selectExisting
        fileDialog.item.selectFolder = selectFolder
        fileDialog.item.selectMultiple = selectMultiple
        fileDialog.item.visible = true
        fileDialog.item.open()
        fileDialog.focus = true
    }

    function close() {
        //console.log("close()")
        fileDialog.item.visible = false
        fileDialog.focus = false
        rejected()
    }

    function back() {
        //console.log("back()")
        if (Qt.platform.os === "android" && !usePlatformDialog) {
            fileDialog.item.onBackPressed()
        } else {
            close()
        }
    }
}
