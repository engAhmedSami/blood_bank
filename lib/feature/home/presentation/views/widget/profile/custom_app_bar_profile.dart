import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomProfileHeader extends StatelessWidget {
  final String userName;
  final String userId;
  final String profileImageUrl;
  final VoidCallback? onBackPressed;
  final VoidCallback? onEditPressed;

  const CustomProfileHeader({
    super.key,
    required this.userName,
    required this.userId,
    required this.profileImageUrl,
    this.onBackPressed,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // أو أي ارتفاع مناسب
      child: Stack(
        children: [
          SvgPicture.asset(
            Assets.imagesAppBar,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: 220, // نفس ارتفاع الـ SizedBox
          ),
          Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: IconButton(
              icon: SvgPicture.asset(Assets.imagesChangeuserinfo),
              onPressed: onEditPressed,
            ),
          ),
          Positioned(
            top: 20,
            left: 125,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(profileImageUrl),
                  backgroundColor: Colors.white,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'User ID: $userId',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
