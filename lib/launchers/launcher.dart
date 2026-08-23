import 'package:flutter/material.dart';

import '../weather/models/weather.dart';

abstract interface class WeatherLauncher {
  String get id;
  String get name;
  Color get backgroundColor;
  Color get foregroundColor;
  Widget buildWeather({required BuildContext context, required CurrentWeather weather});
}

class StyledLauncher implements WeatherLauncher {
  const StyledLauncher({required this.id, required this.name, required this.backgroundColor, required this.foregroundColor, required this.accentColor, required this.icon});

  @override
  final String id;
  @override
  final String name;
  @override
  final Color backgroundColor;
  @override
  final Color foregroundColor;
  final Color accentColor;
  final IconData icon;

  @override
  Widget buildWeather({required BuildContext context, required CurrentWeather weather}) => Text('${weather.city}\n${weather.temperatureCelsius} C', textAlign: TextAlign.center);
}

class LauncherCatalog {
  static const WeatherLauncher retro = StyledLauncher(id: 'retro', name: 'Retro', backgroundColor: Color(0xFF9BBC0F), foregroundColor: Color(0xFF0F380F), accentColor: Color(0xFF306230), icon: Icons.grid_4x4);
  static const WeatherLauncher adventure = StyledLauncher(id: 'adventure', name: 'Adventure', backgroundColor: Color(0xFFF4D35E), foregroundColor: Color(0xFF172A3A), accentColor: Color(0xFFEE6C4D), icon: Icons.explore);
  static const WeatherLauncher battle = StyledLauncher(id: 'battle', name: 'Battle', backgroundColor: Color(0xFF2B2D42), foregroundColor: Color(0xFFFFD166), accentColor: Color(0xFFEF476F), icon: Icons.flash_on);
  static const WeatherLauncher ninja = StyledLauncher(id: 'ninja', name: 'Ninja', backgroundColor: Color(0xFF202A44), foregroundColor: Color(0xFFF7F7F2), accentColor: Color(0xFFE63946), icon: Icons.visibility_off);
  static const WeatherLauncher digital = StyledLauncher(id: 'digital', name: 'Digital', backgroundColor: Color(0xFFE8E9EB), foregroundColor: Color(0xFF202124), accentColor: Color(0xFFFF6B35), icon: Icons.calculate);
  static const List<WeatherLauncher> available = [retro, adventure, battle, ninja, digital];

  static WeatherLauncher byId(String? id) => available.firstWhere((launcher) => launcher.id == id, orElse: () => retro);
}
