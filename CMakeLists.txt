cmake_minimum_required(VERSION 3.20)

project(MiniVideoInfos VERSION 0.10 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(APP_NAME ${CMAKE_PROJECT_NAME})
set(APP_VERSION ${CMAKE_PROJECT_VERSION})

################################################################################

message(STATUS "[CMAKE]   CMAKE_VERSION             = ${CMAKE_VERSION}")
message(STATUS "[CMAKE]   CMAKE_PREFIX_PATH         = ${CMAKE_PREFIX_PATH}")
message(STATUS "[SYSTEM]  (HOST) SYSTEM NAME        = ${CMAKE_HOST_SYSTEM_NAME}")
message(STATUS "[SYSTEM]  (HOST) SYSTEM VERSION     = ${CMAKE_HOST_SYSTEM_VERSION}")
message(STATUS "[SYSTEM]  (TARGET) SYSTEM NAME      = ${CMAKE_SYSTEM_NAME}")
message(STATUS "[SYSTEM]  (TARGET) SYSTEM VERSION   = ${CMAKE_SYSTEM_VERSION}")
message(STATUS "[PROJECT] SOURCE_DIR                = ${CMAKE_SOURCE_DIR}")
message(STATUS "[PROJECT] BUILD_TYPE                = ${CMAKE_BUILD_TYPE}")
message(STATUS "[PROJECT] TOOLCHAIN_FILE            = ${CMAKE_TOOLCHAIN_FILE}")
message(STATUS "[PROJECT] QT_HOST_PATH              = ${QT_HOST_PATH}")

################################################################################

find_package(Qt6 REQUIRED COMPONENTS Core Concurrent Network)
find_package(Qt6 REQUIRED COMPONENTS Location Positioning Multimedia)
find_package(Qt6 REQUIRED COMPONENTS Gui Svg Qml Quick QuickControls2 Charts)
find_package(Qt6 REQUIRED COMPONENTS LinguistTools)

qt_standard_project_setup(REQUIRES 6.8
                          I18N_SOURCE_LANGUAGE en
                          I18N_TRANSLATED_LANGUAGES fr)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0002 NEW)
qt_policy(SET QTP0003 NEW)
qt_policy(SET QTP0004 NEW)

qt_add_executable(${CMAKE_PROJECT_NAME}
    src/main.cpp
    src/SettingsManager.cpp src/SettingsManager.h
    src/MediaManager.cpp src/MediaManager.h
    src/Media.cpp src/Media.h src/MediaUtils.h
    src/minivideo_qml.h src/minivideo_track_qml.cpp  src/minivideo_track_qml.h
    src/minivideo_textexport_qt.cpp src/minivideo_textexport_qt.h
    src/minivideo_utils_qt.cpp src/minivideo_utils_qt.h

    assets/assets.qrc
    thirdparty/IconLibrary/IconLibrary_material.qrc
    thirdparty/IconLibrary/IconLibrary_fontawesome.qrc
)

qt_add_qml_module(${CMAKE_PROJECT_NAME}
    URI ${CMAKE_PROJECT_NAME}
    NO_PLUGIN
    QML_FILES
        qml/MobileApplication.qml
        qml/MobileHeader.qml
        qml/MobileDrawer.qml
        qml/MobileMenu.qml
        qml/MobileExit.qml
        qml/MobilePermissions.qml

        qml/DesktopApplication.qml
        qml/DesktopHeader.qml
        qml/DesktopSettings.qml

        qml/ScreenTutorial.qml
        qml/ScreenSettings.qml
        qml/ScreenAbout.qml

        qml/ScreenMediaList.qml
        qml/ScreenMediaInfos.qml
        qml/MediaWidget.qml
        qml/MiniList.qml
        qml/MiniListItem.qml
        qml/MediaInfos_row.qml
        qml/MediaInfos_swipeview.qml

        qml/InfosGeneric.qml
        qml/InfosAV.qml
        qml/InfosSubtitles.qml
        qml/InfosAudioTags.qml
        qml/InfosImageTags.qml
        qml/InfosMap.qml
        qml/InfosExport.qml

        qml/popups/PopupImage.qml
        qml/popups/PopupLoading.qml
        qml/components/FileDialog.qml
        qml/components/FileDialog_mobile.qml
        qml/components/FileDialog_quickdialogs6_file.qml
        qml/components/FileDialog_quickdialogs6_folder.qml

        qml/components/ItemTracksGraph.qml
        qml/components/ItemNoFile.qml
        qml/components/ComboBoxMedia.qml
        qml/components/InfoFlow.qml
        qml/components/InfoRow.qml
        qml/components/InfoTitle.qml
        qml/components/TextEditMVI.qml
        qml/components/GeometryWidget.qml
        qml/components/ChromaFormatWidget.qml
        qml/components/PixelFormatWidget.qml
        qml/components/SpeakerWidget.qml
)

qt_add_translations(${CMAKE_PROJECT_NAME}
    TS_FILE_BASE ${CMAKE_PROJECT_NAME}
    TS_FILE_DIR ${CMAKE_SOURCE_DIR}/i18n/
    RESOURCE_PREFIX "/i18n"
)

################################################################################

