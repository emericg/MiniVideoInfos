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

#ifndef MEDIAS_MANAGER_H
#define MEDIAS_MANAGER_H
/* ************************************************************************** */

#include "settingsmanager.h"

class Media;

#include <QObject>
#include <QVariant>
#include <QList>

/* ************************************************************************** */

/*!
 * \brief The MediasManager class
 */
class MediasManager: public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool medias READ areMediasAvailable NOTIFY mediasUpdated)
    Q_PROPERTY(QVariant mediasList READ getMedias NOTIFY mediasUpdated)

    //Q_PROPERTY(bool scanning READ isScanning NOTIFY scanningChanged)

    bool m_scanning = false;

    QList<QObject*> m_medias;

    bool isScanning() const;

public:
    MediasManager();
    ~MediasManager();

    Q_INVOKABLE bool areMediasAvailable() const { return !m_medias.empty(); }

    QVariant getMedias() const { return QVariant::fromValue(m_medias); }

public slots:
    bool openMedia(const QString &path);
    void closeMedia(const QString &path);

private slots:
    //

Q_SIGNALS:
    void mediasUpdated();
};

/* ************************************************************************** */
#endif // MEDIAS_MANAGER_H
