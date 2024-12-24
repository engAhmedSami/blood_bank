import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/home/presentation/views/doner_view.dart';
import 'package:blood_bank/feature/home/presentation/views/home_view.dart';
import 'package:blood_bank/feature/home/presentation/views/need_view.dart';
import 'package:blood_bank/feature/home/presentation/views/profile_view.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int selected = 0;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff800000),
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 80,
        child: StylishBottomBar(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          option: DotBarOptions(
            dotStyle: DotStyle.tile,
            gradient: LinearGradient(
              colors: const [
                Colors.deepPurple,
                Colors.pink,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          items: [
            BottomBarItem(
              icon: SvgPicture.asset(
                Assets.imagesHome,
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              selectedIcon: SvgPicture.asset(Assets.imagesHome),
              selectedColor: AppColors.primaryColor,
              title: Text(
                'home'.tr(context),
              ),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                Assets.imagesNeed,
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
                height: 30,
              ),
              selectedIcon: SvgPicture.asset(
                Assets.imagesNeed,
                height: 30,
              ),
              selectedColor: AppColors.primaryColor,
              title: Text(
                'need'.tr(context),
              ),
            ),
            BottomBarItem(
                icon: SvgPicture.asset(
                  Assets.imagesDoner,
                  colorFilter: ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 30,
                ),
                selectedIcon: SvgPicture.asset(Assets.imagesDoner, height: 30),
                selectedColor: AppColors.primaryColor,
                title: Text(
                  'doner'.tr(context),
                )),
            BottomBarItem(
                icon: SvgPicture.asset(
                  Assets.imagesProfile,
                  colorFilter: ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 30,
                ),
                selectedIcon: SvgPicture.asset(
                  Assets.imagesProfile,
                  height: 30,
                ),
                selectedColor: AppColors.primaryColor,
                title: Text(
                  'profile'.tr(context),
                )),
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
              controller.jumpToPage(index); // Navigate only on tap
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        shape: CircleBorder(),
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
        child: SvgPicture.asset(Assets.imagesAdd),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(), // Disable swipe gesture
          children: const [
            HomeView(),
            NeedView(),
            DonerView(),
            ProfileView(),
          ],
        ),
      ),
    );
  }
}
