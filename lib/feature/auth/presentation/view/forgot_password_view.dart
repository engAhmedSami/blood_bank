import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/forgot_password_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        top: 120,
        left: 50,
        title: 'Forgot Password'.tr(context),
        leadingIcon: Icons.arrow_back_ios_new_rounded,
      ),
      body: ForgotPasswordViewBody(),
    );
  }
}
