import '../cities/city_repository.dart';
import '../core/preferences/preferences_repository.dart';
import '../weather/weather_source.dart';

class AppDependencies {
  const AppDependencies({required this.preferences, required this.cityRepository, required this.weatherSource});

  final PreferencesRepository preferences;
  final CityRepository cityRepository;
  final WeatherSource weatherSource;
}
