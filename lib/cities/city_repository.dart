import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/models/city.dart';

abstract interface class CityRepository {
  Future<List<City>> search(String query);
}

class InMemoryCityRepository implements CityRepository {
  InMemoryCityRepository([this.cities = _defaultCities]);

  final List<City> cities;

  @override
  Future<List<City>> search(String query) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return const [];
    return cities.where((city) => '${city.name} ${city.country}'.toLowerCase().contains(normalized)).toList();
  }

  static const _defaultCities = <City>[
    City(id: 'tokyo', name: 'Tokyo', country: 'Japan', latitude: 35.6762, longitude: 139.6503),
    City(id: 'madrid', name: 'Madrid', country: 'Spain', latitude: 40.4168, longitude: -3.7038),
    City(id: 'london', name: 'London', country: 'United Kingdom', latitude: 51.5072, longitude: -0.1276),
    City(id: 'rome', name: 'Rome', country: 'Italy', latitude: 41.9028, longitude: 12.4964),
  ];
}

class OpenMeteoCityRepository implements CityRepository {
  OpenMeteoCityRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<City>> search(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return const [];
    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': normalized,
      'count': '10',
      'language': 'en',
      'format': 'json',
    });
    final response = await _client.get(uri).timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) throw StateError('City search returned ${response.statusCode}');
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (data['results'] as List<dynamic>? ?? const []);
    return results.map((item) {
      final result = item as Map<String, dynamic>;
      return City(
        id: '${result['id']}',
        name: result['name'] as String,
        country: result['country'] as String? ?? result['admin1'] as String? ?? '',
        latitude: (result['latitude'] as num).toDouble(),
        longitude: (result['longitude'] as num).toDouble(),
      );
    }).toList();
  }
}

class Favorites {
  Favorites([Iterable<City> initial = const []]) : _cities = {...initial};

  final Set<City> _cities;
  List<City> get cities => _cities.toList(growable: false);
  bool contains(City city) => _cities.contains(city);
  void add(City city) => _cities.add(city);
  void remove(City city) => _cities.remove(city);
}
