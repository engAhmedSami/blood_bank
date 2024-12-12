import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CustomProgrssHud extends StatelessWidget {
  const CustomProgrssHud({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: Center(
          child: CircularProgressIndicator(
            strokeWidth: 6.0, // سماكة المؤشر
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryColor, // لون متحرك
            ),
            backgroundColor: AppColors.orangeColor.withValues(
              alpha: 0.5,
            ), // لون الخلفية
          ),
        ),
        child: child,
      ),
    );
  }
}
