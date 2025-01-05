import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/editi_user_info.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomProfileAppBar extends StatefulWidget
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
  State<CustomProfileAppBar> createState() => _CustomProfileAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(220);
}

class _CustomProfileAppBarState extends State<CustomProfileAppBar> {
  final GlobalKey _editButtonKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    _checkIfTutorialNeeded();
  }

  Future<void> _checkIfTutorialNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final tutorialKey = '${user.uid}_isFirstTimeCustomProfileAppBar';
      bool isFirstTime = prefs.getBool(tutorialKey) ?? true;

      if (isFirstTime) {
        _showTutorial();
        await prefs.setBool(tutorialKey, false);
      }
    }
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      textSkip: "Skip".tr(context),
      hideSkip: false,
      onFinish: () {
        debugPrint("Tutorial finished");
      },
      onClickTarget: (target) {
        debugPrint("Clicked on target: ${target.keyTarget}");
      },
    )..show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        keyTarget: _editButtonKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "edit_user_info".tr(context),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "tap_here_to_update_your_profile_information".tr(context),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
        shape: ShapeLightFocus.Circle, // شكل التركيز دائري
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          Assets.imagesAppBar,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: widget.preferredSize.height,
        ),
        // Positioned(
        //   top: 30,
        //   left: 10,
        //   child: IconButton(
        //     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        //     onPressed: () {},
        //   ),
        // ),
        Positioned(
          top: 30,
          right: 10,
          child: IconButton(
            key: _editButtonKey, // Attach key to button
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
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    widget.photoUrl != null && widget.photoUrl!.isNotEmpty
                        ? NetworkImage(widget.photoUrl!)
                        : null,
                backgroundColor: Colors.white,
                child: widget.photoUrl == null || widget.photoUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '${'state'.tr(context)}: ${widget.userState}',
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
}
