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
 * \date      2019
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

#ifndef MEDIA_TRACK_QML_H
#define MEDIA_TRACK_QML_H
/* ************************************************************************** */

#include <minivideo.h>

#include <QObject>
#include <QString>
#include <QDateTime>

/* ************************************************************************** */

/*!
 * \brief The MediaTrackQml class
 *
 * QML binding for minivideo tracks.
 */
class MediaTrackQml: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool valid READ isValid NOTIFY trackUpdated)

    Q_PROPERTY(unsigned id READ getInternalId NOTIFY trackUpdated)

    Q_PROPERTY(QDateTime date READ getDate NOTIFY trackUpdated)
    Q_PROPERTY(qint64 size READ getSize NOTIFY trackUpdated)
    Q_PROPERTY(qint64 duration READ getDuration NOTIFY trackUpdated)
    Q_PROPERTY(QString title READ getTitle NOTIFY trackUpdated)

    Q_PROPERTY(QString fcc READ getFcc NOTIFY trackUpdated)
/*
    Q_PROPERTY(QString videoCodec READ getVideoCodec NOTIFY trackUpdated)
    Q_PROPERTY(double videoFramerate READ getFramerate NOTIFY trackUpdated)
    Q_PROPERTY(unsigned videoBitrate READ getBitrate NOTIFY trackUpdated)
    Q_PROPERTY(QString videoTimecode READ getTimecode NOTIFY trackUpdated)

    Q_PROPERTY(unsigned width READ getWidth NOTIFY trackUpdated)
    Q_PROPERTY(unsigned height READ getHeight NOTIFY trackUpdated)
    Q_PROPERTY(unsigned depth READ getDepth NOTIFY trackUpdated)
    Q_PROPERTY(bool alpha READ getAlpha NOTIFY trackUpdated)
    Q_PROPERTY(unsigned projection READ getProjection NOTIFY trackUpdated)
    Q_PROPERTY(unsigned orientation READ getOrientation NOTIFY trackUpdated)

    Q_PROPERTY(QString audioCodec READ getAudioCodec NOTIFY trackUpdated)
    Q_PROPERTY(unsigned audioChannels READ getAudioChannels NOTIFY trackUpdated)
    Q_PROPERTY(unsigned audioBitrate READ getAudioBitrate NOTIFY trackUpdated)
    Q_PROPERTY(unsigned audioSamplerate READ getAudioSamplerate NOTIFY trackUpdated)
*/
    Q_PROPERTY(int bitrateMode READ getBitrateMode NOTIFY trackUpdated)
    Q_PROPERTY(int bitrate_avg READ getBitrate_avg NOTIFY trackUpdated)
    Q_PROPERTY(int bitrate_min READ getBitrate_min NOTIFY trackUpdated)
    Q_PROPERTY(int bitrate_max READ getBitrate_max NOTIFY trackUpdated)
    Q_PROPERTY(int compressionRatio READ getCompressionRatio NOTIFY trackUpdated)

    bool m_valid = false;

    const MediaStream_t *mv_stream = nullptr;

Q_SIGNALS:
    void trackUpdated();

public:
    MediaTrackQml();
    ~MediaTrackQml();

    bool isValid() { return m_valid; }

    bool loadMediaStream(const MediaStream_t *stream);

private:
    int getInternalId() const;
    QDateTime getDate() const;
    qint64 getSize() const;
    qint64 getDuration() const;
    QString getTitle() const;

    QString getFcc() const;

    int getBitrateMode() const;
    int getBitrate_avg() const;
    int getBitrate_min() const;
    int getBitrate_max() const;
    int getCompressionRatio() const;

    int64_t getSampleCount() const;
    int64_t getFrameCount() const;
    int64_t getFrameIdrCount() const;

    int64_t getFrameDuration() const;
};

/* ************************************************************************** */
#endif // MEDIA_TRACK_QML_H
