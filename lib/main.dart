// ignore_for_file: prefer_const_constructors

import 'package:blood_bank/feature/splash/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BloodBank());
}

class BloodBank extends StatelessWidget {
  const BloodBank({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'MPLUSRounded1c'),
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}
