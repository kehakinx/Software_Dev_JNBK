import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:closetinventory/controllers/utilities/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeProvider Tests', () {
    testWidgets('ThemeProvider can be created and used', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final themeProvider = Provider.of<ThemeProvider>(context);
                return Scaffold(
                  body: Column(
                    children: [
                      Text(
                        'Theme: ${themeProvider.isDarkTheme ? "Dark" : "Light"}',
                      ),
                      ElevatedButton(
                        onPressed: () => themeProvider.toggleTheme(),
                        child: const Text('Toggle Theme'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check that the theme provider is working
      expect(find.text('Theme: Light'), findsOneWidget);
      expect(find.text('Toggle Theme'), findsOneWidget);
    });

    testWidgets('ThemeProvider can toggle theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final themeProvider = Provider.of<ThemeProvider>(context);
                return Scaffold(
                  body: Column(
                    children: [
                      Text(
                        'Theme: ${themeProvider.isDarkTheme ? "Dark" : "Light"}',
                      ),
                      ElevatedButton(
                        onPressed: () => themeProvider.toggleTheme(),
                        child: const Text('Toggle Theme'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially should be light theme
      expect(find.text('Theme: Light'), findsOneWidget);

      // Tap the toggle button
      await tester.tap(find.text('Toggle Theme'));
      await tester.pumpAndSettle();

      // Should now be dark theme
      expect(find.text('Theme: Dark'), findsOneWidget);
    });
  });
}
