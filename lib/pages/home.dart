import 'package:flutter/material.dart';

// Models
enum TripStatus { assigned, inProgress, completed, delayed, cancelled }

class TripItem {
  final String id;
  final String name;
  final String description;
  final int quantity;

  TripItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
  });
}

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

// Widgets
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final TripModel trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trip.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(trip.deliveryAddress),
            const SizedBox(height: 8),
            Text('${trip.distance} km • ${trip.tripType}'),
          ],
        ),
      ),
    );
  }
}

// Pages
class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Trips Page'));
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Messages Page'));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile Page'));
  }
}

// Main Home Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  bool _isAvailable = true;

  final List<TripModel> _trips = [
    TripModel(
      id: 'TRIP-001',
      customerName: 'ABC Corporation',
      contactNumber: '+1234567890',
      deliveryAddress: '123 Industrial Zone, Warehouse 4B',
      distance: 8.5,
      items: [
        TripItem(
          id: 'item_1',
          name: 'Industrial Parts',
          description: 'SKU: IND-4567, Qty: 20',
          quantity: 1,
        ),
      ],
      tripType: 'Scheduled Delivery',
      priority: 'High',
      assignedTime: DateTime.now().subtract(const Duration(minutes: 30)),
      status: TripStatus.inProgress,
      expectedCompletion: DateTime.now().add(const Duration(hours: 2)),
    ),
    TripModel(
      id: 'TRIP-002',
      customerName: 'XYZ Retail',
      contactNumber: '+1987654321',
      deliveryAddress: '456 Commercial District, Shop 12',
      distance: 5.2,
      items: [
        TripItem(
          id: 'item_2',
          name: 'Retail Merchandise',
          description: 'SKU: RET-7890, Qty: 15 boxes',
          quantity: 1,
        ),
      ],
      tripType: 'Urgent Delivery',
      priority: 'Critical',
      assignedTime: DateTime.now().subtract(const Duration(hours: 1)),
      status: TripStatus.assigned,
      expectedCompletion: DateTime.now().add(const Duration(hours: 1)),
    ),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(),
      const TripsPage(),
      const MessagesPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ERPNext Driver Portal'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotifications,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          label: 'Trips',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) => setState(() => _currentIndex = index),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDriverStatus(),
            const SizedBox(height: 20),
            _buildSummarySection(),
            const SizedBox(height: 20),
            _buildCurrentTripSection(),
            const SizedBox(height: 20),
            _buildRecentTripsHeader(),
            const SizedBox(height: 10),
            ..._trips.map((trip) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TripCard(trip: trip),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverStatus() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, Driver!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _isAvailable ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isAvailable ? 'Available for trips' : 'Not available',
                        style: TextStyle(
                          color: _isAvailable ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Switch(
              value: _isAvailable,
              onChanged: (value) => setState(() => _isAvailable = value),
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Performance',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              SummaryCard(
                title: 'Assigned Trips',
                value: '5',
                color: Colors.blue,
                icon: Icons.assignment,
              ),
              SizedBox(width: 12),
              SummaryCard(
                title: 'Completed',
                value: '2',
                color: Colors.green,
                icon: Icons.check_circle,
              ),
              SizedBox(width: 12),
              SummaryCard(
                title: 'On Time',
                value: '2',
                color: Colors.teal,
                icon: Icons.timer,
              ),
              SizedBox(width: 12),
              SummaryCard(
                title: 'Delayed',
                value: '0',
                color: Colors.orange,
                icon: Icons.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTripSection() {
    final currentTrip = _trips.firstWhere(
          (trip) => trip.status == TripStatus.inProgress,
      orElse: () => _trips.first, // Fallback to first trip if none in progress
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Trip',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    currentTrip.priority,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: _getPriorityColor(currentTrip.priority),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTripInfoRow(
              icon: Icons.location_on,
              iconColor: Colors.blue,
              title: currentTrip.deliveryAddress,
              subtitle: '${currentTrip.distance.toStringAsFixed(1)} km away',
            ),
            const SizedBox(height: 8),
            _buildTripInfoRow(
              icon: Icons.access_time,
              iconColor: Colors.orange,
              title: 'Estimated Completion',
              subtitle: _formatTime(currentTrip.expectedCompletion),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            const Text('40% completed', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _viewTripDetails,
                    icon: const Icon(Icons.info, size: 20),
                    label: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _startNavigation,
                    icon: const Icon(Icons.directions, size: 20),
                    label: const Text('Navigate'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTripsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent Trips',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () => _viewAllTrips(context),
          child: const Text('View All'),
        ),
      ],
    );
  }

  Widget _buildTripInfoRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data refreshed')),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications clicked')),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _viewAllTrips(BuildContext context) {
    setState(() => _currentIndex = 1); // Switch to Trips tab
  }

  void _viewTripDetails() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View trip details')),
    );
  }

  void _startNavigation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting navigation')),
    );
  }
}