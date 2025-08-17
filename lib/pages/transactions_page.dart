import 'package:flutter/material.dart';
import 'package:delivery/models/order.dart';
import 'package:delivery/services/order_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:delivery/services/routing_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import '../services/delivery_service.dart';




class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<List<OrderItemModel>> _ordersFuture;
  List<OrderItemModel> _allOrders = [];
  List<OrderItemModel> _filteredOrders = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ordersFuture = _loadOrders();
    _searchController.addListener(_filterOrders);
  }

  Future<List<OrderItemModel>> _loadOrders() async {
    final fetched = await OrderService.getAssignedOrders();
    setState(() {
      _allOrders = fetched;
      _filteredOrders = fetched;
    });
    return fetched;
  }



  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending;
      case OrderStatus.inTransit:
        return Icons.directions_bike;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.blue;
      case OrderStatus.inTransit:
        return Colors.orange;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Orders'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                ...OrderStatus.values.map((status) {
                  return ListTile(
                    title: Text(
                      status.toString().split('.').last,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      _getStatusIcon(status),
                      color: _getStatusColor(status),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _filteredOrders = _allOrders.where((o) => o.status == status).toList();
                      });
                    },
                  );
                }).toList(),
                const Divider(),
                ListTile(
                  title: const Text('All Orders'),
                  trailing: const Icon(Icons.all_inbox),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _filteredOrders = _allOrders;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _filterOrders() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOrders = _allOrders.where((order) {
        final id = order.id.toLowerCase();
        final name = order.customerName.toLowerCase();
        final address = order.deliveryAddress.toLowerCase();
        return id.contains(query) || name.contains(query) || address.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Delivery Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by ID, name or address',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<OrderItemModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _allOrders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError && _allOrders.isEmpty) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (_filteredOrders.isEmpty) {
            return const Center(child: Text('No matching orders'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              final refreshedOrders = await _loadOrders();
              setState(() {
                _allOrders = refreshedOrders;
                _filteredOrders = _searchController.text.isEmpty
                    ? refreshedOrders
                    : refreshedOrders.where((order) {
                  final query = _searchController.text.toLowerCase();
                  return order.id.toLowerCase().contains(query) ||
                      order.customerName.toLowerCase().contains(query) ||
                      order.deliveryAddress.toLowerCase().contains(query);
                }).toList();
              });
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return _OrderCard(order: order);
              },
            ),
          );
        },
      ),
    );
  }

}

class _OrderCard extends StatelessWidget {
  final OrderItemModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showOrderDetails(context, order),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '${order.id}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Driver Name:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        order.customerName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Stops To Make:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        order.deliveryAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Trip Depature Time:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        order.formattedOrderTime,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, OrderItemModel order) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
    );
  }
}



class OrderDetailsScreen extends StatefulWidget {
  final OrderItemModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  GoogleMapController? mapController;

  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _sortedPoints = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _prepareMapData();

    // Timer to refresh order time every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildStopItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.order.items.map((stop) {
        final TextEditingController otpController = TextEditingController();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Company Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stop.name,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 8),

                  if (stop.noteItems.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                        child: DataTable(
                          columnSpacing: 32,
                          columns: const [
                            DataColumn(label: Text('Item Name')),
                            DataColumn(label: Text('Qty')),
                          ],
                          rows: stop.noteItems.map((item) {
                            return DataRow(cells: [
                              DataCell(Text(item.itemName)),
                              DataCell(Text(item.qty.toString())),
                            ]);
                          }).toList(),
                        ),
                      ),
                    )
                  else
                    const Text('No items found for this stop'),

                  const SizedBox(height: 12),

                  // 🔐 OTP Field
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP to Close Delivery Note',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ✅ Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final enteredOtp = otpController.text.trim();

                        if (enteredOtp.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter OTP')),
                          );
                          return;
                        }

                        await DeliveryService.submitOtp(
                          context: context,
                          deliveryNoteName: stop.id, // or stop.deliveryNoteName
                          otp: enteredOtp,
                        );
                      },
                      child: const Text('Submit OTP'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }




  Future<void> _prepareMapData() async {
    await _handleLocationPermission();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final currentLatLng = LatLng(position.latitude, position.longitude);
    _currentLocation = currentLatLng;

    final stops = widget.order.items;
    final List<LatLng> stopLocations = [];

    final Set<Marker> markerSet = {
      Marker(
        markerId: const MarkerId('current_location'),
        position: currentLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: "Your Location"),
      ),
    };

    for (var stop in stops) {
      if (stop.latitude != null &&
          stop.longitude != null &&
          stop.latitude != 0 &&
          stop.longitude != 0) {
        final point = LatLng(stop.latitude!, stop.longitude!);
        stopLocations.add(point);

        markerSet.add(
          Marker(
            markerId: MarkerId(stop.id),
            position: point,
            infoWindow: InfoWindow(title: stop.name, snippet: stop.description),
          ),
        );
      }
    }

    if (stopLocations.isEmpty) {
      setState(() {
        _markers = markerSet;
      });
      return;
    }

    // Sort stops by proximity to current location
    stopLocations.sort((a, b) {
      final distA = Geolocator.distanceBetween(
          currentLatLng.latitude, currentLatLng.longitude, a.latitude, a.longitude);
      final distB = Geolocator.distanceBetween(
          currentLatLng.latitude, currentLatLng.longitude, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });

    final LatLng origin = currentLatLng;
    final LatLng destination = stopLocations.last;
    final List<LatLng> waypoints = stopLocations.length > 1
        ? stopLocations.sublist(0, stopLocations.length - 1)
        : [];

    // Animate camera to user location
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng, 14),
      );
    }

    try {
      final polylinePoints = await RouteService.getDetailedRoutePolyline(
        origin: origin,
        destination: destination,
        waypoints: waypoints,
      );

      setState(() {
        _markers = markerSet;
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 4,
            points: polylinePoints,
          ),
        };
      });
    } catch (e) {
      print('Error fetching route: $e');
      setState(() {
        _markers = markerSet;
        _polylines.clear();
      });
    }
  }

  Future<void> _handleLocationPermission() async {
    if (await Permission.location.isGranted) return;

    final status = await Permission.location.request();
    if (!status.isGranted) {
      throw Exception("Location permission denied.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = _currentLocation ?? const LatLng(0.0236, 37.9062); // Kenya

    return Scaffold(
      appBar: AppBar(title: Text('${widget.order.id}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: _DetailRow(icon: Icons.person, text: widget.order.customerName),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: _DetailRow(icon: Icons.location_on, text: widget.order.deliveryAddress, maxLines: 3),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: _DetailRow(icon: Icons.access_time, text: widget.order.formattedOrderTime),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 24,
                      child: _DetailRow(icon: Icons.directions_car, text: widget.order.distanceString),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stop Items Section
          Expanded(
            flex: 2,
            child: SingleChildScrollView(child: _buildStopItems()),
          ),

          // Map Section
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.hardEdge,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: center, zoom: 12),
                  markers: _markers,
                  polylines: _polylines,
                  onMapCreated: (controller) => mapController = controller,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final int? maxLines;

  const _DetailRow({
    required this.icon,
    required this.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
