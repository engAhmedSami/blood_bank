import 'package:blood_bank/feature/notification/notification_service.dart';
import 'package:blood_bank/feature/splash/Presentation/views/splash_view.dart';
import 'package:flutter/material.dart';

class SplashInitializer extends StatefulWidget {
  const SplashInitializer({super.key});

  @override
  State<SplashInitializer> createState() => _SplashInitializerState();
}

class _SplashInitializerState extends State<SplashInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await NotificationService.instance.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return SplashView();
  }
}
