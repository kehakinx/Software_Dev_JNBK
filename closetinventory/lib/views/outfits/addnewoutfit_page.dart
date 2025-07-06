import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/controllers/firebase/database_service.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/user_dataobj.dart';
import 'package:closetinventory/models/outfit_dataobj.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class AddNewOutfitPage extends StatefulWidget {
  const AddNewOutfitPage({super.key});

  @override
  State<AddNewOutfitPage> createState() => _AddNewOutfitPageState();
}

class _AddNewOutfitPageState extends State<AddNewOutfitPage> {
  final _outfitNameController = TextEditingController();
  final _stylingNotesController = TextEditingController();
  final _searchController = TextEditingController();
  final FirebaseDataServices _dataServices = FirebaseDataServices();
  
  List<Item> _allItems = [];
  List<Item> _filteredItems = [];
  List<Item> _selectedItems = [];
  USER? _user;
  bool _isLoading = false;
  
  String _selectedCategory = 'All Categories';
  String _selectedColor = 'All Colors';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    String userId = MyPreferences.getString('prefUserKey');
    _user = CONSTANTS.mockUsers.firstWhere((user) => user.userId == userId);
    _allItems = CONSTANTS.mockClosetItems.where((item) => item.userId == userId).toList();
    _filteredItems = List.from(_allItems);
  }

  void _applyFilters() {
    setState(() {
      _filteredItems = _allItems.where((item) {
        bool search = _searchController.text.isEmpty || 
            item.name.toLowerCase().contains(_searchController.text.toLowerCase());
        bool category = _selectedCategory == 'All Categories' || item.type == _selectedCategory;
        
        bool color = true;
        if (_selectedColor != 'All Colors') {
          if (item.color != null && item.color!.isNotEmpty) {
            color = item.color!.toLowerCase().contains(_selectedColor.toLowerCase());
          } else {
            color = false;
          }
        }
        
        return search && category && color;
      }).toList();
    });
  }

  void _toggleItem(Item item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  void _saveOutfit() async {
    if (_outfitNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter outfit name')),
      );
      return;
    }
    
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final outfit = Outfit(
        outfitId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _user!.userId,
        name: _outfitNameController.text.trim(),
        itemIds: _selectedItems.map((item) => item.itemId).toList(),
        stylingNotes: _stylingNotesController.text.trim().isEmpty ? null : _stylingNotesController.text.trim(),
      );

      // Save to Firebase
      await _dataServices.createOutfit(outfit);
      
      // Also add to mock data for immediate UI update
      CONSTANTS.mockOutfits.add(outfit);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Outfit saved to Firebase!')),
      );
      
      context.goNamed(CONSTANTS.homePage);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving outfit: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = ['All Categories', ...CONSTANTS.categories];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Create New Outfit'),
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                text: 'Outfit Name ',
                style: TextStyle(fontSize: 14, color: Colors.black),
                children: [
                  TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _outfitNameController,
              decoration: const InputDecoration(
                hintText: "e.g., 'Work Chic', 'Weekend Casual'",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text('Styling Notes', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: _stylingNotesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "e.g., 'Pair with nude heels', 'Good for colder days'",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            
            const Text('Current Outfit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _selectedItems.isEmpty
                  ? const Text('No items selected', style: TextStyle(color: Colors.grey))
                  : Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _selectedItems.map((item) {
                        return Container(
                          width: 120,
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF4FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Center(
                            child: Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 32),
            
            const Text('Select Items from Your Wardrobe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search item...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _selectedColor = value.isEmpty ? 'All Colors' : value;
                      });
                      _applyFilters();
                    },
                    decoration: const InputDecoration(
                      hintText: 'All Colors',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.85,
                ),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final isSelected = _selectedItems.contains(item);
                  
                  return GestureDetector(
                    onTap: () => _toggleItem(item),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEBF4FF) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                  color: const Color(0xFFEBF4FF),
                                ),
                                child: Center(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${item.type} - ${item.brand ?? 'Unknown'} - ${item.color ?? 'No Color'}',
                                      style: const TextStyle(fontSize: 8),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveOutfit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Outfit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}