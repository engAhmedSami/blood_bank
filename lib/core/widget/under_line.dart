import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UnderLine extends StatelessWidget {
  const UnderLine({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.darkPrimaryColor,
            ),
          ),
        ),
        child: child);
  }
}
