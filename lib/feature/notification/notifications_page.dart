import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // استيراد مكتبة intl
import 'notification_service.dart';
import 'notification_detail_page.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationService.instance.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      notification['photoUrl']?.isNotEmpty == true
                          ? notification['photoUrl']!
                          : 'https://via.placeholder.com/150',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
                title: Text(
                  notification['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['body']!,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Requested by: ${notification['user_name']} (${notification['user_email']})',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()), // عرض الوقت
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      DateFormat('d MMM, yyyy')
                          .format(DateTime.now()), // عرض التاريخ
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotificationDetailPage(
                        payload:
                            'Title: ${notification['title']}\nBody: ${notification['body']}\nRequested by: ${notification['user_name']} (${notification['user_email']})',
                      ),
                    ),
                  );
                },
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
            ],
          );
        },
      ),
    );
  }
}
