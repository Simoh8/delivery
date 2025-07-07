import 'package:flutter/material.dart';  // For Colors and IconData
import 'package:flutter/cupertino.dart'; // Alternative import if needed


class OrderItemModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final double distance; // in km
  final double amount;
  final int itemCount;
  final DateTime orderTime;
  final OrderStatus status;
  final String? notes;
  final String? paymentMethod;
  final List<OrderItem> items;

  const OrderItemModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.distance,
    required this.amount,
    required this.itemCount,
    required this.orderTime,
    required this.status,
    this.notes,
    this.paymentMethod,
    required this.items,
  });

  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';

  String get distanceString => '${distance.toStringAsFixed(1)} km away';

  String get itemCountString => '$itemCount ${itemCount == 1 ? 'item' : 'items'}';

  String get formattedOrderTime {
    final now = DateTime.now();
    final difference = now.difference(orderTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  String get statusString {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending Pickup';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.inTransit:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending;
      case OrderStatus.inTransit:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      distance: (json['distance'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      itemCount: json['itemCount'] as int,
      orderTime: DateTime.parse(json['orderTime'] as String),
      status: OrderStatus.values[json['status'] as int],
      notes: json['notes'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'deliveryAddress': deliveryAddress,
      'distance': distance,
      'amount': amount,
      'itemCount': itemCount,
      'orderTime': orderTime.toIso8601String(),
      'status': status.index,
      'notes': notes,
      'paymentMethod': paymentMethod,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final double price;
  final String? specialInstructions;

  const OrderItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    this.specialInstructions,
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  String get quantityString => 'Qty: $quantity';

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      specialInstructions: json['specialInstructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'specialInstructions': specialInstructions,
    };
  }
}

enum OrderStatus {
  pending,
  inTransit,
  delivered,
  cancelled,
}