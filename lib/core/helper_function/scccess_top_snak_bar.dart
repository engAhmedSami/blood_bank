import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void successTopSnackBar(BuildContext context, String message) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.success(
      textStyle: TextStyle(color: Colors.white),
      backgroundColor: AppColors.backgroundColor,
      message: message,
    ),
  );
}

void failureTopSnackBar(BuildContext context, String message) {
  return showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.error(
      textStyle: TextStyle(color: Colors.white),
      backgroundColor: AppColors.backgroundColor,
      message: message,
    ),
  );
}
