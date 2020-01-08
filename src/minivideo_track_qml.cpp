/*!
 * This file is part of MiniVideo.
 * COPYRIGHT (C) 2019 Emeric Grange - All Rights Reserved
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

/* ************************************************************************** */

#include "minivideo_track_qml.h"
#include "minivideo_utils_qt.h"

#include <QObject>
#include <QString>
#include <QDateTime>

#include <cmath>

/* ************************************************************************** */
/* ************************************************************************** */

MediaTrackQml::MediaTrackQml(QObject *parent) : QObject(parent)
{
    //
}

MediaTrackQml::~MediaTrackQml()
{
    //
}

/* ************************************************************************** */

bool MediaTrackQml::loadMediaStream(MediaStream_t *stream)
{
    bool status = false;

    if (stream)
    {
        mv_stream = stream;
        status = true;
    }

    return status;
}

/* ************************************************************************** */

unsigned MediaTrackQml::getType() const
{
    return mv_stream->stream_type;
}

int MediaTrackQml::getId() const
{
    if (mv_stream)
    {
        return mv_stream->track_id;
    }

    return -1;
}

QDateTime MediaTrackQml::getDate() const
{
    if (mv_stream)
    {
        QDate date(1970, 1, 1);
        QTime time(0, 0, 0, 0);

        QDateTime datetime(date, time);
        datetime = datetime.addSecs(mv_stream->creation_time);

        return datetime;
    }

    return QDateTime();
}

qint64 MediaTrackQml::getSize() const
{
    if (mv_stream)
    {
        return mv_stream->stream_size;
    }

    return -1;
}

qint64 MediaTrackQml::getDuration() const
{
    if (mv_stream)
    {
        return mv_stream->stream_duration_ms;
    }

    return -1;
}

qint64 MediaTrackQml::getDelay() const
{
    if (mv_stream)
    {
        return mv_stream->stream_delay;
    }

    return 0;
}

QString MediaTrackQml::getTitle() const
{
    if (mv_stream)
    {
        return mv_stream->track_title;
    }

    return QString();
}

bool MediaTrackQml::getVisible() const
{
    if (mv_stream)
    {
        return mv_stream->track_forced;
    }

    return true;
}

bool MediaTrackQml::getDefault() const
{
    if (mv_stream)
    {
        return mv_stream->track_forced;
    }

    return true;
}

bool MediaTrackQml::getForced() const
{
    if (mv_stream)
    {
        return mv_stream->track_forced;
    }

    return false;
}

/* ************************************************************************** */

QString MediaTrackQml::getFcc() const
{
    if (mv_stream)
    {
        char fcc_str[5];
        return QString::fromUtf8(getFccString_le(mv_stream->stream_fcc, fcc_str), 4);
    }

    return QString();
}
QString MediaTrackQml::getTcc() const
{/*
    if (mv_stream)
    {
        char tcc_str[3];
        return QString::fromUtf8(getFccString_le(mv_stream->stream_tcc, tcc_str), 2);
    }
*/
    return QString();
}

QString MediaTrackQml::getCodec() const
{
    if (mv_stream)
    {
        return QString::fromUtf8(getCodecString(mv_stream->stream_type, mv_stream->stream_codec, true));
    }

    return QString();
}

QString MediaTrackQml::getCodecProfile() const
{
    if (mv_stream)
    {
        return QString::fromUtf8(getCodecProfileString(mv_stream->stream_codec_profile));
    }

    return QString();
}

QString MediaTrackQml::getCodecProfileAndLevel() const
{
    QString str;

    if (mv_stream)
    {
        str += getCodecProfileString(mv_stream->stream_codec_profile);

        if (mv_stream->video_level > 0)
        {
            str += " @ L";
            str += QString::number(mv_stream->video_level, 'g', 2);
        }
    }

    return str;
}

QString MediaTrackQml::getCodecFeatures() const
{
    QString str;

    if (mv_stream)
    {
        if (mv_stream->stream_codec == CODEC_H264)
        {
            if (mv_stream->h264_feature_cabac)
                str = "CABAC";
            else
                str = "CAVLC";

            if (mv_stream->h264_feature_8x8)
                str += " / " + tr("8x8 blocks");

            if (mv_stream->max_ref_frames > 0)
                str += " / " + QString::number(mv_stream->max_ref_frames) + tr(" ref. frames");
        }
        else if (mv_stream->stream_codec == CODEC_H265)
        {
            if (mv_stream->max_ref_frames > 0)
                str = QString::number(mv_stream->max_ref_frames) + tr(" ref. frames");
        }
    }

    return str;
}

