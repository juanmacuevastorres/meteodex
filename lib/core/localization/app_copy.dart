import '../../weather/models/weather.dart';

enum SupportedLanguage {
  castilianSpanish('es', 'Castellano'),
  neutralSpanish('es-419', 'Español neutro'),
  english('en', 'English'),
  japanese('ja', '日本語'),
  chinese('zh', '中文'),
  italian('it', 'Italiano'),
  portuguese('pt', 'Português');

  const SupportedLanguage(this.code, this.label);
  final String code;
  final String label;

  static SupportedLanguage fromCode(String? code) => values.firstWhere(
        (language) => language.code == code,
        orElse: () => SupportedLanguage.castilianSpanish,
      );
}

class AppCopy {
  const AppCopy(this.language);

  final SupportedLanguage language;
  String get languageCode => language.code;

  String get weatherTab => _text('weatherTab');
  String get settingsTab => _text('settingsTab');
  String get optionsTitle => _text('optionsTitle');
  String get title => _text('title');
  String get location => _text('location');
  String get condition => _text('condition');
  String get temperature => _text('temperature');
  String get settingsTitle => _text('settingsTitle');
  String get languageLabel => _text('language');
  String get chooseLanguage => _text('chooseLanguage');
  String get launcher => _text('launcher');
  String get favorites => _text('favorites');
  String get searchCity => _text('searchCity');
  String get noResults => _text('noResults');
  String get unavailable => _text('unavailable');
  String get temperatureUnit => _text('temperatureUnit');
  String get celsius => _text('celsius');
  String get fahrenheit => _text('fahrenheit');
  String get customThemes => _text('customThemes');
  String get importTheme => _text('importTheme');

  String weather(WeatherCondition condition) => _text(condition.name);

  String _text(String key) => _catalog[language.code]?[key] ?? _catalog['es']![key]!;

