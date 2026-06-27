import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> loadProducts() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print("Error loading products: $e");
      return [];
    }
  }
}
