# ![MiniVideo Infos](https://i.imgur.com/eKFauTe.jpg)

[![GitHub release](https://img.shields.io/github/release/emericg/MiniVideoInfos.svg?style=flat-square)](https://github.com/emericg/MiniVideoInfos/releases)
[![GitHub action](https://img.shields.io/github/actions/workflow/status/emericg/MiniVideoInfos/builds.yml?style=flat-square)](https://github.com/emericg/MiniVideoInfos/actions)
[![License: GPL v3](https://img.shields.io/badge/license-GPL%20v3-blue.svg?style=flat-square&color=brightgreen)](http://www.gnu.org/licenses/gpl-3.0)

> Get detailed informations about your audio, video and picture files with MiniVideo Infos!

### Features

- Bitrate graphs
- Pixel geometry
- Audio channels mapping
- Camera EXIF
- Audio tags
- GPS location maps

VIDEO file formats:  
▸ AVI, ASF / WMV, MKV / WEBM, MP4 / MOV, MPEG PS  

AUDIO file formats:  
▸ AAC, MP3, WMA, WAVE  
▸ ID3 v1/v2 and Vorbis comments tags  

PICTURE file formats:  
▸ GIF, JPG, PNG, SVG  
▸ EXIF tags  

### Screenshots

![triptik1](https://i.imgur.com/4UktjbK.png)
![triptik2](https://i.imgur.com/UFuHKvo.png)


## Documentation

### Dependencies

You will need a C++17 compiler and Qt 6.5+ with the following 'additional librairies':  
- Qt Positioning
- Qt Location
- Qt Charts

For Android builds, you'll need the appropriates JDK (17) SDK (24+) and NDK (26+). You can customize Android build environment using the `assets/android/gradle.properties` file.  
For macOS and iOS builds, you'll need Xcode 13+ installed.  

### Building dependencies

- minivideo (0.15+)
- libexif (2.0+)
- taglib (2.0+)

You can either use the libraries from your system, or use the `contribs_builder.py` script to build necessary libraries.  
You will probably need to use this script, because some libraries aren't widely available in package managers. Also, if you wish to cross compile for Android or iOS, the script will make your life so much easier.  

Build dependencies using the `contribs_builder.py` script (optional):

```bash
$ git clone https://github.com/emericg/MiniVideoInfos.git
$ cd MiniVideoInfos/contribs/
$ python3 contribs_builder.py # default invocation

$ python3 contribs_builder.py --softwares minivideo,libexif,taglib # build only selected softwares
$ python3 contribs_builder.py --qt-directory /path/to/Qt --android-ndk /path/to/android-sdk/ndk/26.3.11579264/ --targets=android_armv8,android_armv7,android_x86,android_x86_64 # complex Android cross compilation
```

### Building MiniVideo Infos

```bash
$ git clone https://github.com/emericg/MiniVideoInfos.git
$ cd MiniVideoInfos/
$ qmake6 DEFINES+=USE_CONTRIBS # set this flag only if you wish to use the locally built dependencies
$ make
```

### Third party projects used by MiniVideo Infos

* Qt6 [website](https://www.qt.io) ([LGPL 3](https://www.gnu.org/licenses/lgpl-3.0.txt))
* MiniVideo [website](https://github.com/emericg/MiniVideo) ([LGPL 3](https://www.gnu.org/licenses/lgpl-3.0.txt))
* TagLib [website](https://taglib.org/) ([LGPL 2.1](https://www.gnu.org/licenses/lgpl-2.1.txt))
* libexif [website](https://github.com/libexif/libexif/) ([LGPL 2.1](https://www.gnu.org/licenses/lgpl-2.1.txt))
* EGM96 [website](https://github.com/emericg/EGM96) ([zlib](https://github.com/emericg/EGM96/blob/master/LICENSE))
* MobileUI [README](src/thirdparty/MobileUI/README.md) ([MIT](https://opensource.org/licenses/MIT))
* MobileSharing [README](src/thirdparty/MobileSharing/README.md) ([MIT](https://opensource.org/licenses/MIT))
* Graphical resources: [assets/COPYING](assets/COPYING)


## Get involved!

### Developers

You can browse the code on the GitHub page, submit patches and pull requests! Your help would be greatly appreciated ;-)

### Users

You can help us find and report bugs, suggest new features, help with translation, documentation and more! Visit the Issues section of the GitHub page to start!


## License

MiniVideoInfos is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.  
Read the [LICENSE](LICENSE.md) file or [consult the license on the FSF website](https://www.gnu.org/licenses/gpl-3.0.txt) directly.

> Emeric Grange <emeric.grange@gmail.com>
