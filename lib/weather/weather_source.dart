import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/weather.dart';

abstract interface class WeatherSource {
  Future<CurrentWeather> fetchWeather({required double latitude, required double longitude});
}

class FakeWeatherSource implements WeatherSource {
  FakeWeatherSource({this.result});

  final CurrentWeather? result;

  @override
  Future<CurrentWeather> fetchWeather({required double latitude, required double longitude}) async {
    final weather = result;
    if (weather == null) {
      throw StateError('Weather data is unavailable');
    }
    return weather;
  }
}

class OpenMeteoWeatherSource implements WeatherSource {
  OpenMeteoWeatherSource({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<CurrentWeather> fetchWeather({required double latitude, required double longitude}) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current': 'temperature_2m,weather_code',
      'timezone': 'auto',
    });
    final response = await _client.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw StateError('Weather service returned ${response.statusCode}');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final current = data['current'] as Map<String, dynamic>;
    return CurrentWeather(
      city: 'Selected city',
      temperatureCelsius: (current['temperature_2m'] as num).round(),
      condition: conditionFromWeatherCode(current['weather_code'] as num),
      updatedAt: DateTime.tryParse(current['time'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

WeatherCondition conditionFromWeatherCode(num code) => switch (code.toInt()) {
      0 || 1 => WeatherCondition.sunny,
      2 || 3 || 45 || 48 => WeatherCondition.cloudy,
      >= 51 && <= 67 || >= 80 && <= 82 => WeatherCondition.rain,
      >= 71 && <= 77 || 85 || 86 => WeatherCondition.snow,
      _ => WeatherCondition.unknown,
    };
