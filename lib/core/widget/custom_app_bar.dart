import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Stack(
        children: [
          // SvgPicture.asset(
          //   // Assets.imagesCurve,
          //   // fit: BoxFit.cover,
          //   // width: MediaQuery.of(context).size.width,
          //   height: preferredSize.height,
          // ),
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
          const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20),
              // child: Text(title,
              //     style: AppStyles.styleMedium32(context)
              //         .copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(210);
}
