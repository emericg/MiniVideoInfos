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

#ifndef MEDIA_MANAGER_H
#define MEDIA_MANAGER_H
/* ************************************************************************** */

class Media;

#include <QObject>
#include <QVariant>
#include <QList>

/* ************************************************************************** */

/*!
 * \brief The MediaManager class
 */
class MediaManager: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool mediaAvailable READ areMediaAvailable NOTIFY mediaUpdated)
    Q_PROPERTY(QVariant mediaList READ getMedia NOTIFY mediaUpdated)

    //Q_PROPERTY(bool scanning READ isScanning NOTIFY scanningChanged)

    bool m_scanning = false;

    QList <QObject*> m_media;

    bool isScanning() const;

Q_SIGNALS:
    void mediaUpdated();
    void newMedia(Media *);

public slots:
    bool openMedia(const QString &path);
    void closeMedia(const QString &path);

    void detach(const QString &path);

public:
    MediaManager();
    ~MediaManager();

    Q_INVOKABLE bool areMediaAvailable() const { return !m_media.empty(); }

    QVariant getMedia() const { return QVariant::fromValue(m_media); }
};

/* ************************************************************************** */
#endif // MEDIA_MANAGER_H
