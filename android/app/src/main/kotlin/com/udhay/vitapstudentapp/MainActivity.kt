package com.udhay.vitapstudentapp

import android.content.ComponentName
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "vsync/launcher_icon"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setGold" -> {
                        val gold = call.argument<Boolean>("gold") ?: false
                        setLauncherIcon(gold)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /// Enables exactly one of the launcher activity-aliases so the home
    /// screen icon matches the in-app accent theme.
    private fun setLauncherIcon(gold: Boolean) {
        val pm = packageManager
        val defaultAlias = ComponentName(packageName, "$packageName.MainActivityDefault")
        val goldAlias = ComponentName(packageName, "$packageName.MainActivityGold")

        pm.setComponentEnabledSetting(
            defaultAlias,
            if (gold) PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            else PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP
        )
        pm.setComponentEnabledSetting(
            goldAlias,
            if (gold) PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP
        )
    }
}
