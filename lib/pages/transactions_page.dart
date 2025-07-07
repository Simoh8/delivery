import 'package:flutter/material.dart';
import 'package:delivery/models/order.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<OrderItemModel> orders = [
      OrderItemModel(
        id: 'ord_001',
        customerName: 'John Doe',
        customerPhone: '+1234567890',
        deliveryAddress: '123 Main St',
        distance: 2.5,
        amount: 25.50,
        itemCount: 3,
        orderTime: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.delivered,
        items: [
          OrderItem(
            id: 'item_1',
            name: 'Pizza Margherita',
            description: 'Large',
            quantity: 1,
            price: 12.99,
          ),
        ],
      ),
      OrderItemModel(
        id: 'ord_001',
        customerName: 'John Doe',
        customerPhone: '+1234567890',
        deliveryAddress: '123 Main St',
        distance: 2.5,
        amount: 25.50,
        itemCount: 3,
        orderTime: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.pending,
        items: [
          OrderItem(
            id: 'item_1',
            name: 'Pizza Margherita',
            description: 'Large',
            quantity: 1,
            price: 12.99,
          ),
        ],
      ),
      OrderItemModel(
        id: 'ord_001',
        customerName: 'John Doe',
        customerPhone: '+1234567890',
        deliveryAddress: '123 Main St',
        distance: 2.5,
        amount: 25.50,
        itemCount: 3,
        orderTime: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.inTransit,
        items: [
          OrderItem(
            id: 'item_1',
            name: 'Pizza Margherita',
            description: 'Large',
            quantity: 1,
            price: 12.99,
          ),
        ],
      ),
      OrderItemModel(
        id: 'ord_001',
        customerName: 'John Doe',
        customerPhone: '+1234567890',
        deliveryAddress: '123 Main St',
        distance: 2.5,
        amount: 25.50,
        itemCount: 3,
        orderTime: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.cancelled,
        items: [
          OrderItem(
            id: 'item_1',
            name: 'Pizza Margherita',
            description: 'Large',
            quantity: 1,
            price: 12.99,
          ),
        ],
      ),

      // Add more orders...
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: order.statusColor.withOpacity(0.2),
                child: Icon(order.statusIcon, color: order.statusColor),
              ),
              title: Text(order.customerName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.deliveryAddress),
                  Text(order.formattedOrderTime),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.formattedAmount,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    label: Text(
                      order.statusString,
                      style: TextStyle(color: order.statusColor),
                    ),
                    backgroundColor: order.statusColor.withOpacity(0.1),
                  ),
                ],
              ),
              onTap: () => _showOrderDetails(context, order),
            ),
          );
        },
      ),
    );
  }

  void _showOrderDetails(BuildContext context, OrderItemModel order) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${order.id}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(),
              Text('Customer: ${order.customerName}'),
              Text('Phone: ${order.customerPhone}'),
              Text('Address: ${order.deliveryAddress}'),
              Text('Status: ${order.statusString}'),
              const SizedBox(height: 16),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...order.items.map((item) => ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: Text(item.formattedPrice),
              )).toList(),
              const Divider(),
              Text(
                'Total: ${order.formattedAmount}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Orders'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: OrderStatus.values.map((status) {
              return ListTile(
                title: Text(status.toString().split('.').last),
                onTap: () {
                  Navigator.pop(context);
                  // Implement filtering logic
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}