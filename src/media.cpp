/*!
 * This file is part of MiniVideoInfos.
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

#include "media.h"
#include "utils_media.h"
#include "minivideo_textexport.h"

#ifdef ENABLE_LIBEXIF
#include <libexif/exif-data.h>
#endif

#ifdef ENABLE_EXIV2
#include <exiv2/exiv2.hpp>
#endif

#ifdef ENABLE_TAGLIB
#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/tpropertymap.h>
#include <iomanip>

#include <taglib/id3v2tag.h>
#include <taglib/id3v1tag.h>
#include <taglib/apetag.h>
#endif

#include <cmath>

#include <QDir>
#include <QUrl>
#include <QUuid>
#include <QFile>
#include <QFileInfo>
#include <QDateTime>
#include <QImageReader>
#include <QDebug>

/* ************************************************************************** */

Media::Media(const QString &path, QObject *parent)
{
    Q_UNUSED(parent)

    m_path = path;
    if (m_file_folder.isEmpty())
    {
        QDir p(m_path);
        p.cdUp();
        m_file_folder = p.absolutePath();
    }

    QFileInfo fi(m_path);
    if (fi.exists() && fi.isReadable())
    {
        //m_file_folder = fi.filePath();
        m_file_name = fi.baseName();
        m_file_extension = fi.suffix().toLower();
        m_file_size = static_cast<int64_t>(fi.size());

#if (QT_VERSION_MINOR >= 10)
        m_date_file_c = fi.birthTime();
#else
        m_date_file_c = fi.created();
#endif
        m_date_file_m = fi.lastModified();
    }

    if (!m_valid) m_valid = getMetadatasFromPicture();
    if (!m_valid) m_valid = getMetadatasFromVideo();
    if (!m_valid || (m_valid && tracksVideo.length() == 0 && tracksAudio.length() > 0)) m_valid = getMetadatasFromAudio();
}

Media::~Media()
{
    //
}

