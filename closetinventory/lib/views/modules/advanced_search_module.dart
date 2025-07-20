import 'package:flutter/material.dart';
import 'package:closetinventory/controllers/utilities/constants.dart';
import 'package:closetinventory/controllers/utilities/search_service.dart';
import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/search_filter.dart';

class AdvancedSearchModule extends StatefulWidget {
  final Function(List<Item>) onFilteredResults;
  final List<Item> allItems;

  const AdvancedSearchModule({
    super.key,
    required this.onFilteredResults,
    required this.allItems,
  });

  @override
  State<AdvancedSearchModule> createState() => _AdvancedSearchModuleState();
}

class _AdvancedSearchModuleState extends State<AdvancedSearchModule> {
  final TextEditingController _searchController = TextEditingController();
  final SearchFilter _filter = SearchFilter();
  late RangeValues _initialWearCountRange;
  RangeValues? _initialPriceRange;

  @override
  void initState() {
    super.initState();
    _initializeRanges();
    _searchController.addListener(_performSearch);
    // Delay initial search to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch();
    });
  }

  void _initializeRanges() {
    _initialWearCountRange = SearchService.getWearCountRange(widget.allItems);
    _initialPriceRange = SearchService.getPriceRange(widget.allItems);
    _filter.wearCountRange = _initialWearCountRange;
    _filter.priceRange = _initialPriceRange;
  }

  void _performSearch() {
    // Prevent setState during build
    if (!mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      _filter.searchText = _searchController.text;
      final filteredItems = SearchService.filterItems(widget.allItems, _filter);
      widget.onFilteredResults(filteredItems);
    });
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _filter.clear();
      _initializeRanges();
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search items, brands, colors...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        // Quick Filter Chips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 8.0,
            children: [
              FilterChip(
                label: const Text('Unworn'),
                selected: _filter.unwornOnly,
                onSelected: (selected) {
                  setState(() {
                    _filter.unwornOnly = selected;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _performSearch();
                  });
                },
              ),
              FilterChip(
                label: const Text('Declutter'),
                selected: _filter.plannedForDonation,
                onSelected: (selected) {
                  setState(() {
                    _filter.plannedForDonation = selected;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _performSearch();
                  });
                },
              ),
              FilterChip(
                label: const Text('Has Price'),
                selected: _filter.hasPrice,
                onSelected: (selected) {
                  setState(() {
                    _filter.hasPrice = selected;
                  });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _performSearch();
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Advanced Filters
        ExpansionTile(
          title: Text('Advanced Filters ${_filter.hasActiveFilters ? "(Active)" : ""}'),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Dropdown
                  DropdownButtonFormField<String>(
                    value: _filter.selectedBrand,
                    decoration: const InputDecoration(
                      labelText: 'Brand',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Brands')),
                      ...SearchService.getUniqueValues(widget.allItems, 'brand').map((brand) =>
                          DropdownMenuItem(value: brand, child: Text(brand))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filter.selectedBrand = value;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _performSearch();
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Color Dropdown
                  DropdownButtonFormField<String>(
                    value: _filter.selectedColor,
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Colors')),
                      ...SearchService.getUniqueValues(widget.allItems, 'color').map((color) =>
                          DropdownMenuItem(value: color, child: Text(color))),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _filter.selectedColor = value;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _performSearch();
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Sort Options
                  DropdownButtonFormField<SortOption>(
                    value: _filter.sortOption,
                    decoration: const InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(),
                    ),
                    items: SortOption.values.map((sort) =>
                        DropdownMenuItem(value: sort, child: Text(sort.displayName))).toList(),
                    onChanged: (value) {
                      setState(() {
                        _filter.sortOption = value!;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _performSearch();
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // Wear Count Range
                  Text('Wear Count: ${_filter.wearCountRange!.start.round()} - ${_filter.wearCountRange!.end.round()}'),
                  RangeSlider(
                    values: _filter.wearCountRange!,
                    min: _initialWearCountRange.start,
                    max: _initialWearCountRange.end,
                    divisions: 20,
                    onChanged: (values) {
                      setState(() {
                        _filter.wearCountRange = values;
                      });
                      _performSearch();
                    },
                  ),

                  const SizedBox(height: 16),

                  // Price Range
                  if (_initialPriceRange != null) ...[
                    Text('Price: \$${_filter.priceRange!.start.round()} - \$${_filter.priceRange!.end.round()}'),
                    RangeSlider(
                      values: _filter.priceRange!,
                      min: _initialPriceRange!.start,
                      max: _initialPriceRange!.end,
                      divisions: 20,
                      onChanged: (values) {
                        setState(() {
                          _filter.priceRange = values;
                        });
                        _performSearch();
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Purchase Date Range
                  Row(
                    children: [
                      Expanded(
                        child: Text(_filter.purchaseDateRange == null
                            ? 'Purchase Date: All'
                            : 'Purchase Date: ${_filter.purchaseDateRange!.start.toString().split(' ')[0]} - ${_filter.purchaseDateRange!.end.toString().split(' ')[0]}'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final DateTimeRange? picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            initialDateRange: _filter.purchaseDateRange,
                          );
                          if (picked != null) {
                            setState(() {
                              _filter.purchaseDateRange = picked;
                            });
                            _performSearch();
                          }
                        },
                        child: const Text('Select'),
                      ),
                      if (_filter.purchaseDateRange != null)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _filter.purchaseDateRange = null;
                            });
                            _performSearch();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Clear Filters Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _clearAllFilters,
                      child: const Text('Clear All Filters'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}