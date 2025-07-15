import 'package:closetinventory/controllers/firebase/database_service.dart';
import 'package:closetinventory/controllers/firebase/storage_service.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddNewItemPage extends StatefulWidget {
  const AddNewItemPage({super.key});

  @override
  State<AddNewItemPage> createState() => _AddNewItemPageState();
}

class _AddNewItemPageState extends State<AddNewItemPage> {
  final FirebaseDataServices _dataServices = FirebaseDataServices();
  final FirebaseStorageService _storageService = FirebaseStorageService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  late final String _userId;
  String? _selectedCategory;
  DateTime? _selectedDate;
  XFile? _selectedImage;
  bool _isLoading = false;

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

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final userKey = MyPreferences.getString('prefUserKey');
    setState(() {
      _userId = userKey;
    });
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

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (photo != null) {
        setState(() {
          _selectedImage = photo;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo taken!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo selected!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_isLoading) return;
      
      setState(() {
        _isLoading = true;
      });

      try {
        List<String> photoUrls = [];
        
        if (_selectedImage != null) {
          final itemId = DateTime.now().millisecondsSinceEpoch.toString();
          
          final String? uploadedUrl = await _storageService.uploadItemPhoto(
            _selectedImage!, 
            _userId, 
            itemId
          );
          
          if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
            if (uploadedUrl.startsWith('https://firebasestorage.googleapis.com')) {
              photoUrls.add(uploadedUrl);
            }
          }
        }

        Item newItem = Item(
          itemId: '', 
          userId: _userId, 
          name: _itemNameController.text.trim(), 
          type: _selectedCategory ?? 'Other',
          brand: _brandController.text.trim().isNotEmpty ? _brandController.text.trim() : '',
          color: _colorController.text.trim().isNotEmpty ? _colorController.text.trim() : '',
          size: _sizeController.text.trim().isNotEmpty ? _sizeController.text.trim() : '',
          material: _materialController.text.trim().isNotEmpty ? _materialController.text.trim() : '',
          purchaseDate: _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
          price: _priceController.text.trim().isNotEmpty ? double.tryParse(_priceController.text.trim()) : null,
          photoUrls: photoUrls.isNotEmpty ? photoUrls : null,
          wearCount: 0,
          isPlannedForDonation: false,
        );
        
        await _dataServices.createItem(newItem);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(photoUrls.isNotEmpty 
                ? 'Item added with photo!' 
                : 'Item added successfully!'
              ),
              backgroundColor: Colors.green,
            ),
          );
          context.goNamed(CONSTANTS.homePage);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Clothing Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _itemNameController,
                enabled: !_isLoading,
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
                enabled: !_isLoading,
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
                onChanged: _isLoading ? null : (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'e.g. Blue, Black',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sizeController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Size',
                  hintText: 'e.g. M, L, 30x32',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _materialController,
                enabled: !_isLoading,
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
                onTap: _isLoading ? null : () => _pickDate(context),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: 'Price (\$)',
                  hintText: 'e.g. 49.99',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),
              
              const Text('Item Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: _selectedImage != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.photo, size: 50, color: Colors.green),
                          const SizedBox(height: 8),
                          const Text('Photo Ready!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          Text(_selectedImage!.name, style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _isLoading ? null : () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            icon: const Icon(Icons.clear, size: 16),
                            label: const Text('Remove'),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Add item photo (optional)', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _takePhoto,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _pickFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('From Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Add Item'),
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