/* ************************************************************************** */
/* ************************************************************************** */
/*
#ifdef ENABLE_LIBEXIF
static void show_tag(ExifData *d, ExifIfd ifd, ExifTag tag)
{
    ExifEntry *entry = exif_content_get_entry(d->ifd[ifd],tag);
    if (entry)
    {
        char buf[1024];
        exif_entry_get_value(entry, buf, sizeof(buf));
        if (*buf)
            qDebug() << exif_tag_get_name_in_ifd(tag,ifd) << ": " << buf;
    }
}
#endif // ENABLE_LIBEXIF
*/
bool Media::getMetadatasFromPicture()
{
    bool status = false;

#ifdef ENABLE_LIBEXIF

    // Check if the file is already parsed;
    ExifData *ed = exif_data_new_from_file(m_path.toLocal8Bit());
    if (ed)
    {
        m_hasEXIF = true;
        m_exif_tag_found = 0;

        //ExifByteOrder byte_order = exif_data_get_byte_order(ed);

        // EXIF ////////////////////////////////////////////////////////////////

        // Parse tags
        ExifEntry *entry;
        char buf[1024];

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_MAKE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            m_camera_brand = buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_MODEL);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            m_camera_model = buf;
            m_exif_tag_found++;
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_SOFTWARE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            m_camera_software = buf;
            m_exif_tag_found++;
        }

        ////////////////

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_DATE_TIME);
        if (entry)
        {
            // TODO
            //0x882a	TimeZoneOffset	int16s[n]	ExifIFD	(1 or 2 values: 1. The time zone offset of DateTimeOriginal from GMT in hours, 2. If present, the time zone offset of ModifyDate)
            //0x9010	OffsetTime	string	ExifIFD	(time zone for ModifyDate)

            // ex: DateTime: 2018:08:10 10:37:08
            exif_entry_get_value(entry, buf, sizeof(buf));
            m_date_metadatas = QDateTime::fromString(buf, "yyyy:MM:dd hh:mm:ss");
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_PIXEL_X_DIMENSION);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            width = QString::fromLatin1(buf).toUInt();
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_PIXEL_Y_DIMENSION);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            height = QString::fromLatin1(buf).toUInt();
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_X_RESOLUTION);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            resolution_x = QString::fromLatin1(buf).toUInt();
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_Y_RESOLUTION);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            resolution_y = QString::fromLatin1(buf).toUInt();
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_COLOR_SPACE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            //qDebug() << "EXIF_TAG_COLOR_SPACE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_1], EXIF_TAG_BITS_PER_SAMPLE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            //qDebug() << "EXIF_TAG_BITS_PER_SAMPLE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }

        //EXIF_TAG_COLOR_SPACE
        //EXIF_TAG_BITS_PER_SAMPLE
        //EXIF_TAG_YCBCR_COEFFICIENTS
        //EXIF_TAG_YCBCR_SUB_SAMPLING
        //EXIF_TAG_YCBCR_POSITIONING
        //EXIF_TAG_WHITE_POINT
        //EXIF_TAG_PRIMARY_CHROMATICITIES

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_ORIENTATION);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            //qDebug() << "EXIF_TAG_ORIENTATION" << QString::fromLatin1(buf);
/*
            1 = Horizontal (normal)
            2 = Mirror horizontal
            3 = Rotate 180
            4 = Mirror vertical
            5 = Mirror horizontal and rotate 270 CW
            6 = Rotate 90 CW
            7 = Mirror horizontal and rotate 90 CW
            8 = Rotate 270 CW
*/
/*
            if (strncmp(buf, "Top-left", sizeof(buf)) == 0)
            {
                //orientation = -90;
            }
            if (strncmp(buf, "Right-top", sizeof(buf)) == 0)
            {
                //orientation = 90;
            }
*/
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_FNUMBER);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            if (strlen(buf))
            {
                focal = buf;
                focal.replace("f", "ƒ");
            }
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_FOCAL_LENGTH);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            if (strlen(buf))
            {
                if (!focal.isEmpty()) focal += "  ";
                focal += buf;
            }
            m_exif_tag_found++;
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_ISO_SPEED_RATINGS);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            iso = buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_EXPOSURE_TIME);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            exposure_time = buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_EXPOSURE_BIAS_VALUE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            exposure_bias = buf;
            m_exif_tag_found++;
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_METERING_MODE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            metering_mode = buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_SHARPNESS);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            //qDebug() << "EXIF_TAG_SHARPNESS" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_SATURATION);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            //qDebug() << "EXIF_TAG_SATURATION" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_SHUTTER_SPEED_VALUE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            //qDebug() << "EXIF_TAG_SHUTTER_SPEED_VALUE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_APERTURE_VALUE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            //qDebug() << "EXIF_TAG_APERTURE_VALUE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_MAX_APERTURE_VALUE);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            //qDebug() << "EXIF_TAG_MAX_APERTURE_VALUE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        //EXIF_TAG_BRIGHTNESS_VALUE

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_FLASH);
        if (entry)
        {
            exif_entry_get_value(entry, buf, sizeof(buf));
            int flashvalue = QString::fromLatin1(buf).toInt();

            if (flashvalue > 0) flash = true;
            m_exif_tag_found++;
        }
        //EXIF_TAG_FLASH_ENERGY
        //EXIF_TAG_FLASH_PIX_VERSION

        // GPS infos ///////////////////////////////////////////////////////////

        QDate gpsDate;
        QTime gpsTime;
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                       static_cast<ExifTag>(EXIF_TAG_GPS_DATE_STAMP));
        if (entry)
        {
            // ex: GPSDateStamp: 2018:08:10
            exif_entry_get_value(entry, buf, sizeof(buf));
            gpsDate = QDate::fromString(buf, "yyyy:MM:dd");
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                       static_cast<ExifTag>(EXIF_TAG_GPS_TIME_STAMP));
        if (entry)
        {
            // ex: GPSTimeStamp: 08:36:14,00
            exif_entry_get_value(entry, buf, sizeof(buf));
            gpsTime = QTime::fromString(buf, "hh:mm:ss,z");

            if (!gpsTime.isValid())
                gpsTime = QTime::fromString(buf, "hh:mm:ss.z");
            m_exif_tag_found++;
        }

        if (gpsDate.isValid() && gpsTime.isValid())
            m_date_gps = QDateTime(gpsDate, gpsTime);

        if (m_date_gps.isValid())
        {
            m_hasGPS = true;
            m_exif_tag_found++;

            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_LATITUDE));
            if (entry)
            {
                // ex: "45, 41, 24,5662800"
                exif_entry_get_value(entry, buf, sizeof(buf));
                QString str = buf;
                double deg = str.midRef(0, 2).toDouble();
                double min = str.midRef(4, 2).toDouble();
                double sec = str.mid(8, 10).replace(',', '.').toDouble();
                gps_lat = deg + min/60.0 + sec/3600.0;
                gps_lat_str = str.mid(0, 2) + "° " + str.mid(4, 2) + "` " + str.mid(8, 8) + "``";

                entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                               static_cast<ExifTag>(EXIF_TAG_GPS_LATITUDE_REF));
                if (entry)
                {
                    exif_entry_get_value(entry, buf, sizeof(buf));
                    if (strncmp(buf, "S", 1) == 0)
                        gps_lat = -gps_lat;
                    gps_lat_str += " " +  QString::fromLatin1(buf);
                }
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_LONGITUDE));
            if (entry)
            {
                exif_entry_get_value(entry, buf, sizeof(buf));
                QString str = buf;
                double deg = str.midRef(0, 2).toDouble();
                double min = str.midRef(4, 2).toDouble();
                double sec = str.mid(8, 10).replace(',', '.').toDouble();
                gps_long = deg + min/60.0 + sec/3600.0;
                gps_long_str = str.mid(0, 2) + "° " + str.mid(4, 2) + "` " + str.mid(8, 8) + "``";

                entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                               static_cast<ExifTag>(EXIF_TAG_GPS_LONGITUDE_REF));
                if (entry)
                {
                    exif_entry_get_value(entry, buf, sizeof(buf));
                    if (strncmp(buf, "W", 1) == 0)
                        gps_long = -gps_long;
                    gps_long_str += " " + QString::fromLatin1(buf);
                }
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_ALTITUDE));
            if (entry)
            {
                exif_entry_get_value(entry, buf, sizeof(buf));
                QString str = buf;
                str.replace(',', '.');
                gps_alt = str.toDouble();
                gps_alt_str = QString::number(gps_alt, 'g', 3);
                gps_alt_str += " " +  QObject::tr("meters");

                entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                               static_cast<ExifTag>(EXIF_TAG_GPS_ALTITUDE_REF));
                if (entry)
                {
                    exif_entry_get_value(entry, buf, sizeof(buf));
                    QString gps_alt_ref_qstr = buf;
                    if (gps_alt_ref_qstr.contains("below", Qt::CaseInsensitive))
                        gps_alt = -gps_alt;
                }
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_VERSION_ID));
            if (entry)
            {
                exif_entry_get_value(entry, buf, sizeof(buf));
                gps_version = buf;
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_DIFFERENTIAL));
            if (entry)
            {
                exif_entry_get_value(entry, buf, sizeof(buf));
                gps_diff = QString::fromLatin1(buf).toUInt();
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_DOP));
            if (entry)
            {
                exif_entry_get_value(entry, buf, sizeof(buf));
                gps_dop = QString::fromLatin1(buf).toUInt();
            }
