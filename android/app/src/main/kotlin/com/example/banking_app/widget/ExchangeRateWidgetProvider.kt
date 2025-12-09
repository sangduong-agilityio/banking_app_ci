package com.example.banking_app.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import com.example.banking_app.MainActivity
import com.example.banking_app.R
import org.json.JSONArray
import java.text.SimpleDateFormat
import java.util.*

/**
 * AppWidgetProvider for displaying exchange rates on the home screen.
 * 
 * This widget displays up to 5 currency exchange rates with buy/sell prices.
 * It supports:
 * - Manual refresh via tap on refresh button
 * - Opening the app when widget is tapped
 * - Automatic updates from Flutter app
 * - Caching rates in SharedPreferences for offline display
 */
class ExchangeRateWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "ExchangeRateWidget"
        const val PREFS_NAME = "exchange_rate_widget_prefs"
        const val KEY_EXCHANGE_RATES = "exchange_rates"
        const val KEY_LAST_UPDATED = "last_updated"
        const val ACTION_REFRESH = "com.example.banking_app.WIDGET_REFRESH"
        const val ACTION_UPDATE_DATA = "com.example.banking_app.WIDGET_UPDATE_DATA"
        
        /**
         * Updates all active widget instances with the latest exchange rate data.
         * Called from Flutter via MethodChannel.
         */
        fun updateWidgets(context: Context) {
            val intent = Intent(context, ExchangeRateWidgetProvider::class.java).apply {
                action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(
                    ComponentName(context, ExchangeRateWidgetProvider::class.java)
                )
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, appWidgetIds)
            }
            context.sendBroadcast(intent)
        }

        /**
         * Saves exchange rate data to SharedPreferences.
         * Data is stored as JSON for easy serialization.
         */
        fun saveExchangeRates(context: Context, ratesJson: String) {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            prefs.edit().apply {
                putString(KEY_EXCHANGE_RATES, ratesJson)
                putLong(KEY_LAST_UPDATED, System.currentTimeMillis())
                apply()
            }
            Log.d(TAG, "Saved exchange rates: $ratesJson")
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        Log.d(TAG, "onUpdate called for ${appWidgetIds.size} widgets")
        
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        
        when (intent.action) {
            ACTION_REFRESH -> {
                Log.i(TAG, "Refresh action received")
                // Trigger widget update
                updateWidgets(context)
                
                // Optionally trigger data fetch from Flutter app
                val launchIntent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    putExtra("action", "refresh_exchange_rates")
                }
                context.startActivity(launchIntent)
            }
            ACTION_UPDATE_DATA -> {
                Log.i(TAG, "Update data action received")
                updateWidgets(context)
            }
        }
    }

    override fun onEnabled(context: Context) {
        Log.i(TAG, "Widget enabled (first instance added)")
    }

    override fun onDisabled(context: Context) {
        Log.i(TAG, "Widget disabled (last instance removed)")
        // Clean up SharedPreferences if needed
    }

    /**
     * Updates a single widget instance with current exchange rate data.
     */
    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        Log.d(TAG, "Updating widget $appWidgetId")
        
        val views = RemoteViews(context.packageName, R.layout.widget_exchange_rate)
        
        // Set up click listener to open the app
        val openAppIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("shortcut_action", "exchange_rate")
        }
        val openAppPendingIntent = PendingIntent.getActivity(
            context,
            0,
            openAppIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_layout, openAppPendingIntent)
        
        // Set up refresh button click
        val refreshIntent = Intent(context, ExchangeRateWidgetProvider::class.java).apply {
            action = ACTION_REFRESH
        }
        val refreshPendingIntent = PendingIntent.getBroadcast(
            context,
            1,
            refreshIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.refresh_button, refreshPendingIntent)
        
        // Load and display exchange rates
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val ratesJson = prefs.getString(KEY_EXCHANGE_RATES, null)
        val lastUpdated = prefs.getLong(KEY_LAST_UPDATED, 0)
        
        if (ratesJson != null) {
            try {
                displayExchangeRates(context, views, ratesJson)
            } catch (e: Exception) {
                Log.e(TAG, "Error parsing exchange rates", e)
                displayNoData(views)
            }
        } else {
            displayNoData(views)
        }
        
        // Update last updated timestamp
        if (lastUpdated > 0) {
            val dateFormat = SimpleDateFormat("HH:mm dd/MM", Locale.getDefault())
            val formattedDate = dateFormat.format(Date(lastUpdated))
            views.setTextViewText(R.id.last_updated, "Updated: $formattedDate")
        } else {
            views.setTextViewText(R.id.last_updated, "Tap to update")
        }
        
        // Commit the update
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    /**
     * Parses JSON exchange rate data and displays it in the widget.
     * 
     * Expected JSON format:
     * [
     *   {"country": "Vietnam", "flag": "https://...", "buy": "1.403", "sell": "1.746"},
     *   {"country": "Nicaragua", "flag": "https://...", "buy": "9.123", "sell": "12.09"},
     *   ...
     * ]
     */
    private fun displayExchangeRates(context: Context, views: RemoteViews, ratesJson: String) {
        val rates = JSONArray(ratesJson)
        val maxItems = minOf(rates.length(), 5)
        
        // Row IDs for each rate item
        val rowIds = listOf(
            R.id.rate_row_1,
            R.id.rate_row_2,
            R.id.rate_row_3,
            R.id.rate_row_4,
            R.id.rate_row_5
        )
        
        val flagIds = listOf(
            R.id.flag_1,
            R.id.flag_2,
            R.id.flag_3,
            R.id.flag_4,
            R.id.flag_5
        )
        
        val currencyIds = listOf(
            R.id.currency_1,
            R.id.currency_2,
            R.id.currency_3,
            R.id.currency_4,
            R.id.currency_5
        )
        
        val buyIds = listOf(
            R.id.buy_1,
            R.id.buy_2,
            R.id.buy_3,
            R.id.buy_4,
            R.id.buy_5
        )
        
        val sellIds = listOf(
            R.id.sell_1,
            R.id.sell_2,
            R.id.sell_3,
            R.id.sell_4,
            R.id.sell_5
        )
        
        for (i in 0 until 5) {
            if (i < maxItems) {
                val rate = rates.getJSONObject(i)
                val country = rate.optString("country", "-")
                val buy = rate.optString("buy", "-")
                val sell = rate.optString("sell", "-")
                
                views.setViewVisibility(rowIds[i], View.VISIBLE)
                views.setTextViewText(currencyIds[i], country)
                views.setTextViewText(buyIds[i], buy)
                views.setTextViewText(sellIds[i], sell)
                
                // Hide flag image (not used)
                views.setViewVisibility(flagIds[i], View.GONE)
            } else {
                views.setViewVisibility(rowIds[i], View.GONE)
            }
        }
    }
    
    /**
     * Displays a placeholder when no exchange rate data is available.
     */
    private fun displayNoData(views: RemoteViews) {
        // Hide all rate rows
        views.setViewVisibility(R.id.rate_row_1, View.GONE)
        views.setViewVisibility(R.id.rate_row_2, View.GONE)
        views.setViewVisibility(R.id.rate_row_3, View.GONE)
        views.setViewVisibility(R.id.rate_row_4, View.GONE)
        views.setViewVisibility(R.id.rate_row_5, View.GONE)
        
        // Show first row with "No data" message
        views.setViewVisibility(R.id.rate_row_1, View.VISIBLE)
        views.setTextViewText(R.id.currency_1, "No data available")
        views.setTextViewText(R.id.buy_1, "")
        views.setTextViewText(R.id.sell_1, "")
    }
}
