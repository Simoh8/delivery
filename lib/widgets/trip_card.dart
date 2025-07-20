import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripCard extends StatelessWidget {
  final TripModel trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(trip.id, style: Theme.of(context).textTheme.titleMedium),
                Chip(
                  label: Text(trip.status.toString().split('.').last),
                  backgroundColor: _getStatusColor(trip.status),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.business),
              title: Text(trip.customerName),
              subtitle: Text(trip.contactNumber),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.location_on),
              title: const Text('Delivery Address'),
              subtitle: Text(trip.deliveryAddress),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 4),
                Text('Expected by ${_formatTime(trip.expectedCompletion)}'),
                const Spacer(),
                const Icon(Icons.directions_car, size: 16),
                const SizedBox(width: 4),
                Text('${trip.distance.toStringAsFixed(1)} km'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // View trip details
                    },
                    child: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Start trip
                    },
                    child: const Text('Start'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TripStatus status) {
    switch (status) {
      case TripStatus.assigned:
        return Colors.blue;
      case TripStatus.inProgress:
        return Colors.orange;
      case TripStatus.completed:
        return Colors.green;
      case TripStatus.delayed:
        return Colors.red;
      case TripStatus.cancelled:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}