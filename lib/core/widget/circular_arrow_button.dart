import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CircularArrowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CircularArrowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Transform.rotate(
          angle: 3.14159265,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
