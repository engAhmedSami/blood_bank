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
  Size get preferredSize => const Size.fromHeight(220); // ارتفاع AppBar
}

class _CustomProfileAppBarState extends State<CustomProfileAppBar> {
  final GlobalKey _editButtonKey = GlobalKey(); // مفتاح التركيز على الزر
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
      // استخدم uid كمفتاح للتحقق من حالة التعليمات لهذا المستخدم
      final tutorialKey = '${user.uid}_isFirstTimeCustomProfileAppBar';
      bool isFirstTime = prefs.getBool(tutorialKey) ?? true;

      if (isFirstTime) {
        _showTutorial();
        await prefs.setBool(tutorialKey, false); // حفظ الحالة للمستخدم
      }
    }
  }

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(), // إنشاء أهداف التوجيه
      textSkip: "SKIP",
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
        keyTarget: _editButtonKey, // الزر الذي نريد التركيز عليه
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Edit User Info",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Tap here to update your profile information.",
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
            key: _editButtonKey, // ربط المفتاح بالزر
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
                'State: ${widget.userState}',
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
