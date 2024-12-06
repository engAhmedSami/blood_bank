import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/signup_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        top: 120,
        leadingIcon: Icons.arrow_back_ios_new_rounded,
        title: 'sign_up'.tr(context),
      ),
      body: const SignupViewBody(),
    );
  }
}
