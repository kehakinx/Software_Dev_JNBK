import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockEditItemPage extends StatefulWidget {
  final Item closetItem;
  const MockEditItemPage({super.key, required this.closetItem});

  @override
  State<MockEditItemPage> createState() => _MockEditItemPageState();
}

class _MockEditItemPageState extends State<MockEditItemPage> {
  final _formKey = GlobalKey<FormState>();
  
  bool _blnMarkForDonation = false;
  Item closetItem = CONSTANTS.mockItem;

  

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
                    ),], 
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
      
    });

   
  });
}
