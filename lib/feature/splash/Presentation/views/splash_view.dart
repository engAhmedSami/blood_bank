import 'package:blood_bank/feature/splash/presentation/views/widget/big_drop_animation.dart';
import 'package:blood_bank/feature/splash/presentation/views/widget/blood_drops_animation.dart';
import 'package:blood_bank/feature/splash/presentation/views/widget/center_logo_animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _dropsController;
  late AnimationController _bigDropMoveController;
  late AnimationController _logoController;

  late Animation<double> _bigDropYAnimation;
  late Animation<double> _logoScaleAnimation;

  List<double> _dropsXPositions = [];
  List<double> _dropsStartTimes = [];

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _dropsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    final random = Random();
    _dropsXPositions = List.generate(10, (_) => random.nextDouble());
    _dropsStartTimes = List.generate(10, (_) => random.nextDouble());

    _bigDropMoveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _bigDropYAnimation = Tween<double>(begin: -200, end: 200).animate(
      CurvedAnimation(parent: _bigDropMoveController, curve: Curves.easeOut),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _logoScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(seconds: 1));
    await _bigDropMoveController.forward();
    await _logoController.forward();
  }

  @override
  void dispose() {
    _dropsController.dispose();
    _bigDropMoveController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF630909),
      body: Stack(
        children: [
          WaterDropsAnimation(
            controller: _dropsController,
            dropsXPositions: _dropsXPositions,
            dropsStartTimes: _dropsStartTimes,
          ),
          BigDropAnimation(
            controller: _bigDropMoveController,
            animation: _bigDropYAnimation,
          ),
          CenterLogoAnimation(
            controller: _logoController,
            animation: _logoScaleAnimation,
          ),
        ],
      ),
    );
  }
}
