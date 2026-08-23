import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MeteoDexApp());
}

// Paleta retro de 4 colores (Estilo Game Boy original)
class RetroColors {
  static const Color dark = Color(0xFF0F380F);       // Negro verdoso / Texto y bordes
  static const Color mediumDark = Color(0xFF306230); // Tono secundario / Sombras
  static const Color light = Color(0xFF8BAC0F);      // Verde claro / Acentos
  static const Color lightest = Color(0xFF9BBC0F);   // Fondo de pantalla retro
}

// 4 estados climáticos disponibles
enum WeatherState { sunny, rain, snow, cloudy }

class AppCopy {
  AppCopy(this.languageCode);

  final String languageCode;

  static AppCopy fromCode(String code) => AppCopy(
        {'es', 'en', 'zh', 'ja'}.contains(code) ? code : 'es',
      );

  static const _values = {
    'es': {
      'weatherTab': 'ACCEDER AL TIEMPO',
      'settingsTab': 'AJUSTES',
      'title': 'METEODEX v1.0',
      'location': 'PUEBLO PALETA',
      'condition': 'CONDICIÓN',
      'temperature': 'TEMPERATURA',
      'settingsTitle': 'AJUSTES',
      'language': 'IDIOMA',
      'chooseLanguage': 'Selecciona un idioma',
    },
    'en': {
      'weatherTab': 'WEATHER',
      'settingsTab': 'SETTINGS',
      'title': 'METEODEX v1.0',
      'location': 'PALLET TOWN',
      'condition': 'CONDITION',
      'temperature': 'TEMPERATURE',
      'settingsTitle': 'SETTINGS',
      'language': 'LANGUAGE',
      'chooseLanguage': 'Choose a language',
    },
    'zh': {
      'weatherTab': '天气',
      'settingsTab': '设置',
      'title': '天气图鉴 v1.0',
      'location': '真新镇',
      'condition': '天气状况',
      'temperature': '温度',
      'settingsTitle': '设置',
      'language': '语言',
      'chooseLanguage': '选择语言',
    },
    'ja': {
      'weatherTab': 'てんき',
      'settingsTab': 'せってい',
      'title': 'メテオデックス v1.0',
      'location': 'マサラタウン',
      'condition': 'じょうたい',
      'temperature': 'おんど',
      'settingsTitle': 'せってい',
      'language': 'げんご',
      'chooseLanguage': 'げんごをえらぶ',
    },
  };

  String get weatherTab => _values[languageCode]!['weatherTab']!;
  String get settingsTab => _values[languageCode]!['settingsTab']!;
  String get title => _values[languageCode]!['title']!;
  String get location => _values[languageCode]!['location']!;
  String get condition => _values[languageCode]!['condition']!;
  String get temperature => _values[languageCode]!['temperature']!;
  String get settingsTitle => _values[languageCode]!['settingsTitle']!;
  String get language => _values[languageCode]!['language']!;
  String get chooseLanguage => _values[languageCode]!['chooseLanguage']!;

  String weather(WeatherState state) {
    const labels = {
      'es': ['SOLEADO', 'LLUVIA', 'NIEVE', 'NUBLADO'],
      'en': ['SUNNY', 'RAIN', 'SNOW', 'CLOUDY'],
      'zh': ['晴天', '下雨', '下雪', '多云'],
      'ja': ['はれ', 'あめ', 'ゆき', 'くもり'],
    };
    return labels[languageCode]![state.index];
  }
}

class MeteoDexApp extends StatefulWidget {
  const MeteoDexApp({super.key});

  @override
  State<MeteoDexApp> createState() => _MeteoDexAppState();
}

