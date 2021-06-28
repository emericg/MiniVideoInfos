pragma Singleton

import QtQuick 2.12
import QtQuick.Controls.Material 2.12

Item {
    enum ThemeNames {
        THEME_LIGHT = 0,
        THEME_DARK = 1,

        THEME_LAST
    }
    property int currentTheme: -1

    ////////////////

    property int themeStatusbar
    property string colorStatusbar

    // Header
    property string colorHeader
    property string colorHeaderContent
    property string colorHeaderHighlight

    // Sidebar
    property string colorSidebar
    property string colorSidebarContent
    property string colorSidebarHighlight

    // Action bar
    property string colorActionbar
    property string colorActionbarContent
    property string colorActionbarHighlight

    // Tablet bar
    property string colorTabletmenu
    property string colorTabletmenuContent
    property string colorTabletmenuHighlight

    // Content
    property string colorBackground
    property string colorForeground

    property string colorPrimary
    property string colorSecondary
    property string colorSuccess
    property string colorWarning
    property string colorError

    property string colorText
    property string colorSubText
    property string colorIcon
    property string colorSeparator

    property string colorLowContrast
    property string colorHighContrast

    // App specific

    // Qt Quick controls & theming
    property string colorComponent
    property string colorComponentText
    property string colorComponentContent
    property string colorComponentBorder
    property string colorComponentDown
    property string colorComponentBackground

    property int componentHeight: 40
    property int componentRadius: 4
    property int componentBorderWidth: 1

    ////////////////

    // Palette colors
    property string colorLightGreen: "#09debc" // unused
    property string colorGreen
    property string colorDarkGreen: "#1ea892" // unused
    property string colorBlue
    property string colorYellow
    property string colorOrange
    property string colorRed
    property string colorGrey: "#555151" // unused
    property string colorLightGrey: "#a9bcb8" // unused

    // Fixed colors
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
    readonly property int fontSizeHeader: (Qt.platform.os === "ios" || Qt.platform.os === "android") ? 22 : 24
    readonly property int fontSizeTitle: 24
    readonly property int fontSizeContentVerySmall: 12
    readonly property int fontSizeContentSmall: 14
    readonly property int fontSizeContent: 16
    readonly property int fontSizeContentBig: 18
    readonly property int fontSizeContentVeryBig: 20
    readonly property int fontSizeComponent: (Qt.platform.os === "ios" || Qt.platform.os === "android") ? 14 : 15

    ////////////////////////////////////////////////////////////////////////////

    Component.onCompleted: loadTheme(settingsManager.appTheme)
    Connections {
        target: settingsManager
        onAppThemeChanged: { loadTheme(settingsManager.appTheme) }
    }

    function loadTheme(themeIndex) {
        //console.log("ThemeEngine.loadTheme(" + themeIndex + ")")

        if (themeIndex === "light") themeIndex = ThemeEngine.THEME_LIGHT
        if (themeIndex === "dark") themeIndex = ThemeEngine.THEME_DARK
        if (themeIndex >= ThemeEngine.THEME_LAST) themeIndex = 0

        if (settingsManager.appThemeAuto) {
            var rightnow = new Date();
            var hour = Qt.formatDateTime(rightnow, "hh");
            if (hour >= 21 || hour <= 8) {
                themeIndex = ThemeEngine.THEME_DARK;
            }
        }

        if (themeIndex === currentTheme) return;

        if (themeIndex === ThemeEngine.THEME_LIGHT) {

            colorGreen = "#07bf97"
            colorBlue = "#4CA1D5"
            colorYellow = "#ffba5a"
            colorOrange = "#ff863a"
            colorRed = "#ff523a"

            themeStatusbar = Material.Light
            colorStatusbar = colorMaterialDarkGrey

            colorHeader = colorMaterialGrey
            colorHeaderContent = "#0079fe"
            colorHeaderHighlight = ""

            colorActionbar = colorGreen
            colorActionbarContent = "white"
            colorActionbarHighlight = "#00a27d"

            colorTabletmenu = "#f3f3f3"
            colorTabletmenuContent = "#9d9d9d"
            colorTabletmenuHighlight = "#0079fe"

            colorBackground = colorMaterialLightGrey
            colorForeground = colorMaterialGrey

            colorPrimary = colorRed
            colorSecondary = "#ff7b36"
            colorSuccess = colorGreen
            colorWarning = colorOrange
            colorError = colorRed

            colorText = "#303030"
            colorSubText = "#666666"
            colorIcon = "#494949"
            colorSeparator = colorMaterialGrey
            colorLowContrast = "white"
            colorHighContrast = "black"

            colorComponent = "#f0f0f0"
            colorComponentText = "black"
            colorComponentContent = "black"
            colorComponentBorder = "#c4c4c4"
            colorComponentDown = "#e0e0e0"
            colorComponentBackground = "white"

        } else if (themeIndex === ThemeEngine.THEME_DARK) {

            colorGreen = "#58CF77"
            colorBlue = "#4dceeb"
            colorYellow = "#fcc632"
            colorOrange = "#ff7657"
            colorRed = "#e8635a"

            themeStatusbar = Material.Dark
            colorStatusbar = "#292929"

            colorHeader = "#292929"
            colorHeaderContent = "#ee8c21"
            colorHeaderHighlight = ""

            colorActionbar = colorGreen
            colorActionbarContent = "white"
            colorActionbarHighlight = "#00a27d"

            colorTabletmenu = "#292929"
            colorTabletmenuContent = "#808080"
            colorTabletmenuHighlight = "#ff9f1a"

            colorBackground = "#313236"
            colorForeground = "#292929"

            colorPrimary = "#ff9f1a"
            colorSecondary = "#ffb81a"
            colorSuccess = colorGreen
            colorWarning = colorOrange
            colorError = colorRed

            colorText = "white"
            colorSubText = "#AAAAAA"
            colorIcon = "#cccccc"
            colorSeparator = "#404040"
            colorLowContrast = "black"
            colorHighContrast = "white"

            colorComponent = "#666666"
            colorComponentText = "#222222"
            colorComponentContent = "white"
            colorComponentBorder = "#666666"
            colorComponentDown = "#444444"
            colorComponentBackground = "#505050"

        }

        // This will emit the signal 'onCurrentThemeChanged'
        currentTheme = themeIndex
    }
}
