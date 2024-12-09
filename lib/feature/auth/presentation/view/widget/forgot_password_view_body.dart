import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_text_field.dart';
import 'package:blood_bank/feature/auth/presentation/manager/signin_cubit/signin_cubit.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            const SizedBox(height: 50),
            Text(
              'Enter Eamil'.tr(context),
              style: TextStyles.semiBold16,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 24),
            CustomTextFormField(
              hintText: 'Enter your email'.tr(context),
              textInputType: TextInputType.emailAddress,
              controller: emailController,
            ),
            const SizedBox(height: 24),
            CustomButton(
                onPressed: () {
                  context
                      .read<SigninCubit>()
                      .sendPasswordResetLink(emailController.text);
                },
                text: 'Send code'.tr(context)),
          ],
        ),
      ),
    );
  }
}
