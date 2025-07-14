import 'package:closetinventory/models/item_dataobj.dart';
import 'package:flutter/material.dart';

class ClosetFilter extends StatefulWidget {
  final List<Item> filteredItems;
  final List<String> filterTypes;
  final List<String> filterColors;
  final ValueChanged<List<Item>> onFilterApplied; // Modified callback type

  const ClosetFilter({
    super.key,
    required this.filteredItems,
    required this.filterTypes,
    required this.filterColors,
    required this.onFilterApplied, // Renamed callback
  });

  @override
  State<ClosetFilter> createState() => _ClosetFilterState();
}

class _ClosetFilterState extends State<ClosetFilter> {
  
  List<Item> _filteredItems = [];
  
  // Filter fields
  String _searchQuery = '';
  String? _selectedType;
  String? _selectedColor;

  // For dropdown options
  List<String> _types = [];
  List<String> _colors = [];


  List<Item> getFilterItems(){
    return _filteredItems;
  }

  void setFilterItems(List<Item> filterItem){
    _filteredItems = filterItem;
  }

   @override
  void initState() {
    super.initState();
      _initializeFilterOptions(); // Renamed for clarity
  }

  Future<void> _initializeFilterOptions() async{
    setState(() {
      _types = widget.filteredItems.map((item) => item.type).toSet().toList()..sort();
      _colors = widget.filteredItems.map((item) => item.color != null ? item.color! : '').toSet().toList()..sort();
      _filteredItems = List<Item>.from(widget.filteredItems); // Initialize _filteredItems
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredItems = widget.filteredItems.where((item) {
        final matchesSearch = _searchQuery.isEmpty ||
            item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.brand.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesType = _selectedType == null || item.type == _selectedType;
        final matchesColor = _selectedColor == null || item.color == _selectedColor;

        return matchesSearch && matchesType && matchesColor;
      }).toList();
      
      widget.onFilterApplied(_filteredItems); // Pass the filtered list back
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return  Row(
                children: [
                  // Search field
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search by name or brand',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                     onChanged: (value) {
                        _searchQuery = value;
                        _applyFilters();
                      },

                    ),
                  ),
                  const SizedBox(width: 8),
                  // Type dropdown
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All')),
                        ..._types.map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            )),
                      ],
                       onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                      _applyFilters();
                    },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Color dropdown
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedColor,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Color',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All')),
                        ..._colors.map((color) => DropdownMenuItem(
                              value: color,
                              child: Text(color),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedColor = value;
                        });
                        _applyFilters();
                      },

                    ),
                  ),
                  const SizedBox(width: 8),
                  // Apply Filters button
                  ElevatedButton(
                    onPressed: _applyFilters,
                    child: const Text('Apply Filters'),
                  ),
                ],
              );
  }
}