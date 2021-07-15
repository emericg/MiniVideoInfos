import QtQuick 2.12
import "qrc:/js/UtilsPath.js" as UtilsPath

Loader {
    id: fileDialog
    anchors.fill: parent

    property bool useMediaFilter: false
    property bool usePlatformDialog: false

    ////////

    // Emulate 'quick dialogs' API
    // https://doc.qt.io/qt-5/qml-qtquick-dialogs-filedialog.html
    property string title: ""
    property bool sidebarVisible: true
    property bool selectExisting: true
    property bool selectFolder: false
    property bool selectMultiple: false

    property url folder

    signal accepted(url fileUrl)
    signal rejected()

    ////////////////////////////////////////////////////////////////////////////

    property var fileDialogItem: null
    asynchronous: true
    source: {
        if (Qt.platform.os === "ios") {
            usePlatformDialog = true
            if (selectFolder)
                return "FileDialog_platformfolder.qml"
            else
                return "FileDialog_platformfile.qml"
        } else if (Qt.platform.os === "android") {
            if (usePlatformDialog) {
                if (selectFolder)
                    return "FileDialog_platformfolder.qml"
                else
                    return "FileDialog_platformfile.qml"
            } else {
                return "FileDialog_mobile.qml"
            }
        } else {
            if (usePlatformDialog) {
                if (selectFolder)
                    return "FileDialog_platformfolder.qml"
                else
                    return "FileDialog_platformfile.qml"
             } else {
                return "FileDialog_quickdialogs.qml"
            }
        }
    }

    onLoaded: {
        fileDialogItem = item
    }

    ////////////////////////////////////////////////////////////////////////////

    function openFilter(filter) {
        //console.log("FileDialog::penFilter(" + filter + ")")
        if (title) fileDialogItem.title = title
        fileDialogItem.folder = utilsApp.getStandardPath_url(filter)

        fileDialogItem.sidebarVisible = sidebarVisible
        fileDialogItem.selectExisting = selectExisting
        fileDialogItem.selectFolder = selectFolder
        fileDialogItem.selectMultiple = selectMultiple
        fileDialogItem.open()
        fileDialog.focus = true
    }

    function openFolder(folder) {
        //console.log("FileDialog::openFolder(" + folder + ")")
        if (title) fileDialogItem.title = title
        fileDialogItem.folder = UtilsPath.makeUrl(folder)

        fileDialogItem.sidebarVisible = sidebarVisible
        fileDialogItem.selectExisting = selectExisting
        fileDialogItem.selectFolder = selectFolder
        fileDialogItem.selectMultiple = selectMultiple
        fileDialogItem.open()
        fileDialog.focus = true
    }

    function open() {
        console.log("FileDialog::open()")
        if (title) fileDialogItem.title = title
        if (folder.toString().length) fileDialogItem.folder = UtilsPath.makeUrl(folder)
        else fileDialogItem.folder = utilsApp.getStandardPath_url("")

        fileDialogItem.sidebarVisible = sidebarVisible
        fileDialogItem.selectExisting = selectExisting
        fileDialogItem.selectFolder = selectFolder
        fileDialogItem.selectMultiple = selectMultiple
        fileDialogItem.open()
        fileDialog.focus = true
    }

    function close() {
        //console.log("FileDialog::close()")
        fileDialogItem.close()
        fileDialog.focus = false
    }

    Keys.onBackPressed: back()

    function back() {
        //console.log("FileDialog::back()")
        if (Qt.platform.os === "android" && !usePlatformDialog) {
            fileDialogItem.onBackPressed()
        } else {
            close()
        }
    }
}
