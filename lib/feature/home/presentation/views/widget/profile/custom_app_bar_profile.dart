import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/editi_user_info.dart';

class CustomProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String name;
  final String? photoUrl;
  final String userState;

  const CustomProfileAppBar({
    super.key,
    required this.name,
    this.photoUrl,
    required this.userState,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          Assets.imagesAppBar,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: preferredSize.height,
        ),
        Positioned(
          top: 30,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {},
          ),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: IconButton(
            icon: SvgPicture.asset(Assets.imagesChangeuserinfo),
            onPressed: () {
              Navigator.of(context).push(
                buildPageRoute(
                  const UserProfilePage(),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 20,
          left: MediaQuery.of(context).size.width / 2.1 - 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                    ? NetworkImage(photoUrl!)
                    : null,
                backgroundColor: Colors.white,
                child: photoUrl == null || photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'State: $userState',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(220); // ارتفاع AppBar
}
