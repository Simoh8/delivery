import 'package:flutter/material.dart';
import 'package:delivery/widgets/summary_card.dart';
import 'package:delivery/widgets/order_item_card.dart';
import 'package:delivery/models/order.dart';
import 'package:delivery/pages/transactions_page.dart';
import 'package:delivery/pages/messages_page.dart';
import 'package:delivery/pages/profile_page.dart';
import 'package:delivery/services/session_manager.dart';
import 'package:delivery/services/order_service.dart';
import 'package:delivery/pages/splash.dart';
import 'package:delivery/utils/logout_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late Future<List<OrderItemModel>> _ordersFuture;

  final List<Widget> _pages = [
    Container(),
    const TransactionsPage(),
    const MessagesPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _ordersFuture = OrderService.getAssignedOrders();
  }

  @override
  Widget build(BuildContext context) {
    _pages[0] = _buildHomeContent();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Trips Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => LogoutHelper.showLogoutDialog(context),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Delivery Trips'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return FutureBuilder<List<OrderItemModel>>(
      future: _ordersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final orders = snapshot.data ?? [];

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummarySection(orders),
                _tripSummaryCard(orders),
                _buildRecentOrdersSection(),
                if (orders.isEmpty)
                  _buildEmptyState()
                else
                  ...orders.take(5).map((order) => OrderItemCard(order: order)).toList(), // Show only top 5
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummarySection(List<OrderItemModel> orders) {
    final completed = orders.where((o) => o.status == OrderStatus.delivered).length;
    final pending = orders.where((o) => o.status == OrderStatus.pending).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Summary',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90, // fixed card height
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth * 0.5;

              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: SummaryCard(
                      title: 'All Deliveries',
                      value: '${orders.length}',
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: cardWidth,
                    child: SummaryCard(
                      title: 'Completed',
                      value: '$completed',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: cardWidth,
                    child: SummaryCard(
                      title: 'Pending',
                      value: '$pending',
                      color: Colors.orange,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );



  }

  Widget _tripSummaryCard(List<OrderItemModel> orders) {
    final completed = orders.where((o) => o.status == OrderStatus.delivered).length;
    final total = orders.length;
    final percent = total == 0 ? 0.0 : completed / total;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Today\'s Deliveries',
                    style: Theme.of(context).textTheme.titleMedium),
                Icon(Icons.local_shipping, color: Colors.blue.shade700),
              ],
            ),
            const SizedBox(height: 8),
            Text('$completed Completed / $total Total',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Text('${(percent * 100).toStringAsFixed(0)}% of trips completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrdersSection() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Recent Assigned Delivery Trips',
            style: Theme.of(context).textTheme.titleLarge),
        TextButton(
          onPressed: () => _viewAllOrders(context),
          child: const Text('View All'),
        ),
      ],
    ),
  );

  Widget _buildEmptyState() => const Center(
    child: Padding(
      padding: EdgeInsets.all(32.0),
      child: Text('No orders today'),
    ),
  );

  Future<void> _refreshData() async {
    setState(() {
      _ordersFuture = OrderService.getAssignedOrders();
    });
  }

  void _viewAllOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionsPage()),
    );
  }

// Future<void> _handleLogout() async {
//   final confirmed = await showDialog<bool>(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: const Text('Logout'),
//       content: const Text('Are you sure you want to log out?'),
//       actions: [
//         TextButton(
//           child: const Text('Cancel'),
//           onPressed: () => Navigator.pop(context, false),
//         ),
//         ElevatedButton(
//           child: const Text('Logout'),
//           onPressed: () => Navigator.pop(context, true),
//         ),
//       ],
//     ),
//   );
//
//   if (confirmed == true) {
//     await SessionManager.logout();
//     if (mounted) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (_) => const SplashScreen()),
//             (route) => false,
//       );
//     }
//   }
// }

}
