/*!
 * COPYRIGHT (C) 2020 Emeric Grange - All Rights Reserved
 *
 * This file is part of MiniVideoInfos.
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

#include "Media.h"
#include "MediaUtils.h"
#include "minivideo_utils_qt.h"
#include "minivideo_textexport_qt.h"
#include "utils_app.h"

#include <EGM96/EGM96.h>

#if defined(ENABLE_LIBEXIF)
#include <libexif/exif-data.h>
#endif

#if defined(ENABLE_EXIV2)
#include <exiv2/exiv2.hpp>
#endif

#if defined(ENABLE_TAGLIB)
#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/tpropertymap.h>
#include <iomanip>

#include <taglib/id3v2tag.h>
#include <taglib/id3v1tag.h>
#include <taglib/apetag.h>
#endif

#include <cstdint>
#include <cstring>
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

        m_date_file_c = fi.birthTime();
        m_date_file_m = fi.lastModified();
    }

    if (!m_valid) m_valid = getMetadataFromVideo();
    if (!m_valid) m_valid = getMetadataFromPicture();
    if (!m_valid || (m_valid && tracksVideo.length() == 0 && tracksAudio.length() > 0)) m_valid = getMetadataFromAudio();
}

Media::~Media()
{
    //
}

bool Media::load()
{
    if (!m_valid) m_valid = getMetadataFromVideo();
    if (!m_valid) m_valid = getMetadataFromPicture();
    if (!m_valid || (m_valid && tracksVideo.length() == 0 && tracksAudio.length() > 0)) m_valid = getMetadataFromAudio();

    return m_valid;
}

/* ************************************************************************** */
/* ************************************************************************** */
/*
#if defined(ENABLE_LIBEXIF)
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
bool Media::getMetadataFromPicture()
{
    bool status = false;

#if defined(ENABLE_LIBEXIF)

    ExifData *ed = exif_data_new_from_file(m_path.toLocal8Bit());
    if (ed)
    {
        m_hasEXIF = true;
        m_exif_tag_found = 0;

        // Parse tags
        ExifEntry *entry;
        char entry_buf[1024];

        ExifByteOrder byteOrder = exif_data_get_byte_order(ed);

        // EXIF ////////////////////////////////////////////////////////////////

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_MAKE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            m_camera_brand = entry_buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_MODEL);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            m_camera_model = entry_buf;
            m_exif_tag_found++;
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_SOFTWARE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            m_camera_software = entry_buf;
            m_exif_tag_found++;
        }

        // Geometry ////////////////////////////////////////////////////////////

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_PIXEL_X_DIMENSION);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            width = QString::fromLatin1(entry_buf).toUInt();
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_PIXEL_Y_DIMENSION);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            height = QString::fromLatin1(entry_buf).toUInt();
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_X_RESOLUTION);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            resolution_x = QString::fromLatin1(entry_buf).toUInt();
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_Y_RESOLUTION);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            resolution_y = QString::fromLatin1(entry_buf).toUInt();
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_COLOR_SPACE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            //qDebug() << "EXIF_TAG_COLOR_SPACE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_1], EXIF_TAG_BITS_PER_SAMPLE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            //qDebug() << "EXIF_TAG_BITS_PER_SAMPLE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }

        //EXIF_TAG_YCBCR_COEFFICIENTS
        //EXIF_TAG_YCBCR_SUB_SAMPLING
        //EXIF_TAG_YCBCR_POSITIONING
        //EXIF_TAG_WHITE_POINT
        //EXIF_TAG_PRIMARY_CHROMATICITIES

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_ORIENTATION);
        if (entry)
        {
/*
            1 = Horizontal (default)                // "Top-left"
            2 = Mirror horizontal                   // "Top-right"
            3 = Rotate 180                          // "Bottom-right"
            4 = Mirror vertical                     // "Bottom-left"
            5 = Mirror vertical and rotate 90 CW    // "Left-top"
            6 = Rotate 90 CW                        // "Right-top"
            7 = Mirror horizontal and rotate 90 CW  // "Right-bottom"
            8 = Rotate 270 CW                       // "Left-bottom"
*/
            int orientation = exif_get_short(entry->data, byteOrder);
            //qDebug() << "orientation value:" << orientation;

            //exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            //qDebug() << "orientation string:" << entry_buf;

            if (orientation == 1)
                transformation = QImageIOHandler::TransformationNone;
            else if (orientation == 2)
                transformation = QImageIOHandler::TransformationMirror;
            else if (orientation == 3)
                transformation = QImageIOHandler::TransformationRotate180;
            else if (orientation == 4)
                transformation = QImageIOHandler::TransformationFlip;
            else if (orientation == 5)
                transformation = QImageIOHandler::TransformationFlipAndRotate90;
            else if (orientation == 6)
                transformation = QImageIOHandler::TransformationRotate90;
            else if (orientation == 7)
                transformation = QImageIOHandler::TransformationMirrorAndRotate90;
            else if (orientation == 8)
                transformation = QImageIOHandler::TransformationRotate270;

            m_exif_tag_found++;
        }

        // Camera settings /////////////////////////////////////////////////////

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_FNUMBER);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            if (strlen(entry_buf))
            {
                focal = entry_buf;
                focal.replace("f", "ƒ");
            }
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_FOCAL_LENGTH);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            if (strlen(entry_buf))
            {
                if (!focal.isEmpty()) focal += "  ";
                focal += entry_buf;
            }
            m_exif_tag_found++;
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_ISO_SPEED_RATINGS);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            iso = entry_buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_EXPOSURE_TIME);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            exposure_time = entry_buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_EXPOSURE_BIAS_VALUE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            exposure_bias = entry_buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_METERING_MODE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            metering_mode = entry_buf;
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_SHARPNESS);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            //qDebug() << "EXIF_TAG_SHARPNESS" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_SATURATION);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            //qDebug() << "EXIF_TAG_SATURATION" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_SHUTTER_SPEED_VALUE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            //qDebug() << "EXIF_TAG_SHUTTER_SPEED_VALUE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_APERTURE_VALUE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            //qDebug() << "EXIF_TAG_APERTURE_VALUE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_MAX_APERTURE_VALUE);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            //qDebug() << "EXIF_TAG_MAX_APERTURE_VALUE" << QString::fromLatin1(buf);
            //m_exif_tag_found++;
        }
        //EXIF_TAG_BRIGHTNESS_VALUE

        // Flash ///////////////////////////////////////////////////////////////

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_EXIF], EXIF_TAG_FLASH);
        if (entry)
        {
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            int flashvalue = QString::fromLatin1(entry_buf).toInt();

            if (flashvalue > 0) flash = true;
            m_exif_tag_found++;
        }
        //EXIF_TAG_FLASH_ENERGY
        //EXIF_TAG_FLASH_PIX_VERSION

        // DateTime ////////////////////////////////////////////////////////////

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_DATE_TIME);
        if (entry)
        {
            // TODO
            //0x882a	TimeZoneOffset	int16s[n]	ExifIFD	(1 or 2 values: 1. The time zone offset of DateTimeOriginal from GMT in hours, 2. If present, the time zone offset of ModifyDate)
            //0x9010	OffsetTime	string	ExifIFD	(time zone for ModifyDate)

            // ex: DateTime: 2018:08:10 10:37:08
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            m_date_metadata = QDateTime::fromString(entry_buf, "yyyy:MM:dd hh:mm:ss");
        }

        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_0], EXIF_TAG_DATE_TIME);
        if (entry)
        {
            // TODO
            //0x882a	TimeZoneOffset	int16s[n]	ExifIFD	(1 or 2 values: 1. The time zone offset of DateTimeOriginal from GMT in hours, 2. If present, the time zone offset of ModifyDate)
            //0x9010	OffsetTime	string	ExifIFD	(time zone for ModifyDate)

            // ex: DateTime: 2018:08:10 10:37:08
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            m_date_metadata = QDateTime::fromString(entry_buf, "yyyy:MM:dd hh:mm:ss");
            m_exif_tag_found++;
        }

        QDate gpsDate;
        QTime gpsTime;
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                       static_cast<ExifTag>(EXIF_TAG_GPS_DATE_STAMP));
        if (entry)
        {
            // ex: GPSDateStamp: 2018:08:10
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            gpsDate = QDate::fromString(entry_buf, "yyyy:MM:dd");
            m_exif_tag_found++;
        }
        entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                       static_cast<ExifTag>(EXIF_TAG_GPS_TIME_STAMP));
        if (entry)
        {
            // ex: GPSTimeStamp: 08:36:14,00
            exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
            gpsTime = QTime::fromString(entry_buf, "hh:mm:ss,z");

            if (!gpsTime.isValid())
                gpsTime = QTime::fromString(entry_buf, "hh:mm:ss.z");
            m_exif_tag_found++;
        }

        if (gpsDate.isValid() && gpsTime.isValid())
            m_date_gps = QDateTime(gpsDate, gpsTime);

        // GPS infos ///////////////////////////////////////////////////////////////

        if (m_date_gps.isValid())
        {
            m_hasGPS = true;
            m_exif_tag_found++;

            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_LATITUDE));
            if (entry)
            {
                // ex: "45, 41, 24,5662800"
                exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                QString str = entry_buf;
                double deg = QStringView{str}.mid(0, 2).toDouble();
                double min = QStringView{str}.mid(4, 2).toDouble();
                double sec = str.mid(8, 10).replace(',', '.').toDouble();
                gps_lat = deg + min/60.0 + sec/3600.0;

                entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                               static_cast<ExifTag>(EXIF_TAG_GPS_LATITUDE_REF));
                if (entry)
                {
                    exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                    if (strncmp(entry_buf, "S", 1) == 0)
                    {
                        gps_lat = -gps_lat;
                        //gps_lat_str += " " +  QString::fromLatin1(entry_buf);
                    }
                }

                gps_lat_str = str.mid(0, 2) + "° " + str.mid(4, 2) + "` " + str.mid(8, 8) + "`` N";
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_LONGITUDE));
            if (entry)
            {
                exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                QString str = entry_buf;
                double deg = QStringView{str}.mid(0, 2).toDouble();
                double min = QStringView{str}.mid(4, 2).toDouble();
                double sec = str.mid(8, 10).replace(',', '.').toDouble();
                gps_long = deg + min/60.0 + sec/3600.0;

                entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                               static_cast<ExifTag>(EXIF_TAG_GPS_LONGITUDE_REF));
                if (entry)
                {
                    exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                    if (strncmp(entry_buf, "W", 1) == 0)
                    {
                        gps_long = -gps_long;
                        //gps_long_str += " " + QString::fromLatin1(entry_buf);
                    }
                }

                gps_long_str = str.mid(0, 2) + "° " + str.mid(4, 2) + "` " + str.mid(8, 8) + "`` E";
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_ALTITUDE));
            if (entry)
            {
                exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                gps_alt = QString::fromLatin1(entry_buf).replace(',', '.').toDouble();

                entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                               static_cast<ExifTag>(EXIF_TAG_GPS_ALTITUDE_REF));
                if (entry)
                {
                    exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                    QString alt_ref_str = entry_buf;
                    if (alt_ref_str.contains("below", Qt::CaseInsensitive))
                        gps_alt = -gps_alt;
                }

                gps_alt_str = QString::number(gps_alt, 'g', 3);
                gps_alt_str += " " +  QObject::tr("meters");
                gps_alt_egm96 = egm96_compute_altitude_offset(gps_lat, gps_long);
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_IMG_DIRECTION));
            if (entry)
            {
                exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                gps_direction = QString::fromLatin1(entry_buf).replace(',', '.').toDouble();
                gps_direction_str = QString::number(gps_direction, 'g', 4);

                //entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                //                               static_cast<ExifTag>(EXIF_TAG_GPS_IMG_DIRECTION_REF));
                //if (entry)
                //{
                //    exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                //    QString dir_ref_str = entry_buf;
                //}
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_SPEED));
            if (entry)
            {
                exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                gps_speed = QString::fromLatin1(entry_buf).replace(',', '.').toDouble();

                entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                               static_cast<ExifTag>(EXIF_TAG_GPS_SPEED_REF));
                if (entry)
                {
                    exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));

                    if (strncmp(entry_buf, "M", 1) == 0)
                    {
                        // miles/h to km/h
                        gps_speed *= 1.60934;
                    }
                    else if (strncmp(entry_buf, "N", 1) == 0)
                    {
                        // knots to km/h
                        gps_speed *= 1.852;
                    }
                    //else if (strncmp(entry_buf, "K", 1) == 0) //km/h
                }

                gps_speed_str = QString::number(gps_speed, 'g', 4);
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_VERSION_ID));
            if (entry)
            {
                exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                gps_version = entry_buf;
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_DIFFERENTIAL));
            if (entry)
            {
                exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                gps_diff = QString::fromLatin1(entry_buf).toUInt();
            }
            entry = exif_content_get_entry(ed->ifd[EXIF_IFD_GPS],
                                           static_cast<ExifTag>(EXIF_TAG_GPS_DOP));
            if (entry)
            {
                exif_entry_get_value(entry, entry_buf, sizeof(entry_buf));
                gps_dop = QString::fromLatin1(entry_buf).toUInt();
            }
