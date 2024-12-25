import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/coustomAleartDiloage.dart';
import 'package:blood_bank/feature/auth/presentation/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/services/firebase_auth_service.dart';

class LogoutFeature extends StatelessWidget {
  final FirebaseAuthService authService = FirebaseAuthService();

  LogoutFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showLogoutConfirmationDialog(context);
      },
      child: Row(
        children: [
          Icon(Icons.logout, color: AppColors.primaryColor),
          const SizedBox(width: 10),
          Text(
            'Logout',
            style: TextStyles.semiBold16.copyWith(
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Confirm Logout',
          content: 'Are you sure you want to logout?',
          confirmText: 'Logout',
          cancelText: 'Cancel',
          onConfirm: () async {
            await _performLogout(context); // Perform logout
          },
          onCancel: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    try {
      await authService.signOut(); // Call the signOut function

      // Remove all previous routes and push the LoginView
      Navigator.of(context).pushAndRemoveUntil(
        buildPageRoute(const LoginView()),
        (Route<dynamic> route) => false, // This condition removes all routes
      );
    } catch (e) {
      failureTopSnackBar(context, ' Failed to logout: ${e.toString()}');
    }
  }
}
