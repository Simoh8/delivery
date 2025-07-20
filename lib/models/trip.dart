import 'package:delivery/models/trip_item.dart';


enum TripStatus { assigned, inProgress, completed, delayed, cancelled }

class TripModel {
  final String id;
  final String customerName;
  final String contactNumber;
  final String deliveryAddress;
  final double distance;
  final List<TripItem> items;
  final String tripType;
  final String priority;
  final DateTime assignedTime;
  final TripStatus status;
  final DateTime expectedCompletion;

  TripModel({
    required this.id,
    required this.customerName,
    required this.contactNumber,
    required this.deliveryAddress,
    required this.distance,
    required this.items,
    required this.tripType,
    required this.priority,
    required this.assignedTime,
    required this.status,
    required this.expectedCompletion,
  });
}