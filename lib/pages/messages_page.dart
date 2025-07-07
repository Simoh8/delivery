import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
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
        'sender': 'Restaurant',
        'text': 'Your pickup is ready at the counter',
        'time': 'Yesterday',
        'read': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: messages.length,
      //   itemBuilder: (context, index) {
      //     final message = messages[index];
      //     return ListTile(
      //         leading: CircleAvatar(
      //         child: Text(message['sender'].toString().substring(0, 1)),
      //       title: Text(
      //       message['sender'].toString(),
      //       style: TextStyle(
      //       fontWeight: message['read'] as bool ? FontWeight.normal : FontWeight.bold,
      //       ),
      //       ),
      //     subtitle: Text(message['text'].toString()),  // Fixed subtitle usage
      //     trailing: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //     Text(
      //     message['time'].toString(),
      //     style: const TextStyle(fontSize: 12),
      //     ),
      //     if (!(message['read'] as bool))
      //     Container(
      //     width: 10,
      //     height: 10,
      //     decoration: const BoxDecoration(
      //     color: Colors.blue,
      //     shape: BoxShape.circle,
      //     ),
      //     ),
      //     ],
      //     ),
      //     onTap: () => _showMessage(context, message),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {},
      ),
    );
  }

  void _showMessage(BuildContext context, Map<String, dynamic> message) {
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