  static const _catalog = <String, Map<String, String>>{
    'es': {
      'weatherTab': 'TIEMPO', 'settingsTab': 'OPCIONES', 'optionsTitle': 'OPCIONES', 'title': 'METEODEX v1.0',
      'location': 'CIUDAD ACTUAL', 'condition': 'CONDICION', 'temperature': 'TEMPERATURA',
      'settingsTitle': 'AJUSTES', 'language': 'IDIOMA', 'chooseLanguage': 'Selecciona un idioma',
      'launcher': 'LANZADOR', 'favorites': 'FAVORITOS', 'searchCity': 'Buscar ciudad',
      'noResults': 'No se encontraron ciudades', 'unavailable': 'Datos no disponibles',
      'temperatureUnit': 'UNIDAD DE TEMPERATURA', 'celsius': 'Celsius', 'fahrenheit': 'Fahrenheit',
      'customThemes': 'TEMAS PROPIOS', 'importTheme': 'Importar tu tema',
      'sunny': 'SOLEADO', 'rain': 'LLUVIA', 'snow': 'NIEVE', 'cloudy': 'NUBLADO', 'thunderstorm': 'TORMENTA', 'unknown': 'DESCONOCIDO',
    },
    'es-419': {
      'weatherTab': 'TIEMPO', 'settingsTab': 'OPCIONES', 'optionsTitle': 'OPCIONES', 'title': 'METEODEX v1.0', 'location': 'CIUDAD ACTUAL',
      'condition': 'CONDICION', 'temperature': 'TEMPERATURA', 'settingsTitle': 'AJUSTES', 'language': 'IDIOMA',
      'chooseLanguage': 'Elige un idioma', 'launcher': 'LANZADOR', 'favorites': 'FAVORITOS', 'searchCity': 'Buscar ciudad',
      'noResults': 'No se encontraron ciudades', 'unavailable': 'Datos no disponibles', 'sunny': 'SOLEADO', 'thunderstorm': 'TORMENTA',
      'temperatureUnit': 'UNIDAD DE TEMPERATURA', 'celsius': 'Celsius', 'fahrenheit': 'Fahrenheit', 'customThemes': 'TEMAS PROPIOS', 'importTheme': 'Importar tu tema',
      'rain': 'LLUVIA', 'snow': 'NIEVE', 'cloudy': 'NUBLADO', 'unknown': 'DESCONOCIDO',
    },
    'en': {
      'weatherTab': 'WEATHER', 'settingsTab': 'OPTIONS', 'optionsTitle': 'OPTIONS', 'title': 'METEODEX v1.0', 'location': 'CURRENT CITY',
      'condition': 'CONDITION', 'temperature': 'TEMPERATURE', 'settingsTitle': 'SETTINGS', 'language': 'LANGUAGE',
      'chooseLanguage': 'Choose a language', 'launcher': 'LAUNCHER', 'favorites': 'FAVORITES', 'searchCity': 'Search city',
      'noResults': 'No cities found', 'unavailable': 'Data unavailable', 'sunny': 'SUNNY', 'thunderstorm': 'THUNDERSTORM', 'rain': 'RAIN',
      'temperatureUnit': 'TEMPERATURE UNIT', 'celsius': 'Celsius', 'fahrenheit': 'Fahrenheit', 'customThemes': 'CUSTOM THEMES', 'importTheme': 'Import your theme',
      'snow': 'SNOW', 'cloudy': 'CLOUDY', 'unknown': 'UNKNOWN',
    },
    'ja': {'weatherTab': 'てんき', 'settingsTab': 'せってい', 'title': 'メテオデックス', 'location': 'げんざいち', 'condition': 'じょうたい', 'temperature': 'おんど', 'settingsTitle': 'せってい', 'language': 'げんご', 'chooseLanguage': 'げんごをえらぶ', 'launcher': 'ランチャー', 'favorites': 'お気に入り', 'searchCity': '都市を検索', 'noResults': '都市が見つかりません', 'unavailable': 'データなし', 'sunny': 'はれ', 'rain': 'あめ', 'snow': 'ゆき', 'cloudy': 'くもり', 'unknown': 'ふめい'},
    'zh': {'weatherTab': '天气', 'settingsTab': '设置', 'title': '天气图鉴', 'location': '当前城市', 'condition': '天气状况', 'temperature': '温度', 'settingsTitle': '设置', 'language': '语言', 'chooseLanguage': '选择语言', 'launcher': '启动器', 'favorites': '收藏城市', 'searchCity': '搜索城市', 'noResults': '未找到城市', 'unavailable': '暂无数据', 'sunny': '晴天', 'rain': '下雨', 'snow': '下雪', 'cloudy': '多云', 'unknown': '未知'},
    'it': {'weatherTab': 'METEO', 'settingsTab': 'IMPOSTAZIONI', 'title': 'METEODEX', 'location': 'CITTA ATTUALE', 'condition': 'CONDIZIONE', 'temperature': 'TEMPERATURA', 'settingsTitle': 'IMPOSTAZIONI', 'language': 'LINGUA', 'chooseLanguage': 'Scegli una lingua', 'launcher': 'LAUNCHER', 'favorites': 'PREFERITI', 'searchCity': 'Cerca citta', 'noResults': 'Nessuna citta trovata', 'unavailable': 'Dati non disponibili', 'sunny': 'SERENO', 'rain': 'PIOGGIA', 'snow': 'NEVE', 'cloudy': 'NUVOLOSO', 'unknown': 'SCONOSCIUTO'},
    'pt': {'weatherTab': 'TEMPO', 'settingsTab': 'DEFINICOES', 'title': 'METEODEX', 'location': 'CIDADE ATUAL', 'condition': 'CONDICAO', 'temperature': 'TEMPERATURA', 'settingsTitle': 'DEFINICOES', 'language': 'IDIOMA', 'chooseLanguage': 'Escolha um idioma', 'launcher': 'LAUNCHER', 'favorites': 'FAVORITOS', 'searchCity': 'Buscar cidade', 'noResults': 'Nenhuma cidade encontrada', 'unavailable': 'Dados indisponiveis', 'sunny': 'ENSOLARADO', 'rain': 'CHUVA', 'snow': 'NEVE', 'cloudy': 'NUBLADO', 'unknown': 'DESCONHECIDO'},
  };
}
