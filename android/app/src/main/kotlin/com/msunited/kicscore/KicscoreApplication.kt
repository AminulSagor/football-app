package com.msunited.kicscore

import android.app.Application
import android.content.Context
import android.util.Log

class KicscoreApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        initializeFacebookSdk()
    }

    private fun initializeFacebookSdk() {
        try {
            val facebookSdkClass = Class.forName("com.facebook.FacebookSdk")
            val sdkInitializeMethod = facebookSdkClass.getMethod(
                "sdkInitialize",
                Context::class.java,
            )
            sdkInitializeMethod.invoke(null, applicationContext)
        } catch (error: Throwable) {
            Log.w(
                TAG,
                "Facebook SDK could not be initialized before plugin registration.",
                error,
            )
        }
    }

    private companion object {
        const val TAG = "KicscoreApplication"
    }
}
