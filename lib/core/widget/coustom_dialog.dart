import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String? title; // Optional Title text for the dialog
  final String? content; // Optional Content text for the dialog
  final String? confirmText; // Optional text for the confirm button
  final String? cancelText; // Optional text for the cancel button
  final Color? confirmButtonColor; // Optional color for confirm button
  final Color? cancelButtonColor; // Optional color for cancel button

  const CustomDialog({
    super.key,
    this.title,
    this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.confirmButtonColor,
    this.cancelButtonColor,
  });

  // This method checks if any of the fields (title or content) are empty.
  static void showIfScreenEmpty({
    required BuildContext context,
    required String? title,
    required String? content,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
    Color? confirmButtonColor,
    Color? cancelButtonColor,
  }) {
    // If title or content is empty, display the dialog
    if (title == null || title.isEmpty || content == null || content.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
            title: title,
            content: content,
            confirmText: confirmText,
            cancelText: cancelText,
            confirmButtonColor: confirmButtonColor,
            cancelButtonColor: cancelButtonColor,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: screenWidth * 0.8, // Set the width to 80% of the screen width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjusts based on content size
          children: [
            // Header with title and icon
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title ?? 'No Title', // Use title or fallback text
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Content text
            Text(
              content ?? 'No Content', // Use content or fallback text
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Action buttons: Cancel and Confirm
          ],
        ),
      ),
    );
  }
}