QString MediaTrackQml::getLanguage() const
{
    QString langage_qstr;

    if (mv_stream)
    {
        langage_qstr = getLanguageString(mv_stream->track_languagecode);
    }

    return langage_qstr;
}

/* ************************************************************************** */

int MediaTrackQml::getWidth() const
{
    if (mv_stream)
    {
        return mv_stream->width;
    }

    return -1;
}
int MediaTrackQml::getHeight() const
{
    if (mv_stream)
    {
        return mv_stream->height;
    }

    return -1;
}

int MediaTrackQml::getWidthVisible() const
{
    if (mv_stream)
    {
        return mv_stream->visible_width;
    }

    return -1;
}
int MediaTrackQml::getHeightVisible() const
{
    if (mv_stream)
    {
        return mv_stream->visible_height;
    }

    return -1;
}

double MediaTrackQml::getFramerate() const
{
    if (mv_stream)
    {
        return mv_stream->framerate;
    }

    return -1;
}

double MediaTrackQml::getCodecLevel() const
{
    if (mv_stream)
    {
        return mv_stream->video_level;
    }

    return -1;
}

int MediaTrackQml::getProjection() const
{
    if (mv_stream)
    {
        return mv_stream->video_rotation;
    }

    return -1;
}

int MediaTrackQml::getStereoMode() const
{
    if (mv_stream)
    {
        return mv_stream->stereo_mode;
    }

    return -1;
}

int MediaTrackQml::getOrientation() const
{
    if (mv_stream)
    {
        return mv_stream->video_rotation;
    }

    return -1;
}

int MediaTrackQml::getScanMode() const
{
    if (mv_stream)
    {
        //return mv_stream->scan_mode;
    }

    return -1;
}

int MediaTrackQml::getColorDepth() const
{
    if (mv_stream)
    {
        return mv_stream->color_depth;
    }

    return -1;
}

bool MediaTrackQml::getColorRange() const
{
    if (mv_stream)
    {
        return mv_stream->color_range;
    }

    return -1;
}

QString MediaTrackQml::getColorPrimaries() const
{
    QString prim;

    if (mv_stream)
    {
        prim = getColorPrimariesString(static_cast<ColorPrimaries_e>(mv_stream->color_primaries));
    }

    return prim;
}

QString MediaTrackQml::getColorTransfer() const
{
    QString trans;

    if (mv_stream)
    {
        trans = getColorTransferCharacteristicString(static_cast<ColorTransferCharacteristic_e>(mv_stream->color_transfer));
    }

    return trans;
}

QString MediaTrackQml::getColorMatrix() const
{
    QString prim;

    if (mv_stream)
    {
        prim = getColorMatrixString(static_cast<ColorSpace_e>(mv_stream->color_matrix));
    }

    return prim;
}

/* ************************************************************************** */

int MediaTrackQml::getAudioChannels() const
{
    if (mv_stream)
    {
        return mv_stream->channel_count;
    }

    return -1;
}

int MediaTrackQml::getAudioChannelsMode() const
{
    if (mv_stream)
    {
        return mv_stream->channel_mode;
    }

    return -1;
}

int MediaTrackQml::getAudioSamplerate() const
{
    if (mv_stream)
    {
        return mv_stream->sampling_rate;
    }

    return -1;
}

int MediaTrackQml::getAudioBitPerSample() const
{
    if (mv_stream)
    {
        return mv_stream->bit_per_sample;
    }

    return -1;
}

double MediaTrackQml::getAudioSampleDuration() const
{
    if (mv_stream)
    {
        return mv_stream->sample_duration;
    }

    return 0;
}

int MediaTrackQml::getAudioSamplePerFrame() const
{
    if (mv_stream)
    {
        return mv_stream->sample_per_frames;
    }

    return 0;
}

/* ************************************************************************** */

int MediaTrackQml::getBitrateMode() const
{
    if (mv_stream)
    {
        return mv_stream->bitrate_mode;
    }

    return -1;
}

int MediaTrackQml::getBitrate_avg() const
{
    if (mv_stream)
    {
        return mv_stream->bitrate_avg;
    }

    return -1;
}

int MediaTrackQml::getBitrate_min() const
{
    if (mv_stream)
    {
        return mv_stream->bitrate_min;
    }

    return -1;
}

