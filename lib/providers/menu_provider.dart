// ─── Menu Provider ────────────────────────────────────────────────────────────
// Manages menu state: category filtering, search, and customization flow.

import 'package:flutter/foundation.dart';
import '../models/drink_model.dart';
import '../models/customization_model.dart';
import '../data/mock_drinks.dart' as mock_drinks;

class MenuProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  DrinkCategory _selectedCategory = DrinkCategory.hotCoffee;
  String _searchQuery = '';
  DrinkModel? _selectedDrink;
  CustomizationModel _currentCustomization = const CustomizationModel();
  
  // Cache for filtered results
  late List<DrinkModel> _cachedFilteredDrinks = [];
  late List<DrinkModel> _cachedSearchResults = [];
  String _cachedSearchQuery = '';
  DrinkCategory _cachedCategory = DrinkCategory.hotCoffee;

  // ── Getters ────────────────────────────────────────────────────────────────

  DrinkCategory get selectedCategory => _selectedCategory;

  String get searchQuery => _searchQuery;

  DrinkModel? get selectedDrink => _selectedDrink;

  CustomizationModel get currentCustomization => _currentCustomization;

  /// All drinks (no filter)
  List<DrinkModel> get allDrinks => mock_drinks.mockDrinks;

  /// Drinks filtered by selected category and search query - cached
  List<DrinkModel> get filteredDrinks {
    // Return cached result if nothing changed
    if (_cachedCategory == _selectedCategory && _cachedSearchQuery == _searchQuery && _cachedFilteredDrinks.isNotEmpty) {
      return _cachedFilteredDrinks;
    }
    
    var drinks = mock_drinks.drinksByCategory(_selectedCategory);
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      drinks = drinks
          .where((d) =>
              d.name.toLowerCase().contains(q) ||
              d.description.toLowerCase().contains(q))
          .toList();
    }
    
    _cachedFilteredDrinks = drinks;
    _cachedCategory = _selectedCategory;
    _cachedSearchQuery = _searchQuery;
    return drinks;
  }

  /// Search across ALL categories - cached
  List<DrinkModel> get searchResults {
    if (_searchQuery.isEmpty) {
      _cachedSearchResults = [];
      return [];
    }
    
    // Return cached if search query unchanged
    if (_cachedSearchQuery == _searchQuery && _cachedSearchResults.isNotEmpty) {
      return _cachedSearchResults;
    }
    
    final q = _searchQuery.toLowerCase();
    final results = mock_drinks.mockDrinks
        .where((d) =>
            d.name.toLowerCase().contains(q) ||
            d.description.toLowerCase().contains(q))
        .toList();
    
    _cachedSearchResults = results;
    _cachedSearchQuery = _searchQuery;
    return results;
  }

  /// Whether a search is active
  bool get isSearching => _searchQuery.isNotEmpty;

  /// Seasonal / limited-time drinks for Home carousel
  List<DrinkModel> get seasonalDrinksForHome => mock_drinks.seasonalDrinks;

  /// Price of the selected drink with current customization applied
  double get customizedPrice {
    if (_selectedDrink == null) return 0;
    return _selectedDrink!.basePrice + _currentCustomization.extraPrice;
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void selectCategory(DrinkCategory category) {
    _selectedCategory = category;
    _searchQuery = '';
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Set the drink being viewed / customized
  void selectDrink(DrinkModel drink) {
    _selectedDrink = drink;
    // Reset customization to defaults for this drink
    _currentCustomization = CustomizationModel(
      temperature: drink.availableTemperatures.first,
    );
    notifyListeners();
  }

  // ── Customization updates ─────────────────────────────────────────────────

  void updateMilkType(MilkType milk) {
    _currentCustomization = _currentCustomization.copyWith(milkType: milk);
    notifyListeners();
  }

  void updateShots(int shots) {
    _currentCustomization =
        _currentCustomization.copyWith(espressoShots: shots.clamp(1, 4));
    notifyListeners();
  }

  void updateSyrupPumps(int pumps) {
    _currentCustomization =
        _currentCustomization.copyWith(syrupPumps: pumps.clamp(0, 6));
    notifyListeners();
  }

  void updateSyrupFlavor(SyrupFlavor flavor) {
    _currentCustomization =
        _currentCustomization.copyWith(syrupFlavor: flavor);
    notifyListeners();
  }

  void updateTemperature(String temp) {
    _currentCustomization =
        _currentCustomization.copyWith(temperature: temp);
    notifyListeners();
  }

  void resetCustomization() {
    if (_selectedDrink != null) {
      _currentCustomization = CustomizationModel(
        temperature: _selectedDrink!.availableTemperatures.first,
      );
      notifyListeners();
    }
  }
}
