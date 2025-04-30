import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hotel_list_app/core/network/connectivity_aware_mixin.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/filter.dart';
import 'package:hotel_list_app/features/hotels/domain/entities/hotel.dart';
import 'package:hotel_list_app/features/hotels/domain/usecases/get_hotels_data.dart';

class HotelViewModel extends ChangeNotifier with ConnectivityAwareMixin {
  final GetHotelsData getHotelsDataUseCase;

  HotelViewModel({required this.getHotelsDataUseCase}) {
    initConnectivity();
  }

  // State
  bool _isLoading = false;
  bool _isFetchingMore = false;
  bool _hasMoreData = true;
  String? _errorMessage;
  int _currentPage = 1;

  // Data
  List<Hotel> _allHotels = [];
  List<Hotel> _filteredHotels = [];
  List<FilterGroup> _filters = [];
  Set<String> _selectedCategoryIds = {};
  List<FilterCategory> _quickFilters = [];

  // Getters
  List<Hotel> get hotels => _filteredHotels;

  List<FilterGroup> get filters => _filters;

  Set<String> get selectedCategoryIds => _selectedCategoryIds;

  List<FilterCategory> get quickFilters => _quickFilters;

  bool get isLoading => _isLoading;

  bool get isFetchingMore => _isFetchingMore;

  bool get hasMoreData => _hasMoreData;

  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  @override
  void onConnectionRestored() {
    loadHotelsData();
  }

  Future<void> loadHotelsData() async {
    _isLoading = true;
    _currentPage = 1;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await getHotelsDataUseCase(page: _currentPage);
      _allHotels = data.hotels;
      _filters = data.filters;
      _filteredHotels = _allHotels;
      _quickFilters = _pickRandomFilters();
      _hasMoreData = data.hotels.length >= 5;
    } catch (e) {
      print(e);
      _errorMessage = 'Failed to load data.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load next page
  Future<void> loadMoreHotels() async {
    if (_isFetchingMore || !_hasMoreData) return;
    _isFetchingMore = true;
    notifyListeners();
    try {
      _currentPage++;
      final data = await getHotelsDataUseCase(page: _currentPage);
      _allHotels.addAll(data.hotels);
      _hasMoreData = data.hotels.length >= 5;
      _applyFilters();
    } catch (_) {
      _currentPage--;
      _hasMoreData = false;
    }
    _isFetchingMore = false;
    notifyListeners();
  }

  // Filtering
  void applySelectedFilters(Set<String> selectedIds) {
    _selectedCategoryIds = selectedIds;
    _applyFilters();
  }

  void toggleQuickFilter(String id) {
    if (_selectedCategoryIds.contains(id)) {
      _selectedCategoryIds.remove(id);
    } else {
      _selectedCategoryIds.add(id);
    }
    _applyFilters();
  }

  void clearAllFilters() {
    _selectedCategoryIds.clear();
    _filteredHotels = _allHotels;
    notifyListeners();
  }

  void _applyFilters() {
    if (_selectedCategoryIds.isEmpty) {
      _filteredHotels = _allHotels;
    } else {
      _filteredHotels = _allHotels.where((hotel) {
        final ids = hotel.categories.map((c) => c.id).toSet();
        return _selectedCategoryIds.every((id) => ids.contains(id));
      }).toList();
    }
    notifyListeners();
  }

  List<FilterCategory> _pickRandomFilters() {
    final allCategories = _filters.expand((g) => g.categories).toList();
    allCategories.shuffle(Random());
    return allCategories.take(5).toList();
  }

  void retry() => loadHotelsData();

  bool isQuickFilterSelected(String id) => _selectedCategoryIds.contains(id);
}
