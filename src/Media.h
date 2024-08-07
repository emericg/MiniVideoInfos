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

#ifndef MEDIA_H
#define MEDIA_H
/* ************************************************************************** */

#include <minivideo/minivideo.h>
#include "minivideo_qml.h"
#include "minivideo_track_qml.h"

#include "minivideo_utils_qt.h"

#include <QObject>
#include <QImage>
#include <QString>
#include <QDateTime>
#include <QAbstractListModel>

/* ************************************************************************** */

/*!
 * \brief The Media class
 */
class Media: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool valid READ isValid NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned fileType READ getFileType NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned shotType READ getShotType NOTIFY mediaUpdated)

    Q_PROPERTY(QString fullpath READ getPath NOTIFY mediaUpdated)

    Q_PROPERTY(QString name READ getName NOTIFY mediaUpdated)
    Q_PROPERTY(QString path READ getFolder NOTIFY mediaUpdated)
    Q_PROPERTY(QString ext READ getExtension NOTIFY mediaUpdated)
    Q_PROPERTY(bool extensionMismatch READ getExtensionMismatch NOTIFY mediaUpdated)
    Q_PROPERTY(QString container READ getContainer NOTIFY mediaUpdated)
    Q_PROPERTY(QString containerExt READ getExtensionContainer NOTIFY mediaUpdated)
    Q_PROPERTY(QString containerProfile READ getContainerProfile NOTIFY mediaUpdated)
    Q_PROPERTY(qint64 size READ getSize NOTIFY mediaUpdated)

    Q_PROPERTY(QString creation_app READ getCreationApp NOTIFY mediaUpdated)
    Q_PROPERTY(QString creation_lib READ getCreationLib NOTIFY mediaUpdated)

    Q_PROPERTY(bool hasImage READ hasImage NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasVideo READ hasVideo NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasVideoTags READ hasVideoTags NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasAudio READ hasAudio NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasAudioTags READ hasAudioTags NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasSubtitles READ hasSubtitles NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasChapters READ hasChapters NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasEXIF READ hasEXIF NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasGPS READ hasGPS NOTIFY mediaUpdated)
    Q_PROPERTY(bool hasGPMF READ hasGPMF NOTIFY mediaUpdated)

    Q_PROPERTY(QString cameraBrand READ getCameraBrand NOTIFY mediaUpdated)
    Q_PROPERTY(QString cameraModel READ getCameraModel NOTIFY mediaUpdated)
    Q_PROPERTY(QString cameraSoftware READ getCameraSoftware NOTIFY mediaUpdated)
    //Q_PROPERTY(int chapters READ getChapterCount NOTIFY mediaUpdated)
    //Q_PROPERTY(int highlightCount READ getHighlightCount NOTIFY mediaUpdated)

    Q_PROPERTY(QString timecode READ getTimecode NOTIFY mediaUpdated)
    Q_PROPERTY(qint64 duration READ getDuration NOTIFY mediaUpdated)
    Q_PROPERTY(QDateTime date READ getDate NOTIFY mediaUpdated)
    Q_PROPERTY(QDateTime dateFile READ getDateFile NOTIFY mediaUpdated)
    Q_PROPERTY(QDateTime dateMetadata READ getDateMetadata NOTIFY mediaUpdated)
    Q_PROPERTY(QDateTime dateGPS READ getDateGPS NOTIFY mediaUpdated)

    // image/video metadata
    Q_PROPERTY(unsigned width READ getWidth NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned height READ getHeight NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned ar READ getAr NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned widthVisible READ getWidthVisible NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned heightVisible READ getHeightVisible NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned arVisible READ getArVisible NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned depth READ getDepth NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned resolution READ getResolution NOTIFY mediaUpdated)
    Q_PROPERTY(bool alpha READ getAlpha NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned projection READ getProjection NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned transformation READ getTransformation NOTIFY mediaUpdated)
    Q_PROPERTY(int rotation READ getRotation NOTIFY mediaUpdated)

    // image tags
    Q_PROPERTY(QString iso READ getIso NOTIFY mediaUpdated)
    Q_PROPERTY(QString focal READ getFocal NOTIFY mediaUpdated)
    Q_PROPERTY(QString exposure READ getExposure NOTIFY mediaUpdated)
    Q_PROPERTY(QString exposureBias READ getExposureBias NOTIFY mediaUpdated)
    Q_PROPERTY(QString meteringMode READ getMeteringMode NOTIFY mediaUpdated)
    Q_PROPERTY(bool flash READ getFlash NOTIFY mediaUpdated)
    Q_PROPERTY(QString lightSource READ getLightSource NOTIFY mediaUpdated)

    // audio tags
    Q_PROPERTY(QString tag_title READ getTagTitle NOTIFY mediaUpdated)
    Q_PROPERTY(QString tag_artist READ getTagArtist NOTIFY mediaUpdated)
    Q_PROPERTY(QString tag_album READ getTagAlbum NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned tag_track_nb READ getTagTrackNb NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned tag_track_total READ getTagTrackTotal NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned tag_year READ getTagYear NOTIFY mediaUpdated)
    Q_PROPERTY(QString tag_genre READ getTagGenre NOTIFY mediaUpdated)
    Q_PROPERTY(QString tag_comment READ getTagComment NOTIFY mediaUpdated)

    // video
    Q_PROPERTY(QString videoCodec READ getVideoCodec NOTIFY mediaUpdated)
    Q_PROPERTY(double vframerate READ getFramerate NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned vbitrate READ getBitrate NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned vbitratemode READ getBitrateMode NOTIFY mediaUpdated)

    Q_PROPERTY(QVariant videoTracks READ getVideoTracks NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned videoTracksCount READ getVideoTracksCount NOTIFY mediaUpdated)
    Q_PROPERTY(QVariant audioTracks READ getAudioTracks NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned audioTracksCount READ getAudioTracksCount NOTIFY mediaUpdated)
    Q_PROPERTY(QVariant subtitlesTracks READ getSubtitlesTracks NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned subtitlesTracksCount READ getSubtitlesTracksCount NOTIFY mediaUpdated)
    Q_PROPERTY(QVariant otherTracks READ getOtherTracks NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned otherTracksCount READ getOtherTracksCount NOTIFY mediaUpdated)
    Q_PROPERTY(QVariant chapters READ getChapters NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned chaptersCount READ getChaptersCount NOTIFY mediaUpdated)

    // audio
    Q_PROPERTY(QString audioCodec READ getAudioCodec NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned audioChannels READ getAudioChannels NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned audioBitrate READ getAudioBitrate NOTIFY mediaUpdated)
    Q_PROPERTY(unsigned audioSamplerate READ getAudioSamplerate NOTIFY mediaUpdated)

    // gps
    Q_PROPERTY(QString latitudeString READ getLatitudeStr NOTIFY metadataUpdated)
    Q_PROPERTY(QString longitudeString READ getLongitudeStr NOTIFY metadataUpdated)
    Q_PROPERTY(QString altitudeString READ getAltitudeStr NOTIFY metadataUpdated)
    Q_PROPERTY(QString directionString READ getDirectionStr NOTIFY metadataUpdated)
    Q_PROPERTY(QString speedString READ getDirectionStr NOTIFY metadataUpdated)
    Q_PROPERTY(QString gpsVersion READ getGpsVersion NOTIFY metadataUpdated)
    Q_PROPERTY(double latitude READ getLatitude NOTIFY metadataUpdated)
    Q_PROPERTY(double longitude READ getLongitude NOTIFY metadataUpdated)
    Q_PROPERTY(double altitude READ getAltitude NOTIFY metadataUpdated)
    Q_PROPERTY(double altitudeCorrected READ getAltitudeCorrected NOTIFY metadataUpdated)
    Q_PROPERTY(double altitudeCorrection READ getAltitudeOffset NOTIFY metadataUpdated)
    Q_PROPERTY(double direction READ getDirection NOTIFY metadataUpdated)
    Q_PROPERTY(double speed READ getSpeed NOTIFY metadataUpdated)
    Q_PROPERTY(unsigned gpsDop READ getGpsDop NOTIFY metadataUpdated)
    Q_PROPERTY(unsigned gpsDiff READ getGpsDiff NOTIFY metadataUpdated)

    ////////

    bool m_valid = false;
    Shared::FileType m_type = Shared::FILE_UNKNOWN;
    Shared::ShotType m_stype = Shared::SHOT_UNKNOWN;
    //Shared::ShotState m_state = Shared::SHOT_STATE_DEFAULT;

    // MiniVideo media
    MediaFile_t *m_media = nullptr;
    // MiniVideo media tracks
    QList <QObject *> tracksAudio;
    QList <QObject *> tracksVideo;
    QList <QObject *> tracksSubtitles;
    QList <QObject *> tracksOther;
    QList <QObject *> trackChapters;

    QString m_path;
    QString m_file_folder;
    QString m_file_name;
    QString m_file_extension;
    QString m_file_extension_container;
    bool m_file_extension_mismatch = false;
    QString m_file_container;
    QString m_file_containerprofile;
    qint64 m_file_size = 0;

    QString m_creation_app;
    QString m_creation_lib;

    QString m_camera_brand;         //!< Brand of the camera that produced the shot
    QString m_camera_model;         //!< Model of the camera that produced the shot
    QString m_camera_software;      //!< Firmware of the camera that produced the shot

    qint64 m_duration = 0;          //!< Duration (in ms for video, in pictures for pic or timelpase)

    QDateTime m_date_file_c;
    QDateTime m_date_file_m;
    QDateTime m_date_metadata;
    QDateTime m_date_gps;

    // GLOBAL metadata
    unsigned width = 0;
    unsigned height = 0;
    unsigned ar = 0;
    unsigned width_visible = 0;
    unsigned height_visible = 0;
    unsigned ar_visible = 0;
    unsigned bpp = 0;
    bool alpha = false;
    unsigned projection = 0;
    unsigned transformation = 0;    //!< QImageIOHandler::Transformation
    int rotation = 0;               // internal use only

    // IMAGE metadata
    bool m_hasEXIF = false;
    unsigned m_exif_tag_found = 0;
    bool m_hasXMP = false;
    unsigned m_xmp_tag_found = 0;
    bool m_hasIIM = false;
    unsigned m_iim_tag_found = 0;
    bool m_hasMakerNote = false;
    QString m_makernote_brand;

    QString focal;
    QString iso;
    QString exposure_time;
    QString exposure_bias;
    QString metering_mode;
    unsigned resolution_x = 0;
    unsigned resolution_y = 0;
    bool flash = false;
    QString light_source;

    // VIDEO metadata
    QString vcodec;
    QString vtimecode;
    double vframerate = 0.0;
    unsigned vbitrate = 0;
    unsigned vbitratemode = 0;

    bool m_hasGPMF = false;
    bool hasGPMF() const { return m_hasGPMF; }

    // AUDIO metadata
    QString acodec;
    unsigned achannels = 0;
    unsigned abitrate = 0;
    unsigned abitratemode = 0;
    unsigned asamplerate = 0;

    bool m_hasAudioTags = false;
    unsigned m_audio_tag_found = 0;

    QString tag_title;
    QString tag_artist;
    QString tag_album;
    unsigned tag_track_nb = 0;
    unsigned tag_track_total = 0;
    unsigned tag_year = 0;
    QString tag_genre;

    QString tag_comment;
    QString tag_covertart_mime;
    QString tag_transcoded;

    // GPS metadata
    bool m_hasGPS = false;
    bool hasGPS() const { return m_hasGPS; }
    QString gps_version;
    QString gps_lat_str;
    QString gps_long_str;
    QString gps_alt_str;
    QString gps_alt_egm96_str;
    QString gps_direction_str;
    QString gps_speed_str;
    double gps_lat = 0.0;
    double gps_long = 0.0;
    double gps_alt = 0.0;
    double gps_alt_egm96 = 0.0;
    double gps_direction = 0.0;
    double gps_speed = 0.0;
    unsigned gps_dop = 0;
    unsigned gps_diff = 0;

