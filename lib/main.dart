import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cities/city_repository.dart';
import 'core/localization/app_copy.dart';
import 'core/models/city.dart';
import 'core/preferences/preferences_repository.dart';
import 'core/preferences/shared_preferences_repository.dart';
import 'launchers/launcher.dart';
import 'weather/models/weather.dart';
import 'weather/weather_source.dart';

const _widgetChannel = MethodChannel('com.example.meteodex/widget');

Future<void> _updateAndroidWidget(CurrentWeather weather) async {
  try {
    await _widgetChannel.invokeMethod<void>('updateWeather', <String, Object>{
      'city': weather.city,
      'temperature': '${weather.temperatureCelsius} C',
      'condition': weather.condition.name,
    });
  } on MissingPluginException {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    MeteoDexApp(
      preferences: SharedPreferencesRepository(preferences),
      cityRepository: OpenMeteoCityRepository(),
      weatherSource: OpenMeteoWeatherSource(),
    ),
  );
}

class RetroColors {
  static const dark = Color(0xFF0F380F);
  static const mediumDark = Color(0xFF306230);
  static const light = Color(0xFF8BAC0F);
  static const lightest = Color(0xFF9BBC0F);
}

class MeteoDexApp extends StatefulWidget {
  MeteoDexApp({
    required this.preferences,
    CityRepository? cityRepository,
    WeatherSource? weatherSource,
    super.key,
  }) : cityRepository = cityRepository ?? InMemoryCityRepository(),
       weatherSource =
           weatherSource ??
           FakeWeatherSource(
             result: CurrentWeather(
               city: 'Madrid',
               temperatureCelsius: 28,
               condition: WeatherCondition.sunny,
               updatedAt: DateTime(2026, 8, 23),
             ),
           );

  final PreferencesRepository preferences;
  final CityRepository cityRepository;
  final WeatherSource weatherSource;

  @override
  State<MeteoDexApp> createState() => _MeteoDexAppState();
}

class _MeteoDexAppState extends State<MeteoDexApp> {
  SupportedLanguage _language = SupportedLanguage.castilianSpanish;
  String _launcherId = 'retro';
  TemperatureUnit _temperatureUnit = TemperatureUnit.celsius;

  @override
  void initState() {
    super.initState();
    _restorePreferences();
  }

  Future<void> _restorePreferences() async {
    final language = SupportedLanguage.fromCode(
      await widget.preferences.readLanguage(),
    );
    final launcherId = LauncherCatalog.byId(
      await widget.preferences.readLauncher(),
    ).id;
    final temperatureUnit = (await widget.preferences.readTemperatureUnit()) ==
            TemperatureUnit.fahrenheit.name
        ? TemperatureUnit.fahrenheit
        : TemperatureUnit.celsius;
    if (!mounted) return;
    setState(() {
      _language = language;
      _launcherId = launcherId;
      _temperatureUnit = temperatureUnit;
    });
  }

  Future<void> _changeLanguage(SupportedLanguage language) async {
    setState(() => _language = language);
    await widget.preferences.writeLanguage(language.code);
  }

  Future<void> _changeLauncher(String launcherId) async {
    final launcher = LauncherCatalog.byId(launcherId);
    setState(() => _launcherId = launcher.id);
    await widget.preferences.writeLauncher(launcher.id);
  }

  Future<void> _changeTemperatureUnit(TemperatureUnit unit) async {
    setState(() => _temperatureUnit = unit);
    await widget.preferences.writeTemperatureUnit(unit.name);
  }

  @override
  Widget build(BuildContext context) {
    final copy = AppCopy(_language);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: copy.title,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        fontFamily: 'monospace',
      ),
      home: AppShell(
        copy: copy,
        launcherId: _launcherId,
        preferences: widget.preferences,
        cityRepository: widget.cityRepository,
        weatherSource: widget.weatherSource,
        onLanguageChanged: _changeLanguage,
        onLauncherChanged: _changeLauncher,
        temperatureUnit: _temperatureUnit,
        onTemperatureUnitChanged: _changeTemperatureUnit,
      ),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({
    required this.copy,
    required this.launcherId,
    required this.preferences,
    required this.cityRepository,
    required this.weatherSource,
    required this.onLanguageChanged,
    required this.onLauncherChanged,
    required this.temperatureUnit,
    required this.onTemperatureUnitChanged,
    super.key,
  });

