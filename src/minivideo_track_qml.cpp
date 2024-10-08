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
    if (mv_stream)
    {
        return mv_stream->stream_type;
    }

    return 0;
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
    if (mv_stream && mv_stream->stream_fcc)
    {
        char fcc_str[5];
        return QString::fromUtf8(getFccString_le(mv_stream->stream_fcc, fcc_str), 4);
    }

    return QString();
}

QString MediaTrackQml::getTcc() const
{
    //if (mv_stream && mv_stream->stream_tcc)
    //{
    //    char tcc_str[3];
    //    return QString::fromUtf8(getFccString_le(mv_stream->stream_tcc, tcc_str), 2);
    //}

    return QString();
}

QString MediaTrackQml::getCodec() const
{
    if (mv_stream)
    {
        return getCodecQString(mv_stream->stream_type, mv_stream->stream_codec, true);
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

            if (mv_stream->h264_feature_b_frames)
                str += " / " + tr("B frames");

            if (mv_stream->h264_feature_8x8_blocks)
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
        langage_qstr = getLanguageQString(mv_stream->track_languagecode);
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
        return mv_stream->width_display;
    }

    return -1;
}
int MediaTrackQml::getHeightVisible() const
{
    if (mv_stream)
    {
        return mv_stream->height_display;
    }

    return -1;
}

double MediaTrackQml::getFramerate() const
{
    if (mv_stream)
    {
        return mv_stream->framerate;
    }

    return -1.0;
}

double MediaTrackQml::getVAR() const
{
    if (mv_stream)
    {
         return mv_stream->video_aspect_ratio;
    }

    return -1.0;
}
double MediaTrackQml::getDAR() const
{
    if (mv_stream)
    {
        return mv_stream->display_aspect_ratio;
    }

    return -1.0;
}
double MediaTrackQml::getPAR() const
{
    if (mv_stream)
    {
        return mv_stream->pixel_aspect_ratio;
    }

    return -1.0;
}

double MediaTrackQml::getCodecLevel() const
{
    if (mv_stream)
    {
        return mv_stream->video_level;
    }

    return -1.0;
}

