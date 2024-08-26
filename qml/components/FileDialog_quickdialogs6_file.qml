import QtQuick
import QtQuick.Dialogs

FileDialog {
    id: fileDialogPlatformFile

    // https://doc.qt.io/qt-6/qml-qtquick-dialogs-filedialog.html

    // compatibility
    property url folder: ""
    property bool sidebarVisible: true // not supported
    property bool selectExisting: true
    property bool selectFolder: false // not supported
    property bool selectMultiple: false

    ////////////////////////////////////////////////////////////////////////////

    currentFolder: folder

    fileMode: {
        if (!selectExisting)
            return FileDialog.SaveFile
        else if (selectMultiple)
            return FileDialog.OpenFiles
        else // if (selectExisting)
            return FileDialog.OpenFile
    }

    nameFilters: [
        qsTr("All files") + " (*)",
        qsTr("Media files") + " (*.mp1 *.mp2 *.mp3 *.m4a *.mp4a *.m4r  *.aac *.mka *.wma *.amb *.wav *.wave *.flac *.ogg *.opus *.vorbis *.mov *.m4v *.mp4 *.mp4v *.3gp *.3gpp *.mkv *.webm *.avi *.divx *.asf *.wmv *.jpg *.jpeg *.webp *.png *.gpr *.gif *.heif *.heic *.avif *.bmp *.tga *.tif *.tiff *.svg)",
        qsTr("Audio files") + " (*.mp1 *.mp2 *.mp3 *.m4a *.mp4a *.m4r *.aac *.mka *.wma *.amb *.wav *.wave *.flac *.ogg *.opus *.vorbis)",
        qsTr("Video files") + " (*.mov *.m4v *.mp4 *.mp4v *.3gp *.3gpp *.mkv *.webm *.avi *.divx *.asf *.wmv)",
        qsTr("Image files") + " (*.jpg *.jpeg *.webp *.png *.gpr *.gif *.heif *.heic *.avif *.bmp *.tga *.tif *.tiff *.svg)"
    ]

    ////////////////////////////////////////////////////////////////////////////

    onAccepted: {
        //if (Qt.platform.os === "android") file = utilsShare.getPathFromURI(selectedFile)

        if (selectMultiple) fileDialog.accepted(selectedFiles)
        else fileDialog.accepted(selectedFile)
        fileDialog.close()
    }
    onRejected: {
        fileDialog.rejected()
        fileDialog.close()
    }

    ////////////////////////////////////////////////////////////////////////////
}
