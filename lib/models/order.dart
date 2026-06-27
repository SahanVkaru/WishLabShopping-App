import 'cart_item.dart';

enum OrderStatus {
  placed,
  confirmed,
  processing,
  ready
}

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final String shippingAddress;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime date;
  final String? notes;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.status,
    required this.date,
    this.notes,
  });

  OrderModel copyWith({
    String? id,
    List<CartItem>? items,
    double? totalAmount,
    String? shippingAddress,
    String? paymentMethod,
    OrderStatus? status,
    DateTime? date,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'],
      shippingAddress: json['shippingAddress'],
      paymentMethod: json['paymentMethod'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => OrderStatus.placed,
      ),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'status': status.toString(),
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
}
