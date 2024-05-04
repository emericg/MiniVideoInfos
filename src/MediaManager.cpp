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

#include "MediaManager.h"
#include "Media.h"

#include <QStandardPaths>
#include <QList>
#include <QDir>
#include <QDebug>

/* ************************************************************************** */

MediaManager::MediaManager()
{
    //
}

MediaManager::~MediaManager()
{
    //
}

/* ************************************************************************** */

bool MediaManager::openMedia(const QString &path)
{
    bool status = false;

    if (!path.isEmpty())
    {
        //qDebug() << "MediaManager::openMedia()" << path;

        // Already opened?
        closeMedia(path);

        // Now open it up
        Media *mf = new Media(path);
        if (mf && mf->isValid())
        {
            m_media.push_front(mf);
            status = true;
            Q_EMIT mediaUpdated();
        }
        else
        {
            delete mf;
        }
    }

    return status;
}

void MediaManager::closeMedia(const QString &path)
{
    if (!path.isEmpty())
    {
        //qDebug() << "MediaManager::closeMedia()" << path;

        for (auto m: std::as_const(m_media))
        {
            Media *mm = static_cast<Media *>(m);
            if (mm->getPath() == path)
            {
                delete mm;
                m_media.removeOne(m);
                Q_EMIT mediaUpdated();
            }
        }
    }
}
