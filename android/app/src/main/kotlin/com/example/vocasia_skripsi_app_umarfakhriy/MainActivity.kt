package com.example.vocasia_skripsi_app_umarfakhriy

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Membuat Notification Channel dengan prioritas TINGGI (agar muncul banner pop-up & bersuara)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "vocasia_high_importance_channel"
            val channelName = "Notifikasi Vocasia"
            val channelDescription = "Notifikasi untuk tugas, perizinan, persuratan, dan bimbingan"
            val importance = NotificationManager.IMPORTANCE_HIGH

            val channel = NotificationChannel(channelId, channelName, importance).apply {
                description = channelDescription
                enableLights(true)
                enableVibration(true)
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager?.createNotificationChannel(channel)
        }
    }
}
