import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/under_line.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class HaveAnAccountWidget extends StatelessWidget {
  const HaveAnAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account".tr(context),
          style: TextStyles.semiBold16.copyWith(color: Colors.grey),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: UnderLine(
            child: Text(
              'sign_up'.tr(context),
              style: TextStyles.semiBold14,
            ),
          ),
        ),
      ],
    );
  }
}
