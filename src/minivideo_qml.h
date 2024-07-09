/*!
 * COPYRIGHT (C) 2020 Emeric Grange - All Rights Reserved
 *
 * This file is part of MiniVideo.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \author    Emeric Grange <emeric.grange@gmail.com>
 * \date      2019
 */

#ifndef MINIVIDEO_QML_H
#define MINIVIDEO_QML_H
/* ************************************************************************** */

#include <minivideo.h>
#include <minivideo_avutils.h>

#include <QObject>
#include <QQmlApplicationEngine>

/* ************************************************************************** */

class MiniVideoQML : public QObject
{
    Q_OBJECT

public:
    MiniVideoQML() = default;
    ~MiniVideoQML() = default;

    static void registerQML()
    {
        qmlRegisterType<MiniVideoQML>("MiniVideo", 0, 13, "MiniVideo");
    }

    Q_ENUM(StreamType_e)
    Q_ENUM(SampleType_e)

    Q_ENUM(BitrateMode_e)

    Q_ENUM(FramerateMode_e)
    Q_ENUM(Projection_e)
    Q_ENUM(HdrMode_e)
    Q_ENUM(ScanType_e)
    Q_ENUM(Rotation_e)
    Q_ENUM(StereoMode_e)

    Q_ENUM(ColorModel_e)
    Q_ENUM(ColorsRec_e)
    Q_ENUM(ColorMatrix_e)

    Q_ENUM(ColorPrimaries_e)
    Q_ENUM(ColorTransferCharacteristic_e)
    Q_ENUM(ColorSpace_e)

    Q_ENUM(AudioSpeakers_e)
    Q_ENUM(AudioSpeakersExtended_e)
    Q_ENUM(ChannelMode_e)
};

/* ************************************************************************** */
#endif // MINIVIDEO_QML_H
