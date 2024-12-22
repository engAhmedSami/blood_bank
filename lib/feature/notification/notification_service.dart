import 'dart:convert';
import 'dart:developer';
import 'package:blood_bank/feature/notification/notification_detail_page.dart';
import 'package:blood_bank/feature/notification/sql_helper_notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;
  bool _isMessageListenerAdded = false;

  final List<Map<String, dynamic>> _notifications = [];
  List<Map<String, dynamic>> get notifications => _notifications;

  // Future<void> initialize(BuildContext context) async {
  //   await _requestPermission();
  //   await setupFlutterNotifications(context);

  //   if (!_isMessageListenerAdded) {
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       _handleMessage(message, context);
  //     });
  //     _isMessageListenerAdded = true;
  //   }

  //   final token = await _messaging.getToken();
  //   log('FCM Token: $token');
  //   if (token != null) {
  //     await saveUserToken(token);
  //   }
  // }
  Future<void> initialize(BuildContext context) async {
    await _requestPermission();
    await setupFlutterNotifications(context);

    if (!_isMessageListenerAdded) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleMessage(message, context);
      });
      _isMessageListenerAdded = true;
    }

    // جلب الإشعارات المخزنة من قاعدة البيانات
    final savedNotifications = await SQlHelperNotification().getNotifications();
    _notifications
        .addAll(savedNotifications.map((e) => e.cast<String, String>()));

    final token = await _messaging.getToken();
    log('FCM Token: $token');
    if (token != null) {
      await saveUserToken(token);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications(BuildContext context) async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettingsDarwin = DarwinInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log('Notification clicked with payload: ${details.payload}');
        if (details.payload != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  NotificationDetailPage(payload: details.payload!),
            ),
          );
        }
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> saveUserToken(String token) async {
    final firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      final existingDoc =
          await firestore.collection('userTokens').doc(userId).get();

      if (existingDoc.exists && existingDoc['token'] == token) {
        log('Token already exists. Skipping save.');
        return;
      }

      await firestore.collection('userTokens').doc(userId).set({
        'token': token,
        'userId': userId,
      });
    }
  }

  Future<void> sendNotificationToAllUsers({
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    final firestore = FirebaseFirestore.instance;
    final tokensSnapshot = await firestore.collection('userTokens').get();

    if (tokensSnapshot.docs.isNotEmpty) {
      final tokens = tokensSnapshot.docs.map((doc) => doc['token']).toSet();
      for (final token in tokens) {
        await _sendNotificationViaRestApi(token, title, body, data);
      }
    }
  }

  Future<void> _sendNotificationViaRestApi(
    String token,
    String title,
    String body,
    Map<String, String> data,
  ) async {
    final accessToken = await getAccessToken();

    const serverUrl =
        'https://fcm.googleapis.com/v1/projects/news-app-478cb/messages:send';

    final message = {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": data,
      }
    };

    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      log('Notification sent successfully: ${response.body}');
    } else {
      log('Failed to send notification: ${response.body}');
    }
  }

  Future<String> getAccessToken() async {
    final serviceAccountCredentials =
        await rootBundle.loadString('assets/service_account_file.json');

    final serviceAccountCredentialsJson =
        json.decode(serviceAccountCredentials);

    final credentials =
        ServiceAccountCredentials.fromJson(serviceAccountCredentialsJson);

    final client = await clientViaServiceAccount(
      credentials,
      ['https://www.googleapis.com/auth/firebase.messaging'],
    );

    return client.credentials.accessToken.data;
  }

  Future<void> _handleMessage(
      RemoteMessage message, BuildContext context) async {
    final notification = message.notification;
    if (notification != null) {
      final data = {
        'title': notification.title ?? 'No title',
        'body': notification.body ?? 'No body',
        'user_name': message.data['user_name'] ?? 'Unknown',
        'user_email': message.data['user_email'] ?? 'Unknown',
        'photoUrl': message.data['photoUrl'] ?? '',
        'timestamp': DateTime.now().toIso8601String(),
      };

      // حفظ الإشعار في القائمة المحلية
      _notifications.add(data);

      // حفظ الإشعار في SQLite
      await SQlHelperNotification().insertNotification(data);

      // عرض الإشعار باستخدام الإشعارات المحلية
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  // Future<void> _handleMessage(
  //     RemoteMessage message, BuildContext context) async {
  //   final notification = message.notification;
  //   if (notification != null) {
  //     _notifications.add({
  //       'title': notification.title ?? 'No title',
  //       'body': notification.body ?? 'No body',
  //       'user_name': message.data['user_name'] ?? 'Unknown',
  //       'user_email': message.data['user_email'] ?? 'Unknown',
  //       'photoUrl': message.data['photoUrl'] ?? '',
  //       'timestamp': DateTime.now().toIso8601String(),
  //     });

  //     await _localNotifications.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'high_importance_channel',
  //           'High Importance Notifications',
  //           channelDescription:
  //               'This channel is used for important notifications.',
  //           importance: Importance.high,
  //           priority: Priority.high,
  //           icon: '@mipmap/ic_launcher',
  //         ),
  //         iOS: DarwinNotificationDetails(
  //           presentAlert: true,
  //           presentBadge: true,
  //           presentSound: true,
  //         ),
  //       ),
  //       payload: message.data.toString(),
  //     );
  //   }
  // }
}
