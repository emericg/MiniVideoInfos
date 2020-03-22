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
 * \date      2017
 */

#include "minivideo_textexport_qt.h"

// minivideo library
#include <minivideo.h>

// minianalyser
#include "minivideo_utils_qt.h"

#include <QMessageBox>
#include <QFontDatabase>
#include <QFileDialog>
#include <QDateTime>
#include <QFile>
#include <QDebug>

/* ************************************************************************** */

textExport::textExport()
{
    //
}

textExport::~textExport()
{
    //
}

/* ************************************************************************** */

int textExport::generateExportData_text(MediaFile_t &media, QString &exportData, bool detailed)
{
    int status = 1;

    exportData += "Full path      : ";
    exportData += media.file_path;

    exportData += "\n\nTitle          : ";
    exportData += media.file_name;
    exportData += "\nDuration       : ";
    exportData += getDurationString(media.duration);
    exportData += "\nSize           : ";
    exportData += getSizeString(media.file_size);
    exportData += "\nContainer      : ";
    exportData += getContainerString(media.container, true);
    if (media.creation_app)
    {
        exportData += "\nCreation app   : ";
        exportData += media.creation_app;
    }
    if (media.creation_lib)
    {
        exportData += "\nCreation lib   : ";
        exportData += media.creation_lib;
    }
    if (media.creation_time)
    {
        QDate date(1904, 1, 1);
        QTime time(0, 0, 0, 0);
        QDateTime datetime(date, time);
        datetime = datetime.addSecs(static_cast<qint64>(media.creation_time));
        exportData += "\nCreation time  : ";
        exportData += datetime.toString("dddd d MMMM yyyy, hh:mm:ss");
    }

    // VIDEO TRACKS ////////////////////////////////////////////////////////////

    for (unsigned i = 0; i < media.tracks_video_count; i++)
    {
        MediaStream_t *t = media.tracks_video[i];
        if (t == nullptr)
            break;

        // Section title
        if (media.tracks_video_count == 1)
        {
            exportData += "\n\nVIDEO";
            exportData += "\n-----";
        }
        else
        {
            exportData += "\n\nVIDEO TRACK #" + QString::number(i);
            exportData += "\n--------------";
        }

        // Data
        if (detailed == true)
        {
            exportData += "\nTrack ID       : ";
            exportData += QString::number(t->track_id);

            if (t->stream_fcc)
            {
                exportData += "\nFourCC         : ";
                exportData += getFourccString(t->stream_fcc);
            }
        }
        exportData += "\nCodec          : ";
        exportData += getCodecString(stream_VIDEO, t->stream_codec, true);
        exportData += "\nSize           : ";
        exportData += getTrackSizeString(t, media.file_size, detailed);
        exportData += "\nDuration       : ";
        exportData += getDurationString(t->stream_duration_ms);
        exportData += "\nWidth          : ";
        exportData += QString::number(t->width);
        exportData += "\nHeight         : ";
        exportData += QString::number(t->height);

        if (detailed == true)
        {
            if (t->pixel_aspect_ratio_h || t->pixel_aspect_ratio_v)
            {
                exportData += "\nPixel Aspect Ratio    : ";
                exportData += QString::number(t->pixel_aspect_ratio_h) + ":" + QString::number(t->pixel_aspect_ratio_v);
            }
            if (t->video_aspect_ratio > 0.0)
            {
                exportData += "\nVideo Aspect Ratio    : ";
                exportData += getAspectRatioString(t->video_aspect_ratio, false);
            }
            exportData += "\nDisplay Aspect Ratio  : ";
            exportData += getAspectRatioString(t->display_aspect_ratio, true);
        }
        else
        {
            exportData += "\nAspect ratio   : ";
            exportData += getAspectRatioString(t->display_aspect_ratio, detailed);
        }

        if (detailed == true)
        {
            exportData += "\nFramerate      : ";
            exportData += QString::number(t->framerate) + " fps";
            if (t->framerate_mode)
            {
                exportData += "\nFramerate mode : ";
                exportData += getFramerateModeString(t->framerate_mode);
            }

            exportData += "\nBitrate        : ";
            exportData += getBitrateString(t->bitrate_avg);
            exportData += "\nBitrate mode   : ";
            exportData += getBitrateModeString(t->bitrate_mode);
            if (t->bitrate_mode != BITRATE_CBR)
            {
                exportData += "\nBitrate (min)  : ";
                exportData += getBitrateString(t->bitrate_min);
                exportData += "\nBitrate (max)  : ";
                exportData += getBitrateString(t->bitrate_max);
            }
        }
        else
        {
            exportData += "\nFramerate      : ";
            exportData += QString::number(t->framerate) + " fps";
            if (t->framerate_mode)
            {
                exportData += " (" + getFramerateModeString(t->framerate_mode) + ")";
            }
            exportData += "\nBitrate        : ";
            exportData += getBitrateString(t->bitrate_avg);
            exportData += " (" + getBitrateModeString(t->bitrate_mode) + ")";
        }

        if (t->color_depth > 0)
        {
            exportData += "\nColor depth    : ";
            exportData += QString::number(t->color_depth) + " bits";
            if (t->color_range == 0)
                exportData += "\nColor range    : Limited";
            else
                exportData += "\nColor range    : Full";
        }
        if (t->color_primaries && t->color_transfer)
        {
            QString prim = getColorPrimariesString((ColorPrimaries_e)t->color_primaries);
            if (!prim.isEmpty())
            {
                exportData += "\nColor primaries: " + prim;
            }

            QString tra = getColorTransferCharacteristicString((ColorTransferCharacteristic_e)t->color_transfer);
            if (!tra.isEmpty())
            {
                exportData += "\nColor tranfer  : " + tra;
            }

            QString mat = getColorMatrixString((ColorSpace_e)t->color_matrix);
            if (!mat.isEmpty())
            {
                exportData += "\nColor matrix   : " + mat;
            }
        }
    }

    // AUDIO TRACKS ////////////////////////////////////////////////////////////

    for (unsigned i = 0; i < media.tracks_audio_count; i++)
    {
        MediaStream_t *t = media.tracks_audio[i];
        if (t == nullptr)
            break;

        // Section title
        if (media.tracks_audio_count == 1)
        {
            exportData += "\n\nAUDIO";
            exportData += "\n-----";
        }
        else
        {
            exportData += "\n\nAUDIO TRACK #" + QString::number(i);
            exportData += "\n--------------";
            if (i > 9) exportData += "-";
        }

        // Data
        if (detailed == true)
        {
            exportData += "\nTrack ID       : ";
            exportData += QString::number(t->track_id);

            if (t->stream_fcc)
            {
                exportData += "\nFourCC         : ";
                exportData += getFourccString(t->stream_fcc);
            }
        }
        exportData += "\nCodec          : ";
        exportData += getCodecString(stream_AUDIO, t->stream_codec, true);
        exportData += "\nSize           : ";
        exportData += getTrackSizeString(t, media.file_size, detailed);
        exportData += "\nDuration       : ";
        exportData += getDurationString(t->stream_duration_ms);
        if (t->track_title)
        {
            exportData += "\nTitle          : ";
            exportData += QString::fromUtf8(t->track_title);
        }
        if (t->track_languagecode && strcmp(t->track_languagecode, "und") != 0)
        {
            exportData += "\nLanguage code  : ";
            exportData += QString::fromUtf8(t->track_languagecode);

            QString track_language = getLanguageString(t->track_languagecode);
            if (!track_language.isEmpty())
            {
                exportData += "\nLanguage       : ";
                exportData +=  getLanguageString(t->track_languagecode);
            }
        }
        exportData += "\nChannels       : ";
        exportData += QString::number(t->channel_count);
        exportData += "\nBit per sample : ";
        exportData += QString::number(t->bit_per_sample);
        exportData += "\nSamplerate     : ";
        exportData += QString::number(t->sampling_rate) + " Hz";
        if (detailed == true)
        {
            exportData += "\nBitrate        : ";
            exportData += getBitrateString(t->bitrate_avg);
            exportData += "\nBitrate mode   : ";
            exportData += getBitrateModeString(t->bitrate_mode);
            if (t->bitrate_mode != BITRATE_CBR)
            {
                exportData += "\nBitrate (min)  : ";
                exportData += getBitrateString(t->bitrate_min);
                exportData += "\nBitrate (max)  : ";
                exportData += getBitrateString(t->bitrate_max);
            }
        }
        else
        {
            exportData += "\nBitrate        : ";
            exportData += getBitrateString(t->bitrate_avg);
            exportData += " (" + getBitrateModeString(t->bitrate_mode) + ")";
        }
    }

    // SUBTITLES TRACKS ////////////////////////////////////////////////////////

    for (unsigned i = 0; i < media.tracks_subtitles_count; i++)
    {
        MediaStream_t *t = media.tracks_subt[i];
        if (t == nullptr)
            break;

        // Section title
        exportData += "\n\nSUBTITLES TRACK #"+ QString::number(i);
        exportData += "\n------------------";
        if (i > 9) exportData += "-";

        // Data
        if (detailed == true)
        {
            exportData += "\nTrack ID       : ";
            exportData += QString::number(t->track_id);
        }
        exportData += "\nFormat         : ";
        exportData += getCodecString(stream_TEXT, t->stream_codec, true);
        exportData += "\nSize           : ";
        exportData += getTrackSizeString(t, media.file_size, detailed);
        if (t->track_title)
        {
            exportData += "\nTitle          : ";
            exportData += QString::fromUtf8(t->track_title);
        }
        if (t->track_languagecode && strcmp(t->track_languagecode, "und") != 0)
        {
            exportData += "\nLanguage code  : ";
            exportData += QString::fromUtf8(t->track_languagecode);

            QString track_language = getLanguageString(t->track_languagecode);
            if (!track_language.isEmpty())
            {
                exportData += "\nLanguage       : ";
                exportData +=  getLanguageString(t->track_languagecode);
            }
        }
    }

    // OTHER TRACKS ////////////////////////////////////////////////////////////

    for (unsigned i = 0; i < media.tracks_others_count; i++)
    {
        MediaStream_t *t = media.tracks_others[i];
        if (t == nullptr)
            break;

        // Section title
        if (t->stream_type == stream_TEXT)
            exportData += "\n\nTEXT TRACK #";
        else if (t->stream_type == stream_MENU)
            exportData += "\n\nMENU TRACK #";
        else if (t->stream_type == stream_TMCD)
            exportData += "\n\nTMCD TRACK #";
        else if (t->stream_type == stream_META)
            exportData += "\n\nMETA TRACK #";
        else if (t->stream_type == stream_HINT)
            exportData += "\n\nHINT TRACK #";

        exportData += QString::number(i);
        exportData += "\n-------------";
        if (i > 9) exportData += "-";

        // Data
        if (detailed == true)
        {
            exportData += "\nTrack ID       : ";
            exportData += QString::number(t->track_id);
        }
        exportData += "\nSize           : ";
        exportData += getTrackSizeString(t, media.file_size, detailed);
        if (t->track_title)
        {
            exportData += "\nTitle          : ";
            exportData += QString::fromUtf8(t->track_title);
        }
        exportData += "\nLanguage       : ";
        exportData += QString::fromUtf8(t->track_languagecode);

        status = 0;
    }

    return status;
}

