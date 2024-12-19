import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondaryCustomButton extends StatelessWidget {
  const SecondaryCustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.image,
  });

  final VoidCallback onPressed;
  final String text;
  final Image? image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
          backgroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              Assets.imagesArrowRight,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
