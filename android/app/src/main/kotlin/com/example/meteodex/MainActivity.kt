package com.example.meteodex

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val channelName = "com.example.meteodex/widget"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
			if (call.method != "updateWeather") {
				result.notImplemented()
				return@setMethodCallHandler
			}

			val city = call.argument<String>("city") ?: "MeteoDex"
			val temperature = call.argument<String>("temperature") ?: "--"
			val condition = call.argument<String>("condition") ?: "unknown"
			getSharedPreferences(WeatherWidget.PREFERENCES, MODE_PRIVATE).edit()
				.putString(WeatherWidget.CITY, city)
				.putString(WeatherWidget.TEMPERATURE, temperature)
				.putString(WeatherWidget.CONDITION, condition)
				.apply()
			WeatherWidget.updateAll(this)
			result.success(null)
		}
	}
}
