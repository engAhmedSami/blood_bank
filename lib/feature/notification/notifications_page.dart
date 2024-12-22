import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:blood_bank/feature/notification/sql_helper_notification.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<Map<String, dynamic>>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    _notificationsFuture = SQlHelperNotification().getNotifications();
  }

  Future<void> _deleteNotification(int id, int index) async {
    await SQlHelperNotification().deleteNotification(id);
    NotificationService.instance.notifications.removeAt(index);

    setState(() {
      _loadNotifications();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification deleted'),
      ),
    );
  }

  Future<void> _deleteAllNotifications() async {
    await SQlHelperNotification().deleteAllNotifications();
    NotificationService.instance.notifications.clear();

    setState(() {
      _loadNotifications();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications deleted'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete All Notifications'),
                    content: const Text(
                        'Are you sure you want to delete all notifications?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true) {
                await _deleteAllNotifications();
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Notifications Found'));
          }

          final notifications = snapshot.data as List<Map<String, dynamic>>;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    notification['photoUrl']?.isNotEmpty == true
                        ? notification['photoUrl']
                        : 'https://via.placeholder.com/150',
                  ),
                ),
                title: Text(notification['title']),
                subtitle: Text(notification['body']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Notification'),
                          content: const Text(
                              'Are you sure you want to delete this notification?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await _deleteNotification(
                        notification['id'] as int,
                        index,
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
