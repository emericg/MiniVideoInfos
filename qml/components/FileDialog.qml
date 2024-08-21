import QtQuick
import "qrc:/utils/UtilsPath.js" as UtilsPath

Loader {
    id: fileDialog
    anchors.fill: parent

    property string title

    property url folder

    property bool useMediaFilter: false
    property bool usePlatformDialog: (isDesktop || settingsManager.mediaNativeFilePicker)

    property var fileDialogItem: null

    signal accepted(url fileUrl)
    signal rejected()

    ////////////////////////////////////////////////////////////////////////////

    // Emulate Qt6 'platform file/folder dialogs' API
    // https://doc.qt.io/qt-6/qml-qtquick-dialogs-filedialog.html
    // https://doc.qt.io/qt-6/qml-qtquick-dialogs-folderdialog.html
    //property int fileMode: FileDialog.SaveFile
    //property url currentFolder: settingsManager.exportDirectory_url
    //property url selectedFile: UtilsPath.makeUrl("log.txt")

    // Emulate Qt5 'quick dialogs' API
    // https://doc.qt.io/qt-5/qml-qtquick-dialogs-filedialog.html
    property bool sidebarVisible: true
    property bool selectExisting: true
    property bool selectFolder: false
    property bool selectMultiple: false

    ////////////////////////////////////////////////////////////////////////////

    active: true
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
                    return "FileDialog_quickdialogs6_folder.qml"
                else
                    return "FileDialog_quickdialogs6_file.qml"
            } else {
                return "FileDialog_mobile.qml"
            }
        } else {
            if (selectFolder)
                return "FileDialog_quickdialogs6_folder.qml"
            else
                return "FileDialog_quickdialogs6_file.qml"
        }
    }

    onLoaded: {
        fileDialogItem = item
    }

    Keys.onBackPressed: back()

    ////////////////////////////////////////////////////////////////////////////

    function openFilter(filter) {
        //console.log("FileDialog::openFilter(" + filter + ")")
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
        //console.log("FileDialog::open()")
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
        if (fileDialogItem) fileDialogItem.close()
        fileDialog.focus = false
    }

    function back() {
        //console.log("FileDialog::back()")
        if (Qt.platform.os === "android" && !usePlatformDialog) {
            if (fileDialogItem) fileDialogItem.onBackPressed()
        } else {
            close()
        }
    }

    ////////////////////////////////////////////////////////////////////////////
}
