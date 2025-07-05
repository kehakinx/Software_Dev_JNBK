import 'package:closetinventory/controllers/utilities/shared_preferences.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/user_dataobj.dart';
import 'package:closetinventory/views/modules/closetitemcard_module.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';

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
  late List<Item> _closetItems;
  late USER _user;

  // Filter fields
  String _searchQuery = '';
  String? _selectedType;
  String? _selectedColor;

  // For dropdown options
  late final List<String> _types;
  late final List<String> _colors;

  List<Item> _filteredItems = [];

  @override
  void initState() {
    super.initState();

    _user = CONSTANTS.mockUsers.firstWhere((user) => user.userId == MyPreferences.getString('prefUserKey'));
    _closetItems = List<Item>.from(CONSTANTS.mockClosetItems.where((item) => item.userId == _user.userId));

    if (widget.unworn) {
      _closetItems.retainWhere((item) => item.wearCount == 0);
    } else if (widget.declutter) {
      _closetItems.retainWhere((item) => item.isPlannedForDonation == true);
    }

    // Extract unique types and colors for dropdowns
    _types = _closetItems.map((item) => item.type).toSet().toList()..sort();
    _colors = _closetItems.map((item) => item.color != null ? item.color! : '').toSet().toList()..sort();

    _filteredItems = List<Item>.from(_closetItems);
  }

  void _applyFilters() {
    setState(() {
      _filteredItems = _closetItems.where((item) {
        final matchesSearch = _searchQuery.isEmpty ||
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.brand.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesType = _selectedType == null || item.type == _selectedType;
        final matchesColor = _selectedColor == null || item.color == _selectedColor;

        return matchesSearch && matchesType && matchesColor;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View All Clothing Items'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Search field
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search by name or brand',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        _searchQuery = value;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  // Type dropdown
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('All')),
                        ..._types.map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  // Color dropdown
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedColor,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Color',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('All')),
                        ..._colors.map((color) => DropdownMenuItem(
                              value: color,
                              child: Text(color),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedColor = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  // Apply Filters button
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
                  ),
                ],
              ),
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