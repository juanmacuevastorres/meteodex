import 'models/weather.dart';
import 'weather_source.dart';

class WeatherRepository {
  WeatherRepository(this.source, {this.staleAfter = const Duration(hours: 1)});

  final WeatherSource source;
  final Duration staleAfter;
  final Map<String, CurrentWeather> _cache = {};

  Future<WeatherResult> load({required String cityId, required double latitude, required double longitude, DateTime? now}) async {
    try {
      final weather = await source.fetchWeather(latitude: latitude, longitude: longitude);
      _cache[cityId] = weather;
      return WeatherResult.success(weather);
    } catch (_) {
      final cached = _cache[cityId];
      if (cached == null) return const WeatherResult.error('Weather data is unavailable');
      final age = (now ?? DateTime.now()).difference(cached.updatedAt);
      return age > staleAfter ? WeatherResult.stale(cached) : WeatherResult.success(cached);
    }
  }
}
