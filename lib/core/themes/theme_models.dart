import 'dart:convert';

import 'package:flutter/material.dart';

import '../../weather/models/weather.dart';

class CustomTheme {
  const CustomTheme({
    required this.version,
    required this.id,
    required this.name,
    required this.visual,
    required this.assets,
    required this.rules,
    this.fontFamily,
  });

  factory CustomTheme.fromJson(String source) =>
      CustomTheme.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory CustomTheme.fromMap(Map<String, dynamic> map) {
    final version = map['version'];
    final id = map['id'];
    final name = map['name'];
    if (version is! int || version < 1 || id is! String || id.isEmpty || name is! String || name.isEmpty) {
      throw const FormatException('Invalid theme identity');
    }
    final visualMap = map['visual'];
    final assetsMap = map['assets'];
    final rulesValue = map['weatherRules'];
    if (visualMap is! Map<String, dynamic> || assetsMap is! Map<String, dynamic> || rulesValue is! List<dynamic>) {
      throw const FormatException('Theme sections are required');
    }
    final assets = <String, ThemeAsset>{};
    for (final entry in assetsMap.entries) {
      assets[entry.key] = ThemeAsset.fromMap(entry.value, entry.key);
    }
    final rules = rulesValue
        .map((value) => ThemeWeatherRule.fromMap(value as Map<String, dynamic>, assets))
        .toList(growable: false);
    _validateRuleOverlaps(rules);
    return CustomTheme(
      version: version,
      id: id,
      name: name,
      visual: ThemeVisual.fromMap(visualMap),
      assets: Map.unmodifiable(assets),
      rules: rules,
      fontFamily: map['fontFamily'] as String?,
    );
  }

  final int version;
  final String id;
  final String name;
  final ThemeVisual visual;
  final Map<String, ThemeAsset> assets;
  final List<ThemeWeatherRule> rules;
  final String? fontFamily;

  static void _validateRuleOverlaps(List<ThemeWeatherRule> rules) {
    for (var index = 0; index < rules.length; index++) {
      for (var otherIndex = index + 1; otherIndex < rules.length; otherIndex++) {
        final first = rules[index];
        final second = rules[otherIndex];
        if (first.condition != second.condition || first.priority != second.priority) continue;
        final firstMax = first.maxTemperature ?? double.infinity;
        final secondMax = second.maxTemperature ?? double.infinity;
        if (first.minTemperature <= secondMax && second.minTemperature <= firstMax) {
          throw const FormatException('Ambiguous weather rules');
        }
      }
    }
  }
}

class ThemeVisual {
  const ThemeVisual({
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.accentColor,
    this.iconAsset,
  });

  factory ThemeVisual.fromMap(Map<String, dynamic> map) => ThemeVisual(
        backgroundColor: _parseColor(map['backgroundColor']),
        surfaceColor: _parseColor(map['surfaceColor']),
        textColor: _parseColor(map['textColor']),
        accentColor: _parseColor(map['accentColor']),
        iconAsset: map['iconAsset'] as String?,
      );

  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Color accentColor;
  final String? iconAsset;
}

class ThemeAsset {
  const ThemeAsset({required this.path, required this.type});

  factory ThemeAsset.fromMap(dynamic value, String id) {
    if (value is! Map<String, dynamic> || value['path'] is! String || value['type'] is! String) {
      throw FormatException('Invalid asset: $id');
    }
    final path = value['path'] as String;
    final type = value['type'] as String;
    if (path.startsWith('/') || path.contains('..') || path.contains('://')) {
      throw FormatException('Invalid asset path: $id');
    }
    if (!const {'png', 'jpg', 'jpeg', 'webp', 'gif', 'ttf', 'otf'}.contains(type)) {
      throw FormatException('Unsupported asset type: $id');
    }
    return ThemeAsset(path: path, type: type);
  }

  final String path;
  final String type;
}

class ThemeWeatherRule {
  const ThemeWeatherRule({
    required this.condition,
    required this.assetId,
    this.minTemperature = double.negativeInfinity,
    this.maxTemperature,
    this.label,
    this.priority = 0,
  });

  factory ThemeWeatherRule.fromMap(Map<String, dynamic> map, Map<String, ThemeAsset> assets) {
    final conditionName = map['condition'];
    final assetId = map['asset'];
    if (conditionName is! String || assetId is! String || !assets.containsKey(assetId)) {
      throw const FormatException('Invalid weather rule');
    }
    final condition = WeatherCondition.values.firstWhere(
      (value) => value.name == conditionName,
      orElse: () => throw const FormatException('Unsupported weather condition'),
    );
    final minTemperature = (map['minTemperature'] as num?)?.toDouble();
    final maxTemperature = (map['maxTemperature'] as num?)?.toDouble();
    if (minTemperature != null && maxTemperature != null && minTemperature > maxTemperature) {
      throw const FormatException('Invalid temperature range');
    }
    return ThemeWeatherRule(
      condition: condition,
      assetId: assetId,
      minTemperature: minTemperature ?? double.negativeInfinity,
      maxTemperature: maxTemperature,
      label: map['label'] as String?,
      priority: (map['priority'] as num?)?.toInt() ?? 0,
    );
  }

  final WeatherCondition condition;
  final String assetId;
  final double minTemperature;
  final double? maxTemperature;
  final String? label;
  final int priority;

  bool matches(CurrentWeather weather) =>
      condition == weather.condition &&
      weather.temperatureCelsius >= minTemperature &&
      (maxTemperature == null || weather.temperatureCelsius <= maxTemperature!);
}

Color _parseColor(dynamic value) {
  if (value is! String || !RegExp(r'^#[0-9a-fA-F]{6,8}$').hasMatch(value)) {
    throw const FormatException('Invalid theme color');
  }
  final hex = value.substring(1);
  final normalized = hex.length == 6 ? 'FF$hex' : hex;
  return Color(int.parse(normalized, radix: 16));
}