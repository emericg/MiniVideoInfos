import QtQuick
import QtQuick.Controls

import ThemeEngine

TextEdit {
    readOnly: true
    selectByMouse: isDesktop
    selectionColor: Theme.colorPrimary
    selectedTextColor: "white"

    color: Theme.colorText
    font.pixelSize: 15
    wrapMode: Text.WrapAnywhere
}
