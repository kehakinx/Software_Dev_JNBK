// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:closetinventory/views/modules/dashcard_module.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:closetinventory/controllers/utilities/theme_provider.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Closet Dashboard loads and shows expected UI', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>(
        create: (context) => ThemeProvider(),
        child: const MaterialApp(
          home: DashCard(
            title: 'My Closet Dashboard',
            icon: Icons.checkroom,
            number: 0,
            color: Colors.blue,
            link: '/dashboard',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('My Closet Dashboard'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
  });
}
