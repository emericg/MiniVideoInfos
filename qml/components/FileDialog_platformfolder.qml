import QtQuick 2.15
import Qt.labs.platform 1.1

FolderDialog {
    id: fileDialogPlatformFolder

    // 'platform'
    // https://doc.qt.io/qt-5/qml-qt-labs-platform-folderdialog.html

    // compatibility
    property bool sidebarVisible: true // not supported
    property bool selectExisting: true
    property bool selectFolder: false
    property bool selectMultiple: false

    property var fileMode // not supported
    property var nameFilters // not supported

    ////////////////////////////////////////////////////////////////////////////

    //acceptLabel : string
    //currentFolder : url
    //folder : url
    //options : flags
    //rejectLabel : string

    ////////////////////////////////////////////////////////////////////////////

    onAccepted: {
        fileDialog.accepted(currentFolder)
        fileDialog.close()
    }
    onRejected: {
        fileDialog.rejected()
        fileDialog.close()
    }
}
