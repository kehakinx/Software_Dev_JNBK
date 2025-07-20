import 'package:flutter/material.dart';

enum SortOption {
  newest,
  oldest,
  mostWorn,
  leastWorn,
  alphabetical,
  priceHighToLow,
  priceLowToHigh,
}

extension SortOptionExtension on SortOption {
  String get displayName {
    switch (this) {
      case SortOption.newest:
        return 'Newest First';
      case SortOption.oldest:
        return 'Oldest First';
      case SortOption.mostWorn:
        return 'Most Worn';
      case SortOption.leastWorn:
        return 'Least Worn';
      case SortOption.alphabetical:
        return 'A-Z';
      case SortOption.priceHighToLow:
        return 'Price: High to Low';
      case SortOption.priceLowToHigh:
        return 'Price: Low to High';
    }
  }
}

class SearchFilter {
  String searchText;
  String? selectedCategory;
  String? selectedBrand;
  String? selectedColor;
  SortOption sortOption;
  bool unwornOnly;
  bool plannedForDonation;
  bool hasPrice;
  DateTimeRange? purchaseDateRange;
  RangeValues? wearCountRange;
  RangeValues? priceRange;

  SearchFilter({
    this.searchText = '',
    this.selectedCategory,
    this.selectedBrand,
    this.selectedColor,
    this.sortOption = SortOption.newest,
    this.unwornOnly = false,
    this.plannedForDonation = false,
    this.hasPrice = false,
    this.purchaseDateRange,
    this.wearCountRange,
    this.priceRange,
  });

  bool get hasActiveFilters {
    return searchText.isNotEmpty ||
           selectedCategory != null ||
           selectedBrand != null ||
           selectedColor != null ||
           unwornOnly ||
           plannedForDonation ||
           hasPrice ||
           purchaseDateRange != null ||
           sortOption != SortOption.newest;
  }

  void clear() {
    searchText = '';
    selectedCategory = null;
    selectedBrand = null;
    selectedColor = null;
    sortOption = SortOption.newest;
    unwornOnly = false;
    plannedForDonation = false;
    hasPrice = false;
    purchaseDateRange = null;
    wearCountRange = null;
    priceRange = null;
  }
}