# "Other Files" macro
function(add_other_files target)
    foreach(file IN LISTS ARGN)
        target_sources(${target} PRIVATE ${file})
        source_group("Other Files" FILES ${file})
    endforeach()
endfunction()

add_other_files(${CMAKE_PROJECT_NAME}
    README.md LICENSE.md
    .gitignore
)
################################################################################

# AppUtils
add_subdirectory(thirdparty/AppUtils)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE AppUtils)

# MobileUI
add_subdirectory(thirdparty/MobileUI)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE MobileUI)

# MobileSharing
if(IOS OR ANDROID)
add_subdirectory(thirdparty/MobileSharing)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE MobileSharing)
endif()

# ComponentLibrary
add_subdirectory(thirdparty/ComponentLibrary)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE ComponentLibraryplugin)

# EGM96
add_subdirectory(thirdparty/EGM96)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE EGM96)

# minivideo
#add_subdirectory(thirdparty/minivideo)
add_subdirectory(contribs/build/linux_x86_64/MiniVideo-master/minivideo)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE minivideo)

################################################################################

# Qt
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    Qt6::Core
    Qt6::Concurrent
    Qt6::Network
    Qt6::Location
    Qt6::Positioning
    Qt6::Gui
    Qt6::Svg
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Charts
    Qt6::Multimedia
)

## QMapLibre (if available)
#find_package(QMapLibre COMPONENTS Location)
#if(QMapLibre_FOUND)
#    qmaplibre_location_setup_plugins(${CMAKE_PROJECT_NAME})
#    target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE QMapLibre::Location)
#endif()

# QWidgets (for desktop)
if(NOT IOS AND NOT ANDROID)
    find_package(Qt6 REQUIRED COMPONENTS Widgets)
    target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE Qt6::Widgets)
endif()

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE src/)
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE thirdparty/)

################################################################################

## Release build? Set "no debug" macros
if(CMAKE_BUILD_TYPE STREQUAL Release)
    target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE
        NDEBUG
        QT_NO_DEBUG
        QT_NO_DEBUG_OUTPUT
    )
endif()

################################################################################

## Android
if(CMAKE_SYSTEM_NAME STREQUAL "Android")
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
        #QT_ANDROID_ABIS "armeabi-v7a;arm64-v8a;x86;x86_64"
        #QT_ANDROID_BUILD_ALL_ABIS ON
        QT_ANDROID_MIN_SDK_VERSION 28
        QT_ANDROID_TARGET_SDK_VERSION 36
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/assets/android/"
    )

    # Include SSL Libraries (download)
    include(FetchContent)
    FetchContent_Declare(
        android_openssl
        DOWNLOAD_EXTRACT_TIMESTAMP true
        URL https://github.com/KDAB/android_openssl/archive/refs/heads/master.zip
    )
    FetchContent_MakeAvailable(android_openssl)
    include(${android_openssl_SOURCE_DIR}/android_openssl.cmake)
    add_android_openssl_libraries(${CMAKE_PROJECT_NAME})
endif()

## macOS
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    #set(CMAKE_OSX_ARCHITECTURES "x86_64;arm64")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "12.0")
    set(UTILS_DOCK_ENABLED true)

    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE ON
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_SOURCE_DIR}/assets/macos/Info.plist"
        # New Xcode attributes (???)
        XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER           "io.minivideo.info"
        XCODE_ATTRIBUTE_PRODUCT_NAME                        ${CMAKE_PROJECT_NAME}
        XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION             ${CMAKE_PROJECT_VERSION}
        XCODE_ATTRIBUTE_MARKETING_VERSION                   ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS             "${CMAKE_SOURCE_DIR}/assets/macos/${CMAKE_PROJECT_NAME}.entitlements"
    )
endif()

## iOS
if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set(CMAKE_OSX_ARCHITECTURES "arm64")
    set(CMAKE_OSX_SYSROOT "iphoneos")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "16.0")
    set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "16.0")
    set(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2") # iPhone,iPad
    set(CMAKE_XCODE_ATTRIBUTE_INFOPLIST_FILE "${CMAKE_SOURCE_DIR}/assets/ios/Info.plist")

    #set(assets_catalog_path "${CMAKE_SOURCE_DIR}/assets/ios/Assets.xcassets")
    #target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${assets_catalog_path})
    #set_source_files_properties(${assets_catalog_path} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE ON
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_SOURCE_DIR}/assets/ios/Info.plist"
        # Qt
        QT_IOS_LAUNCH_SCREEN "${CMAKE_SOURCE_DIR}/assets/ios/LaunchScreen.storyboard"
        # New Xcode attributes (???)
        XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER           "io.minivideo.info"
        XCODE_ATTRIBUTE_PRODUCT_NAME                        ${CMAKE_PROJECT_NAME}
        XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION             ${CMAKE_PROJECT_VERSION}
        XCODE_ATTRIBUTE_MARKETING_VERSION                   ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET          "16.0"
        XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY              "1,2"   # iPhone,iPad
        XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME  "AppIcon"
        XCODE_ATTRIBUTE_GCC_GENERATE_DEBUGGING_SYMBOLS      "YES"
    )
endif()

## Windows
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
        WIN32_EXECUTABLE ON
    )
endif()

################################################################################

# Output (build)
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    #ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/lib"
    #LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/lib"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin"
)

################################################################################