/*
            qDebug() << "gps_lat_str:" << gps_lat_str;
            qDebug() << "gps_long_str:" << gps_long_str;
            qDebug() << "gps_alt_str:" << gps_alt_str;
            qDebug() << "gps_lat:" << gps_lat;
            qDebug() << "gps_long:" << gps_long;
            qDebug() << "gps_alt:" << gps_alt;
            qDebug() << "gps_dop:" << m_gps_dop;
            qDebug() << "gps_diff:" << m_gps_diff;
            qDebug() << "gps_version:" << m_gps_version;
            qDebug() << "gps_timestamp:" << m_date_gps;
*/
        }

        // MAKERNOTE ///////////////////////////////////////////////////////////

        ExifMnoteData *mn = exif_data_get_mnote_data(ed);
        if (mn)
        {
            //qDebug() << "WE HAVE MAKERNOTEs";
        }

        exif_data_unref(ed);

        status = true;
    }
    else
    {
        //qDebug() << "File not readable or no EXIF data";
    }
#endif // ENABLE_LIBEXIF

#ifdef ENABLE_EXIV2
    Exiv2::Image::AutoPtr image = Exiv2::ImageFactory::open(m_pictures.at(index)->filesystemPath.toStdString());
    image->readMetadata();

    Exiv2::ExifData &exifData = image->exifData();
    if (!exifData.empty())
    {
        //
    }
    else
    {
        //qDebug() << "File not readable or no EXIF data";
    }
