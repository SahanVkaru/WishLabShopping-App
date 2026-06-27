import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  Timer? _progressTimer;

  List<OrderModel> get orders => _orders;

  OrderProvider() {
    _loadOrders();
  }

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    _saveOrders();
    notifyListeners();
    _startOrderProgression(order.id);
  }

  void _startOrderProgression(String orderId) {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index == -1) {
        timer.cancel();
        return;
      }

      final order = _orders[index];
      OrderStatus nextStatus;
      
      switch (order.status) {
        case OrderStatus.placed:
          nextStatus = OrderStatus.confirmed;
          break;
        case OrderStatus.confirmed:
          nextStatus = OrderStatus.processing;
          break;
        case OrderStatus.processing:
          nextStatus = OrderStatus.ready;
          break;
        case OrderStatus.ready:
          timer.cancel();
          return;
      }

      _orders[index] = order.copyWith(status: nextStatus);
      _saveOrders();
      notifyListeners();
    });
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _orders.map((order) => order.toJson()).toList(),
    );
    await prefs.setString('ordersData', encodedData);
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('ordersData')) return;

    final extractedData = json.decode(prefs.getString('ordersData')!) as List;
    _orders = extractedData.map((data) => OrderModel.fromJson(data)).toList();
    notifyListeners();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }
}
