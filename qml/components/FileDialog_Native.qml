import QtQuick 2.9
import QtQuick.Dialogs 1.3

FileDialog {

    nameFilters: [qsTr("All files") + " (*)",
        qsTr("Media files") + " (*.mp1 *.mp2 *.mp3 *.m4a *.mp4a *.aac *.mka *.wma *.wav *.wave *.ogg *.opus *.vorbis *.mov *.m4v *.mp4 *.mp4v *.3gp *.3gpp *.mkv *.webm *.avi *.divx *.asf *.wmv *.jpg *.jpeg *.webp *.png *.gpr *.gif *.heif *.heic *.avif *.bmp *.tga *.tif *.tiff *.svg)",
        qsTr("Audio files") + " (*.mp1 *.mp2 *.mp3 *.m4a *.mp4a *.aac *.mka *.wma *.wav *.wave *.ogg *.opus *.vorbis)",
        qsTr("Video files") + " (*.mov *.m4v *.mp4 *.mp4v *.3gp *.3gpp *.mkv *.webm *.avi *.divx *.asf *.wmv)",
        qsTr("Image files") + " (*.jpg *.jpeg *.webp *.png *.gpr *.gif *.heif *.heic *.avif *.bmp *.tga *.tif *.tiff *.svg)"]

    onAccepted: {
        fileDialog.accepted(fileUrl);
        fileDialog.close();
    }
    onRejected: {
        fileDialog.rejected();
        fileDialog.close();
    }
}
