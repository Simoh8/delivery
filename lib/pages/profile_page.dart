import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://example.com/profile.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delivery Person',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'delivery@example.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildProfileCard(context),
            const SizedBox(height: 16),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileItem(Icons.phone, '+1 234 567 890'),
            const Divider(),
            _buildProfileItem(Icons.location_on, '123 Delivery St, City'),
            const Divider(),
            _buildProfileItem(Icons.two_wheeler, 'Motorcycle - ABC123'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text('152', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Deliveries'),
          ],
        ),
        Column(
          children: [
            Text('4.8', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Rating'),
          ],
        ),
        Column(
          children: [
            Text('\$2,450', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Earnings'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {},
          child: const Text('Edit Profile'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {},
          child: const Text('Log Out'),
        ),
      ],
    );
  }
}