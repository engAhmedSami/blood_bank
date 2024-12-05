import 'package:blood_bank/feature/splash/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BloodBank());
}

class BloodBank extends StatelessWidget {
  const BloodBank({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
