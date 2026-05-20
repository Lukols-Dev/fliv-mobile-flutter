package com.example.mobile

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.LocationManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "fliv/location_permission"
    private val requestCode = 4071
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "check" -> result.success(currentPermissionStatus())
                    "request" -> requestPermission(result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun requestPermission(result: MethodChannel.Result) {
        val status = currentPermissionStatus()
        if (status == "granted" || status == "serviceDisabled") {
            result.success(status)
            return
        }

        if (pendingResult != null) {
            result.error("permission_request_active", "Location permission request is already active.", null)
            return
        }

        pendingResult = result
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION,
            ),
            requestCode,
        )
    }

    private fun currentPermissionStatus(): String {
        val fineGranted = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION,
        ) == PackageManager.PERMISSION_GRANTED
        val coarseGranted = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_COARSE_LOCATION,
        ) == PackageManager.PERMISSION_GRANTED

        if (!fineGranted && !coarseGranted) return "denied"

        return if (isLocationServiceEnabled()) "granted" else "serviceDisabled"
    }

    private fun isLocationServiceEnabled(): Boolean {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) ||
            locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode != this.requestCode) return

        val result = pendingResult ?: return
        pendingResult = null

        val granted = grantResults.any { it == PackageManager.PERMISSION_GRANTED }
        if (granted) {
            result.success(currentPermissionStatus())
            return
        }

        val shouldShowFineRationale = ActivityCompat.shouldShowRequestPermissionRationale(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION,
        )
        val shouldShowCoarseRationale = ActivityCompat.shouldShowRequestPermissionRationale(
            this,
            Manifest.permission.ACCESS_COARSE_LOCATION,
        )

        result.success(
            if (!shouldShowFineRationale && !shouldShowCoarseRationale) "deniedForever" else "denied"
        )
    }
}