#endif // ENABLE_EXIV2

    // Gather additional infos
    QImageReader img_infos(m_path);
    if (img_infos.canRead())
    {
        m_type = Shared::FILE_PICTURE;

        vcodec = img_infos.format();
        width = img_infos.size().rwidth();
        height = img_infos.size().rheight();
        orientation = img_infos.transformation(); // FIXME

        status = true;
    }
    else
    {
        qWarning() << "QImageReader cannot read" << m_path;

        // QImage
        QImage img;
        if (img.load(m_path))
        {
            m_type = Shared::FILE_PICTURE;

            width = img.width();
            height = img.height();
            bpp = img.depth();
            alpha = img.hasAlphaChannel();

            status = true;
        }
        else
        {
            qWarning() << "QImage cannot read" << m_path;
        }
    }

    return status;
}

bool Media::getMetadatasFromAudio()
{
    //qDebug() << "Media::getMetadatasFromAudio()";
    bool status = false;

    if (m_path.isEmpty())
        return status;

#ifdef ENABLE_TAGLIB
    TagLib::FileRef f(m_path.toLocal8Bit());
    if(!f.isNull() && f.tag())
    {
        m_hasAudioTags = true;
        status = true;

        TagLib::Tag *tag = f.tag();
        if (tag->artist().length())
        {
            tag_artist = QString::fromStdWString(tag->artist().toCWString());
            m_audio_tag_found++;
        }
        if (tag->title().length())
        {
            tag_title = QString::fromStdWString(tag->title().toCWString());
            m_audio_tag_found++;
        }
        if (tag->album().length())
        {
            tag_album = QString::fromStdWString(tag->album().toCWString());
            m_audio_tag_found++;
        }
        if (tag->track() > 0)
        {
            tag_track_nb = tag->track();
            m_audio_tag_found++;
        }
        if (tag->year() > 0)
        {
            tag_year = tag->year();
            m_audio_tag_found++;
        }
        if (tag->genre().length())
        {
            tag_genre = QString::fromStdWString(tag->genre().toCWString());
            m_audio_tag_found++;
        }
        if (tag->comment().length())
        {
            tag_comment = QString::fromStdWString(tag->comment().toCWString());
            m_audio_tag_found++;
        }

        //std::cout << "-- TAG (properties) --" << std::endl;
        TagLib::PropertyMap tags = f.file()->properties();
        for (TagLib::PropertyMap::ConstIterator i = tags.begin(); i != tags.end(); ++i)
        {
            for (TagLib::StringList::ConstIterator j = i->second.begin(); j != i->second.end(); ++j)
            {
                QString key = QString::fromStdWString((i->first).toCWString());

                if (key == "TRACKTOTAL")
                    tag_track_total = (*j).toInt();
                else if (key == "COVERARTMIME")
                    tag_covertart_mime = QString::fromStdWString((*j).toCWString());
                else if (key == "TRANSCODED")
                    tag_transcoded = QString::fromStdWString((*j).toCWString());
                else if (key == "TRACKNUMBER")
                {
                    std::string a = (*j).to8Bit();
                    a = a.substr(a.rfind('/')+1);
                    tag_track_total = std::stoi(a);
                }

                //qDebug() << key << " - " << QString::fromStdWString((*j).toCWString());
            }
        }

        //TagLib::APE::Tag *ape = f.APETag();
        //TagLib::ID3v1::Tag *id31 = f.();
        //TagLib::ID3v2::Tag *id32 = f.();
    }

    if(!f.isNull() && f.audioProperties())
    {
        TagLib::AudioProperties *properties = f.audioProperties();

        //int seconds = properties->length() % 60;
        //int minutes = (properties->length() - seconds) / 60;

        if (m_duration <= 0)
           m_duration = properties->lengthInMilliseconds();
        if (abitrate <= 0)
           abitrate = properties->bitrate()*1000;
        if (asamplerate <= 0)
           asamplerate = properties->sampleRate();
        if (achannels <= 0)
           achannels = properties->channels();
     }

#endif // ENABLE_TAGLIB

    return status;
}

