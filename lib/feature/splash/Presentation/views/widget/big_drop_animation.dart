import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BigDropAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> animation;

  const BigDropAnimation({
    super.key,
    required this.controller,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: animation.value,
          left: size.width / 3.3 - 50,
          child: SvgPicture.asset(
            Assets.imagesSplashHugeBlood,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
