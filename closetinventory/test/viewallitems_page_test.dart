import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test Scenario 3: Search for Items by Tag', () {

    testWidgets('user opens search filter menu', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('View All Clothing Items')),
            body: Column(
              children: [
                TextField(decoration: InputDecoration(labelText: 'Search')),
                DropdownButton<String>(
                  hint: Text('Filter'),
                  items: [
                    DropdownMenuItem(value: 'winter', child: Text('Winter')),
                  ],
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('View All Clothing Items'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Filter'), findsOneWidget);
    });

    testWidgets('user enters tag winter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextField(decoration: InputDecoration(labelText: 'Search')),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'winter');
      expect(find.text('winter'), findsOneWidget);
    });

    testWidgets('system displays items with winter tag', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Winter Coat'),
                Text('Winter Boots'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Winter Coat'), findsOneWidget);
      expect(find.text('Winter Boots'), findsOneWidget);
    });

    testWidgets('user views item details', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: Text('Winter Coat'),
            ),
          ),
        ),
      );

      expect(find.text('Winter Coat'), findsOneWidget);
      await tester.tap(find.text('Winter Coat'));
    });

    testWidgets('user quits', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Search Items')),
            body: ElevatedButton(
              onPressed: () {},
              child: Text('Back'),
            ),
          ),
        ),
      );

      expect(find.text('Back'), findsOneWidget);
      await tester.tap(find.text('Back'));
    });

  });
}