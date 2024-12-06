import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WaterDropsAnimation extends StatelessWidget {
  final AnimationController controller;
  final List<double> dropsXPositions;
  final List<double> dropsStartTimes;

  const WaterDropsAnimation({
    super.key,
    required this.controller,
    required this.dropsXPositions,
    required this.dropsStartTimes,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          children: List.generate(10, (index) {
            final startTime = dropsStartTimes[index];
            final animationProgress = (controller.value - startTime) % 1.0;
            final dropX = dropsXPositions[index] * size.width;
            final dropY = animationProgress * size.height;

            return Positioned(
              left: dropX,
              top: dropY,
              child: SvgPicture.asset(
                Assets.imagesSplashDrop,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            );
          }),
        );
      },
    );
  }
}
