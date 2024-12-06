import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/under_line.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/custom_check_box.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key, required this.onChange});
  final ValueChanged<bool> onChange;

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  bool isTearmAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCheckBox(
          onChange: (value) {
            isTearmAccepted = value;
            widget.onChange(value);
            setState(() {});
          },
          isChecked: isTearmAccepted,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "By creating an account, you agree to".tr(context),
                    style: TextStyles.semiBold14.copyWith(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {},
                    child: UnderLine(
                      child: Text(
                        "the terms".tr(context),
                        style: TextStyles.semiBold14,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: UnderLine(
                  child: Text(
                    "and conditions of our policy".tr(context),
                    style: TextStyles.semiBold14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
