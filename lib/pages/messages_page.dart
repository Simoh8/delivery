import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages(); // Initial fetch
    // Optionally, set up polling or Firestore/Firebase stream here
  }

  void fetchMessages() {
    // Replace this with API call or Firestore listener
    setState(() {
      messages = [
        {
          'sender': 'Customer Support',
          'text': 'Your recent order has been delivered successfully',
          'time': '10:30 AM',
          'read': false,
        },
        {
          'sender': 'John Doe',
          'text': 'Where is my order? It\'s been 30 minutes',
          'time': '9:45 AM',
          'read': true,
        },
        {
          'sender': 'Dispatcher',
          'text': 'You’ve been assigned a new delivery route.',
          'time': '9:30 AM',
          'read': false,
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchMessages, // Manual refresh for now
          ),
        ],
      ),
      body: messages.isEmpty
          ? const Center(child: Text("No notifications"))
          : ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(message['sender'].toString()[0]),
            ),
            title: Text(
              message['sender'].toString(),
              style: TextStyle(
                fontWeight: message['read'] ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            subtitle: Text(message['text'].toString()),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  message['time'].toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                if (!(message['read'] as bool))
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            onTap: () => _showMessage(context, message),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.notifications),
        onPressed: fetchMessages,
      ),
    );
  }

  void _showMessage(BuildContext context, Map<String, dynamic> message) {
    setState(() {
      message['read'] = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message['sender'].toString()),
        content: Text(message['text'].toString()),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
