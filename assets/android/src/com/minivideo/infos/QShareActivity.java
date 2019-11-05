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
 * \date      2019
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

package com.minivideo.infos;

// Qt
import org.qtproject.qt5.android.QtNative;
import org.qtproject.qt5.android.bindings.QtActivity;

// android
import android.os.*;
import android.content.*;
import android.app.*;

import java.lang.String;
import android.content.Intent;
import java.io.File;
import android.net.Uri;
import android.util.Log;
import android.content.ContentResolver;
import android.webkit.MimeTypeMap;

public class QShareActivity extends QtActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        // now we're checking if the App was started from another Android App via Intent

        Intent theIntent = getIntent();
        if (theIntent != null)
        {
            String theAction = theIntent.getAction();
            if (theAction != null)
            {
                // delay processIntent();
                //isIntentPending = true;
            }
        }
    }

    // if we are opened from other apps:
    @Override
    public void onNewIntent(Intent intent)
    {
        super.onNewIntent(intent);
        setIntent(intent);
/*
        // Intent will be processed, if all is initialized and Qt / QML can handle the event
        if (isInitialized)
        {
            processIntent();
        }
        else
        {
            isIntentPending = true;
        }
*/
    }

    public void checkPendingIntents(String workingDir)
    {
        //
    }

    // process the Intent if Action is SEND or VIEW
    private void processIntent()
    {
        Intent intent = getIntent();

        // do something with the Intent
    }
}
