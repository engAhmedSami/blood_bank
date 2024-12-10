// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/helper_function/failuer_top_snak_bar.dart';
import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/feature/auth/presentation/view/donor_or_need.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VerfiedEmailView extends StatefulWidget {
  const VerfiedEmailView({super.key});

  @override
  VerfiedEmailViewState createState() => VerfiedEmailViewState();
}

class VerfiedEmailViewState extends State<VerfiedEmailView> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();

        if (user.emailVerified) {
          timer.cancel();

          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            buildPageRoute(
              const DonorOrNeed(),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Verify Email',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Text(
              'Please verify your email address.',
              style: TextStyles.semiBold19,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SvgPicture.asset(Assets.imagesConfirmed, height: 300),
            const SizedBox(height: 50),
            CustomButton(
                onPressed: () => resendVerificationEmail(context),
                text: 'Resend Verification Email'),
          ],
        ),
      ),
    );
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      if (!mounted) return;

      succesTopSnackBar(context, 'Email verification link has been sent.');
    } else {
      failuerTopSnackBar(context, 'Unable to send verification email.');
    }
  }
}
