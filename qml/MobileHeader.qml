import QtQuick 2.12

import ThemeEngine 1.0

Rectangle {
    width: parent.width
    height: screenStatusbarPadding + screenNotchPadding + headerHeight
    color: Theme.colorHeader
    z: 10

    property int headerHeight: 52
    property string appName: "MiniVideo Infos"
    property string title: "MiniVideo Infos"
    property string leftMenuMode: "drawer" // drawer / back / close

    signal leftMenuClicked()
    signal rightMenuClicked()

    onLeftMenuModeChanged: {
        if (leftMenuMode === "drawer")
            leftMenuImg.source = "qrc:/assets/icons_material/baseline-menu-24px.svg"
        else if (leftMenuMode === "close")
            leftMenuImg.source = "qrc:/assets/icons_material/baseline-close-24px.svg"
        else // back
            leftMenuImg.source = "qrc:/assets/icons_material/baseline-arrow_back-24px.svg"
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        height: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: (!isPhone && appContent.state === "MediaInfos")
        color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorSeparator : Theme.colorMaterialDarkGrey
    }

    // prevent clicks into this area
    MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; }

    Item {
        anchors.fill: parent
        anchors.topMargin: screenStatusbarPadding + screenNotchPadding

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 64
            anchors.verticalCenter: parent.verticalCenter

            text: title
            color: Theme.colorHeaderContent
            font.bold: false
            font.pixelSize: Theme.fontSizeHeader
            font.capitalization: Font.Capitalize
        }

        MouseArea {
            id: leftArea
            width: headerHeight
            height: headerHeight
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.bottom: parent.bottom

            visible: true
            onClicked: leftMenuClicked()

            ImageSvg {
                id: leftMenuImg
                width: headerHeight/2
                height: headerHeight/2
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter

                source: "qrc:/assets/icons_material/baseline-menu-24px.svg"
                color: Theme.colorHeaderContent
            }
        }

        ////////////

        MouseArea {
            id: rightArea
            width: headerHeight
            height: headerHeight
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            visible: false
            onClicked: rightMenuClicked()

            ImageSvg {
                id: rightMenuImg
                width: headerHeight/2
                height: headerHeight/2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                source: "qrc:/assets/icons_material/baseline-more_vert-24px.svg"
                color: Theme.colorHeaderContent
            }
        }
    }
}
