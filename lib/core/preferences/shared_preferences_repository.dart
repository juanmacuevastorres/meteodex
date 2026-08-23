import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_repository.dart';

class SharedPreferencesRepository implements PreferencesRepository {
  SharedPreferencesRepository(this.preferences);

  final SharedPreferences preferences;

  @override
  Future<String?> readLanguage() async => preferences.getString('language');

  @override
  Future<String?> readLauncher() async => preferences.getString('launcher');

  @override
  Future<String?> readCurrentCityId() async => preferences.getString('current_city');

  @override
  Future<List<String>> readFavoriteCityIds() async => preferences.getStringList('favorite_cities') ?? const [];

  @override
  Future<void> writeLanguage(String languageCode) async => preferences.setString('language', languageCode);

  @override
  Future<void> writeLauncher(String launcherId) async => preferences.setString('launcher', launcherId);

  @override
  Future<void> writeCurrentCityId(String cityId) async => preferences.setString('current_city', cityId);

  @override
  Future<void> writeFavoriteCityIds(List<String> cityIds) async => preferences.setStringList('favorite_cities', cityIds);
}
