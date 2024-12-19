import 'package:flutter/material.dart';

class NotificationDetailPage extends StatelessWidget {
  final String payload;

  const NotificationDetailPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          payload,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
