package com.example.banking_app.widget

import android.content.Context
import android.util.Log
import androidx.work.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.util.concurrent.TimeUnit

/**
 * WorkManager Worker for fetching exchange rates in the background.
 * 
 * This worker periodically fetches exchange rates from the API and
 * updates the home screen widget with the latest data.
 */
class ExchangeRateWorker(
    context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    companion object {
        private const val TAG = "ExchangeRateWorker"
        private const val WORK_NAME = "exchange_rate_update_work"
        
        // API endpoint - this should match your Flutter app's endpoint
        // In production, consider storing this securely or sharing with Flutter
        private const val PREFS_NAME = "flutter_prefs"
        private const val KEY_API_ENDPOINT = "api_endpoint"
        
        /**
         * Schedules periodic background updates for exchange rates.
         * Updates every 30 minutes when the device has network connectivity.
         */
        fun schedulePeriodicWork(context: Context) {
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

            val periodicWorkRequest = PeriodicWorkRequestBuilder<ExchangeRateWorker>(
                30, TimeUnit.MINUTES,  // Repeat interval
                15, TimeUnit.MINUTES   // Flex interval
            )
                .setConstraints(constraints)
                .setBackoffCriteria(
                    BackoffPolicy.LINEAR,
                    10, TimeUnit.MINUTES
                )
                .build()

            WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                WORK_NAME,
                ExistingPeriodicWorkPolicy.KEEP,
                periodicWorkRequest
            )
            
            Log.i(TAG, "Scheduled periodic exchange rate updates")
        }

        /**
         * Triggers an immediate one-time update of exchange rates.
         */
        fun triggerImmediateUpdate(context: Context) {
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.CONNECTED)
                .build()

            val oneTimeWorkRequest = OneTimeWorkRequestBuilder<ExchangeRateWorker>()
                .setConstraints(constraints)
                .build()

            WorkManager.getInstance(context).enqueue(oneTimeWorkRequest)
            
            Log.i(TAG, "Triggered immediate exchange rate update")
        }

        /**
         * Cancels all scheduled exchange rate updates.
         */
        fun cancelWork(context: Context) {
            WorkManager.getInstance(context).cancelUniqueWork(WORK_NAME)
            Log.i(TAG, "Cancelled exchange rate update work")
        }
    }

    override suspend fun doWork(): Result {
        Log.d(TAG, "Starting exchange rate fetch...")
        
        return try {
            val rates = fetchExchangeRates()
            
            if (rates != null) {
                // Save rates to SharedPreferences
                ExchangeRateWidgetProvider.saveExchangeRates(applicationContext, rates)
                
                // Update all widget instances
                ExchangeRateWidgetProvider.updateWidgets(applicationContext)
                
                Log.i(TAG, "Successfully fetched and updated exchange rates")
                Result.success()
            } else {
                Log.w(TAG, "No exchange rates returned from API")
                Result.retry()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to fetch exchange rates", e)
            Result.retry()
        }
    }

    /**
     * Fetches exchange rates from the API.
     * Returns JSON string of exchange rates or null on failure.
     */
    private suspend fun fetchExchangeRates(): String? = withContext(Dispatchers.IO) {
        var connection: HttpURLConnection? = null
        
        try {
            // Get API endpoint from SharedPreferences (set by Flutter app)
            val prefs = applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val baseUrl = prefs.getString(KEY_API_ENDPOINT, null)
            
            if (baseUrl.isNullOrEmpty()) {
                Log.w(TAG, "API endpoint not configured, using cached data if available")
                return@withContext null
            }
            
            val apiUrl = "$baseUrl/exchange_rates?select=country,flag,buy,sell"
            Log.d(TAG, "Fetching from: $apiUrl")
            
            val url = URL(apiUrl)
            connection = url.openConnection() as HttpURLConnection
            connection.apply {
                requestMethod = "GET"
                connectTimeout = 10000
                readTimeout = 10000
                setRequestProperty("Accept", "application/json")
            }
            
            val responseCode = connection.responseCode
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                val reader = BufferedReader(InputStreamReader(connection.inputStream))
                val response = StringBuilder()
                var line: String?
                
                while (reader.readLine().also { line = it } != null) {
                    response.append(line)
                }
                reader.close()
                
                // Validate JSON response
                val jsonArray = JSONArray(response.toString())
                Log.d(TAG, "Fetched ${jsonArray.length()} exchange rates")
                
                return@withContext response.toString()
            } else {
                Log.e(TAG, "API returned error code: $responseCode")
                return@withContext null
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error fetching exchange rates", e)
            return@withContext null
        } finally {
            connection?.disconnect()
        }
    }
}

/**
 * Helper object for managing widget-related WorkManager operations.
 */
object WidgetWorkManager {
    
    /**
     * Initializes background work for widget updates.
     * Should be called when the app starts or when the first widget is added.
     */
    fun initialize(context: Context) {
        ExchangeRateWorker.schedulePeriodicWork(context)
    }
    
    /**
     * Forces an immediate refresh of widget data.
     */
    fun forceRefresh(context: Context) {
        ExchangeRateWorker.triggerImmediateUpdate(context)
    }
}
