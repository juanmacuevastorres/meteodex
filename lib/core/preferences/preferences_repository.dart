import '../models/city.dart';

abstract interface class PreferencesRepository {
  Future<String?> readLanguage();
  Future<String?> readLauncher();
  Future<String?> readCurrentCityId();
  Future<List<String>> readFavoriteCityIds();
  Future<List<City>> readFavoriteCities();
  Future<void> writeLanguage(String languageCode);
  Future<void> writeLauncher(String launcherId);
  Future<void> writeCurrentCityId(String cityId);
  Future<void> writeFavoriteCityIds(List<String> cityIds);
  Future<void> writeFavoriteCities(List<City> cities);
}