bool Media::getMetadatasFromVideo()
{
    //qDebug() << "Media::getMetadatasFromVideo()";
    bool status = false;

    if (m_path.isEmpty())
        return status;

    // open it
    int minivideo_retcode = minivideo_open(m_path.toLocal8Bit(), &m_media);
    if (minivideo_retcode == 1)
    {
        minivideo_retcode = minivideo_parse(m_media, true, false);
        if (minivideo_retcode != 1)
        {
            qDebug() << "minivideo_parse() failed with retcode: " << minivideo_retcode;
            minivideo_close(&m_media);
        }
    }
    else
    {
        qDebug() << "minivideo_open() failed with retcode: " << minivideo_retcode;
        qDebug() << "minivideo_open() cannot open: " << m_path;
        qDebug() << "minivideo_open() cannot open: " << m_path.toLocal8Bit();
    }

    if (m_media)
    {
        m_file_name = m_media->file_name;
        m_file_folder = m_media->file_directory;

        m_file_extension = m_media->file_extension;
        m_file_container = getContainerString(m_media->container, true);

        m_creation_app = QString::fromLocal8Bit(m_media->creation_app);
        m_creation_lib = QString::fromLocal8Bit(m_media->creation_lib);

        m_duration = static_cast<qint64>(m_media->duration);

        m_date_metadatas = QDateTime::fromTime_t(m_media->creation_time);

        for (unsigned i = 0; i < m_media->tracks_audio_count; i++)
        {
            if (m_media->tracks_audio[i])
            {
                m_type = Shared::FILE_AUDIO;

                if (i == 0)
                {
                    acodec = QString::fromLocal8Bit(getCodecString(stream_AUDIO, m_media->tracks_audio[0]->stream_codec, true));
                    achannels = m_media->tracks_audio[0]->channel_count;
                    asamplerate = m_media->tracks_audio[0]->sampling_rate;
                    abitrate = m_media->tracks_audio[0]->bitrate_avg;
                }

                MediaTrackQml *t = new MediaTrackQml(this);
                t->loadMediaStream(m_media->tracks_audio[i]);

                if (t && t->isValid())
                {
                    tracksAudio.push_back(t);
                }
            }
        }
        for (unsigned i = 0; i < m_media->tracks_video_count; i++)
        {
            if (m_media->tracks_video[i])
            {
                m_type = Shared::FILE_VIDEO;

                if (i == 0)
                {
                    width = m_media->tracks_video[0]->width;
                    height = m_media->tracks_video[0]->height;
                    //m_duration = m_media->tracks_video[0]->stream_duration_ms;
                    projection = m_media->tracks_video[0]->video_projection;

                    vcodec = QString::fromLocal8Bit(getCodecString(stream_VIDEO, m_media->tracks_video[0]->stream_codec, true));
                    vframerate = m_media->tracks_video[0]->framerate;
                    vbitrate = m_media->tracks_video[0]->bitrate_avg;
                    vbitratemode = m_media->tracks_video[0]->bitrate_mode;
                }

                MediaTrackQml *t = new MediaTrackQml(this);
                t->loadMediaStream(m_media->tracks_video[i]);

                if (t && t->isValid())
                {
                    tracksVideo.push_back(t);
                }
            }
        }

        for (unsigned i = 0; i < m_media->tracks_subtitles_count; i++)
        {
            if (m_media->tracks_subt[i])
            {
                MediaTrackQml *t = new MediaTrackQml(this);
                t->loadMediaStream(m_media->tracks_subt[i]);

                if (t && t->isValid())
                {
                    tracksSubtitles.push_back(t);
                }
            }
        }

        for (unsigned i = 0; i < m_media->tracks_others_count; i++)
        {
            if (m_media->tracks_others[i])
            {
                MediaStream_t *t = m_media->tracks_others[i];

                if (t->stream_type == stream_TMCD && vtimecode.isEmpty())
                {
                    vtimecode += QString("%1:%2:%3-%4")\
                                    .arg(t->time_reference[0], 2, 'u', 0, '0')\
                                    .arg(t->time_reference[1], 2, 'u', 0, '0')\
                                    .arg(t->time_reference[2], 2, 'u', 0, '0')\
                                    .arg(t->time_reference[3], 2, 'u', 0, '0');
                }
/*
                else if (t->stream_fcc == fourcc_be("gpmd"))
                {
                    MediaStream_t *t = m_media->tracks_others[i];

                    uint32_t gpmf_sample_count = t->sample_count;
                    int devc_count = 0;

                    if (devc_count)
                        hasGPMF = true;

                    // Now the purpose of the following code is to get accurate
                    // date from the GPS, but in case of chaptered videos, we may
                    // have that date already, so don't run this code twice
                    if (!m_date_gps.isValid())
                    {
                        for (unsigned sp_index = 0; sp_index < gpmf_sample_count; sp_index++)
                        {
                            MediaSample_t *sp = minivideo_get_sample(media, t, sp_index);

                            GpmfBuffer buf;
                            if (buf.loadBuffer(sp->data, sp->size))
                            {
                                if (parseGpmfSampleFast(buf, devc_count))
                                {
                                    // we have GPS datetime
                                    minivideo_destroy_sample(&sp);
                                    break;
                                }
                            }

                            minivideo_destroy_sample(&sp);
                        }
                    }
                }
*/
                MediaTrackQml *tt = new MediaTrackQml(this);
                tt->loadMediaStream(m_media->tracks_others[i]);

                if (tt && tt->isValid())
                {
                    tracksOther.push_back(tt);
                }
            }
        }

        return true;
    }

    return false;
}

