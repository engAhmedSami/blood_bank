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
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
