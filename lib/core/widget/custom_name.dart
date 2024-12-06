import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomName extends StatelessWidget {
  const CustomName({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyles.regular16,
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
