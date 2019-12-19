import QtQuick 2.9

Loader {
    id: fileDialog
    anchors.fill: parent
    Keys.onBackPressed:  (Qt.platform.os === "android" || Qt.platform.os === "ios") ? back() : close()
    source: (Qt.platform.os === "android" || Qt.platform.os === "ios") ? "FileDialog_QML.qml" : "FileDialog_Native.qml"

    property bool selectFolder: false
    property string title: ""
    //property bool sidebarVisible: false
    //property bool selectExisting: false
    //property bool selectMultiple: false

    signal accepted(url fileUrl)
    signal rejected()

    function open(filter) {
        fileDialog.item.folder = app.getStandardPath(filter);
        fileDialog.item.open();
        fileDialog.item.selectFolder = selectFolder;
        fileDialog.item.visible = true;
        fileDialog.focus = true;
    }

    function openFolder(folder) {
        fileDialog.item.folder = "file://" + folder;
        fileDialog.item.selectFolder = selectFolder;
        fileDialog.item.visible = true;
        fileDialog.item.open();
        fileDialog.focus = true;
    }

    function back() {
       if (Qt.platform.os === "android" || Qt.platform.os === "ios") {
            fileDialog.item.onBackPressed();
        } else {
            // ?
        }
    }

    function close() {
        fileDialog.item.visible = false;
        fileDialog.focus = false;
        rejected();
    }
}
