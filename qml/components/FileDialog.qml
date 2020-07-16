import QtQuick 2.12

Loader {
    id: fileDialog
    anchors.fill: parent

    property bool useMediaFilter: false //settingsManager.mediaFilter
    property bool usePlatformDialog: false //settingsManager.usePlatformDialog

    ////////

    // Mimick 'quick' API
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

    Keys.onBackPressed: (source === "FileDialog_QML.qml") ? back() : close()

    ////////

    function openFilter(filter) {
        fileDialog.item.title = title;
        fileDialog.item.folder = utilsApp.getStandardPath(filter);
        fileDialog.item.sidebarVisible = sidebarVisible;
        fileDialog.item.selectExisting = selectExisting;
        fileDialog.item.selectFolder = selectFolder;
        fileDialog.item.selectMultiple = selectMultiple;
        fileDialog.item.visible = true;
        fileDialog.item.open();
        fileDialog.focus = true;
    }

    function openFolder(folder) {
        fileDialog.item.title = title;
        fileDialog.item.folder = "file://" + folder;
        fileDialog.item.sidebarVisible = sidebarVisible;
        fileDialog.item.selectExisting = selectExisting;
        fileDialog.item.selectFolder = selectFolder;
        fileDialog.item.selectMultiple = selectMultiple;
        fileDialog.item.visible = true;
        fileDialog.item.open();
        fileDialog.focus = true;
    }

    function open() {
        fileDialog.item.title = title;
        fileDialog.item.folder = utilsApp.getStandardPath("");
        fileDialog.item.sidebarVisible = sidebarVisible;
        fileDialog.item.selectExisting = selectExisting;
        fileDialog.item.selectFolder = selectFolder;
        fileDialog.item.selectMultiple = selectMultiple;
        fileDialog.item.visible = true;
        fileDialog.item.open();
        fileDialog.focus = true;
    }

    function close() {
        fileDialog.item.visible = false;
        fileDialog.focus = false;
        rejected();
    }

    function back() {
       if (Qt.platform.os === "android" && !usePlatformDialog) {
            fileDialog.item.onBackPressed();
        } else {
            // ?
        }
    }
}
