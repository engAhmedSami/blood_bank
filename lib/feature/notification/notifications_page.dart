import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/CoustomDialog.dart';
import 'package:blood_bank/core/widget/coustomAleartDiloage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'sql_helper_notification.dart';

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

  Future<void> _deleteNotification(int id) async {
    await SQlHelperNotification().deleteNotification(id);

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

    setState(() {
      _loadNotifications();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications deleted'),
      ),
    );
  }

  Future<bool?> deleteDialogNotfication(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Delete All Notifications',
          content: 'Are you sure you want to delete all notifications?',
          confirmText: 'Delete',
          cancelText: 'Cancel',
          onConfirm: () {
            Navigator.pop(context, true);
          },
          onCancel: () {
            Navigator.pop(context, false);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppbar(context),
      body: FutureBuilder(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: CoustomDialog(
              content: 'you don\'t have notifications yet',
              title: 'Alert for Notification',
            ));
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final id = notification['id'];

              return Slidable(
                key: ValueKey(id),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    CustomSlidableAction(
                      onPressed: (context) async {
                        await _deleteNotification(id);
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
      backgroundColor: Colors.white,
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
}