/*
            qDebug() << "gps_timestamp: " << m_date_gps;
            qDebug() << "gps_lat_str:   " << gps_lat_str;
            qDebug() << "gps_long_str:  " << gps_long_str;
            qDebug() << "gps_alt_str:   " << gps_alt_str;
            qDebug() << "gps_direction_str:" << gps_direction_str;
            qDebug() << "gps_speed_str: " << gps_speed_str;
            qDebug() << "gps_lat:  " << gps_lat;
            qDebug() << "gps_long: " << gps_long;
            qDebug() << "gps_alt:  " << gps_alt;
            qDebug() << "gps_alt_offset:" << gps_alt_egm96;
            qDebug() << "gps_direction: " << gps_direction;
            qDebug() << "gps_speed:     " << gps_speed;
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

#if defined(ENABLE_EXIV2)
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
        transformation = img_infos.transformation();

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

    // Post processing
    computeAdditionalMetadata();

    return status;
}

bool Media::getMetadataFromAudio()
{
    //qDebug() << "Media::getMetadataFromAudio()";
    bool status = false;

    if (m_path.isEmpty())
        return status;

#if defined(ENABLE_TAGLIB)
    TagLib::FileRef f(m_path.toLocal8Bit());
    if (!f.isNull() && f.tag())
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

    if (!f.isNull() && f.audioProperties())
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

bool Media::getMetadataFromVideo()
{
    //qDebug() << "Media::getMetadataFromVideo()";
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
        qWarning() << "minivideo_open() failed with retcode: " << minivideo_retcode;
        qDebug() << "minivideo_open() cannot open: " << m_path;
        qDebug() << "minivideo_open() cannot open: " << m_path.toLocal8Bit();
    }

    if (m_media)
    {
        m_file_name = m_media->file_name;
        m_file_folder = m_media->file_directory;

        m_file_extension = m_media->file_extension;
        m_file_extension_mismatch = (m_media->container_sc != m_media->container_ext);
        m_file_extension_container = getContainerString(m_media->container, false);
        m_file_container = getContainerString(m_media->container, true);
        m_file_containerprofile = getContainerProfileString(m_media->container_profile, true);

        m_creation_app = QString::fromLocal8Bit(m_media->creation_app);
        m_creation_lib = QString::fromLocal8Bit(m_media->creation_lib);

        m_duration = static_cast<qint64>(m_media->duration);

        m_date_metadata = QDateTime::fromSecsSinceEpoch(m_media->creation_time);

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
                    rotation = m_media->tracks_video[0]->video_rotation * 90;
                    if (m_media->tracks_video[0]->video_rotation == 1)
                        transformation = QImageIOHandler::TransformationRotate90;
                    else if (m_media->tracks_video[0]->video_rotation == 2)
                        transformation = QImageIOHandler::TransformationRotate180;
                    else if (m_media->tracks_video[0]->video_rotation == 3)
                        transformation = QImageIOHandler::TransformationRotate270;

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

        for (unsigned i = 0; i < m_media->chapters_count; i++)
        {
            Chapter_t *ch = &m_media->chapters[i];
            if (ch == nullptr) break;

            MediaChapterQml *c = new MediaChapterQml(ch->pts, QString::fromUtf8(ch->name), this);
            if (c) trackChapters.push_back(c);
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
                else if (t->stream_fcc == fourcc_be("gpmd"))
                {
/*
                    MediaStream_t *t = m_media->tracks_others[i];

                    //uint32_t gpmf_sample_count = t->sample_count;
                    int devc_count = 0;

                    if (devc_count)
                        m_hasGPMF = true;

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
*/
                }

                MediaTrackQml *tt = new MediaTrackQml(this);
                tt->loadMediaStream(m_media->tracks_others[i]);

                if (tt && tt->isValid())
                {
                    tracksOther.push_back(tt);
                }
            }
        }

        // Post processing
        computeAdditionalMetadata();

        status = true;
    }

    return status;
}

