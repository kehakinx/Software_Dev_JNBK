import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:intl/intl.dart';

class AddNewItemPage extends StatefulWidget {
  const AddNewItemPage({super.key});

  @override
  State<AddNewItemPage> createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedCategory;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _itemNameController.dispose();
    _brandController.dispose();
    _colorController.dispose();
    _sizeController.dispose();
    _materialController.dispose();
    _purchaseDateController.dispose();
    _priceController.dispose();
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Clothing Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _itemNameController,
                decoration: InputDecoration(
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
              SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: 'Brand',
                  hintText: 'e.g. Zara, Nike',
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category *',
                ),
                hint: Text('Select a category'),
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
              SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: 'Color',
                  hintText: 'e.g. Blue, Black',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(
                  labelText: 'Size',
                  hintText: 'e.g. M, L, 30x32',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _materialController,
                decoration: InputDecoration(
                  labelText: 'Material',
                  hintText: 'e.g. Cotton, Silk, Denim',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _purchaseDateController,
                decoration: InputDecoration(
                  labelText: 'Purchase Date',
                  hintText: 'mm/dd/yyyy',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _pickDate(context),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price (\$)',
                  hintText: 'e.g. 49.99',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Add Item'),
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