Q_SIGNALS:
    void mediaUpdated();
    void metadataUpdated();

public:
    Media(const QString &path, QObject *parent = nullptr);
    ~Media();

    bool load();

    bool hasAudio() const { return (tracksAudio.length() > 0); }
    bool hasVideo() const { return (tracksVideo.length() > 0); }
    bool hasImage() const { return (m_type == Shared::FILE_PICTURE); }
    bool hasSubtitles() const { return (tracksSubtitles.length() > 0); }
    bool hasChapters() const { return (trackChapters.length() > 0); }

    bool getMetadataFromPicture();
    bool getMetadataFromVideo();
    bool getMetadataFromAudio();
    void computeAdditionalMetadata();

    QString getName() const { return m_file_name; }
    QString getFolder() const { return m_file_folder; }
    QString getPath() const { return m_path; }
    QString getExtension() const { return m_file_extension; }
    QString getExtensionContainer() const { return m_file_extension_container; }
    bool getExtensionMismatch() const { return m_file_extension_mismatch; }
    QString getContainer() const { return m_file_container; }
    QString getContainerProfile() const { return m_file_containerprofile; }
    qint64 getSize() const { return m_file_size; }
    qint64 getDuration() const { return m_duration; }

    QString getCreationApp() const;
    QString getCreationLib() const;

    QDateTime getDate() const;
    QDateTime getDateFile() const;
    QDateTime getDateMetadata() const;
    QDateTime getDateGPS() const;

    unsigned getWidth() const { return width; }
    unsigned getHeight() const { return height; }
    unsigned getAr() const { return ar; }
    unsigned getWidthVisible() const { return width_visible; }
    unsigned getHeightVisible() const { return height_visible; }
    unsigned getArVisible() const { return ar_visible; }
    unsigned getDepth() const { return bpp; }
    bool getAlpha() const { return alpha; }
    unsigned getProjection() const { return projection; }
    unsigned getTransformation() const { return transformation; }
    int getRotation() const { return rotation; }
    unsigned getResolution() const { return resolution_x; }

    QString getVideoCodec() const { return vcodec; }
    QString getTimecode() const { return vtimecode; }
    double getFramerate() const { return vframerate; }
    unsigned getBitrate() const { return vbitrate; }
    unsigned getBitrateMode() const { return vbitratemode; }

    bool hasVideoTags() const { return false; }

    int getAudioTracksCount() const { return tracksAudio.size(); }
    int getVideoTracksCount() const { return tracksVideo.size(); }
    int getSubtitlesTracksCount() const { return tracksSubtitles.size(); }
    int getOtherTracksCount() const { return tracksOther.size(); }
    QVariant getAudioTracks() const { if (tracksAudio.empty()) return QVariant(); return QVariant::fromValue(tracksAudio); }
    QVariant getVideoTracks() const { if (tracksVideo.empty()) return QVariant(); return QVariant::fromValue(tracksVideo); }
    QVariant getSubtitlesTracks() const { if (tracksSubtitles.empty()) return QVariant(); return QVariant::fromValue(tracksSubtitles); }
    QVariant getOtherTracks() const { if (tracksOther.empty()) return QVariant(); return QVariant::fromValue(tracksOther); }
    QVariant getChapters() const { if (trackChapters.empty()) return QVariant(); return QVariant::fromValue(trackChapters); }
    int getChaptersCount() const { return trackChapters.size(); }

    QString getAudioCodec() const { return acodec; }
    unsigned getAudioChannels() const { return achannels; }
    unsigned getAudioBitrate() const { return abitrate; }
    unsigned getAudioBitrateMode() const { return abitratemode; }
    unsigned getAudioSamplerate() const { return asamplerate; }

    bool hasAudioTags() const { return m_hasAudioTags && m_audio_tag_found; }
    QString getTagTitle() const { return tag_title; }
    QString getTagArtist() const { return tag_artist; }
    QString getTagAlbum() const { return tag_album; }
    unsigned getTagTrackNb() const { return tag_track_nb; }
    unsigned getTagTrackTotal() const { return tag_track_total; }
    unsigned getTagYear() const { return tag_year; }
    QString getTagGenre() const { return tag_genre; }
    QString getTagComment() const { return tag_comment; }

    bool hasEXIF() const { return (m_hasEXIF && m_exif_tag_found); }
    bool hasXMP() const { return m_hasXMP && m_xmp_tag_found; }
    bool hasIIM() const { return m_hasIIM && m_iim_tag_found; }
    QString getCameraBrand() const { return m_camera_brand; }
    QString getCameraModel() const { return m_camera_model; }
    QString getCameraSoftware() const { return m_camera_software; }
    QString getIso() const { return iso; }
    QString getFocal() const { return focal; }
    QString getExposure() const { return exposure_time; }
    QString getExposureBias() const { return exposure_bias; }
    QString getMeteringMode() const { return metering_mode; }
    bool getFlash() const { return flash; }
    QString getLightSource() const { return light_source; }

    QString getGpsVersion() const { return gps_version; }
    QString getLatitudeStr() const { return gps_lat_str; }
    QString getLongitudeStr() const { return gps_long_str; }
    QString getAltitudeStr() const { return gps_alt_str; }
    QString getDirectionStr() const { return gps_direction_str; }
    QString getSpeedStr() const { return gps_speed_str; }
    double getLatitude() const { return gps_lat; }
    double getLongitude() const { return gps_long; }
    double getAltitude() const { return gps_alt; }
    double getAltitudeCorrected() const { return gps_alt - gps_alt_egm96; }
    double getAltitudeOffset() const { return gps_alt_egm96; }
    double getDirection() const { return gps_direction; }
    double getSpeed() const { return gps_speed; }
    unsigned getGpsDop() const { return gps_dop; }
    unsigned getGpsDiff() const { return gps_diff; }

