// import 'package:flutter/material.dart';
// import 'package:delivery/models/trip.dart';
//
// class OrderItem extends StatelessWidget {
//   final OrderItemModel order;
//
//   const OrderItem({super.key, required this.order});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: order.statusColor.withOpacity(0.2),
//           child: Icon(order.statusIcon, color: order.statusColor),
//         ),
//         title: Text(order.customerName),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(order.deliveryAddress),
//             Text('${order.formattedAmount} • ${order.itemCountString}'),
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(order.formattedOrderTime),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: order.statusColor,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Text(
//                 order.statusString,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         onTap: () => _showOrderDetails(context, order),
//       ),
//     );
//   }
//
//   void _showOrderDetails(BuildContext context, OrderItemModel order) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: ListView(
//             children: [
//               Text(
//                 'Order #${order.id}',
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               const Divider(),
//               _buildDetailRow('Customer', order.customerName),
//               _buildDetailRow('Phone', order.customerPhone),
//               _buildDetailRow('Address', order.deliveryAddress),
//               _buildDetailRow('Status', order.statusString),
//               _buildDetailRow('Order Time', order.formattedOrderTime),
//               const SizedBox(height: 16),
//               const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
//               ...order.items.map((item) => ListTile(
//                 title: Text(item.name),
//                 subtitle: Text(item.description),
//                 trailing: Text(item.formattedPrice),
//               )).toList(),
//               const Divider(),
//               Text(
//                 'Total: ${order.formattedAmount}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text(value),
//         ],
//       ),
//     );
//   }
// }