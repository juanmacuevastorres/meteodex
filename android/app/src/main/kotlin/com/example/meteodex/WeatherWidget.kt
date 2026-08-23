package com.example.meteodex

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.app.PendingIntent
import android.widget.RemoteViews

class WeatherWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        ids.forEach { id -> update(context, manager, id) }
    }

    companion object {
        const val PREFERENCES = "meteodex_widget"
        const val CITY = "city"
        const val TEMPERATURE = "temperature"
        const val CONDITION = "condition"

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val component = ComponentName(context, WeatherWidget::class.java)
            manager.getAppWidgetIds(component).forEach { id -> update(context, manager, id) }
        }

        private fun update(context: Context, manager: AppWidgetManager, id: Int) {
            val preferences = context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)
            val city = preferences.getString(CITY, "MeteoDex") ?: "MeteoDex"
            val temperature = preferences.getString(TEMPERATURE, "--") ?: "--"
            val condition = preferences.getString(CONDITION, "unknown") ?: "unknown"
            val views = RemoteViews(context.packageName, R.layout.weather_widget)
            views.setTextViewText(R.id.widget_city, city)
            views.setTextViewText(R.id.widget_temperature, temperature)
            views.setTextViewText(R.id.widget_condition, condition.replaceFirstChar { it.uppercase() })
            val launchIntent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(context, 0, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
            manager.updateAppWidget(id, views)
        }
    }
}
