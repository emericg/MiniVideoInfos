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

#ifndef MINIVIDEO_TRACK_QML_H
#define MINIVIDEO_TRACK_QML_H
/* ************************************************************************** */

#include <minivideo/minivideo.h>

#include <QObject>
#include <QString>
#include <QDateTime>

#include <QtCharts>
#include <QtCharts/QLineSeries>

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
    Q_PROPERTY(QString codecProfile READ getCodecProfile NOTIFY trackUpdated)
    Q_PROPERTY(double codecLevel READ getCodecLevel NOTIFY trackUpdated)
    Q_PROPERTY(QString codecProfileAndLevel READ getCodecProfileAndLevel NOTIFY trackUpdated)
    Q_PROPERTY(QString codecFeatures READ getCodecFeatures NOTIFY trackUpdated)

    Q_PROPERTY(double frameDuration READ getFrameDuration NOTIFY trackUpdated)
    Q_PROPERTY(double sampleDuration READ getAudioSampleDuration NOTIFY trackUpdated)

    // video
    Q_PROPERTY(int width READ getWidth NOTIFY trackUpdated)
    Q_PROPERTY(int height READ getHeight NOTIFY trackUpdated)
    Q_PROPERTY(int widthVisible READ getWidthVisible NOTIFY trackUpdated)
    Q_PROPERTY(int heightVisible READ getHeightVisible NOTIFY trackUpdated)
    Q_PROPERTY(double framerate READ getFramerate NOTIFY trackUpdated)
    Q_PROPERTY(double var READ getVAR NOTIFY trackUpdated)
    Q_PROPERTY(double dar READ getDAR NOTIFY trackUpdated)
    Q_PROPERTY(double par READ getPAR NOTIFY trackUpdated)
    Q_PROPERTY(int colorDepth READ getColorDepth NOTIFY trackUpdated)
    Q_PROPERTY(bool colorRange READ getColorRange NOTIFY trackUpdated)
    Q_PROPERTY(QString colorPrimaries READ getColorPrimaries NOTIFY trackUpdated)
    Q_PROPERTY(QString colorTransfer READ getColorTransfer NOTIFY trackUpdated)
    Q_PROPERTY(QString colorMatrix READ getColorMatrix NOTIFY trackUpdated)
    //Q_PROPERTY(bool alpha READ getAlpha NOTIFY trackUpdated)
    Q_PROPERTY(int orientation READ getOrientation NOTIFY trackUpdated)
    Q_PROPERTY(int projection READ getProjection NOTIFY trackUpdated)
    Q_PROPERTY(int stereoMode READ getStereoMode NOTIFY trackUpdated)
    Q_PROPERTY(int scanMode READ getScanMode NOTIFY trackUpdated)

    // audio
    Q_PROPERTY(int audioChannels READ getAudioChannels NOTIFY trackUpdated)
    Q_PROPERTY(int audioChannelsMode READ getAudioChannelsMode NOTIFY trackUpdated)
    Q_PROPERTY(int audioSamplerate READ getAudioSamplerate NOTIFY trackUpdated)
    Q_PROPERTY(int audioSamplePerFrame READ getAudioSamplePerFrame NOTIFY trackUpdated)
    Q_PROPERTY(int audioBitPerSample READ getAudioBitPerSample NOTIFY trackUpdated)

    Q_PROPERTY(int bitrateMode READ getBitrateMode NOTIFY trackUpdated)
    Q_PROPERTY(int bitrate_avg READ getBitrate_avg NOTIFY trackUpdated)
    Q_PROPERTY(int bitrate_min READ getBitrate_min NOTIFY bitrateUpdated)
    Q_PROPERTY(int bitrate_max READ getBitrate_max NOTIFY bitrateUpdated)
    Q_PROPERTY(int compressionRatio READ getCompressionRatio NOTIFY trackUpdated)

    Q_PROPERTY(int sampleCount READ getSampleCount NOTIFY trackUpdated)
    Q_PROPERTY(int frameCount READ getFrameCount NOTIFY trackUpdated)
    Q_PROPERTY(int frameCountIdr READ getFrameCountIdr NOTIFY trackUpdated)

    MediaStream_t *mv_stream = nullptr;

    QVector <QPointF> points_bitrate_data;
    QVector <QPointF> points_bitrate_mean;

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
    QString getCodecProfile() const;
    QString getCodecProfileAndLevel() const;
    QString getCodecFeatures() const;
    QString getLanguage() const;

    //
    int getWidth() const;
    int getHeight() const;
    int getWidthVisible() const;
    int getHeightVisible() const;
    double getFramerate() const;
    double getCodecLevel() const;
    double getVAR() const;
    double getDAR() const;
    double getPAR() const;
    int getProjection() const;
    int getOrientation() const;
    int getScanMode() const;
    int getStereoMode() const;
    int getColorDepth() const;
    bool getColorRange() const;
    QString getColorPrimaries() const;
    QString getColorTransfer() const;
    QString getColorMatrix() const;

    //
    int getAudioChannels() const;
    int getAudioChannelsMode() const;
    int getAudioSamplerate() const;
    int getAudioBitPerSample() const;
    double getAudioSampleDuration() const;
    int getAudioSamplePerFrame() const;

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

Q_SIGNALS:
    void trackUpdated();
    void bitrateUpdated();

public:
    MediaTrackQml(QObject *parent = nullptr);
    ~MediaTrackQml();

    bool isValid() const { if (mv_stream) return true; else return false; }

    bool loadMediaStream(MediaStream_t *stream);

    Q_INVOKABLE void getBitrateData(QLineSeries *bitrateData, QLineSeries *bitrateMean, float freq);
};

/* ************************************************************************** */

/*!
 * \brief The MediaChapterQml class
 *
 * QML binding for minivideo chapters.
 */
class MediaChapterQml: public QObject
{
    Q_OBJECT

    Q_PROPERTY(qint64 pts READ getPts NOTIFY chapterUpdated)
    Q_PROPERTY(QString name READ getName NOTIFY chapterUpdated)

    int64_t m_pts = -1;
    QString m_name;

Q_SIGNALS:
    void chapterUpdated();

public:
    MediaChapterQml(int64_t pts, const QString &name, QObject *parent = nullptr);
    ~MediaChapterQml();

    qint64 getPts() const { return m_pts; }
    QString getName() const { return m_name; }
};

/* ************************************************************************** */
#endif // MINIVIDEO_TRACK_QML_H
