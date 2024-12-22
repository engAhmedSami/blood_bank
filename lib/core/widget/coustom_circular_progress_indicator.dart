import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CoustomCircularProgressIndicator extends StatelessWidget {
  const CoustomCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 6.0, // Thicker indicator for a bolder appearance
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.backgroundColor,
        ), // Custom color from ColorsManager
        backgroundColor: AppColors.primaryColor
            .withValues(alpha: 0.3), // Use a softer background color
      ),
    );
  }
}