void Media::computeAdditionalMetadata()
{
    // Get default aspect ratio value for the UI
    if (transformation >= QImageIOHandler::TransformationRotate90 ||
        rotation == 90 || rotation == 270)
    {
        width_visible = height;
        height_visible = width;
    }
    else
    {
        width_visible = width;
        height_visible = height;
    }

    //qDebug() << "Media::computeAdditionalMetadata(g)" << width << height;
    //qDebug() << "Media::computeAdditionalMetadata(v)" << width_visible << height_visible;

    ar = MediaUtils::arFromGeometry(width, height);
    ar_visible = MediaUtils::arFromGeometry(width_visible, height_visible);
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
    return m_date_metadata;
}

QDateTime Media::getDateGPS() const
{
    return m_date_gps;
}

/* ************************************************************************** */
/* ************************************************************************** */

QString Media::getExportString()
{
    QString exportData;

    if (m_media)
    {
        textExport::generateExportData_text(*m_media, exportData, true);
    }

    return exportData;
}

bool Media::saveExportString()
{
    bool status = false;

    UtilsApp *utilsApp = UtilsApp::getInstance();
    utilsApp->getMobileStorageWritePermission();

    if (m_media)
    {
        QString exportData;
        textExport::generateExportData_text(*m_media, exportData, true);

        if (!exportData.isEmpty())
        {
            QString exportFilePath = m_file_folder + m_file_name + "_infos.txt";

            QFile exportFile;
            exportFile.setFileName(exportFilePath);

            if (exportFile.exists() == true)
            {
                qWarning() << "saveExportString() already exists: " << exportFilePath;
            }

            if (exportFile.open(QIODevice::WriteOnly) == true &&
                exportFile.isWritable() == true)
            {
                if (exportFile.write(exportData.toLocal8Bit()) == exportData.toLocal8Bit().size())
                {
                    status = true;
                }
                exportFile.close();
            }
            else
            {
                qWarning() << "saveExportString() not writable: " << exportFilePath;
            }
        }
    }

    return status;
}

