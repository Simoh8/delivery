import 'package:flutter/material.dart';
import 'package:delivery/widgets/summary_card.dart';
import 'package:delivery/widgets/order_item_card.dart';
import 'package:delivery/models/order.dart';
import 'package:delivery/pages/transactions_page.dart';
import 'package:delivery/pages/messages_page.dart';
import 'package:delivery/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<OrderItemModel> orders = [
    OrderItemModel(
      id: 'ord_001',
      customerName: 'John Doe',
      customerPhone: '+1234567890',
      deliveryAddress: '123 Main St, Apt 4B',
      distance: 2.5,
      amount: 25.50,
      itemCount: 3,
      orderTime: DateTime.now().subtract(const Duration(minutes: 45)),
      status: OrderStatus.inTransit,
      items: [
        OrderItem(
          id: 'item_1',
          name: 'Vegetable Pizza',
          description: 'Large with extra cheese',
          quantity: 1,
          price: 12.99,
        ),
        OrderItem(
          id: 'item_2',
          name: 'Garlic Bread',
          description: 'With dipping sauce',
          quantity: 2,
          price: 6.25,
        ),
      ],
    ),
    OrderItemModel(
      id: 'ord_002',
      customerName: 'Jane Smith',
      customerPhone: '+1987654321',
      deliveryAddress: '456 Oak Avenue',
      distance: 1.8,
      amount: 18.75,
      itemCount: 2,
      orderTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: OrderStatus.pending,
      items: [
        OrderItem(
          id: 'item_3',
          name: 'Caesar Salad',
          description: 'With chicken',
          quantity: 1,
          price: 10.50,
        ),
        OrderItem(
          id: 'item_4',
          name: 'Mineral Water',
          description: '500ml bottle',
          quantity: 1,
          price: 8.25,
        ),
      ],
    ),
  ];

  final List<Widget> _pages = [
    Container(), // Placeholder - will be replaced
    const TransactionsPage(),
    const MessagesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    _pages[0] = _buildHomeContent();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Trips Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          )
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
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummarySection(),
            _earningsCard(),
            _buildRecentOrdersSection(),
            if (orders.isEmpty) _buildEmptyState(),
            ...orders.map((order) => OrderItemCard(order: order)).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Update data here
    });
  }

  Widget _buildSummarySection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Today\'s Summary',
          style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      const Row(
        children: [
          SummaryCard(title: 'Total Orders', value: '12', color: Colors.blue),
          SizedBox(width: 12),
          SummaryCard(title: 'Completed', value: '8', color: Colors.green),
          SizedBox(width: 12),
          SummaryCard(title: 'Pending', value: '4', color: Colors.orange),
        ],
      ),
    ],
  );

  Widget _earningsCard() => Card(
    margin: const EdgeInsets.symmetric(vertical: 16),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Today\'s Earnings',
                  style: Theme.of(context).textTheme.titleMedium),
              Icon(Icons.attach_money, color: Colors.green.shade700),
            ],
          ),
          const SizedBox(height: 8),
          const Text('\$245.50',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey[200],
            color: Colors.blue,
          ),
          const SizedBox(height: 8),
          const Text('70% of daily target achieved'),
        ],
      ),
    ),
  );

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

  void _viewAllOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionsPage()),
    );
  }
}