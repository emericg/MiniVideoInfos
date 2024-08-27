import QtQuick

import ThemeEngine

Grid {
    id: item_parBox

    height: 80
    rows: 3
    columns: 3

    ////////

    property int www: 1 * (item_parBox.height/3)
    property int hhh: 1 * (item_parBox.height/3)

    Rectangle { width: parent.www; height: parent.hhh; color: "#9377a6"; }
    Rectangle { width: parent.www; height: parent.hhh; color: "#dda1be"; }
    Rectangle { width: parent.www; height: parent.hhh; color: "#ffa6ca"; }
    Rectangle { width: parent.www; height: parent.hhh; color: "#707cad"; }
    Rectangle { width: parent.www; height: parent.hhh; color: "#9593b5";
                border.width: 2; border.color: "white"; }
    Rectangle { width: parent.www; height: parent.hhh; color: "#c99fc7"; }
    Rectangle { width: parent.www; height: parent.hhh; color: "#6f77a4"; }
    Rectangle { width: parent.www; height: parent.hhh; color: "#7784ad"; }
    Rectangle { width: parent.www; height: parent.hhh; color: "#8e97c1"; }

    ////////
}
