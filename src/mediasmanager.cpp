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

#include "mediasmanager.h"
#include "media.h"

#include <QStandardPaths>
#include <QList>
#include <QDir>
#include <QDebug>

/* ************************************************************************** */

MediasManager::MediasManager()
{
    //
}

MediasManager::~MediasManager()
{
    //
}

/* ************************************************************************** */

bool MediasManager::openMedia(const QString &path)
{
    qDebug() << "MediasManager::openMedia()" << path;
    bool status = false;

    Media *mf = new Media(path);
    if (mf && mf->isValid())
    {
        m_medias.push_front(mf);
        status = true;
        Q_EMIT mediasUpdated();
    }

    return status;
}

void MediasManager::closeMedia(const QString &path)
{
    Q_UNUSED(path)
}