QString Media::openExportString()
{
    QString exportFilePath;

    if (m_media)
    {
        QString exportData;
        textExport::generateExportData_text(*m_media, exportData, true);
        if (!exportData.isEmpty())
        {
            // Get temp directory path
            QString exportDirectory = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).value(0);

            QDir ddd(exportDirectory + "/export");
            if (!ddd.exists()) ddd.mkpath(exportDirectory + "/export");

            // Get temp file path
            exportFilePath = exportDirectory + "/export/" + m_file_name + "_infos.txt";

            QFile exportFile;
            exportFile.setFileName(exportFilePath);

            if (exportFile.open(QIODevice::WriteOnly) == true &&
                exportFile.isWritable() == true)
            {
                exportFile.write(exportData.toLocal8Bit());
                exportFile.close();
            }
            else
            {
                qWarning() << "openExportString() not writable: " << exportFilePath;
                exportFilePath = "";
            }
        }
    }

    return exportFilePath;
}

/* ************************************************************************** */

QString Media::getSubtitlesString(unsigned track)
{
    QString subtitlesData;

    if (m_media)
    {
        textExport::generateSubtitlesData_text(*m_media, subtitlesData, track);
    }

    return subtitlesData;
}

bool Media::saveSubtitlesString(unsigned track)
{
    bool status = false;

    UtilsApp *utilsApp = UtilsApp::getInstance();
    utilsApp->getMobileStorageWritePermission();

    if (m_media)
    {
        if (m_media->tracks_subtitles_count <= track) return status;

        QString subtitlesData;
        textExport::generateSubtitlesData_text(*m_media, subtitlesData, track);

        if (!subtitlesData.isEmpty())
        {
            QString lng = m_media->tracks_subt[track]->track_languagecode;
            if (lng.size()) lng.prepend("_");
            QString subtitlesFilePath = m_file_folder + m_file_name + lng + ".srt";

            QFile subtitlesFile;
            subtitlesFile.setFileName(subtitlesFilePath);

            if (subtitlesFile.exists() == true)
            {
                qWarning() << "saveSubtitlesString() already exists: " << subtitlesFilePath;
            }

            if (subtitlesFile.open(QIODevice::WriteOnly) == true &&
                subtitlesFile.isWritable() == true)
            {
                if (subtitlesFile.write(subtitlesData.toLocal8Bit()) == subtitlesData.toLocal8Bit().size())
                {
                    status = true;
                }
                subtitlesFile.close();
            }
            else
            {
                qWarning() << "saveSubtitlesString() not writable: " << subtitlesFilePath;
            }
        }
    }

    return status;
}

