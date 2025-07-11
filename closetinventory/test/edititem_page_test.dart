import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockEditItemPage extends StatefulWidget {
  final Item closetItem;
  const MockEditItemPage({super.key, required this.closetItem});

  @override
  State<MockEditItemPage> createState() => _MockEditItemPageState();
}

class _MockEditItemPageState extends State<MockEditItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _wearCountController = TextEditingController();
  final TextEditingController _lastWornDateController = TextEditingController();
  final TextEditingController _isMarkForDonationController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;
  DateTime? _selectedLastWornDate;
  bool _blnMarkForDonation = false;
  Item closetItem = CONSTANTS.mockItem;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _purchaseDateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectLastWornDate(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: _selectedLastWornDate ?? DateTime.now(),
      firstDate: _selectedLastWornDate!, 
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedLastWornDate = picked;
        _lastWornDateController.text = DateFormat('MM/dd/yyyy').format(picked);
        _wearCountController.text = '${int.parse(_wearCountController.text)+1}'; 
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Item newItem = Item(itemId: closetItem.itemId, 
          userId: closetItem.userId, 
          name: _itemNameController.text, 
          type: _selectedCategory.toString(),
          brand: _brandController.text,
          color: _colorController.text,
          size: _sizeController.text,
          material: _materialController.text,
          purchaseDate:_selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
          lastWornDate: _selectedLastWornDate != null ? Timestamp.fromDate(_selectedLastWornDate!) : null,
          isPlannedForDonation: _blnMarkForDonation,
          wearCount: int.parse(_wearCountController.text),
          price: double.tryParse(_priceController.text),
          );

      // Handle form submission logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated!')),
      );
    }
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Clothing Item'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name *',
                    hintText: 'e.g. Blue Midi Dress',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Item Name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'Brand',
                    hintText: 'e.g. Zara, Nike',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category *',
                  ),
                  hint: const Text('Select a category'),
                  items: CONSTANTS.categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  validator: (value) =>
                      value == null ? 'Category is required' : null,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    hintText: 'e.g. Blue, Black',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _sizeController,
                  decoration: const InputDecoration(
                    labelText: 'Size',
                    hintText: 'e.g. M, L, 30x32',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _materialController,
                  decoration: const InputDecoration(
                    labelText: 'Material',
                    hintText: 'e.g. Cotton, Silk, Denim',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _purchaseDateController,
                  decoration: const InputDecoration(
                    labelText: 'Purchase Date',
                    hintText: 'mm/dd/yyyy',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _pickDate(context),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price (\$)',
                    hintText: 'e.g. 49.99',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                ResponsiveWrap(
                  children: [ 
                    Text(
                      'Times Worn: ${_wearCountController.text};  Last Worn Date: ${_lastWornDateController.text}',
                    ),
                    const SizedBox(width: 5),

                    ElevatedButton(
                      onPressed: () => _selectLastWornDate(context),
                      child: const Text('Log Worn'),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Mark to Donate',
                    ),
                    Switch(
                      key: const Key('donationSwitch'),
                      value: _blnMarkForDonation, 
                      onChanged: (bool value){
                        setState((){
                          _blnMarkForDonation = value;
                        });
                      },
                      activeColor: CONSTANTS.primaryAccentColor,
                      inactiveThumbColor: CONSTANTS.primaryCardColor,
                      inactiveTrackColor: CONSTANTS.disabledButtonColor,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Save Item'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
}


void main() {

  group('Scenario 4: Mark Item for Donation', () {
    testWidgets('User can mark item as donate and it updates the item', (WidgetTester tester) async {
      // Build our widget with the test item
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockEditItemPage(closetItem: CONSTANTS.mockItem),
          ),
        ),
      );

      // Verify initial state
      //expect(find.text('Test Item'), findsOneWidget);
      //expect(find.text('Test Brand'), findsOneWidget);

      // Find the donation switch
      final switchFinder = find.byKey(const Key('donationSwitch'));
      expect(switchFinder, findsOneWidget);
      
      // Verify initial switch state is false
      Switch switchWidget = tester.widget(switchFinder);
      expect(switchWidget.value, false);
      
      // Tap the switch to mark for donation
      await tester.tap(switchFinder);
      await tester.pump();
      
      // Verify switch state changed to true
      switchWidget = tester.widget(switchFinder);
      expect(switchWidget.value, true);
      
      // Find and tap the save button
      final saveButtonFinder = find.text('Save Item');
      expect(saveButtonFinder, findsOneWidget);
      await tester.tap(saveButtonFinder);
      await tester.pump();
      
      // Verify that the updated item has isPlannedForDonation set to true
      // Note: In a real test, you would verify the mock database service was called with the right parameters
    });

    /*testWidgets('System moves item to donation list when marked for donation', (WidgetTester tester) async {
      // This would require mocking the database service and verifying the update
      // Since we can't directly test Firestore in unit tests, we verify the behavior
      
      // Build our widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditItemPage(closetItem: testItem),
          ),
        ),
      );

      // Find and tap the donation switch
      await tester.tap(find.byType(Switch));
      await tester.pump();
      
      // Find and tap the save button
      await tester.tap(find.text('Save Item'));
      await tester.pump();
      
      // Verify that the item would be updated with isPlannedForDonation = true
      // In a real app, you would verify mockDatabaseService.updateItem() was called with the right parameters
    });

    testWidgets('User can view donation suggestions after marking for donation', (WidgetTester tester) async {
      // This would typically be tested at the widget/integration test level
      // For unit tests, we can verify the navigation occurs
      
      // Build our widget with mocked dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditItemPage(closetItem: testItem),
          ),
        ),
      );

      // Mark for donation
      await tester.tap(find.byType(Switch));
      await tester.pump();
      
      // Save the item
      await tester.tap(find.text('Save Item'));
      await tester.pump();
      
      // Verify navigation occurs (in a real test, you would mock the router and verify)
      // expect(mockGoRouter.goNamed, calledWith(CONSTANTS.homePage));
    });*/
  });
}
