import QtQuick 2.12
import QtQuick.Dialogs 1.3

FileDialog {
    id: fileDialogQuickDialogs

    // 'quick'
    // https://doc.qt.io/qt-5/qml-qtquick-dialogs-filedialog.html

    ////////////////////////////////////////////////////////////////////////////

    nameFilters: [
        qsTr("All files") + " (*)",
        //qsTr("Media files") + " (*.mp1 *.mp2 *.mp3 *.m4a *.mp4a *.m4r  *.aac *.mka *.wma *.amb *.wav *.wave *.flac *.ogg *.opus *.vorbis *.mov *.m4v *.mp4 *.mp4v *.3gp *.3gpp *.mkv *.webm *.avi *.divx *.asf *.wmv *.jpg *.jpeg *.webp *.png *.gpr *.gif *.heif *.heic *.avif *.bmp *.tga *.tif *.tiff *.svg)",
        //qsTr("Audio files") + " (*.mp1 *.mp2 *.mp3 *.m4a *.mp4a *.m4r *.aac *.mka *.wma *.amb *.wav *.wave *.flac *.ogg *.opus *.vorbis)",
        qsTr("Video files") + " (*.mov *.m4v *.mp4 *.mp4v *.3gp *.3gpp *.mkv *.webm *.avi *.divx *.asf *.wmv)",
        //qsTr("Image files") + " (*.jpg *.jpeg *.webp *.png *.gpr *.gif *.heif *.heic *.avif *.bmp *.tga *.tif *.tiff *.svg)"
    ]

    ////////////////////////////////////////////////////////////////////////////

    onAccepted: {
        fileDialog.accepted(fileUrl)
        fileDialog.close()
    }
    onRejected: {
        fileDialog.rejected()
        fileDialog.close()
    }
}