/*
    int getChapterCount() const;    //!< 0 means no notion of chapter
    int getHighlightCount() const { return m_highlights.size(); }
    int getGpsPointCount() const { return m_gps.size(); }
*/

    bool isValid() { return m_valid; }
    unsigned getFileType() const {
/*
        if (m_type >= Shared::SHOT_VIDEO && m_type <= Shared::SHOT_VIDEO_3D)
           return Shared::FILE_VIDEO;
        else if (m_type >= Shared::SHOT_PICTURE && m_type <= Shared::SHOT_PICTURE_NIGHTLAPSE)
            return Shared::FILE_PICTURE;

         return Shared::FILE_UNKNOWN;
*/
        return m_type;
    }
    unsigned getShotType() const {
        return Shared::SHOT_UNKNOWN;
    }

    Q_INVOKABLE QString getExportString();
    Q_INVOKABLE bool saveExportString();
    Q_INVOKABLE QString openExportString();

    Q_INVOKABLE QString getSubtitlesString(unsigned track = 0);
    Q_INVOKABLE bool saveSubtitlesString(unsigned track = 0);
    Q_INVOKABLE QString openSubtitlesString(unsigned track = 0);

    Q_INVOKABLE QVariant getVideoTrack(int tid = 0);
    Q_INVOKABLE QVariant getAudioTrack(int tid = 0);
    Q_INVOKABLE QVariant getSubtitlesTrack(int tid = 0);
    Q_INVOKABLE QVariant getOtherTrack(int tid = 0);
};

/* ************************************************************************** */
#endif // MEDIA_H
