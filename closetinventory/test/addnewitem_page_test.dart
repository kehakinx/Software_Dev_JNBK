import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAddNewItemPage extends StatefulWidget {
  const MockAddNewItemPage({super.key});

  @override
  State<MockAddNewItemPage> createState() => _MockAddNewItemPageState();
}

class _MockAddNewItemPageState extends State<MockAddNewItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _colorController = TextEditingController();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Clothing Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(labelText: 'Item Name *'),
                validator: (value) => value?.isEmpty == true ? 'Item Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Color'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category *'),
                items: ['Tops', 'Bottoms', 'Outerwear', 'Dresses']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                validator: (value) => value == null ? 'Category is required' : null,
                onChanged: (value) => setState(() => _selectedCategory = value),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item added!')),
                    );
                  }
                },
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  group('Test Scenario 1: Add New Clothing Item', () {
    
    setUp(() async {
      SharedPreferences.setMockInitialValues({'prefUserKey': 'test_user'});
    });

    testWidgets('user opens app and selects add item', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MockAddNewItemPage()));

      expect(find.text('Add New Clothing Item'), findsOneWidget);
    });

    testWidgets('user enters item details', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MockAddNewItemPage()));

      await tester.enterText(find.byType(TextFormField).first, 'Blue Winter Jacket');
      await tester.enterText(find.byType(TextFormField).at(1), 'Navy Blue');

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Outerwear').last);
      await tester.pumpAndSettle();

      expect(find.text('Blue Winter Jacket'), findsOneWidget);
      expect(find.text('Navy Blue'), findsOneWidget);
    });

    testWidgets('user saves the item', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MockAddNewItemPage()));

      await tester.enterText(find.byType(TextFormField).first, 'Test Item');
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tops').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Item'));
      await tester.pumpAndSettle();

      expect(find.text('Item added!'), findsOneWidget);
    });

    testWidgets('system shows validation errors', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MockAddNewItemPage()));

      await tester.tap(find.text('Add Item'));
      await tester.pump();

      expect(find.text('Item Name is required'), findsOneWidget);
      expect(find.text('Category is required'), findsOneWidget);
    });

  });
}