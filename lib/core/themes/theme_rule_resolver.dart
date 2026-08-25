import '../../weather/models/weather.dart';
import 'theme_models.dart';

ThemeWeatherRule? resolveThemeRule(CustomTheme theme, CurrentWeather weather) {
  final matches = theme.rules.where((rule) => rule.matches(weather)).toList();
  if (matches.isEmpty) return null;
  matches.sort((first, second) {
    final priority = second.priority.compareTo(first.priority);
    if (priority != 0) return priority;
    return second.minTemperature.compareTo(first.minTemperature);
  });
  return matches.first;
}
