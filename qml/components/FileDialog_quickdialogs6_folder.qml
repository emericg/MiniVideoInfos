import QtQuick
import QtQuick.Dialogs

FolderDialog {
    id: fileDialogPlatformFolder

    // https://doc.qt.io/qt-6/qml-qtquick-dialogs-folderdialog.html

    // compatibility
    property url folder: ""
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
        fileDialog.accepted(selectedFolder)
        fileDialog.close()
    }
    onRejected: {
        fileDialog.rejected()
        fileDialog.close()
    }

    ////////////////////////////////////////////////////////////////////////////
}
