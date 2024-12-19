import 'package:blood_bank/feature/notification/notification_detail_page.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationService.instance.notifications;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blueAccent, // تغيير لون الشريط العلوي
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return Card(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            elevation: 5, // إضافة ظل لزيادة التأثير الجمالي
            child: ListTile(
              leading: Icon(
                Icons.notifications,
                color: Colors.orange, // لون الأيقونة
              ),
              title: Text(
                notification['title']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                notification['body']!,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NotificationDetailPage(
                      payload:
                          'Title: ${notification['title']}\nBody: ${notification['body']}',
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
