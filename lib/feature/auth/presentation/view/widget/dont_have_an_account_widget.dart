import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/under_line.dart';
import 'package:blood_bank/feature/auth/presentation/view/signup_view.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class DontHaveAnAccountWidget extends StatelessWidget {
  const DontHaveAnAccountWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account".tr(context),
          style: TextStyles.semiBold16.copyWith(color: Colors.grey),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              buildPageRoute(
                const SignupView(),
              ),
            );
          },
          child: UnderLine(
            child: Text(
              "Create your account".tr(context),
              style: TextStyles.semiBold14,
            ),
          ),
        ),
      ],
    );
  }
}