int MediaTrackQml::getProjection() const
{
    if (mv_stream)
    {
        return mv_stream->video_projection;
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

QString MediaTrackQml::getStereoMode_str() const
{
    QString mode;

    if (mv_stream)
    {
        return getStereoModeString(static_cast<StereoMode_e>(mv_stream->stereo_mode));
    }

    return mode;
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
        return mv_stream->scan_mode;
    }

    return -1;
}

QString MediaTrackQml::getScanMode_str() const
{
    QString mode;

    if (mv_stream)
    {
        mode = getScanModeString(static_cast<ScanType_e>(mv_stream->scan_mode));
    }

    return mode;
}

int MediaTrackQml::getHdrMode() const
{

    if (mv_stream)
    {
        return mv_stream->hdr_mode;
    }

    return -1;
}

QString MediaTrackQml::getHdrMode_str() const
{
    QString hdr;

    if (mv_stream)
    {
        hdr = getHdrModeString(static_cast<HdrMode_e>(mv_stream->hdr_mode));
    }

    return hdr;
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

    return false;
}

int MediaTrackQml::getChromaSubsampling() const
{
    if (mv_stream)
    {
        return mv_stream->chroma_subsampling;
    }

    return -1;
}

QString MediaTrackQml::getChromaSubsampling_str() const
{
    QString ss;

    if (mv_stream)
    {
        ss = getChromaSubsamplingString(static_cast<ChromaSubSampling_e>(mv_stream->chroma_subsampling));
    }

    return ss;
}

int MediaTrackQml::getChromaLocation() const
{
    if (mv_stream)
    {
        //return mv_stream->color_subsampling;
    }

    return -1;
}

QString MediaTrackQml::getChromaLocation_str() const
{
    QString loc;

    if (mv_stream)
    {
        loc = getChromaLocationString(static_cast<ChromaLocation_e>(mv_stream->chroma_location));
    }

    return loc;
}

int MediaTrackQml::getColorPrimaries() const
{
    if (mv_stream)
    {
        return mv_stream->color_primaries;
    }

    return -1;
}

QString MediaTrackQml::getColorPrimaries_str() const
{
    QString prim;

    if (mv_stream)
    {
        prim = getColorPrimariesString(static_cast<ColorPrimaries_e>(mv_stream->color_primaries));
    }

    return prim;
}

int MediaTrackQml::getColorTransfer() const
{
    if (mv_stream)
    {
        return mv_stream->color_transfer;
    }

    return -1;
}

QString MediaTrackQml::getColorTransfer_str() const
{
    QString trans;

    if (mv_stream)
    {
        trans = getColorTransferCharacteristicString(static_cast<ColorTransferCharacteristic_e>(mv_stream->color_transfer));
    }

    return trans;
}

int MediaTrackQml::getColorMatrix() const
{
    if (mv_stream)
    {
        return mv_stream->color_matrix;
    }

    return -1;
}

QString MediaTrackQml::getColorMatrix_str() const
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
            uint64_t rawsize = mv_stream->sampling_rate * mv_stream->channel_count * (mv_stream->bit_per_sample / 8.0);
            rawsize *= mv_stream->stream_duration_ms;
            rawsize /= 1024.0;

            uint64_t ratio = 1;
            if (rawsize && mv_stream->stream_size)
                ratio = std::round(static_cast<double>(rawsize) / static_cast<double>(mv_stream->stream_size));

            return ratio;
        }

        if (mv_stream->stream_type == stream_VIDEO)
        {
            unsigned color_planes = mv_stream->color_planes;
            unsigned color_depth = mv_stream->color_depth;
            if (color_planes == 0) color_planes = 3;
            if (color_depth == 0) color_depth = 8;

            uint64_t rawsize = mv_stream->width * mv_stream->height * (color_depth / 8.0) * color_planes;
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

Q_INVOKABLE void MediaTrackQml::getBitrateData(QLineSeries *bitrateData, QLineSeries *bitrateMean, float freq)
{
    if (!bitrateData) return;
    if (!bitrateMean) return;

    if (mv_stream)
    {
        if (points_bitrate_data.size() == 0)
        {
            // min/max
            double fps = 0;
            if (mv_stream->stream_duration_ms > 0)
                fps = (static_cast<double>(mv_stream->sample_count) / (static_cast<double>(mv_stream->stream_duration_ms)/1000.0));

            bitrateMinMax btc(fps);
            uint32_t bitratemin = 0, bitratemax = 0;

            // graph frequency
            unsigned skip = 8;

            if (mv_stream->stream_type == 1) skip = 32; // audio
            if (mv_stream->stream_type == 2) skip = std::round(mv_stream->framerate) - 1; // video

            // skip = std::round(freq);
            // skip = std::round(mv_stream->framerate) - 1;
            // skip = std::round(mv_stream->sample_count) * 4;
/*
            if (mv_stream->sample_count < 1000)
                skip = 1;
            else if (mv_stream->sample_count < 2000)
                skip = 2;
            else if (mv_stream->sample_count < 4000)
                skip = 4;
            else if (mv_stream->sample_count < 8000)
                skip = 8;
            else if (mv_stream->sample_count < 16000)
                skip = 16;
            else if (mv_stream->sample_count < 32000)
                skip = 32;
            else
                skip = 64;
*/
            points_bitrate_data.reserve(mv_stream->sample_count/skip);

            int serie_id = 0;
            for (unsigned sample_id = 0; sample_id < mv_stream->sample_count; sample_id+=skip)
            {
                if ((sample_id+skip) > mv_stream->sample_count) break;

                int fff = 0;
                for (unsigned k = 0; k < skip; k++)
                {
                    fff += mv_stream->sample_size[sample_id+k];
                    btc.pushSampleSize(mv_stream->sample_size[sample_id+k]);
                }
                //fff *= (skip);

                points_bitrate_data.insert(serie_id, QPointF(serie_id, fff));
                serie_id++;
            }

            bitrateData->replace(points_bitrate_data);

            btc.getMinMax(bitratemin, bitratemax);
            mv_stream->bitrate_min = bitratemin;
            mv_stream->bitrate_max = bitratemax;
            Q_EMIT bitrateUpdated();
        }

        if (points_bitrate_mean.size() == 0)
        {
            points_bitrate_mean.reserve(2);
            points_bitrate_mean.insert(0, QPointF(0, mv_stream->bitrate_avg));
            points_bitrate_mean.insert(1, QPointF(1, mv_stream->bitrate_avg));

            bitrateMean->replace(points_bitrate_mean);
        }
    }
}

/* ************************************************************************** */
/* ************************************************************************** */

MediaChapterQml::MediaChapterQml(int64_t pts, const QString &name, QObject *parent) : QObject(parent)
{
    m_pts = pts;
    m_name = name;
}

MediaChapterQml::~MediaChapterQml()
{
    //
}

/* ************************************************************************** */
/* ************************************************************************** */