  final AppCopy copy;
  final String launcherId;
  final PreferencesRepository preferences;
  final CityRepository cityRepository;
  final WeatherSource weatherSource;
  final ValueChanged<SupportedLanguage> onLanguageChanged;
  final ValueChanged<String> onLauncherChanged;
  final TemperatureUnit temperatureUnit;
  final ValueChanged<TemperatureUnit> onTemperatureUnitChanged;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: RetroColors.dark,
          foregroundColor: RetroColors.lightest,
          title: Text(copy.title),
          bottom: TabBar(
            tabs: [
              Tab(text: copy.weatherTab),
              Tab(text: copy.settingsTab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WeatherScreen(
              copy: copy,
              preferences: preferences,
              cityRepository: cityRepository,
              weatherSource: weatherSource,
              launcherId: launcherId,
              temperatureUnit: temperatureUnit,
            ),
            SettingsScreen(
              copy: copy,
              launcherId: launcherId,
              onLanguageChanged: onLanguageChanged,
              onLauncherChanged: onLauncherChanged,
              temperatureUnit: temperatureUnit,
              onTemperatureUnitChanged: onTemperatureUnitChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.copy,
    required this.launcherId,
    required this.temperatureUnit,
    required this.onLanguageChanged,
    required this.onLauncherChanged,
    required this.onTemperatureUnitChanged,
    super.key,
  });

  final AppCopy copy;
  final String launcherId;
  final TemperatureUnit temperatureUnit;
  final ValueChanged<SupportedLanguage> onLanguageChanged;
  final ValueChanged<String> onLauncherChanged;
  final ValueChanged<TemperatureUnit> onTemperatureUnitChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          copy.optionsTitle,
          style: const TextStyle(color: RetroColors.lightest, fontSize: 22),
        ),
        const SizedBox(height: 24),
        Text(
          copy.temperatureUnit,
          style: const TextStyle(color: RetroColors.lightest, fontSize: 16),
        ),
        ...TemperatureUnit.values.map(
          (unit) => RadioListTile<TemperatureUnit>(
            activeColor: RetroColors.light,
            title: Text(
              unit == TemperatureUnit.celsius ? copy.celsius : copy.fahrenheit,
              style: const TextStyle(color: RetroColors.lightest),
            ),
            value: unit,
            groupValue: temperatureUnit,
            onChanged: (value) {
              if (value != null) onTemperatureUnitChanged(value);
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          copy.chooseLanguage,
          style: const TextStyle(color: RetroColors.lightest, fontSize: 16),
        ),
        ...SupportedLanguage.values.map(
          (language) => RadioListTile<SupportedLanguage>(
            activeColor: RetroColors.light,
            title: Text(
              language.label,
              style: const TextStyle(color: RetroColors.lightest),
            ),
            value: language,
            groupValue: copy.language,
            onChanged: (value) {
              if (value != null) onLanguageChanged(value);
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          copy.launcher,
          style: const TextStyle(color: RetroColors.lightest, fontSize: 16),
        ),
        ...LauncherCatalog.available.map(
          (launcher) => RadioListTile<String>(
            activeColor: RetroColors.light,
            title: Text(
              launcher.name,
              style: const TextStyle(color: RetroColors.lightest),
            ),
            value: launcher.id,
            groupValue: launcherId,
            onChanged: (value) {
              if (value != null) onLauncherChanged(value);
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          copy.customThemes,
          style: const TextStyle(color: RetroColors.lightest, fontSize: 16),
        ),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(copy.importTheme)),
          ),
          icon: const Icon(Icons.file_upload),
          label: Text(copy.importTheme),
        ),
      ],
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({
    required this.copy,
    required this.preferences,
    required this.cityRepository,
    required this.weatherSource,
    required this.launcherId,
    required this.temperatureUnit,
    super.key,
  });

  final AppCopy copy;
  final PreferencesRepository preferences;
  final CityRepository cityRepository;
  final WeatherSource weatherSource;
  final String launcherId;
  final TemperatureUnit temperatureUnit;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final City _defaultCity = const City(
    id: 'madrid',
    name: 'Madrid',
    country: 'Spain',
    latitude: 40.4168,
    longitude: -3.7038,
  );
  late City _city;
  final Set<String> _favoriteIds = {};
  final List<City> _favoriteCities = [];
  WeatherCondition _condition = WeatherCondition.sunny;
  int _temperature = 28;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _city = _defaultCity;
    _restoreCity();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final weather = await widget.weatherSource.fetchWeather(
        latitude: _city.latitude,
        longitude: _city.longitude,
      );
      if (!mounted) return;
      setState(() {
        _temperature = weather.temperatureCelsius;
        _condition = weather.condition;
        _loading = false;
      });
      await _updateAndroidWidget(weather);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = widget.copy.unavailable;
      });
    }
  }

  Future<void> _restoreCity() async {
    final cityId = await widget.preferences.readCurrentCityId();
    final favoriteIds = await widget.preferences.readFavoriteCityIds();
    final favoriteCities = await widget.preferences.readFavoriteCities();
    if (!mounted) return;
    final matches = cityId == null
        ? const <City>[]
        : await widget.cityRepository.search(cityId);
    setState(() {
      _favoriteIds.addAll(favoriteIds);
      _favoriteCities.addAll(
        favoriteCities.where((city) => _favoriteIds.contains(city.id)).take(3),
      );
      _favoriteIds.addAll(_favoriteCities.map((city) => city.id));
      if (matches.isNotEmpty) _city = matches.first;
    });
    await _loadWeather();
  }

  Future<void> _selectCity(City city, {bool closePicker = true}) async {
    setState(() => _city = city);
    await widget.preferences.writeCurrentCityId(city.id);
    await _loadWeather();
    if (closePicker && mounted) Navigator.of(context).pop();
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      if (_favoriteIds.remove(_city.id)) {
        _favoriteCities.removeWhere((city) => city.id == _city.id);
      } else if (_favoriteCities.length < 3) {
        _favoriteIds.add(_city.id);
        _favoriteCities.add(_city);
      }
    });
    await widget.preferences.writeFavoriteCityIds(_favoriteIds.toList());
    await widget.preferences.writeFavoriteCities(_favoriteCities);
  }

  void _openCityPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CityPicker(
        copy: widget.copy,
        repository: widget.cityRepository,
        favorites: _favoriteIds,
        onSelected: _selectCity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final launcher = LauncherCatalog.byId(widget.launcherId) as StyledLauncher;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 360),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: launcher.backgroundColor,
                  border: Border.all(color: launcher.foregroundColor, width: 4),
                  borderRadius: BorderRadius.circular(
                    launcher.id == 'retro' ? 12 : 2,
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, offset: Offset(6, 6)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.copy.title,
                          style: TextStyle(
                            color: launcher.foregroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            _city.name,
                            style: TextStyle(
                              color: launcher.accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: launcher.foregroundColor,
                      thickness: 2,
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: launcher.accentColor,
                        border: Border.all(
                          color: launcher.foregroundColor,
                          width: 2,
                        ),
                      ),
                      child: _loading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: launcher.foregroundColor,
                              ),
                            )
                          : PixelWeatherGlyph(
                              condition: _condition,
                              launcherId: launcher.id,
                              color: launcher.foregroundColor,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.copy.condition,
                              style: TextStyle(
                                color: launcher.accentColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _error ?? widget.copy.weather(_condition),
                              style: TextStyle(
                                color: launcher.foregroundColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.copy.temperature,
                              style: TextStyle(
                                color: launcher.accentColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                                _loading
                                  ? '--'
                                  : widget.temperatureUnit == TemperatureUnit.celsius
                                  ? '$_temperature C'
                                  : '${(_temperature * 9 / 5 + 32).round()} F',
                              style: TextStyle(
                                color: launcher.foregroundColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _openCityPicker,
                    icon: const Icon(Icons.location_city),
                    label: Text(widget.copy.searchCity),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _favoriteIds.contains(_city.id)
                          ? Icons.star
                          : Icons.star_border,
                    ),
                    color: RetroColors.light,
                    tooltip: widget.copy.favorites,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_favoriteCities.isNotEmpty)
                ..._favoriteCities
                    .take(3)
                    .map(
                      (city) => SizedBox(
                        width: 360,
                        child: ListTile(
                          leading: const Icon(Icons.star),
                          title: Text(city.name),
                          subtitle: Text(city.country),
                          onTap: () => _selectCity(city, closePicker: false),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class PixelWeatherGlyph extends StatefulWidget {
  const PixelWeatherGlyph({
    required this.condition,
    required this.launcherId,
    required this.color,
    super.key,
  });

  final WeatherCondition condition;
  final String launcherId;
  final Color color;

  @override
  State<PixelWeatherGlyph> createState() => _PixelWeatherGlyphState();
}

class _PixelWeatherGlyphState extends State<PixelWeatherGlyph>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(150, 130),
    painter: PixelWeatherPainter(
      condition: widget.condition,
      launcherId: widget.launcherId,
      color: widget.color,
      animation: _controller,
    ),
    willChange: true,
  );
}

class PixelWeatherPainter extends CustomPainter {
  PixelWeatherPainter({
    required this.condition,
    required this.launcherId,
    required this.color,
    required this.animation,
  }) : super(repaint: animation);

  final WeatherCondition condition;
  final String launcherId;
  final Color color;
  final Animation<double> animation;

  double get progress => animation.value;

  static const _patterns = <WeatherCondition, List<String>>{
    WeatherCondition.sunny: [
      '     XX     ',
      '  XXHHHHXX  ',
      ' XXHHHHHHXX ',
      'XXHHHHHHHHXX',
      'XXHHHHHHHHXX',
      '  XXHHHHXX  ',
      '     XX     ',
      '   XX  XX   ',
      '  XX    XX  ',
      '             ',
      '             ',
      '             ',
    ],
    WeatherCondition.cloudy: [
      '            ',
      '      XXXX  ',
      '   XXXXXXXXX',
      '  XHHHHHHXXX',
      ' XHHHHHHHHXX',
      'XXXXXXXXXXXX',
      'XXXXXXXXXXXX',
      '  XXXXXXXX  ',
      '            ',
      '            ',
      '            ',
      '            ',
    ],
    WeatherCondition.rain: [
      '            ',
      '      XXXX  ',
      '   XXXXXXXXX',
      '  XHHHHHHXXX',
      ' XHHHHHHHHXX',
      'XXXXXXXXXXXX',
      'XXXXXXXXXXXX',
      '   X  X  X   ',
      '  X  X  X   ',
      ' X  X  X    ',
      '            ',
      '            ',
    ],
    WeatherCondition.snow: [
      '            ',
      '      XXXX  ',
      '   XXXXXXXXX',
      '  XHHHHHHXXX',
      ' XHHHHHHHHXX',
      'XXXXXXXXXXXX',
      '  XXXX  XXXX',
      ' X  X  X  X ',
      '   XX  XX   ',
      '  X  XX  X  ',
      '            ',
      '            ',
    ],
    WeatherCondition.unknown: [
      'XXXXXXXXXXXX',
      'XHHHHHHHHHHX',
      'XHH  XX  HHX',
      'XH  XXXX  HX',
      'XHH  XX  HHX',
      'XHHHHHHHHHHX',
      'XH  XXXX  HX',
      'XH  XXXX  HX',
      'XHHHHHHHHHHX',
      'XXXXXXXXXXXX',
      '            ',
      '            ',
    ],
  };

  @override
  void paint(Canvas canvas, Size size) {
    if (launcherId == 'retro') {
      _paintRetro(canvas, size);
    } else if (launcherId == 'ninja') {
      _paintNinja(canvas, size);
    } else if (launcherId == 'battle') {
      _paintBattle(canvas, size);
    } else if (launcherId == 'digital') {
      _paintDigital(canvas, size);
    } else {
      _paintAdventure(canvas, size);
    }
  }

  void _paintRetro(Canvas canvas, Size size) {
    final cell = size.shortestSide / 18;
    final piecePaint = Paint()..color = color;
    final lightPaint = Paint()..color = Color.lerp(color, Colors.white, 0.35)!;
    final cleared = progress > 0.78 && progress < 0.9;
    for (var index = 0; index < 12; index++) {
      final x = ((index * 29) % 15) * cell;
      final y = ((progress * 17 + index * 1.7) % 16) * cell;
      if (cleared && y > size.height * 0.68) continue;
      final paint = index.isEven ? piecePaint : lightPaint;
      canvas.drawRect(Rect.fromLTWH(x + cell, y, cell * 2, cell), paint);
      canvas.drawRect(Rect.fromLTWH(x + cell, y + cell, cell, cell), paint);
    }
    _paintPixelWeather(canvas, size, Paint()..color = color);
    if (cleared) {
      final linePaint = Paint()..color = Colors.white.withValues(alpha: 0.8);
      canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.72, size.width, cell),
        linePaint,
      );
    }
  }

  void _paintNinja(Canvas canvas, Size size) {
    final bladePaint = Paint()..color = color;
    final shadowPaint = Paint()..color = color.withValues(alpha: 0.35);
    for (var index = 0; index < 5; index++) {
      final x =
          ((progress * 1.4 + index * 0.23) % 1.3) * size.width -
          size.width * 0.2;
      final y = size.height * (0.18 + index * 0.16);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(-0.35 + index * 0.12);
      canvas.drawRect(Rect.fromLTWH(0, 0, 28, 4), shadowPaint);
      canvas.drawRect(Rect.fromLTWH(3, -2, 23, 3), bladePaint);
      canvas.drawRect(Rect.fromLTWH(0, -4, 5, 8), bladePaint);
      canvas.restore();
    }
    _paintStandardWeather(canvas, size, Paint()..color = color);
  }

  void _paintBattle(Canvas canvas, Size size) {
    final fighterPaint = Paint()..color = color;
    final highlightPaint = Paint()
      ..color = Color.lerp(color, Colors.white, 0.45)!;
    final leftX = size.width * (0.25 + progress * 0.08);
    final rightX = size.width * (0.75 - progress * 0.08);
    _paintFighter(
      canvas,
      leftX,
      size.height * 0.55,
      fighterPaint,
      highlightPaint,
      false,
    );
    _paintFighter(
      canvas,
      rightX,
      size.height * 0.55,
      fighterPaint,
      highlightPaint,
      true,
    );
    final sparkPaint = Paint()..color = Colors.white;
    final pulse = (progress * 2).clamp(0.0, 1.0);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.47, size.height * 0.42, 5 + pulse * 8, 4),
      sparkPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.5, size.height * 0.35, 4, 12),
      sparkPaint,
    );
    _paintStandardWeather(
      canvas,
      size,
      Paint()..color = color.withValues(alpha: 0.65),
    );
  }

  void _paintFighter(
    Canvas canvas,
    double x,
    double y,
    Paint paint,
    Paint highlight,
    bool mirrored,
  ) {
    final direction = mirrored ? -1 : 1;
    canvas.drawRect(Rect.fromLTWH(x - 6, y - 30, 12, 12), paint);
    canvas.drawRect(Rect.fromLTWH(x - 5, y - 18, 10, 22), paint);
    canvas.drawRect(
      Rect.fromLTWH(x - 13.0 * direction, y - 17, 14, 5),
      highlight,
    );
    canvas.drawRect(Rect.fromLTWH(x + 2.0 * direction, y + 4, 5, 22), paint);
    canvas.drawRect(Rect.fromLTWH(x - 7.0 * direction, y + 4, 5, 22), paint);
  }

  void _paintDigital(Canvas canvas, Size size) {
    final barPaint = Paint()..color = color;
    for (var index = 0; index < 7; index++) {
      final height =
          size.height * (0.18 + ((index * 17 + progress * 35) % 45) / 100);
      canvas.drawRect(
        Rect.fromLTWH(12 + index * 19, size.height - height, 10, height),
        barPaint,
      );
    }
    _paintStandardWeather(canvas, size, Paint()..color = color);
  }

  void _paintAdventure(Canvas canvas, Size size) {
    final sparklePaint = Paint()..color = color;
    for (var index = 0; index < 6; index++) {
      final x = 12 + ((index * 31 + progress * 20) % 120);
      final y = 14.0 + ((index * 23) % 95);
      canvas.drawRect(Rect.fromLTWH(x, y, 5.0, 5.0), sparklePaint);
    }
    _paintStandardWeather(canvas, size, Paint()..color = color);
  }

  void _paintPixelWeather(Canvas canvas, Size size, Paint paint) {
    final pattern = _patterns[condition]!;
    final pixelSize = size.shortestSide / 15;
    final left = (size.width - pixelSize * 12) / 2;
    final top = (size.height - pixelSize * 12) / 2;
    final pixelPaint = paint;
    final highlightPaint = Paint()
      ..color = Color.lerp(color, Colors.white, 0.35)!;
    final shadowPaint = Paint()..color = color.withValues(alpha: 0.25);
    final useShadow = launcherId != 'digital';

    for (var row = 0; row < pattern.length; row++) {
      for (var column = 0; column < pattern[row].length; column++) {
        final pixel = pattern[row][column];
        if (pixel == ' ') continue;
        final rect = Rect.fromLTWH(
          left + column * pixelSize,
          top + row * pixelSize,
          pixelSize,
          pixelSize,
        );
        if (useShadow)
          canvas.drawRect(
            rect.translate(pixelSize * 0.12, pixelSize * 0.12),
            shadowPaint,
          );
        canvas.drawRect(rect, pixel == 'H' ? highlightPaint : pixelPaint);
      }
    }

    final detailPaint = Paint()..color = color;
    if (launcherId == 'ninja') {
      canvas.drawRect(
        Rect.fromLTWH(
          left + pixelSize * 10,
          top + pixelSize * 5,
          pixelSize * 2,
          pixelSize,
        ),
        detailPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          left + pixelSize * 9,
          top + pixelSize * 6,
          pixelSize * 3,
          pixelSize,
        ),
        detailPaint,
      );
    } else if (launcherId == 'battle') {
      canvas.drawRect(
        Rect.fromLTWH(
          left + pixelSize * 10,
          top + pixelSize * 1,
          pixelSize,
          pixelSize * 3,
        ),
        detailPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          left + pixelSize * 9,
          top + pixelSize * 3,
          pixelSize * 2,
          pixelSize,
        ),
        detailPaint,
      );
    } else if (launcherId == 'digital') {
      canvas.drawRect(
        Rect.fromLTWH(left, top + pixelSize * 11, pixelSize * 3, pixelSize / 2),
        detailPaint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          left + pixelSize * 9,
          top + pixelSize * 11,
          pixelSize * 3,
          pixelSize / 2,
        ),
        detailPaint,
      );
    }
  }

  void _paintStandardWeather(Canvas canvas, Size size, Paint paint) {
    final center = Offset(size.width / 2, size.height / 2 - 8);
    if (condition == WeatherCondition.sunny) {
      canvas.drawCircle(center, 24, paint);
      for (var index = 0; index < 8; index++) {
        final angle = index * 3.14159 / 4;
        final start = center + Offset(cos(angle) * 32, sin(angle) * 32);
        final end = center + Offset(cos(angle) * 43, sin(angle) * 43);
        canvas.drawLine(start, end, paint..strokeWidth = 5);
      }
    } else {
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(-12, 4),
          width: 58,
          height: 30,
        ),
        paint,
      );
      canvas.drawCircle(center.translate(-22, -4), 15, paint);
      canvas.drawCircle(center.translate(2, -10), 20, paint);
      if (condition == WeatherCondition.rain) {
        for (var index = -2; index <= 2; index++) {
          canvas.drawLine(
            Offset(center.dx + index * 15, center.dy + 24),
            Offset(center.dx + index * 15 - 5, center.dy + 39),
            paint..strokeWidth = 4,
          );
        }
      } else if (condition == WeatherCondition.snow) {
        for (var index = -1; index <= 1; index++) {
          final flake = Offset(center.dx + index * 20, center.dy + 36);
          canvas.drawLine(
            flake.translate(-6, 0),
            flake.translate(6, 0),
            paint..strokeWidth = 3,
          );
          canvas.drawLine(
            flake.translate(0, -6),
            flake.translate(0, 6),
            paint..strokeWidth = 3,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(PixelWeatherPainter oldDelegate) =>
      oldDelegate.condition != condition ||
      oldDelegate.launcherId != launcherId ||
      oldDelegate.color != color;
}

class _CityPicker extends StatefulWidget {
  const _CityPicker({
    required this.copy,
    required this.repository,
    required this.favorites,
    required this.onSelected,
  });

  final AppCopy copy;
  final CityRepository repository;
  final Set<String> favorites;
  final ValueChanged<City> onSelected;

  @override
  State<_CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<_CityPicker> {
  final TextEditingController _controller = TextEditingController();
  Future<List<City>>? _results;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String value) {
    final results = widget.repository.search(value);
    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            onChanged: _search,
            decoration: InputDecoration(
              labelText: widget.copy.searchCity,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 12),
          if (_results == null) Text(widget.copy.favorites),
          if (_results != null)
            FutureBuilder<List<City>>(
              future: _results,
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(widget.copy.unavailable),
                  );
                if (!snapshot.hasData)
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                final cities = snapshot.data!;
                if (cities.isEmpty)
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(widget.copy.noResults),
                  );
                return Column(
                  children: cities
                      .map(
                        (city) => ListTile(
                          leading: Icon(
                            widget.favorites.contains(city.id)
                                ? Icons.star
                                : Icons.location_on,
                          ),
                          title: Text(city.name),
                          subtitle: Text(city.country),
                          onTap: () => widget.onSelected(city),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