class _MeteoDexAppState extends State<MeteoDexApp> {
  String _languageCode = 'es';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _languageCode = preferences.getString('language') ?? 'es';
    });
  }

  Future<void> _changeLanguage(String code) async {
    setState(() => _languageCode = code);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('language', code);
  }

  @override
  Widget build(BuildContext context) {
    final copy = AppCopy.fromCode(_languageCode);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: copy.title,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E), // Fondo exterior del dispositivo
        fontFamily: 'monospace',
      ),
      home: AppShell(copy: copy, onLanguageChanged: _changeLanguage),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({required this.copy, required this.onLanguageChanged, super.key});

  final AppCopy copy;
  final ValueChanged<String> onLanguageChanged;

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
            MeteoDexScreen(copy: copy),
            SettingsScreen(copy: copy, onLanguageChanged: onLanguageChanged),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.copy, required this.onLanguageChanged, super.key});

  final AppCopy copy;
  final ValueChanged<String> onLanguageChanged;

  static const languages = {
    'es': 'Castellano',
    'en': 'English',
    'zh': '中文',
    'ja': '日本語',
  };

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(copy.settingsTitle, style: const TextStyle(color: RetroColors.lightest, fontSize: 22)),
        const SizedBox(height: 24),
        Text(copy.chooseLanguage, style: const TextStyle(color: RetroColors.lightest, fontSize: 16)),
        const SizedBox(height: 12),
        ...languages.entries.map(
          (entry) => RadioListTile<String>(
            activeColor: RetroColors.light,
            title: Text(entry.value, style: const TextStyle(color: RetroColors.lightest)),
            value: entry.key,
            groupValue: copy.languageCode,
            onChanged: (value) {
              if (value != null) onLanguageChanged(value);
            },
          ),
        ),
      ],
    );
  }
}

class MeteoDexScreen extends StatefulWidget {
  const MeteoDexScreen({required this.copy, super.key});

  final AppCopy copy;

  @override
  State<MeteoDexScreen> createState() => _MeteoDexScreenState();
}

class _MeteoDexScreenState extends State<MeteoDexScreen> {
  WeatherState _currentState = WeatherState.sunny;
  final int _temperature = 28;

  // Mapeo de datos por estado
  String get _stateName => widget.copy.weather(_currentState);

  IconData get _weatherIcon {
    switch (_currentState) {
      case WeatherState.sunny:
        return Icons.wb_sunny_outlined;
      case WeatherState.rain:
        return Icons.water_drop_outlined;
      case WeatherState.snow:
        return Icons.ac_unit;
      case WeatherState.cloudy:
        return Icons.cloud_outlined;
    }
  }

  String get _creatureSprite {
    switch (_currentState) {
      case WeatherState.sunny:
        return "( ˘▽˘ )っ☀\n[SOLAREX]";
      case WeatherState.rain:
        return "( ◞‸◟ )☂\n[AQUAPOD]";
      case WeatherState.snow:
        return "(*ﾟｰﾟ*)❄\n[GLACIO]";
      case WeatherState.cloudy:
        return "(・_・)☁\n[NIMBUS]";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Carcasa / Pantalla retro principal
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 360),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: RetroColors.lightest,
                    border: Border.all(color: RetroColors.dark, width: 4),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(6, 6),
                        blurRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      // Cabecera: Título y Ubicación
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.copy.title,
                            style: TextStyle(
                              color: RetroColors.dark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            widget.copy.location,
                            style: const TextStyle(
                              color: RetroColors.mediumDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: RetroColors.dark, thickness: 2, height: 20),

                      // Sprite / Caja de la criatura
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: RetroColors.light,
                          border: Border.all(color: RetroColors.dark, width: 2),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_weatherIcon, size: 48, color: RetroColors.dark),
                            const SizedBox(height: 12),
                            Text(
                              _creatureSprite,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: RetroColors.dark,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Panel de métricas (Temperatura y Estado)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.copy.condition,
                                style: TextStyle(color: RetroColors.mediumDark, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _stateName,
                                style: const TextStyle(color: RetroColors.dark, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.copy.temperature,
                                style: TextStyle(color: RetroColors.mediumDark, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$_temperature°C',
                                style: const TextStyle(color: RetroColors.dark, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Selector de prueba de estados (Simulación)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: WeatherState.values.map((state) {
                    final isSelected = _currentState == state;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? RetroColors.light : RetroColors.dark,
                        foregroundColor: isSelected ? RetroColors.dark : RetroColors.lightest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                          side: const BorderSide(color: RetroColors.dark, width: 2),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentState = state;
                        });
                      },
                      child: Text(widget.copy.weather(state)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}