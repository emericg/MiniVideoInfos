pragma Singleton
import QtQuick 2.9

Item {
    enum ThemeNames {
        THEME_LIGHT = 0,
        THEME_DARK = 1,

        THEME_LAST
    }
    property int currentTheme: -1

    ////////////////

    // Header
    property string colorHeader
    property string colorHeaderContent
    property string colorHeaderStatusbar

    // Sidebar
    property string colorSidebar
    property string colorSidebarContent

    // Action bar
    property string colorActionbar
    property string colorActionbarContent

    // Tablet bar
    property string colorTabletmenu
    property string colorTabletmenuContent
    property string colorTabletmenuHighlight

    // Content
    property string colorBackground
    property string colorForeground

    property string colorPrimary
    property string colorSecondary
    property string colorWarning // todo
    property string colorError // todo

    property string colorText
    property string colorSubText
    property string colorIcon
    property string colorSeparator
    property string colorHighContrast

    // Qt Quick controls & theming
    property string colorComponent
    property string colorComponentText
    property string colorComponentContent
    property string colorComponentBorder
    property string colorComponentDown
    property string colorComponentBackground
    property int componentRadius: 3
    property int componentHeight: 40

    ////////////////

    // Palette colors
    property string colorLightGreen: "#09debc" // unused
    property string colorGreen
    property string colorDarkGreen: "#1ea892" // unused
    property string colorBlue
    property string colorYellow
    property string colorRed
    property string colorGrey: "#555151" // unused
    property string colorLightGrey: "#a9bcb8" // unused

    // Fixed palette
    readonly property string colorMaterialBlue: "#2196f3" // colorMaterialThisblue
    readonly property string colorMaterialIndigo: "#3f51b5"
    readonly property string colorMaterialPurple: "#9c27b0"
    readonly property string colorMaterialDeepPurple: "#673ab7"
    readonly property string colorMaterialRed: "#f44336"
    readonly property string colorMaterialOrange: "#ff9800"
    readonly property string colorMaterialLightGreen: "#8bc34a"

    readonly property string colorMaterialDarkGrey: "#d0d0d0"
    readonly property string colorMaterialGrey: "#eeeeee"
    readonly property string colorMaterialLightGrey: "#fafafa"
    readonly property string colorMaterialThisblue: "#448aff"

    // ios blue "#077aff"
    // ios red "#ff3b30"
    // ios grey "#f8f8f8"

    ////////////////

    // Fonts (sizes in pixel) (WIP)
    readonly property int fontSizeHeader: (Qt.platform.os === "ios" || Qt.platform.os === "android") ? 24 : 26
    readonly property int fontSizeTitle: 24
    readonly property int fontSizeContentBig: 18
    readonly property int fontSizeContent: 16
    readonly property int fontSizeContentSmall: 14

    ////////////////////////////////////////////////////////////////////////////

    Component.onCompleted: loadTheme(settingsManager.appTheme)
    Connections {
        target: settingsManager
        onAppthemeChanged: loadTheme(settingsManager.appTheme)
    }

    function loadTheme(themeIndex) {
        //console.log("ThemeEngine.loadTheme(" + themeIndex + ")")

        if (themeIndex === "light") themeIndex = ThemeEngine.THEME_LIGHT
        else if (themeIndex === "dark") themeIndex = ThemeEngine.THEME_DARK
        else themeIndex = 0
        if (themeIndex >= ThemeEngine.THEME_LAST) themeIndex = 0

        if (settingsManager.autoDark) {
            var rightnow = new Date();
            var hour = Qt.formatDateTime(rightnow, "hh");
            if (hour >= 21 || hour <= 8) {
                themeIndex = ThemeEngine.THEME_DARK;
            }
        }

        if (currentTheme === themeIndex) return;

        if (themeIndex === ThemeEngine.THEME_LIGHT) {

            colorGreen = "#07bf97"
            colorBlue = "#4CA1D5"
            colorYellow = "#ffba5a"
            colorRed = "#ff7657"

            colorHeader = colorMaterialGrey
            colorHeaderStatusbar = colorMaterialDarkGrey
            colorHeaderContent = "#5483EF" // colorMaterialBlue

            colorActionbar = colorRed
            colorActionbarContent = "white"

            colorTabletmenu = "#f3f3f3"
            colorTabletmenuContent = "#9d9d9d"
            colorTabletmenuHighlight = "#0079fe"

            colorBackground = colorMaterialLightGrey
            colorForeground = colorMaterialGrey

            colorPrimary = colorMaterialRed
            colorSecondary = "#ff7b36" // colorMaterialOrange

            colorText = "#303030"
            colorSubText = "#666666"
            colorIcon = "#494949"
            colorSeparator = colorMaterialGrey
            colorHighContrast = "black"

            colorComponent = "#eaeaea"
            colorComponentText = "black"
            colorComponentContent = "black"
            colorComponentBorder = "#b3b3b3"
            colorComponentDown = "#cacaca"
            colorComponentBackground = colorBackground
            componentRadius = 4

        } else if (themeIndex === ThemeEngine.THEME_DARK) {

            colorGreen = "#58CF77"
            colorBlue = "#4dceeb"
            colorYellow = "#fcc632"
            colorRed = "#e8635a"

            colorHeader = "#292929"
            colorHeaderStatusbar = "#292929"
            colorHeaderContent = "#ee8c21"

            colorActionbar = colorRed
            colorActionbarContent = "white"

            colorTabletmenu = "#292929"
            colorTabletmenuContent = "#808080"
            colorTabletmenuHighlight = "#bb86fc"

            colorBackground = "#313236"
            colorForeground = "#292929"

            colorPrimary = "#ff9f1a"
            colorSecondary = "#ffb81a"

            colorText = "white"
            colorSubText = "#AAAAAA"
            colorIcon = "#cccccc"
            colorSeparator = "#404040"
            colorHighContrast = "white"

            colorComponent = "#666666"
            colorComponentText = "#222222"
            colorComponentContent = "white"
            colorComponentBorder = "#666666"
            colorComponentDown = "#444444"
            colorComponentBackground = "#505050"
            componentRadius = 4

        }

        // This will emit the signal 'onCurrentThemeChanged'
        currentTheme = themeIndex
    }
}
