import 'package:flutter/material.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/views/modules/closetitemcard_module.dart';
import 'package:closetinventory/views/modules/responsivewrap_module.dart';
import 'package:closetinventory/views/modules/advanced_search_module.dart';
import 'package:closetinventory/controllers/utilities/platform_service.dart';

class SearchResultsPage extends StatefulWidget {
  final List<Item> allItems;

  const SearchResultsPage({
    super.key,
    required this.allItems,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final PlatformService _platformService = PlatformService.instance;
  List<Item> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.allItems;
  }

  void _updateFilteredResults(List<Item> filteredItems) {
    setState(() {
      _filteredItems = filteredItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results (${_filteredItems.length})'),
      ),
      body: Column(
        children: [
          // Search and Filter Module
          AdvancedSearchModule(
            allItems: widget.allItems,
            onFilteredResults: _updateFilteredResults,
          ),

          const Divider(),

          // Results
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No items found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: ResponsiveWrap(
                      children: _filteredItems.map((item) => ClosetItemCard(
                        closetItem: item,
                        ratio: _platformService.isWeb ? 1 : 0.85,
                      )).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}