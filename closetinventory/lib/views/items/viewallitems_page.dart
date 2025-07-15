import 'dart:async';

import 'package:closetinventory/controllers/firebase/authentication_service.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/views/modules/closetfilter_module.dart';
import 'package:closetinventory/views/modules/closetitemcard_module.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';
import 'package:go_router/go_router.dart';

class ViewallitemsPage extends StatefulWidget {
  final bool unworn;
  final bool declutter;

  const ViewallitemsPage({
    super.key,
    this.unworn = false,
    this.declutter = false,
    });

  @override
  State<ViewallitemsPage> createState() => _ViewallitemsPageState();
}

class _ViewallitemsPageState extends State<ViewallitemsPage> {
  final PlatformService _platformService = PlatformService.instance;
  final FirebaseAuthServices _authServices = FirebaseAuthServices();
  late String _userId;
  late List<Item> _closetItems = [];
  StreamSubscription? _itemSubscription;
  ClosetFilter? closetFilter ;

  // For dropdown options
  List<String> _types = [];
  List<String> _colors = [];
  List<String> _location = [];

  List<Item> _filteredItems = [];

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

        List<Item> tempFilteredItems = List<Item>.from(_closetItems); // Create a temporary list for filtering

        if (widget.unworn) {
          tempFilteredItems.retainWhere((item) => item.wearCount == 0);
        } else if (widget.declutter) {
          tempFilteredItems.retainWhere((item) => item.isPlannedForDonation == true);
        }

        // Extract unique types and colors for dropdowns
        _types = _closetItems.map((item) => item.type).toSet().toList()..sort();
        _colors = _closetItems.map((item) => item.color != null ? item.color! : '').toSet().toList()..sort();
        _location = _closetItems.map((item) => item.currentLocationId != null ? item.currentLocationId! : '').toSet().toList()..sort();

        _filteredItems = tempFilteredItems; // Update _filteredItems with initial filtered list

        closetFilter = ClosetFilter(
                filteredItems: _closetItems, // Pass the original _closetItems to the filter
                filterTypes: _types,
                filterColors: _colors,
                filterLocation: _location,
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

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: const Text('View All Clothing Items'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: closetFilter
            ),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Text(
                        CONSTANTS.itemNoRecordsErrorEn,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: ResponsiveWrap(
                        children: List.generate(
                          _filteredItems.length,
                          (index) => ClosetItemCard(
                            closetItem: _filteredItems.elementAt(index),
                            ratio: _platformService.isWeb ? 1 : .85,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}