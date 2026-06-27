import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider with ChangeNotifier {
  Set<String> _favoriteIds = {};

  WishlistProvider() {
    _loadFavorites();
  }

  Set<String> get favorites => _favoriteIds;

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('wishlist_ids') ?? [];
    _favoriteIds = ids.toSet();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('wishlist_ids', _favoriteIds.toList());
  }
}
