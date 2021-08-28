# ![MiniVideo Infos](https://i.imgur.com/eKFauTe.jpg)

[![Travis](https://img.shields.io/travis/emericg/MiniVideoInfos.svg?style=flat-square)](https://travis-ci.org/emericg/MiniVideoInfos)
[![License: GPL v3](https://img.shields.io/badge/license-GPL%20v3-blue.svg?style=flat-square)](http://www.gnu.org/licenses/gpl-3.0)

Get detailed informations about your audio, video and picture files with MiniVideo Infos!

### Features

- Bitrate graphs
- Pixel geometry
- Audio channels mapping
- Camera EXIF
- Audio tags
- GPS location maps

VIDEO file formats:  
✔ AVI, ASF / WMV, MKV / WEBM, MP4 / MOV, MPEG  

AUDIO file formats:  
✔ AAC, MP3, WMA, WAVE  
✔ ID3 v1/v2 and Vorbis comments tags  

PICTURE file formats:  
✔ GIF, JPG, PNG, SVG  
✔ EXIF tags  

### Screenshots

![triptik1](https://i.imgur.com/4UktjbK.png)
![triptik2](https://i.imgur.com/UFuHKvo.png)


## Documentation

### Dependencies

You will need:
- Any C++11 compiler
- Android NDK 20+
- Android SDK
- Qt 5.12+ (with Qt Charts)
- MiniVideo
- TagLib
- libexif

### Building MiniVideo Infos

```bash
$ git clone https://github.com/emericg/MiniVideoInfos.git
$ cd MiniVideoInfos/
$ cd contribs/ && python3 contribs.py && cd ..
$ qmake
$ make
```

### Third party projects used by MiniVideo Infos

* Qt [website](https://www.qt.io) ([LGPL 3](https://www.gnu.org/licenses/lgpl-3.0.txt))
* MiniVideo [website](https://github.com/emericg/MiniVideo) ([LGPL 3](https://www.gnu.org/licenses/lgpl-3.0.txt))
* TagLib [website](https://taglib.org/) ([LGPL 2.1](https://www.gnu.org/licenses/lgpl-2.1.txt))
* libexif [website](https://github.com/libexif/libexif/) ([LGPL 2.1](https://www.gnu.org/licenses/lgpl-2.1.txt))
* StatusBar [website](https://github.com/jpnurmi/statusbar) ([MIT](https://opensource.org/licenses/MIT))
* Graphical resources: please read [assets/COPYING](assets/COPYING)


## Get involved!

### Developers

You can browse the code on the GitHub page, submit patches and pull requests! Your help would be greatly appreciated ;-)

### Users

You can help us find and report bugs, suggest new features, help with translation, documentation and more! Visit the Issues section of the GitHub page to start!


## License

MiniVideoInfos is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.  
Read the [LICENSE](LICENSE) file or [consult the license on the FSF website](https://www.gnu.org/licenses/gpl-3.0.txt) directly.

> Emeric Grange <emeric.grange@gmail.com>
