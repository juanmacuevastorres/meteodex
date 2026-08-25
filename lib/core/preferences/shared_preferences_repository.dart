import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/city.dart';
import 'preferences_repository.dart';

class SharedPreferencesRepository implements PreferencesRepository {
  SharedPreferencesRepository(this.preferences);

  final SharedPreferences preferences;

  @override
  Future<String?> readLanguage() async => preferences.getString('language');

  @override
  Future<String?> readLauncher() async => preferences.getString('launcher');

  @override
  Future<String?> readTemperatureUnit() async =>
      preferences.getString('temperature_unit');

  @override
  Future<String?> readCurrentCityId() async =>
      preferences.getString('current_city');

  @override
  Future<List<String>> readFavoriteCityIds() async =>
      preferences.getStringList('favorite_cities') ?? const [];

  @override
  Future<List<City>> readFavoriteCities() async {
    final encodedCities =
        preferences.getStringList('favorite_city_data') ?? const [];
    return encodedCities.map((encodedCity) {
      final city = jsonDecode(encodedCity) as Map<String, dynamic>;
      return City(
        id: city['id'] as String,
        name: city['name'] as String,
        country: city['country'] as String,
        latitude: (city['latitude'] as num).toDouble(),
        longitude: (city['longitude'] as num).toDouble(),
      );
    }).toList();
  }

  @override
  Future<void> writeLanguage(String languageCode) async =>
      preferences.setString('language', languageCode);

  @override
  Future<void> writeLauncher(String launcherId) async =>
      preferences.setString('launcher', launcherId);

    @override
    Future<void> writeTemperatureUnit(String unit) async =>
      preferences.setString('temperature_unit', unit);

  @override
  Future<void> writeCurrentCityId(String cityId) async =>
      preferences.setString('current_city', cityId);

  @override
  Future<void> writeFavoriteCityIds(List<String> cityIds) async =>
      preferences.setStringList('favorite_cities', cityIds);

  @override
  Future<void> writeFavoriteCities(List<City> cities) async =>
      preferences.setStringList(
        'favorite_city_data',
        cities
            .map(
              (city) => jsonEncode({
                'id': city.id,
                'name': city.name,
                'country': city.country,
                'latitude': city.latitude,
                'longitude': city.longitude,
              }),
            )
            .toList(),
      );
}
