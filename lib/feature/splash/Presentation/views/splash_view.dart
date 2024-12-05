import 'package:blood_bank/feature/splash/presentation/views/widget/big_drop_animation.dart';
import 'package:blood_bank/feature/splash/presentation/views/widget/blood_drops_animation.dart';
import 'package:blood_bank/feature/splash/presentation/views/widget/center_logo_animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:jumping_dot/jumping_dot.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  SplashViewState createState() => SplashViewState();
}

class SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _dropsController;
  late AnimationController _bigDropMoveController;
  late AnimationController _logoController;
  late AnimationController _fadeController;

  late Animation<double> _bigDropYAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;

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
    _bigDropYAnimation = Tween<double>(begin: -500, end: 200).animate(
      CurvedAnimation(parent: _bigDropMoveController, curve: Curves.easeOut),
    );

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _logoScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutBack,
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(seconds: 1));
    await _bigDropMoveController.forward();
    await _logoController.forward();
    _fadeController.forward(); // Start loading indicator fade animation
  }

  @override
  void dispose() {
    _dropsController.dispose();
    _bigDropMoveController.dispose();
    _logoController.dispose();
    _fadeController.dispose();
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: buildLoadingIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoadingIndicator() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Loading",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(width: 5),
          Transform.translate(
            offset: const Offset(0, 5),
            child: JumpingDots(
              color: Colors.white,
              verticalOffset: 6,
              animationDuration: const Duration(milliseconds: 200),
              radius: 6,
            ),
          ),
        ],
      ),
    );
  }
}
