import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const CustomButton({required this.onPressed, super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6390cf), Color(0xFF2c2c68)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Builder(builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                Assets.imagesArrowRight,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
