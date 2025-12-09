package com.example.banking_app.service

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.util.Log

class BackgroundTimerService : Service() {
    private var counter = 0
    private var isRunning = false

    override fun onCreate() {
        super.onCreate()
        Log.d("BG_TIMER", "Service created")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("BG_TIMER", "Service started")
        
        if (!isRunning) {
            isRunning = true
            startCounting()
        }

        return START_STICKY
    }

    private fun startCounting() {
        Thread {
            while (isRunning) {
                counter++
                Log.d("BG_TIMER", "Counter: $counter")
                Thread.sleep(1000)
            }
        }.start()
    }

    override fun onDestroy() {
        super.onDestroy()
        isRunning = false
        Log.d("BG_TIMER", "Service destroyed")
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
