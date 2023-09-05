pragma Singleton

import QtQuick
import QtQuick.Controls.Material

Item {
    enum ThemeNames {
        THEME_LIGHT = 0,
        THEME_DARK = 1,

        THEME_LAST
    }
    property int currentTheme: -1

    ////////////////

    property bool isHdpi: (utilsScreen.screenDpi >= 128 || utilsScreen.screenPar >= 2.0)
    property bool isDesktop: (Qt.platform.os !== "ios" && Qt.platform.os !== "android")
    property bool isMobile: (Qt.platform.os === "ios" || Qt.platform.os === "android")
    property bool isPhone: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (utilsScreen.screenSize < 7.0))
    property bool isTablet: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (utilsScreen.screenSize >= 7.0))

    ////////////////

    // Status bar (mobile)
    property int themeStatusbar
    property color colorStatusbar

    // Header
    property color colorHeader
    property color colorHeaderContent
    property color colorHeaderHighlight

    // Sidebar (desktop)
    property color colorSidebar
    property color colorSidebarContent
    property color colorSidebarHighlight

    // Action bar
    property color colorActionbar
    property color colorActionbarContent
    property color colorActionbarHighlight

    // Tablet bar (mobile)
    property color colorTabletmenu
    property color colorTabletmenuContent
    property color colorTabletmenuHighlight

    // Content
    property color colorBackground
    property color colorForeground

    property color colorPrimary
    property color colorSecondary
    property color colorSuccess
    property color colorWarning
    property color colorError

    property color colorText
    property color colorSubText
    property color colorIcon
    property color colorSeparator

    property color colorLowContrast
    property color colorHighContrast

    // App specific

    ////////////////

    // Palette colors
    property color colorLightGreen: "#09debc"
    property color colorGreen
    property color colorDarkGreen: "#1ea892"
    property color colorBlue
    property color colorYellow
    property color colorOrange
    property color colorRed
    property color colorGrey: "#555151"
    property color colorLightGrey: "#a9bcb8"

    // Fixed colors
    readonly property color colorMaterialBlue: "#2196f3"
    readonly property color colorMaterialThisblue: "#448aff"
    readonly property color colorMaterialIndigo: "#3f51b5"
    readonly property color colorMaterialPurple: "#9c27b0"
    readonly property color colorMaterialDeepPurple: "#673ab7"
    readonly property color colorMaterialRed: "#f44336"
    readonly property color colorMaterialOrange: "#ff9800"
    readonly property color colorMaterialLightGreen: "#8bc34a"

    readonly property color colorMaterialLightGrey: "#f8f8f8"
    readonly property color colorMaterialGrey: "#eeeeee"
    readonly property color colorMaterialDarkGrey: "#ececec"

    readonly property color colorNeutralDay: "#e4e4e4"
    readonly property color colorNeutralNight: "#ffb300"

    ////////////////

    // Qt Quick Controls & theming
    property color colorComponent
    property color colorComponentText
    property color colorComponentContent
    property color colorComponentBorder
    property color colorComponentDown
    property color colorComponentBackground

    property int componentMargin: isHdpi ? 12 : 16
    property int componentMarginL: isHdpi ? 16 : 20
    property int componentMarginXL: isHdpi ? 20 : 24

    property int componentHeight: (isDesktop && isHdpi) ? 36 : 40
    property int componentHeightL: (isDesktop && isHdpi) ? 44 : 48
    property int componentHeightXL: (isDesktop && isHdpi) ? 48 : 56

    property int componentRadius: 4
    property int componentBorderWidth: 2

    property int componentFontSize: isMobile ? 14 : 15

    ////////////////

    // Fonts (sizes in pixel)
    readonly property int fontSizeHeader: isMobile ? 22 : 26
    readonly property int fontSizeTitle: isMobile ? 24 : 28
    readonly property int fontSizeContentVeryVerySmall: 10
    readonly property int fontSizeContentVerySmall: 12
    readonly property int fontSizeContentSmall: 14
    readonly property int fontSizeContent: 16
    readonly property int fontSizeContentBig: 18
    readonly property int fontSizeContentVeryBig: 20
    readonly property int fontSizeContentVeryVeryBig: 22

    ////////////////////////////////////////////////////////////////////////////

    Component.onCompleted: loadTheme(settingsManager.appTheme)
    Connections {
        target: settingsManager
        function onAppThemeChanged() { loadTheme(settingsManager.appTheme) }
    }

    function loadTheme(themeIndex) {
        //console.log("ThemeEngine.loadTheme(" + themeIndex + ")")

        if (themeIndex === "light") themeIndex = ThemeEngine.THEME_LIGHT
        if (themeIndex === "dark") themeIndex = ThemeEngine.THEME_DARK
        if (themeIndex >= ThemeEngine.THEME_LAST) themeIndex = 0

        if (settingsManager.appThemeAuto) {
            var rightnow = new Date()
            var hour = Qt.formatDateTime(rightnow, "hh")
            if (hour >= 21 || hour <= 8) {
                themeIndex = ThemeEngine.THEME_DARK
            }
        }

        // Do not reload the same theme
        if (themeIndex === currentTheme) return

        if (themeIndex === ThemeEngine.THEME_LIGHT) {

            colorGreen = "#07bf97"
            colorBlue = "#4CA1D5"
            colorYellow = "#ffba5a"
            colorOrange = "#ff863a"
            colorRed = "#ff523a"

            themeStatusbar = Material.Light
            colorStatusbar = "#e9e9e9" //colorMaterialDarkGrey

            colorHeader = "#e9e9e9" //colorMaterialGrey
            colorHeaderContent = "#0079fe"
            colorHeaderHighlight = "#ccc"

            colorActionbar = colorGreen
            colorActionbarContent = "white"
            colorActionbarHighlight = "#00a27d"

            colorTabletmenu = "#f3f3f3"
            colorTabletmenuContent = "#555555"
            colorTabletmenuHighlight = "#0079fe"

            colorBackground = colorMaterialLightGrey
            colorForeground = "#f0f0f0"

            colorPrimary = colorRed
            colorSecondary = "#ff7b36"
            colorSuccess = colorGreen
            colorWarning = colorOrange
            colorError = colorRed

            colorText = "#303030"
            colorSubText = "#666666"
            colorIcon = "#303030"
            colorSeparator = colorMaterialGrey
            colorLowContrast = "white"
            colorHighContrast = "black"

            colorComponent = "#f0f0f0"
            colorComponentText = "black"
            colorComponentContent = "black"
            colorComponentBorder = "#d0d0d0"
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
            colorHeaderHighlight = "#444"

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
