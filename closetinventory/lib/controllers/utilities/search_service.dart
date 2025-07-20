import 'package:closetinventory/models/item_dataobj.dart';
import 'package:closetinventory/models/search_filter.dart';
import 'package:flutter/material.dart';

class SearchService {
  static List<Item> filterItems(List<Item> items, SearchFilter filter) {
    List<Item> filteredItems = List.from(items);

    // Text search
    if (filter.searchText.isNotEmpty) {
      final searchTerm = filter.searchText.toLowerCase();
      filteredItems = filteredItems.where((item) {
        return item.name.toLowerCase().contains(searchTerm) ||
               item.brand.toLowerCase().contains(searchTerm) ||
               (item.color?.toLowerCase().contains(searchTerm) ?? false) ||
               (item.material?.toLowerCase().contains(searchTerm) ?? false);
      }).toList();
    }

    // Brand filter
    if (filter.selectedBrand != null) {
      filteredItems = filteredItems.where((item) => 
          item.brand == filter.selectedBrand).toList();
    }

    // Color filter
    if (filter.selectedColor != null) {
      filteredItems = filteredItems.where((item) => 
          item.color == filter.selectedColor).toList();
    }

    // Unworn filter
    if (filter.unwornOnly) {
      filteredItems = filteredItems.where((item) => 
          item.wearCount == 0).toList();
    }

    // Planned for donation filter
    if (filter.plannedForDonation) {
      filteredItems = filteredItems.where((item) => 
          item.isPlannedForDonation).toList();
    }

    // Has price filter
    if (filter.hasPrice) {
      filteredItems = filteredItems.where((item) => 
          item.price != null).toList();
    }

    // Purchase date range filter
    if (filter.purchaseDateRange != null) {
      filteredItems = filteredItems.where((item) {
        if (item.purchaseDate == null) return false;
        final itemDate = item.purchaseDate!.toDate();
        return itemDate.isAfter(filter.purchaseDateRange!.start.subtract(const Duration(days: 1))) &&
               itemDate.isBefore(filter.purchaseDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    // Wear count range filter
    if (filter.wearCountRange != null) {
      filteredItems = filteredItems.where((item) {
        return item.wearCount >= filter.wearCountRange!.start &&
               item.wearCount <= filter.wearCountRange!.end;
      }).toList();
    }

    // Price range filter
    if (filter.priceRange != null) {
      filteredItems = filteredItems.where((item) {
        if (item.price == null) return false;
        return item.price! >= filter.priceRange!.start &&
               item.price! <= filter.priceRange!.end;
      }).toList();
    }

    _sortItems(filteredItems, filter.sortOption);
    return filteredItems;
  }

  static void _sortItems(List<Item> items, SortOption sortOption) {
    switch (sortOption) {
      case SortOption.newest:
        items.sort((a, b) => a.name.compareTo(b.name)); // Fallback to alphabetical
        break;
      case SortOption.oldest:
        items.sort((a, b) => b.name.compareTo(a.name)); // Fallback to reverse alphabetical
        break;
      case SortOption.mostWorn:
        items.sort((a, b) => b.wearCount.compareTo(a.wearCount));
        break;
      case SortOption.leastWorn:
        items.sort((a, b) => a.wearCount.compareTo(b.wearCount));
        break;
      case SortOption.alphabetical:
        items.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.priceHighToLow:
        items.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case SortOption.priceLowToHigh:
        items.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
    }
  }

  static List<String> getUniqueValues(List<Item> items, String field) {
    Set<String> values = {};
    for (var item in items) {
      switch (field) {
        case 'brand':
          if (item.brand.isNotEmpty) values.add(item.brand);
          break;
        case 'color':
          if (item.color != null && item.color!.isNotEmpty) values.add(item.color!);
          break;
      }
    }
    return values.toList()..sort();
  }

  static RangeValues getWearCountRange(List<Item> items) {
    if (items.isEmpty) return const RangeValues(0, 100);
    final wearCounts = items.map((e) => e.wearCount.toDouble()).toList();
    final min = wearCounts.reduce((a, b) => a < b ? a : b);
    final max = wearCounts.reduce((a, b) => a > b ? a : b);
    return RangeValues(min, max == min ? max + 1 : max);
  }

  static RangeValues? getPriceRange(List<Item> items) {
    final prices = items.where((e) => e.price != null).map((e) => e.price!).toList();
    if (prices.isEmpty) return null;
    final min = prices.reduce((a, b) => a < b ? a : b);
    final max = prices.reduce((a, b) => a > b ? a : b);
    return RangeValues(min, max == min ? max + 1 : max);
  }
}