int MediaTrackQml::getBitrate_max() const
{
    if (mv_stream)
    {
        return mv_stream->bitrate_max;
    }

    return -1;
}

int MediaTrackQml::getCompressionRatio() const
{
    if (mv_stream)
    {
        if (mv_stream->stream_type == stream_AUDIO)
        {
            uint64_t rawsize = mv_stream->sampling_rate * mv_stream->channel_count * (mv_stream->bit_per_sample / 8);
            rawsize *= mv_stream->stream_duration_ms;
            rawsize /= 1024.0;

            uint64_t ratio = 1;
            if (rawsize && mv_stream->stream_size)
                ratio = std::round(static_cast<double>(rawsize) / static_cast<double>(mv_stream->stream_size));

            return ratio;
        }

        if (mv_stream->stream_type == stream_VIDEO)
        {
            uint64_t rawsize = mv_stream->width * mv_stream->height * (mv_stream->color_depth / 8);
            rawsize *= mv_stream->sample_count;

            uint64_t ratio = 1;
            if (rawsize && mv_stream->stream_size)
                ratio = std::round(static_cast<double>(rawsize) / static_cast<double>(mv_stream->stream_size));

            return ratio;
        }
    }

    return 1;
}

/* ************************************************************************** */

int64_t MediaTrackQml::getSampleCount() const
{
    if (mv_stream)
    {
        return mv_stream->sample_count;
    }

    return 0;
}

int64_t MediaTrackQml::getFrameCount() const
{
    if (mv_stream)
    {
        return mv_stream->frame_count;
    }

    return 0;
}

int64_t MediaTrackQml::getFrameCountIdr() const
{
    if (mv_stream)
    {
        return mv_stream->frame_count_idr;
    }

    return 0;
}

double MediaTrackQml::getFrameDuration() const
{
    if (mv_stream)
    {
        return mv_stream->frame_duration;
    }

    return 0;
}

/* ************************************************************************** */

Q_INVOKABLE void MediaTrackQml::getBitrateDatas(QLineSeries *bitrateData)
{
    if (!bitrateData) return;

    if (mv_stream)
    {
        if (points.size() == 0)
        {
            points.reserve(mv_stream->sample_count/10);
            int j = 0;
            for (unsigned i = 0; i < mv_stream->sample_count; i+=10)
            {
                points.insert(j, QPointF(j, mv_stream->sample_size[i]));j++;
            }
        }

        bitrateData->replace(points);
    }
}

Q_INVOKABLE void MediaTrackQml::getBitrateDatasFps(QLineSeries *bitrateData, float fpfs)
{
    Q_UNUSED(fpfs)
    if (!bitrateData) return;

    if (mv_stream)
    {
        if (points.size() == 0)
        {
            // min/max
            double fps = 0;
            if (mv_stream->stream_duration_ms > 0)
                fps = (static_cast<double>(mv_stream->sample_count) / (static_cast<double>(mv_stream->stream_duration_ms)/1000.0));
            bitrateMinMax btc(fps);
            uint32_t bitratemin = 0, bitratemax = 0;

            //
            unsigned freq = 96; // std::round(mv_stream->framerate) * 4;

            if (mv_stream->sample_count < 1000)
                freq = 1;
            else if (mv_stream->sample_count < 2000)
                freq = 2;
            else if (mv_stream->sample_count < 4000)
                freq = 4;
            else if (mv_stream->sample_count < 8000)
                freq = 8;
            else if (mv_stream->sample_count < 16000)
                freq = 16;

            points.reserve(mv_stream->sample_count/freq);

            int serie_id = 0;
            for (unsigned sample_id = 0; sample_id < mv_stream->sample_count; sample_id+=freq)
            {
                if ((sample_id+freq) > mv_stream->sample_count)
                    break; // freq = mv_stream->sample_count - sample_id;

                int fff = 0;
                for (unsigned k = 0; k < freq; k++)
                {
                     fff += mv_stream->sample_size[sample_id+k];
                     btc.pushSampleSize(mv_stream->sample_size[sample_id+k]);

                }

                points.insert(serie_id, QPointF(serie_id, fff));
                serie_id++;
            }

            btc.getMinMax(bitratemin, bitratemax);
            mv_stream->bitrate_min = bitratemin;
            mv_stream->bitrate_max = bitratemax;
        }

        bitrateData->replace(points);
    }
}
