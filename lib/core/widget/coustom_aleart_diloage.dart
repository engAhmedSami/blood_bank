import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAlertDialog extends StatelessWidget {
  String title; // Title text for the dialog
  String content; // Content text for the dialog
  String confirmText; // Text for the confirm button
  String cancelText; // Text for the cancel button
  VoidCallback onConfirm; // Callback for confirm button press
  VoidCallback onCancel; // Callback for cancel button press
  Color? confirmButtonColor; // Optional color for confirm button
  Color? cancelButtonColor; // Optional color for cancel button
  CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
    this.confirmButtonColor,
    this.cancelButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 10),
          Text(
            title, // Title text passed as parameter
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          content, // Content text passed as parameter
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: cancelButtonColor ??
                Colors.grey[300], // Use passed color or default
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: onCancel,
          child: Text(
            cancelText, // Cancel button text passed as parameter
            style: const TextStyle(
              color: Colors.black, // Dark text for contrast
              fontSize: 16,
            ),
          ), // Cancel button callback passed as parameter
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: confirmButtonColor ?? AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: onConfirm,
          child: Text(
            confirmText, // Confirm button text passed as parameter
            style: const TextStyle(
              color: Colors.white, // White text for contrast
              fontSize: 16,
            ),
          ), // Confirm button callback passed as parameter
        ),
      ],
    );
  }
}
