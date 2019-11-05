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

#ifndef MINIVIDEO_TRACK_QML_H
#define MINIVIDEO_TRACK_QML_H
/* ************************************************************************** */

#include <minivideo.h>

#include <QObject>
#include <QString>
#include <QDateTime>

#include <QtCharts>
#include <QtCharts/QLineSeries>
QT_CHARTS_USE_NAMESPACE

/* ************************************************************************** */

/*!
 * \brief The MediaTrackQml class
 *
 * QML binding for minivideo tracks.
 */
class MediaTrackQml: public QObject
{
    Q_OBJECT

    Q_PROPERTY(unsigned id READ getId NOTIFY trackUpdated)
    Q_PROPERTY(unsigned type READ getType NOTIFY trackUpdated)
    Q_PROPERTY(bool valid READ isValid NOTIFY trackUpdated)

    Q_PROPERTY(QDateTime date READ getDate NOTIFY trackUpdated)
    Q_PROPERTY(qint64 size READ getSize NOTIFY trackUpdated)
    Q_PROPERTY(qint64 duration READ getDuration NOTIFY trackUpdated)
    Q_PROPERTY(qint64 delay READ getDelay NOTIFY trackUpdated)
    Q_PROPERTY(QString title READ getTitle NOTIFY trackUpdated)
    Q_PROPERTY(QString language READ getLanguage NOTIFY trackUpdated)
    Q_PROPERTY(bool visible READ getVisible NOTIFY trackUpdated)
    Q_PROPERTY(bool forced READ getForced NOTIFY trackUpdated)

    Q_PROPERTY(QString fcc READ getFcc NOTIFY trackUpdated)
    Q_PROPERTY(QString tcc READ getTcc NOTIFY trackUpdated)

    Q_PROPERTY(QString codec READ getCodec NOTIFY trackUpdated)
    Q_PROPERTY(QString profile READ getProfile NOTIFY trackUpdated)

    Q_PROPERTY(double frameDuration READ getFrameDuration NOTIFY trackUpdated)
    //Q_PROPERTY(double sampleDuration READ getSampleDuration NOTIFY trackUpdated)

    //
    Q_PROPERTY(int width READ getWidth NOTIFY trackUpdated)
    Q_PROPERTY(int height READ getHeight NOTIFY trackUpdated)
    Q_PROPERTY(int width_visible READ getWidthVisible NOTIFY trackUpdated)
    Q_PROPERTY(int height_visible READ getHeightVisible NOTIFY trackUpdated)
    Q_PROPERTY(double framerate READ getFramerate NOTIFY trackUpdated)
    //Q_PROPERTY(int depth READ getDepth NOTIFY trackUpdated)
    //Q_PROPERTY(bool alpha READ getAlpha NOTIFY trackUpdated)
    Q_PROPERTY(int orientation READ getOrientation NOTIFY trackUpdated)
    Q_PROPERTY(int projection READ getProjection NOTIFY trackUpdated)
    //Q_PROPERTY(int scanmode READ getScanMode NOTIFY trackUpdated)

    //
    Q_PROPERTY(int audioChannels READ getAudioChannels NOTIFY trackUpdated)
    Q_PROPERTY(int audioSamplerate READ getAudioSamplerate NOTIFY trackUpdated)
    Q_PROPERTY(int audioBitPerSample READ getAudioBitPerSample NOTIFY trackUpdated)

    Q_PROPERTY(int bitrateMode READ getBitrateMode NOTIFY trackUpdated)
    Q_PROPERTY(int bitrate_avg READ getBitrate_avg NOTIFY trackUpdated)
    Q_PROPERTY(int bitrate_min READ getBitrate_min NOTIFY trackUpdated)
    Q_PROPERTY(int bitrate_max READ getBitrate_max NOTIFY trackUpdated)
    Q_PROPERTY(int compressionRatio READ getCompressionRatio NOTIFY trackUpdated)

    Q_PROPERTY(int sampleCount READ getSampleCount NOTIFY trackUpdated)
    Q_PROPERTY(int frameCount READ getFrameCount NOTIFY trackUpdated)
    Q_PROPERTY(int frameCountIdr READ getFrameCountIdr NOTIFY trackUpdated)

    MediaStream_t *mv_stream = nullptr;

Q_SIGNALS:
    void trackUpdated();

public:
    MediaTrackQml(QObject *parent = nullptr);
    ~MediaTrackQml();

    bool isValid() const { if (mv_stream) return true; else return false; }

    bool loadMediaStream(MediaStream_t *stream);

    Q_INVOKABLE void getBitrateDatas(QLineSeries *bitrateData);
    Q_INVOKABLE void getBitrateDatasFps(QLineSeries *bitrateData, float fps);
    //Q_INVOKABLE void getBitrateDatas(QChart *chart, QLineSeries *bitrateData);
    QVector<QPointF> points;

private:

    //
    unsigned getType() const;
    int getId() const;

    QDateTime getDate() const;
    qint64 getSize() const;
    qint64 getDuration() const;
    qint64 getDelay() const;
    QString getTitle() const;
    bool getVisible() const;
    bool getForced() const;
    bool getDefault() const;

    //
    QString getFcc() const;
    QString getTcc() const;
    QString getCodec() const;
    QString getProfile() const;
    QString getLanguage() const;

    //
    int getWidth() const;
    int getHeight() const;
    int getWidthVisible() const;
    int getHeightVisible() const;
    double getFramerate() const;
    //double getAR() const;
    int getProjection() const;
    int getOrientation() const;
    int getScanMode() const;

    //
    int getAudioChannels() const;
    int getAudioSamplerate() const;
    int getAudioBitPerSample() const;

    //
    int getBitrateMode() const;
    int getBitrate_avg() const;
    int getBitrate_min() const;
    int getBitrate_max() const;
    int getCompressionRatio() const;

    int64_t getSampleCount() const;
    int64_t getFrameCount() const;
    int64_t getFrameCountIdr() const;
    double getFrameDuration() const;
};

/* ************************************************************************** */
#endif // MINIVIDEO_TRACK_QML_H
