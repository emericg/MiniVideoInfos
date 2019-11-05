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

#ifndef UTILS_ANDROID_H
#define UTILS_ANDROID_H
/* ************************************************************************** */

/*!
 * \brief android_ask_storage_permissions
 * \return True if R/W permissions on main storage have been obtained.
 */
bool android_ask_storage_permissions();

/* ************************************************************************** */

/*!
 * \brief android_set_statusbar_color
 * \param color: 32b RGBA color.
 *
 * \note: WIP, only make the app segfault right now.
 */
void android_set_statusbar_color(int color);

/* ************************************************************************** */

#include <QString>

/*!
 * \brief android_get_storages_by_api
 * \return Search for storage devices using native API.
 */
QStringList android_get_storages_by_api();

/*!
 * \brief android_get_storages_by_env
 * \return Search for storage devices in the environment variables.
 */
QStringList android_get_storages_by_env();

/*!
 * \brief android_get_external_storage
 * \return The path to the external storage.
 *
 * Read this, it might get complicated...
 * - https://source.android.com/devices/storage/
 */
QString android_get_external_storage();

/* ************************************************************************** */
#endif // UTILS_ANDROID_H
