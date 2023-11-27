/*
 * Copyright (C) 2016 The CyanogenMod Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.awaken.support.preferences;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.UserHandle;
import android.util.ArrayMap;
import android.util.Log;

import java.util.HashSet;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import static com.awaken.support.preferences.RemotePreference.ACTION_REFRESH_PREFERENCE;
import static com.awaken.support.preferences.RemotePreference.ACTION_UPDATE_PREFERENCE;
import static com.awaken.support.preferences.RemotePreference.EXTRA_KEY;

/**
 * Manages attaching and detaching of RemotePreferences and optimizes callbacks
 * thru a single receiver on a separate thread.
 *
 * @hide
 */
public class RemotePreferenceManager {

    private static final String TAG = RemotePreferenceManager.class.getSimpleName();

    private static final boolean DEBUG = Log.isLoggable(
            RemotePreference.class.getSimpleName(), Log.VERBOSE);

    private static RemotePreferenceManager sInstance;

    private final Context mContext;
    private final Map<String, Intent> mCache = new ArrayMap<>();
    private final Map<String, Set<OnRemoteUpdateListener>> mCallbacks = new ArrayMap<>();

    private final Handler mMainHandler = new Handler(Looper.getMainLooper());

    private Handler mHandler;
    private HandlerThread mThread;

    public interface OnRemoteUpdateListener {
        public Intent getReceiverIntent();

        public void onRemoteUpdated(Bundle bundle);
    }

    private RemotePreferenceManager(Context context) {
        mContext = context;
    }

    public synchronized static RemotePreferenceManager get(Context context) {
        if (sInstance == null) {
            sInstance = new RemotePreferenceManager(context.getApplicationContext());
        }
        return sInstance;
    }

    public void attach(String key, OnRemoteUpdateListener pref) {
        Intent i;
        synchronized (mCache) {
            i = mCache.get(key);
            if (i == null && !mCache.containsKey(key)) {
                i = pref.getReceiverIntent();
                mCache.put(key, i);
            }
        }
        synchronized (mCallbacks) {
            if (i != null) {
                Set<OnRemoteUpdateListener> cbs = mCallbacks.get(key);
                if (cbs == null) {
                    cbs = new HashSet<>();
                    mCallbacks.put(key, cbs);
                    if (mCallbacks.size() == 1) {
                        mThread = new HandlerThread("RemotePreference");
                        mThread.start();
                        mHandler = new Handler(mThread.getLooper());
                        mContext.registerReceiver(mListener,
                                new IntentFilter(ACTION_REFRESH_PREFERENCE),
                                "lineageos.permission.MANAGE_REMOTE_PREFERENCES", mHandler);
                    }
                }
                cbs.add(pref);
                requestUpdate(key);
            }
        }
    }

    public void detach(String key, OnRemoteUpdateListener pref) {
        synchronized (mCallbacks) {
            Set<OnRemoteUpdateListener> cbs = mCallbacks.get(key);
            if (cbs != null && cbs.remove(pref) && cbs.isEmpty()
                    && mCallbacks.remove(key) != null && mCallbacks.isEmpty()) {
                mContext.unregisterReceiver(mListener);
                if (mThread != null) {
                    mThread.quit();
                    mThread = null;
                }
                mHandler = null;
            }
        }
    }

    private void requestUpdate(String key) {
        synchronized (mCache) {
            Intent i = mCache.get(key);
            if (i == null) {
                return;
            }
            mContext.sendOrderedBroadcastAsUser(i, UserHandle.CURRENT,
                    "lineageos.permission.MANAGE_REMOTE_PREFERENCES",
                    mListener, mHandler, Activity.RESULT_OK, null, null);
        }
    }

    private final BroadcastReceiver mListener = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (DEBUG) Log.d(TAG, "onReceive: intent=" + Objects.toString(intent));

            if (ACTION_REFRESH_PREFERENCE.equals(intent.getAction())) {
                final String key = intent.getStringExtra(EXTRA_KEY);
                synchronized (mCallbacks) {
                    if (key != null && mCallbacks.containsKey(key)) {
                        requestUpdate(key);
                    }
                }
            } else if (ACTION_UPDATE_PREFERENCE.equals(intent.getAction())) {
                if (getAbortBroadcast()) {
                    Log.e(TAG, "Broadcast aborted, code=" + getResultCode());
                    return;
                }
                final Bundle bundle = getResultExtras(true);
                final String key = bundle.getString(EXTRA_KEY);
                synchronized (mCallbacks) {
                    if (key != null && mCallbacks.containsKey(key)) {
                        mMainHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                synchronized (mCallbacks) {
                                    if (mCallbacks.containsKey(key)) {
                                        Set<OnRemoteUpdateListener> cbs = mCallbacks.get(key);
                                        if (cbs != null) {
                                            for (OnRemoteUpdateListener cb : cbs) {
                                                cb.onRemoteUpdated(bundle);
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    }
                }
            }
        }
    };
}
