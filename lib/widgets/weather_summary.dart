import '../weather/models/weather.dart';

class WidgetWeatherSummary {
  const WidgetWeatherSummary({
    required this.city,
    required this.temperatureCelsius,
    required this.condition,
    required this.updatedAt,
    required this.isAvailable,
  });

  factory WidgetWeatherSummary.fromWeather(CurrentWeather weather) => WidgetWeatherSummary(
        city: weather.city,
        temperatureCelsius: weather.temperatureCelsius,
        condition: weather.condition,
        updatedAt: weather.updatedAt,
        isAvailable: true,
      );

  const WidgetWeatherSummary.unavailable()
      : city = '',
        temperatureCelsius = 0,
        condition = WeatherCondition.unknown,
        updatedAt = null,
        isAvailable = false;

  final String city;
  final int temperatureCelsius;
  final WeatherCondition condition;
  final DateTime? updatedAt;
  final bool isAvailable;
}