/* ************************************************************************** */

int textExport::generateExportData_json(MediaFile_t &media, QString &exportData, bool detailed)
{
    int status = 1;

    Q_UNUSED(media)
    Q_UNUSED(exportData)
    Q_UNUSED(detailed)

    // TODO

    return status;
}

/* ************************************************************************** */

int textExport::generateExportData_xml(MediaFile_t &media, QString &exportData, bool detailed)
{
    int status = 1;

    Q_UNUSED(media)
    Q_UNUSED(exportData)
    Q_UNUSED(detailed)

    // TODO

    return status;
}

/* ************************************************************************** */

int textExport::generateExportMapping_xml(MediaFile_t &media, QString &exportData)
{
    int status = 0;

    QFile xmlMapFile;
    QString filename;

    // Load XML file (from given file descriptor)
    if (media.container_mapper_fd == nullptr ||
        xmlMapFile.open(media.container_mapper_fd, QIODevice::ReadOnly) == false)
    {
        status = 1;
        qDebug() << "xmlFile.open(FILE*) > error";
    }

    // Load XML file (fallback from file path / DEPRECATED)
    if (status == 1)
    {
        filename = "/tmp/" + QString::fromUtf8(media.file_name) + "_mapped.xml";
        xmlMapFile.setFileName(filename);

        if (xmlMapFile.exists() == false ||
            xmlMapFile.open(QIODevice::ReadOnly) == false)
        {
            qDebug() << "xmlFile.open(" << filename << ") > error";
            status = 1;
        }
    }

    if (status == 0)
    {
        xmlMapFile.seek(0);
        exportData = xmlMapFile.readAll();
    }

    return status;
}

/* ************************************************************************** */
