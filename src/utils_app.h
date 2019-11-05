/*!
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

#ifndef UTILS_APP_H
#define UTILS_APP_H
/* ************************************************************************** */

#include <QUrl>
#include <QSize>
#include <QObject>
#include <QVariantMap>

/* ************************************************************************** */

#include <QMetaType>

namespace Shared
{
    Q_NAMESPACE

    enum FileType
    {
        FILE_UNKNOWN    = 0,

        FILE_AUDIO      = 1,
        FILE_VIDEO      = 2,
        FILE_PICTURE    = 3,
    };
    Q_ENUM_NS(FileType)

    enum ShotType
    {
        SHOT_UNKNOWN = 0,

        SHOT_VIDEO = 8,
        SHOT_VIDEO_LOOPING,
        SHOT_VIDEO_TIMELAPSE,
        SHOT_VIDEO_NIGHTLAPSE,
        SHOT_VIDEO_3D,

        SHOT_PICTURE = 16,
        SHOT_PICTURE_MULTI,
        SHOT_PICTURE_BURST,
        SHOT_PICTURE_TIMELAPSE,
        SHOT_PICTURE_NIGHTLAPSE,

        SHOT_PICTURE_ANIMATED, // ex: gif?
    };
    Q_ENUM_NS(ShotType)
}


/* ************************************************************************** */

class UtilsApp : public QObject
{
    Q_OBJECT

public:
    explicit UtilsApp(QObject* parent = nullptr);
   ~UtilsApp();

    static Q_INVOKABLE void openWith(const QString path);

    static Q_INVOKABLE QUrl getStandardPath(const QString type);

    static Q_INVOKABLE int getMobileStorageCount();
    static Q_INVOKABLE QString getMobileStorageInternal();
    static Q_INVOKABLE QString getMobileStorageExternal(int index = 0);
    static Q_INVOKABLE QStringList getMobileStorageExternals();

    static Q_INVOKABLE QString appVersion();
    static Q_INVOKABLE QString appBuildDate();
    static Q_INVOKABLE void appExit();
};

/* ************************************************************************** */
#endif // UTILS_APP_H
