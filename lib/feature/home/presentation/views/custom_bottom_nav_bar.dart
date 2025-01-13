import 'dart:async';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/doner_view.dart';
import 'package:blood_bank/feature/home/presentation/views/home_view.dart';
import 'package:blood_bank/feature/home/presentation/views/need_view.dart';
import 'package:blood_bank/feature/home/presentation/views/profile_view.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/chat_bot/chat_bot_view_body.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int selected = 0;
  final controller = PageController();
  bool shouldAnimateLottie = false;
  Timer? animationTimer;
  int animationCount = 0; // عداد الأنيميشن

  @override
  void initState() {
    super.initState();
    _startAnimationCycle();
  }

  void _startAnimationCycle() {
    // تشغيل الأنيميشن ثلاث مرات، ثم التوقف
    _playAnimationTwice();
    animationTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
      if (animationCount < 3) {
        _playAnimationTwice();
      } else {
        animationTimer?.cancel(); // إيقاف التايمر بعد ثلاث مرات
      }
    });
  }

  void _playAnimationTwice() async {
    if (animationCount >= 3) return; // إيقاف الأنيميشن بعد 3 مرات
    setState(() {
      shouldAnimateLottie = true;
      animationCount++; // زيادة العداد
    });
    await Future.delayed(const Duration(seconds: 3)); // الأنيميشن الأول
    await Future.delayed(const Duration(milliseconds: 500)); // فاصل قصير
    setState(() => shouldAnimateLottie = true);
    await Future.delayed(const Duration(seconds: 3)); // الأنيميشن الثاني
    setState(() => shouldAnimateLottie = false);
  }

  @override
  void dispose() {
    animationTimer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff800000),
      extendBody: true,
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeView(),
            NeedView(),
            DonerView(),
            ProfileView(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      height: 80,
      child: StylishBottomBar(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        option: DotBarOptions(
          dotStyle: DotStyle.tile,
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        items: [
          _buildBottomBarItem(Assets.imagesHome, 'home'.tr(context)),
          _buildBottomBarItem(Assets.imagesNeed, 'need'.tr(context)),
          _buildBottomBarItem(Assets.imagesDoner, 'doner'.tr(context)),
          _buildBottomBarItem(Assets.imagesProfile, 'profile'.tr(context)),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        notchStyle: NotchStyle.circle,
        onTap: (index) {
          if (index != selected) {
            setState(() {
              selected = index;
            });
            controller.jumpToPage(index);
          }
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      elevation: 15,
      shape: const CircleBorder(),
      onPressed: () {
        Navigator.of(context).push(
          buildPageRoute(
            const ChatBotViewBody(),
          ),
        );
      },
      backgroundColor: AppColors.primaryColor,
      child: Lottie.asset(
        'assets/chatbot.json',
        height: 40,
        width: 40,
        fit: BoxFit.contain,
        repeat: shouldAnimateLottie,
        animate: shouldAnimateLottie,
      ),
    );
  }

  BottomBarItem _buildBottomBarItem(String asset, String label) {
    return BottomBarItem(
      icon: SvgPicture.asset(
        asset,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        height: 28,
      ),
      selectedIcon: SvgPicture.asset(
        asset,
        height: 30,
      ),
      selectedColor: AppColors.primaryColor,
      title: Text(label),
    );
  }
}
