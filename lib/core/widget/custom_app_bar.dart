import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onBackPressed;
  final double? top;
  final double? left;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.leadingIcon,
    this.top = 100,
    this.left = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Stack(
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
              icon: Icon(leadingIcon, color: Colors.white),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(
            height: preferredSize.height,
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
