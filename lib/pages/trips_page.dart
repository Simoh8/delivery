import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../widgets/trip_card.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // This would normally fetch from API
    final List<TripModel> trips = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Trips'),
      ),
      body: trips.isEmpty
          ? const Center(child: Text('No trips assigned'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          return TripCard(trip: trips[index]);
        },
      ),
    );
  }
}