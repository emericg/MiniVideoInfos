import QtQuick 2.15
import QtQuick.Controls 2.15

import ThemeEngine 1.0

TextEdit {
    readOnly: true
    selectByMouse: true
    selectionColor: Theme.colorPrimary
    color: Theme.colorText
    font.pixelSize: 15
    wrapMode: Text.WrapAnywhere
}
