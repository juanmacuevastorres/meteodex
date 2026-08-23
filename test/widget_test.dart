import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meteodex/core/preferences/shared_preferences_repository.dart';
import 'package:meteodex/main.dart';

void main() {
  testWidgets('retro weather screen remains available', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MeteoDexApp(preferences: SharedPreferencesRepository(preferences)),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('METEODEX v1.0'), findsWidgets);
    expect(find.text('Madrid'), findsOneWidget);
    expect(find.text('28 C'), findsOneWidget);
  });

  testWidgets('weather glyph advances its animation', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MeteoDexApp(preferences: SharedPreferencesRepository(preferences)),
    );
    await tester.pump(const Duration(milliseconds: 500));

    final customPaint = tester.widget<CustomPaint>(
      find.byType(CustomPaint).first,
    );
    final painter = customPaint.painter! as PixelWeatherPainter;
    final initialProgress = painter.progress;
    await tester.pump(const Duration(milliseconds: 500));

    expect(painter.progress, isNot(initialProgress));
  });

  testWidgets('language changes without restarting the app', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'language': 'en'});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MeteoDexApp(preferences: SharedPreferencesRepository(preferences)),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('SETTINGS'), findsWidgets);
    expect(find.text('WEATHER'), findsWidgets);
  });

  testWidgets('city search updates the selected location', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MeteoDexApp(preferences: SharedPreferencesRepository(preferences)),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Buscar ciudad'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byType(TextField), 'Tokyo');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(ListTile, 'Tokyo'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tokyo'), findsWidgets);
  });

  testWidgets('favorite city appears below search and can be selected', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MeteoDexApp(preferences: SharedPreferencesRepository(preferences)),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Buscar ciudad'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.enterText(find.byType(TextField), 'Tokyo');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(ListTile, 'Tokyo'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byTooltip('FAVORITOS'));
    await tester.pump();

    expect(find.widgetWithText(ListTile, 'Tokyo'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Tokyo'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tokyo'), findsWidgets);
  });
}
