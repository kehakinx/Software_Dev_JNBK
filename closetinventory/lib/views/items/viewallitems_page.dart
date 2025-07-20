import 'dart:async';

import 'package:closetinventory/controllers/firebase/authentication_service.dart';
import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/views/modules/advanced_search_module.dart';
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
  List<Item> _filteredItems = [];
  StreamSubscription? _itemSubscription;
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseAndAuth();
  }

  Future<void> _initializeFirebaseAndAuth() async {
    _authServices.getAuth().authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _userId = MyPreferences.getString('prefUserKey');
        });
        _loadCloset();
      } else {
        mounted ? context.go(CONSTANTS.loginPage) : null;
      }
    });
  }

  Future<void> _loadCloset() async {
    _itemSubscription?.cancel();

    _itemSubscription = _authServices
        .getDataServices()
        .getFirestore()
        .collection(CONSTANTS.itemsCollection)
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .listen(
      (snapshot) {
        if (!mounted) return;

        setState(() {
          _closetItems = snapshot.docs.map((doc) => Item.fromDocument(doc)).toList();

          List<Item> tempFilteredItems = List<Item>.from(_closetItems);

          if (widget.unworn) {
            tempFilteredItems.retainWhere((item) => item.wearCount == 0);
          } else if (widget.declutter) {
            tempFilteredItems.retainWhere((item) => item.isPlannedForDonation == true);
          }

          _filteredItems = tempFilteredItems;
        });
      },
      onError: (error) {
        if (!mounted) return;
      },
    );
  }

  @override
  void dispose() {
    _itemSubscription?.cancel();
    super.dispose();
  }

  void _updateFilteredItems(List<Item> filteredList) {
    setState(() {
      _filteredItems = filteredList;
    });
  }

  String _getPageTitle() {
    if (widget.unworn) return 'Unworn Items';
    if (widget.declutter) return 'Items to Declutter';
    return 'All Items';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_getPageTitle()} (${_filteredItems.length})'),
        actions: [
          IconButton(
            icon: Icon(_showSearch ? Icons.search_off : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Module (conditionally shown)
            if (_showSearch) ...[
              AdvancedSearchModule(
                allItems: _closetItems,
                onFilteredResults: _updateFilteredItems,
              ),
              const Divider(),
            ],

            // Results
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _showSearch ? Icons.search_off : Icons.checkroom_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _showSearch ? 'No items match your search' : CONSTANTS.itemNoRecordsErrorEn,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (_showSearch)
                            const Text(
                              'Try adjusting your filters',
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
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