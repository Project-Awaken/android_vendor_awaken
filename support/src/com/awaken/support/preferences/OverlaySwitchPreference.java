/*
 * Copyright (C) 2022 Yet Another AOSP Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.awaken.support.preferences;

import static android.os.UserHandle.USER_CURRENT;

import android.content.Context;
import android.content.om.IOverlayManager;
import android.content.om.OverlayInfo;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.util.AttributeSet;
import android.util.Log;

import androidx.preference.SwitchPreference;

import java.lang.SecurityException;

public class OverlaySwitchPreference extends SwitchPreference {
    private final static String TAG = "OverlaySwitchPreference";
    private IOverlayManager mOverlayManager;

    public OverlaySwitchPreference(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    public OverlaySwitchPreference(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public OverlaySwitchPreference(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public OverlaySwitchPreference(Context context) {
        super(context);
    }

    @Override
    public void onAttached() {
        super.onAttached();
        mOverlayManager = IOverlayManager.Stub.asInterface(
                ServiceManager.getService(Context.OVERLAY_SERVICE));
        if (mOverlayManager == null) return;
        OverlayInfo info = null;
        try {
            info = mOverlayManager.getOverlayInfo(getKey(), USER_CURRENT);
        } catch (RemoteException e) {
            Log.e(TAG, "Failed getting overlay " + getKey() + " info");
            e.printStackTrace();
        }
        if (info != null) {
            setChecked(info.isEnabled());
        }
    }

    @Override
    public void setChecked(boolean checked) {
        if (mOverlayManager == null) return;
        try {
            mOverlayManager.setEnabled(getKey(), checked, USER_CURRENT);
        } catch (SecurityException | RemoteException e) {
            Log.e(TAG, "Failed setting overlay " + getKey() + " to " +
                    (checked ? "enabled" : "disabled"));
            e.printStackTrace();
            return;
        }
        super.setChecked(checked);
    }
}
