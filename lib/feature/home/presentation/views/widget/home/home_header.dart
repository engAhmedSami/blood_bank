import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blood_bank/core/utils/assets_images.dart';

class HomeHeader extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final String userState;
  final String bloodType;

  const HomeHeader({
    super.key,
    required this.name,
    this.photoUrl,
    required this.userState,
    required this.bloodType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              Assets.imagesAppBar,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 30,
            left: 16,
            child: CircleAvatar(
              radius: 30,
              backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                  ? NetworkImage(photoUrl!)
                  : null,
              backgroundColor: Colors.white,
              child: photoUrl == null || photoUrl!.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          Positioned(
            top: 35,
            left: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello $name!',
                  style: TextStyles.semiBold16.copyWith(color: Colors.white),
                ),
                Text(
                  'User state: $userState',
                  style: TextStyles.regular13.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            top: 35,
            right: 50,
            child: IconButton(
              icon: SvgPicture.asset(
                Assets.imagesChat,
                width: 24,
                height: 24,
              ),
              onPressed: () {},
            ),
          ),
          Positioned(
            top: 35,
            right: 12,
            child: IconButton(
              icon: SvgPicture.asset(
                Assets.imagesNotfication,
                width: 24,
                height: 24,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
