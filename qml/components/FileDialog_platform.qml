import QtQuick 2.12
import Qt.labs.platform 1.1

FileDialog {
    id: fileDialogPlatform

    // 'platform'
    // https://doc.qt.io/qt-5/qml-qt-labs-platform-filedialog.html

    // compatibility
    property bool sidebarVisible: true // not supported
    property bool selectExisting: true
    property bool selectFolder: false // not supported
    property bool selectMultiple: false

    fileMode: {
        if (!selectExisting)
            return FileDialog.SaveFile
        else if (selectMultiple)
            return FileDialog.OpenFiles
        else // if (selectExisting)
            return FileDialog.OpenFile
    }

    nameFilters: [qsTr("All files") + " (*)",
        qsTr("Media files") + " (*.mp1 *.mp2 *.mp3 *.m4a *.mp4a *.m4r  *.aac *.mka *.wma *.amb *.wav *.wave *.flac *.ogg *.opus *.vorbis *.mov *.m4v *.mp4 *.mp4v *.3gp *.3gpp *.mkv *.webm *.avi *.divx *.asf *.wmv *.jpg *.jpeg *.webp *.png *.gpr *.gif *.heif *.heic *.avif *.bmp *.tga *.tif *.tiff *.svg)",
        qsTr("Audio files") + " (*.mp1 *.mp2 *.mp3 *.m4a *.mp4a *.m4r *.aac *.mka *.wma *.amb *.wav *.wave *.flac *.ogg *.opus *.vorbis)",
        qsTr("Video files") + " (*.mov *.m4v *.mp4 *.mp4v *.3gp *.3gpp *.mkv *.webm *.avi *.divx *.asf *.wmv)",
        qsTr("Image files") + " (*.jpg *.jpeg *.webp *.png *.gpr *.gif *.heif *.heic *.avif *.bmp *.tga *.tif *.tiff *.svg)"]

    onAccepted: {
        fileDialog.accepted(file);
        fileDialog.close();
    }
    onRejected: {
        fileDialog.rejected();
        fileDialog.close();
    }
}
