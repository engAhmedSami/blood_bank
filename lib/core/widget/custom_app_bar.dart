import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSkipPressed; // Callback for Skip button
  final double? top;
  final double? left;
  final String? skipText;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.leadingIcon,
    this.onSkipPressed, // Skip button handler
    this.top = 100,
    this.left = 100,
    this.skipText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            Assets.imagesAppBar,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: preferredSize.height,
          ),
          Positioned(
            top: 50,
            left: 16,
            child: IconButton(
              icon: Icon(
                leadingIcon,
                color: Colors.white,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 50,
            right: 25, // Position for the Skip button
            child: TextButton(
              onPressed: onSkipPressed, // Call the skip handler
              child: Text(
                skipText ?? '',
                style: TextStyles.bold16.copyWith(color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: top,
            left: left,
            child: Text(
              title,
              style: TextStyles.regular32.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(220);
}
