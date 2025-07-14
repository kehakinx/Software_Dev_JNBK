import 'package:closetinventory/controllers/firebase/database_service.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditItemPage extends StatefulWidget {
  final Item closetItem;

  const EditItemPage({
    super.key,
    required this.closetItem,
    });

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final FirebaseDataServices _dataServices = FirebaseDataServices();
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

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing item data
    _itemNameController.text = widget.closetItem.name;
    _brandController.text = widget.closetItem.brand;
    _colorController.text = widget.closetItem.color ?? '';
    _sizeController.text = widget.closetItem.size ?? '';
    _materialController.text = widget.closetItem.material ?? '';
    _purchaseDateController.text = widget.closetItem.purchaseDate!.toDate().toString();
    _priceController.text = widget.closetItem.price?.toString() ?? '';
    _selectedCategory = widget.closetItem.type;
    _wearCountController.text = widget.closetItem.wearCount.toString();
    if(widget.closetItem.lastWornDate != null){
      _selectedLastWornDate = widget.closetItem.lastWornDate!.toDate();
      _lastWornDateController.text = DateFormat('MM/dd/yyyy').format(widget.closetItem.lastWornDate!.toDate());
    }
    _blnMarkForDonation = widget.closetItem.isPlannedForDonation;
    if(widget.closetItem.isPlannedForDonation){
      _isMarkForDonationController.text = 'True';
    }
    else{
      _isMarkForDonationController.text = 'False';
    }
    if(widget.closetItem.purchaseDate != null ){
      _selectedDate = widget.closetItem.purchaseDate!.toDate();
      _purchaseDateController.text = DateFormat('MM/dd/yyyy').format(widget.closetItem.purchaseDate!.toDate()) ;
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _brandController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    _materialController.dispose();
    _purchaseDateController.dispose();
    _priceController.dispose();
    _wearCountController.dispose();
    _lastWornDateController.dispose();
    _isMarkForDonationController.dispose();
    super.dispose();
  }

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
      Item newItem = Item(itemId: widget.closetItem.itemId, 
          userId: widget.closetItem.userId, 
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
      _dataServices.updateItem(newItem);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated!')),
      );
      context.goNamed(CONSTANTS.homePage);
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