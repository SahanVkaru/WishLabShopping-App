import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  CartProvider() {
    _loadCartData();
  }

  void addItem(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          product: product,
          quantity: quantity,
        ),
      );
    }
    _saveCartData();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveCartData();
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: newQuantity,
        ),
      );
      _saveCartData();
      notifyListeners();
    }
  }

  void clearCart() {
    _items = {};
    _saveCartData();
    notifyListeners();
  }

  Future<void> _saveCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _items.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString('cartData', encodedData);
  }

  Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('cartData')) {
      return;
    }
    
    final extractedData = json.decode(prefs.getString('cartData')!) as Map<String, dynamic>;
    final Map<String, CartItem> loadedCart = {};
    
    extractedData.forEach((key, value) {
      loadedCart[key] = CartItem.fromJson(value);
    });
    
    _items = loadedCart;
    notifyListeners();
  }
}
