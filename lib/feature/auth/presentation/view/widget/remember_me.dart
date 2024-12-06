import 'package:blood_bank/feature/auth/presentation/view/widget/custom_check_box.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class RememberMe extends StatefulWidget {
  const RememberMe({super.key, required this.onChange});
  final ValueChanged<bool> onChange;

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe> {
  bool isTearmAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomCheckBox(
          width: 20,
          height: 20,
          size: 14,
          onChange: (value) {
            isTearmAccepted = value;
            widget.onChange(value);
            setState(() {});
          },
          isChecked: isTearmAccepted,
        ),
        const SizedBox(
          width: 4,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Remember me".tr(context),
              ),
            ],
          ),
          textAlign: TextAlign.left,
        )
      ],
    );
  }
}
