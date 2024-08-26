import QtQuick

import ThemeEngine

Rectangle {
    id: appHeader

    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    height: headerHeight + Math.max(screenPaddingStatusbar, screenPaddingTop)
    color: Theme.colorHeader
    clip: true
    z: 10

    property int headerHeight: 52

    property int headerPosition: 56

    property string headerTitle: "MiniVideo Infos"

    ////////////////////////////////////////////////////////////////////////////

    property string leftMenuMode: "drawer" // drawer / back / close
    signal leftMenuClicked()

    property string rightMenuMode: "off" // on / off
    signal rightMenuClicked()

    function rightMenuIsOpen() { return actionMenu.visible; }
    function rightMenuClose() { actionMenu.close(); }

    ////////////////////////////////////////////////////////////////////////////

    // prevent clicks below this area
    MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

    ActionMenu_bottom {
        id: actionMenu
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle { // OS statusbar area
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        height: Math.max(screenPaddingStatusbar, screenPaddingTop)
        color: Theme.colorStatusbar
    }

    Item {
        anchors.fill: parent
        anchors.topMargin: Math.max(screenPaddingStatusbar, screenPaddingTop)
        anchors.leftMargin: screenPaddingLeft
        anchors.rightMargin: screenPaddingRight

        ////////////

        Row { // left area
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.leftMargin: 4
            anchors.bottom: parent.bottom

            spacing: 4

            ////

            MouseArea { // left button
                width: headerHeight
                height: headerHeight

                visible: true
                onClicked: leftMenuClicked()

                RippleThemed {
                    anchors.fill: parent
                    anchor: parent

                    pressed: parent.pressed
                    //active: enabled && parent.containsPress
                    color: Qt.rgba(Theme.colorHeaderHighlight.r, Theme.colorHeaderHighlight.g, Theme.colorHeaderHighlight.b, 0.33)
                }

                IconSvg {
                    anchors.centerIn: parent
                    width: (headerHeight / 2)
                    height: (headerHeight / 2)

                    source: {
                        if (leftMenuMode === "drawer") return "qrc:/assets/icons/material-symbols/menu.svg"
                        if (leftMenuMode === "close") return "qrc:/assets/icons/material-symbols/close.svg"
                        return "qrc:/assets/icons/material-symbols/arrow_back.svg"
                    }
                    color: Theme.colorHeaderContent
                }
            }

            ////
        }

        ////////////

        Text { // header title
            anchors.left: parent.left
            anchors.leftMargin: headerPosition
            anchors.right: rightArea.left
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter

            text: headerTitle
            textFormat: Text.PlainText
            color: Theme.colorHeaderContent
            font.bold: false
            font.pixelSize: Theme.fontSizeHeader
            font.capitalization: Font.Capitalize
            verticalAlignment: Text.AlignVCenter
        }

        ////////////

        Row { // right area
            id: rightArea
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.bottom: parent.bottom

            spacing: 4

            ////

            MouseArea { // right button
                width: headerHeight
                height: headerHeight

                visible: false

                onClicked: {
                    rightMenuClicked()
                    actionMenu.open()
                }

                RippleThemed {
                    anchors.fill: parent
                    anchor: parent

                    pressed: parent.pressed
                    //active: enabled && parent.containsPress
                    color: Qt.rgba(Theme.colorHeaderHighlight.r, Theme.colorHeaderHighlight.g, Theme.colorHeaderHighlight.b, 0.33)
                }

                IconSvg {
                    anchors.centerIn: parent
                    width: (headerHeight / 2)
                    height: (headerHeight / 2)

                    source: "qrc:/assets/icons/material-symbols/more_vert.svg"
                    color: Theme.colorHeaderContent
                }
            }

            ////
        }

        ////////////
    }

    ////////////////////////////////////////////////////////////////////////////
}
