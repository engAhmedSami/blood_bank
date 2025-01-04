import 'dart:io';

import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_name.dart';
import 'package:blood_bank/core/widget/custom_text_field.dart';
import 'package:blood_bank/core/widget/under_line.dart';
import 'package:blood_bank/feature/auth/presentation/manager/signin_cubit/signin_cubit.dart';
import 'package:blood_bank/feature/auth/presentation/view/forgot_password_view.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/dont_have_an_account_widget.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/or_divider.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/password_field.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/remember_me.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'social_login_button.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String email, password;
  bool isRemembermeClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                "Welcome Back".tr(context),
                style: TextStyles.bold23,
              ),
              Text(
                "Let’s login for explore continues".tr(context),
                style: TextStyles.regular17,
              ),
              const SizedBox(height: 32),
              CustomName(text: "Email".tr(context)),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: emailController,
                hintText: "Enter your email".tr(context),
                textInputType: TextInputType.emailAddress,
                onSaved: (value) {
                  email = value!;
                },
              ),
              const SizedBox(height: 16),
              CustomName(text: "Password".tr(context)),
              const SizedBox(height: 8),
              PasswordField(
                hintText: '*********',
                controller: passwordController,
                onSaved: (value) {
                  password = value!;
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RememberMe(
                    onChange: (value) {
                      setState(() {
                        isRemembermeClicked = value;
                      });
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        buildPageRoute(
                          const ForgotPasswordView(),
                        ),
                      );
                    },
                    child: UnderLine(
                      child: Text(
                        "Forgot Password".tr(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      context.read<SigninCubit>().signIn(
                            email,
                            password,
                          );
                    }
                  },
                  text: "login".tr(context)),
              const SizedBox(height: 16),
              const DontHaveAnAccountWidget(),
              const SizedBox(height: 12),
              const OrDivider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialLoginButton(
                    onPressed: () {
                      context.read<SigninCubit>().signInWithGoogle();
                    },
                    image: Assets.imagesGoogel,
                  ),
                  const SizedBox(width: 24),
                  SocialLoginButton(
                    onPressed: () {},
                    image: Assets.imagesFacebook,
                  ),
                  // const SizedBox(width: 24),
                  Platform.isIOS
                      ? SocialLoginButton(
                          onPressed: () {},
                          image: Assets.imagesApple,
                        )
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
