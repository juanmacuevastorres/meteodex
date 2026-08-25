enum WeatherCondition { sunny, rain, snow, cloudy, thunderstorm, unknown }

enum WeatherLoadState { loading, success, stale, empty, error }

class ForecastDay {
  const ForecastDay({required this.date, required this.highCelsius, required this.lowCelsius, required this.condition});

  final DateTime date;
  final int highCelsius;
  final int lowCelsius;
  final WeatherCondition condition;
}

class CurrentWeather {
  const CurrentWeather({
    required this.city,
    required this.temperatureCelsius,
    required this.condition,
    required this.updatedAt,
    this.forecast = const [],
  });

  final String city;
  final int temperatureCelsius;
  final WeatherCondition condition;
  final DateTime updatedAt;
  final List<ForecastDay> forecast;
}

class WeatherResult {
  const WeatherResult({required this.state, this.weather, this.message});

  const WeatherResult.loading() : this(state: WeatherLoadState.loading);
  const WeatherResult.empty() : this(state: WeatherLoadState.empty);
  const WeatherResult.error(String message) : this(state: WeatherLoadState.error, message: message);
  const WeatherResult.success(CurrentWeather weather) : this(state: WeatherLoadState.success, weather: weather);
  const WeatherResult.stale(CurrentWeather weather) : this(state: WeatherLoadState.stale, weather: weather);

  final WeatherLoadState state;
  final CurrentWeather? weather;
  final String? message;
}
