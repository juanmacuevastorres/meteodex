import 'package:flutter_test/flutter_test.dart';

import 'package:meteodex/cities/city_repository.dart';
import 'package:meteodex/core/localization/app_copy.dart';
import 'package:meteodex/core/models/city.dart';
import 'package:meteodex/core/themes/theme_models.dart';
import 'package:meteodex/core/themes/theme_rule_resolver.dart';
import 'package:meteodex/weather/models/weather.dart';
import 'package:meteodex/weather/weather_repository.dart';
import 'package:meteodex/weather/weather_source.dart';
import 'package:meteodex/widgets/weather_summary.dart';

class _FailingAfterFirstSource implements WeatherSource {
  _FailingAfterFirstSource(this.weather);

  final CurrentWeather weather;
  bool failed = false;

  @override
  Future<CurrentWeather> fetchWeather({required double latitude, required double longitude}) async {
    if (failed) throw StateError('offline');
    failed = true;
    return weather;
  }
}

void main() {
  test('unsupported language falls back to Castilian Spanish', () {
    expect(SupportedLanguage.fromCode('xx'), SupportedLanguage.castilianSpanish);
    expect(AppCopy(SupportedLanguage.fromCode('xx')).weatherTab, 'TIEMPO');
  });

  test('city search supports empty results', () async {
    final repository = InMemoryCityRepository();
    expect((await repository.search('Tokyo')).single.name, 'Tokyo');
    expect(await repository.search('nowhere'), isEmpty);
  });

  test('fake weather source and widget summary preserve domain data', () async {
    final weather = CurrentWeather(city: 'Madrid', temperatureCelsius: 22, condition: WeatherCondition.cloudy, updatedAt: DateTime(2026, 8, 23));
    final loaded = await FakeWeatherSource(result: weather).fetchWeather(latitude: 0, longitude: 0);
    final summary = WidgetWeatherSummary.fromWeather(loaded);
    expect(summary.city, 'Madrid');
    expect(summary.temperatureCelsius, 22);
    expect(summary.isAvailable, isTrue);
  });

  test('favorites add and remove cities', () {
    const city = City(id: 'rome', name: 'Rome', country: 'Italy', latitude: 41.9, longitude: 12.5);
    final favorites = Favorites();
    favorites.add(city);
    expect(favorites.contains(city), isTrue);
    favorites.remove(city);
    expect(favorites.contains(city), isFalse);
  });

  test('weather repository returns stale cached data when source fails', () async {
    final weather = CurrentWeather(city: 'Madrid', temperatureCelsius: 22, condition: WeatherCondition.cloudy, updatedAt: DateTime(2026, 8, 23));
    final repository = WeatherRepository(FakeWeatherSource(result: weather), staleAfter: const Duration(hours: 1));
    await repository.load(cityId: 'madrid', latitude: 0, longitude: 0);
    final offline = WeatherRepository(FakeWeatherSource(), staleAfter: const Duration(hours: 1));
    final result = await offline.load(cityId: 'madrid', latitude: 0, longitude: 0, now: DateTime(2026, 8, 23, 2));
    expect(result.state, WeatherLoadState.error);

    final cachedRepository = WeatherRepository(_FailingAfterFirstSource(weather), staleAfter: const Duration(hours: 1));
    await cachedRepository.load(cityId: 'madrid', latitude: 0, longitude: 0);
    final stale = await cachedRepository.load(cityId: 'madrid', latitude: 0, longitude: 0, now: DateTime(2026, 8, 23, 2));
    expect(stale.state, WeatherLoadState.stale);
  });

  test('custom theme parses assets and resolves Celsius weather rules', () {
    final theme = CustomTheme.fromMap({
      'version': 1,
      'id': 'sample',
      'name': 'Sample',
      'visual': {
        'backgroundColor': '#101820',
        'surfaceColor': '#203040',
        'textColor': '#FFFFFF',
        'accentColor': '#FFCC00',
      },
      'assets': {
        'hot': {'path': 'images/hot.gif', 'type': 'gif'},
        'cool': {'path': 'images/cool.png', 'type': 'png'},
      },
      'weatherRules': [
        {'condition': 'sunny', 'minTemperature': 40, 'asset': 'hot'},
        {'condition': 'sunny', 'maxTemperature': 39, 'asset': 'cool'},
      ],
    });

    final weather = CurrentWeather(
      city: 'Madrid',
      temperatureCelsius: 40,
      condition: WeatherCondition.sunny,
      updatedAt: DateTime(2026, 8, 23),
    );
    expect(resolveThemeRule(theme, weather)?.assetId, 'hot');
  });

  test('custom theme rejects unsafe assets and ambiguous rules', () {
    expect(
      () => CustomTheme.fromMap({
        'version': 1,
        'id': 'unsafe',
        'name': 'Unsafe',
        'visual': {
          'backgroundColor': '#101820',
          'surfaceColor': '#203040',
          'textColor': '#FFFFFF',
          'accentColor': '#FFCC00',
        },
        'assets': {'bad': {'path': '../bad.gif', 'type': 'gif'}},
        'weatherRules': [],
      }),
      throwsFormatException,
    );
    expect(
      () => CustomTheme.fromMap({
        'version': 1,
        'id': 'overlap',
        'name': 'Overlap',
        'visual': {
          'backgroundColor': '#101820',
          'surfaceColor': '#203040',
          'textColor': '#FFFFFF',
          'accentColor': '#FFCC00',
        },
        'assets': {'one': {'path': 'one.png', 'type': 'png'}},
        'weatherRules': [
          {'condition': 'sunny', 'minTemperature': 20, 'asset': 'one'},
          {'condition': 'sunny', 'minTemperature': 25, 'asset': 'one'},
        ],
      }),
      throwsFormatException,
    );
  });
}
