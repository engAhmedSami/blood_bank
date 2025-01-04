import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CenterLogoAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation<double> animation;

  const CenterLogoAnimation({
    super.key,
    required this.controller,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            opacity: animation.value,
            child: Transform.scale(
              scale: animation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 130),
                  // SvgPicture.asset(Assets.imagesSplashLogo),
                  const SizedBox(height: 20),
                  SvgPicture.asset(
                    Assets.imagesFinallogoinside,
                    width: 200,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
