// widgets/order_item_card.dart
import 'package:flutter/material.dart';
import 'package:delivery/models/order.dart';

class OrderItemCard extends StatelessWidget {
  final OrderItemModel order;
  const OrderItemCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            Text('${order.formattedAmount} • ${order.itemCountString}'),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(order.formattedOrderTime),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: order.statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                order.statusString,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showOrderDetails(context, order),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, OrderItemModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);

        return Theme(
          // 👇 override bottom sheet to always use light surface & dark text
          data: theme.copyWith(
            cardColor: Colors.white,
            textTheme: ThemeData.light().textTheme,
            iconTheme: const IconThemeData(color: Colors.black87),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${order.id}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),

                  _buildColoredDetailRow('Customer', order.customerName, theme),
                  _buildColoredDetailRow('Address', order.deliveryAddress, theme),

                  const SizedBox(height: 16),
                  Text(
                    'Delivery Note Items:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary, // adapts
                    ),
                  ),
                  const SizedBox(height: 8),

                  ...order.items.map((stop) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (stop.noteItems.isNotEmpty)
                        Column(
                          children: stop.noteItems.map((item) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                item.itemName,
                                style: theme.textTheme.bodyMedium,
                              ),
                              trailing: Text(
                                'Qty: ${item.qty}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'No items for this stop',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      const Divider(),
                    ],
                  )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColoredDetailRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }


}