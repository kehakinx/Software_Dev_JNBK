import 'dart:async';

import 'package:closetinventory/controllers/firebase/authentication_service.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';
import 'package:closetinventory/views/modules/closetfilter_module.dart';
import 'package:closetinventory/views/modules/closetitemcard_module.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/outfit_dataobj.dart';
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
  final FirebaseAuthServices _authServices = FirebaseAuthServices();
    final PlatformService _platformService = PlatformService.instance;
  late String _userId;
  ClosetFilter? closetFilter ;
  
  late List<Item> _closetItems = [];
  List<Item> _filteredItems = [];
  final List<Item> _selectedItems = [];
  bool _isLoading = false;
  
  // For dropdown options
  List<String> _types = [];
  List<String> _colors = [];

 
  StreamSubscription? _itemSubscription;

  @override
  void initState() {
    super.initState();
      _initializeFirebaseAndAuth();
  }

  Future<void> _initializeFirebaseAndAuth() async{
    _authServices.getAuth().authStateChanges().listen((User? user){
      if(user != null){
        setState(() {
          _userId = MyPreferences.getString('prefUserKey');
        });
        _loadCloset();
      }else{
        mounted ? context.go(CONSTANTS.loginPage) : null;
      }
    });
  }

  Future<void> _loadCloset() async {
    _itemSubscription?.cancel();
   
    _itemSubscription = _authServices.getDataServices().getFirestore().collection(CONSTANTS.itemsCollection).where('userId', isEqualTo: _userId).snapshots().listen((snapshot){
      if(!mounted) return;

      setState(() {
        _closetItems = snapshot.docs.map((doc) => Item.fromDocument(doc)).toList();
        _filteredItems = List.from(_closetItems);

         List<Item> tempFilteredItems = List<Item>.from(_closetItems); // Create a temporary list for filtering
        // Extract unique types and colors for dropdowns
        _types = _closetItems.map((item) => item.type).toSet().toList()..sort();
        _colors = _closetItems.map((item) => item.color != null ? item.color! : '').toSet().toList()..sort();

        _filteredItems = tempFilteredItems; // Update _filteredItems with initial filtered list

        closetFilter = ClosetFilter(
                filteredItems: _closetItems, // Pass the original _closetItems to the filter
                filterTypes: _types,
                filterColors: _colors,
                onFilterApplied: (filteredList) => _updateFilteredItems(filteredList), // Pass the new callback
              );
      });
    },
    onError: (error){
      if(!mounted) return;
      setState(() {
        
      });
    });
  }

   @override
   void dispose(){
    _itemSubscription?.cancel();

    super.dispose();
   }

   void _updateFilteredItems(List<Item> filteredList) { // New function to receive filtered list
    setState(() {
      _filteredItems = filteredList;
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
        userId: _userId,
        name: _outfitNameController.text.trim(),
        itemIds: _selectedItems.map((item) => item.itemId).toList(),
        stylingNotes: _stylingNotesController.text.trim().isEmpty ? null : _stylingNotesController.text.trim(),
      );

      // Save to Firebase
      await _authServices.getDataServices().createOutfit(outfit);
      
      // Also add to mock data for immediate UI update
      CONSTANTS.mockOutfits.add(outfit);
      
      mounted ? ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Outfit saved to Firebase!')),
      ) : null ;
      
      mounted ? context.goNamed(CONSTANTS.homePage) : null;
    
    } catch (e) {
      mounted ? ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving outfit: $e')),
      ) : null ;
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
            
            ?closetFilter,
            const SizedBox(height: 24),
            
            SizedBox(
              height: 400,
              child: ResponsiveWrap(
                children: [ 
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child:ClosetItemCard(
                            closetItem: item,
                            ratio: _platformService.isWeb ? 1 : .85,
                            onTap: true,
                            shortSummary: true,
                            closetItemCallBack:  () => _toggleItem(item),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveOutfit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Outfit', style: TextStyle(color:  Colors.white,),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}