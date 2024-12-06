import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.primaryColor,
            indent: 40,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          "or continue with".tr(context),
          style: TextStyles.semiBold16,
        ),
        const SizedBox(
          width: 8,
        ),
        const Expanded(
          child: Divider(
            color: AppColors.primaryColor,
            endIndent: 40,
          ),
        ),
      ],
    );
  }
}