QString Media::openSubtitlesString(unsigned track)
{
    QString subtitlesFilePath;

    if (m_media)
    {
        if (m_media->tracks_subtitles_count <= track) return subtitlesFilePath;

        QString subtitlesData;
        textExport::generateExportData_text(*m_media, subtitlesData, true);

        if (!subtitlesData.isEmpty())
        {
            QString lng = m_media->tracks_subt[track]->track_languagecode;
            if (lng.size()) lng.prepend("_");

            // Get temp directory path
            QString exportDirectory = QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).value(0);

            QDir ddd(exportDirectory + "/export");
            if (!ddd.exists()) ddd.mkpath(exportDirectory + "/export");

            // Get temp file path
            subtitlesFilePath = exportDirectory + "/export/" + m_file_name + lng + ".srt";

            QFile subtitlesFile;
            subtitlesFile.setFileName(subtitlesFilePath);

            if (subtitlesFile.open(QIODevice::WriteOnly) == true &&
                subtitlesFile.isWritable() == true)
            {
                subtitlesFile.write(subtitlesData.toLocal8Bit());
                subtitlesFile.close();
            }
            else
            {
                qWarning() << "openSubtitlesString() not writable: " << subtitlesFilePath;
                subtitlesFilePath = "";
            }
        }
    }

    return subtitlesFilePath;
}

/* ************************************************************************** */
