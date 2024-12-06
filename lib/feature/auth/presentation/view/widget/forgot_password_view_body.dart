import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_text_field.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/widgets.dart';

class ForgotPasswordViewBody extends StatefulWidget {
  const ForgotPasswordViewBody({super.key});

  @override
  State<ForgotPasswordViewBody> createState() => _ForgotPasswordViewBodyState();
}

class _ForgotPasswordViewBodyState extends State<ForgotPasswordViewBody> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            // SvgPicture.asset(Assets.imagesForgotPassword, height: 350),
            const SizedBox(height: 24),
            Text(
              'Enter Eamil.'.tr(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              hintText: 'Email'.tr(context),
              textInputType: TextInputType.emailAddress,
              controller: emailController,
            ),
            const SizedBox(height: 24),
            CustomButton(onPressed: () {}, text: 'Send code'.tr(context)),
          ],
        ),
      ),
    );
  }
}
