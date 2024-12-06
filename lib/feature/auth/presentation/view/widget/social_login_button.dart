import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton(
      {super.key, required this.image, required this.onPressed});
  final String image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: SvgPicture.asset(
        image,
        fit: BoxFit.contain,
        height: 35,
      ),
    );
  }
}