/* ************************************************************************** */
/* ************************************************************************** */

QVariant Media::getVideoTrack(int tid)
{
    if (tracksVideo.count() > tid && tracksVideo.at(tid))
    {
        return QVariant::fromValue(tracksVideo.at(tid));
    }

    return QVariant();
}

QVariant Media::getAudioTrack(int tid)
{
    if (tracksAudio.count() > tid && tracksAudio.at(tid))
    {
        return QVariant::fromValue(tracksAudio.at(tid));
    }

    return QVariant();
}

QVariant Media::getSubtitlesTrack(int tid)
{
    if (tracksSubtitles.count() > tid && tracksSubtitles.at(tid))
    {
        return QVariant::fromValue(tracksSubtitles.at(tid));
    }

    return QVariant();
}

QVariant Media::getOtherTrack(int tid)
{
    if (tracksOther.count() > tid && tracksOther.at(tid))
    {
        return QVariant::fromValue(tracksOther.at(tid));
    }

    return QVariant();
}

/* ************************************************************************** */
/* ************************************************************************** */

QString Media::getCreationApp() const
{
    return m_creation_app;
}

QString Media::getCreationLib() const
{
    return m_creation_lib;
}

QDateTime Media::getDate() const
{
    return m_date_file_m;
}

QDateTime Media::getDateFile() const
{
    return m_date_file_m;
}

QDateTime Media::getDateMetadata() const
{
    return m_date_metadatas;
}

QDateTime Media::getDateGPS() const
{
    return m_date_gps;
}

/* ************************************************************************** */
/* ************************************************************************** */

QString Media::getExportString()
{
    QString exportDatas;

    if (m_media)
    {
        textExport::generateExportDatas_text(*m_media, exportDatas, true);
    }

    return exportDatas;
}

bool Media::saveExportString()
{
    bool status = false;

    if (m_media)
    {
        QString exportDatas;
        textExport::generateExportDatas_text(*m_media, exportDatas, true);
        if (!exportDatas.isEmpty())
        {
            QString ppp = m_file_folder + m_file_name + "_infos.txt";
            QFile exportFile;
            exportFile.setFileName(ppp);
            if (exportFile.exists() == false)
            {
                if (exportFile.open(QIODevice::WriteOnly) == true &&
                    exportFile.isWritable() == true)
                {
                    if (exportFile.write(exportDatas.toLocal8Bit()) == exportDatas.toLocal8Bit().size())
                    {
                        status = true;
                    }
                    exportFile.close();
                }
                else
                {
                    qDebug() << "saveExportString() not writable: " << ppp;
                }
            }
            else
            {
                qDebug() << "saveExportString() already exists: " << ppp;
            }
        }
    }

    return status;
}
