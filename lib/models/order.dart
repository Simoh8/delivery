import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class NoteItem {
  final String itemName;
  final double qty;
  final double rate;

  NoteItem({required this.itemName, required this.qty, required this.rate});

  factory NoteItem.fromJson(Map<String, dynamic> json) => NoteItem(
    itemName: json['item_name'] ?? '',
    qty: (json['qty'] ?? 0).toDouble(),
    rate: (json['rate'] ?? 0).toDouble(),
  );
}

class StopModel {
  final String id;
  final String name;
  final String description;
  final double? latitude;
  final double? longitude;
  final List<NoteItem> noteItems;

  StopModel({
    required this.id,
    required this.name,
    required this.description,
    this.latitude,
    this.longitude,
    required this.noteItems,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) => StopModel(
    id: json['id'],
    name: json['name'],
    description: json['description'] ?? '',
    latitude: (json['latitude'] ?? 0).toDouble(),
    longitude: (json['longitude'] ?? 0).toDouble(),
    noteItems: (json['note_items'] as List<dynamic>? ?? [])
        .map((i) => NoteItem.fromJson(i)).toList(),
  );
}

class OrderItemModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final double distance;
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

  String get distanceString => '${(distance / 1000).toStringAsFixed(1)} Est Distance km';

  String get itemCountString => '$itemCount ${itemCount == 1 ? 'item' : 'items'}';

  String get formattedOrderTime {
    final now = DateTime.now();
    final difference = now.difference(orderTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes} mins ago';
    if (difference.inDays < 1) return '${difference.inHours} hours ago';
    return '${difference.inDays} days ago';
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
      id: json['id']?.toString() ?? '',
      customerName: json['customer_name']?.toString() ?? '',
      customerPhone: json['customer_phone']?.toString() ?? '',
      deliveryAddress: json['delivery_address']?.toString() ?? '',
      distance: (json['distance'] is num) ? (json['distance'] as num).toDouble() : 0.0,
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0,
      itemCount: json['item_count'] is int ? json['item_count'] : int.tryParse(json['item_count']?.toString() ?? '0') ?? 0,
      orderTime: DateTime.tryParse(json['order_time']?.toString() ?? '') ?? DateTime.now(),
      status: _parseStatus(json['status']),
      notes: json['notes']?.toString(),
      paymentMethod: json['paymentMethod']?.toString(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  static OrderStatus _parseStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'in transit':
        return OrderStatus.inTransit;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'scheduled':
        return OrderStatus.pending;
      default:
        return OrderStatus.pending;
    }
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
      'status': status.name,
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
  final double? latitude;
  final double? longitude;
  final String? specialInstructions;
  final List<NoteItem> noteItems; // 🔥 Add this

  const OrderItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    this.latitude,
    this.longitude,
    this.specialInstructions,
    this.noteItems = const [], // 🔥 Default empty list
  });

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get quantityString => 'Qty: $quantity';

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      quantity: json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      latitude: json['latitude'] != null ? (json['latitude'] as num?)?.toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num?)?.toDouble() : null,
      specialInstructions: json['specialInstructions']?.toString(),
      noteItems: (json['note_items'] as List<dynamic>? ?? []) // 🔥 Deserialize note_items
          .map((i) => NoteItem.fromJson(i))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'latitude': latitude,
      'longitude': longitude,
      'specialInstructions': specialInstructions,
      'note_items': noteItems.map((item) => {
        'item_name': item.itemName,
        'qty': item.qty,
        'rate': item.rate,
      }).toList(),
    };
  }
}

enum OrderStatus {
  pending,
  inTransit,
  delivered,
  cancelled,
}
