import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:blood_bank/feature/notification/sql_helper_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
    succesTopSnackBar(context, ' All notifications deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
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

              return Slidable(
                key: ValueKey(notification['id']),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    CustomSlidableAction(
                      onPressed: (context) async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Notification'),
                              content: const Text(
                                  'Are you sure you want to delete this notification?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
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
                      backgroundColor: AppColors.primaryColor,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(height: 4),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      notification['photoUrl']?.isNotEmpty == true
                          ? notification['photoUrl']
                          : 'https://static.thenounproject.com/png/4644820-200.png',
                    ),
                  ),
                  title: Text(
                    notification['title'],
                    style: TextStyles.semiBold16,
                  ),
                  subtitle: Text(notification['body']),
                ),
              );
            },
          );
        },
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Notifications',
        style: TextStyles.semiBold19.copyWith(color: Colors.black),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.delete, color: AppColors.primaryColor),
          onPressed: () async {
            final confirm = await deleteDialogNotfication(context);

            if (confirm == true) {
              await _deleteAllNotifications();
            }
          },
        ),
      ],
    );
  }

  Future<bool?> deleteDialogNotfication(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete All Notifications'),
          content:
              const Text('Are you sure you want to delete all notifications?'),
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
  }
}
