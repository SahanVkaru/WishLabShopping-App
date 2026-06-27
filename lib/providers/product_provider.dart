import 'dart:math';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Advanced Filters
  double _minPrice = 0;
  double _maxPrice = 20000;
  double _minRating = 0;
  String _sortBy = 'Popularity';

  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  
  // Advanced Filter Getters
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get minRating => _minRating;
  String get sortBy => _sortBy;

  List<String> get categories {
    final Set<String> uniqueCategories = {'All'};
    for (var product in _allProducts) {
      uniqueCategories.add(product.category);
    }
    return uniqueCategories.toList();
  }

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    _allProducts = await _productService.loadProducts();
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setFilters({double? minPrice, double? maxPrice, double? minRating, String? sortBy}) {
    if (minPrice != null) _minPrice = minPrice;
    if (maxPrice != null) _maxPrice = maxPrice;
    if (minRating != null) _minRating = minRating;
    if (sortBy != null) _sortBy = sortBy;
    _applyFilters();
  }

  void clearFilters() {
    _minPrice = 0;
    _maxPrice = 20000;
    _minRating = 0;
    _sortBy = 'Popularity';
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesSearch = fuzzyMatch(_searchQuery, product.name);
      final matchesPrice = product.price >= _minPrice && product.price <= _maxPrice;
      final matchesRating = product.rating >= _minRating;
      
      return matchesCategory && matchesSearch && matchesPrice && matchesRating;
    }).toList();
    
    if (_sortBy == 'Price: Low to High') {
      _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Top Rated') {
      _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      // Popularity (review count)
      _filteredProducts.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
    }
    
    _isLoading = false;
    notifyListeners();
  }

  bool fuzzyMatch(String query, String target) {
    if (query.trim().isEmpty) return true;
    
    // Fast path: Exact substring match
    if (target.toLowerCase().contains(query.toLowerCase())) return true;

    final queryWords = query.toLowerCase().split(RegExp(r'\s+'));
    final targetWords = target.toLowerCase().split(RegExp(r'\s+'));

    for (final qWord in queryWords) {
      if (qWord.isEmpty) continue;
      bool wordMatched = false;
      for (final tWord in targetWords) {
        if (tWord.contains(qWord)) {
          wordMatched = true;
          break;
        }
        
        // Only attempt fuzzy match for words longer than 3 characters
        if (qWord.length > 3 && tWord.length > 3) {
          int distance = _levenshtein(qWord, tWord);
          // Allow 1 typo for 4-5 letter words, 2 typos for 6+ letter words
          int allowedDistance = qWord.length > 5 ? 2 : 1; 
          if (distance <= allowedDistance) {
            wordMatched = true;
            break;
          }
        }
      }
      if (!wordMatched) return false; // This query word didn't match any target word
    }
    return true; // All query words fuzzy matched
  }

  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.filled(t.length + 1, 0);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < t.length + 1; i++) {
      v0[i] = i;
    }

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;

      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = min(v1[j] + 1, min(v0[j + 1] + 1, v0[j] + cost));
      }

      for (int j = 0; j < t.length + 1; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[t.length];
  }
}
