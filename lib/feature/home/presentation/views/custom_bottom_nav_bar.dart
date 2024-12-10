import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/home/presentation/views/profile_view.dart';
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
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 80,
        child: StylishBottomBar(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          option: DotBarOptions(
            dotStyle: DotStyle.tile,
            gradient: const LinearGradient(
              colors: [
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
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              selectedIcon: SvgPicture.asset(Assets.imagesHome),
              selectedColor: AppColors.primaryColor,
              title: const Text('Home'),
            ),
            BottomBarItem(
              icon: SvgPicture.asset(
                Assets.imagesNeed,
                colorFilter: const ColorFilter.mode(
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
              title: const Text('Need'),
            ),
            BottomBarItem(
                icon: SvgPicture.asset(
                  Assets.imagesDoner,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                  height: 30,
                ),
                selectedIcon: SvgPicture.asset(Assets.imagesDoner, height: 30),
                selectedColor: AppColors.primaryColor,
                title: const Text('Doner')),
            BottomBarItem(
                icon: SvgPicture.asset(
                  Assets.imagesProfile,
                  colorFilter: const ColorFilter.mode(
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
                title: const Text('Profile')),
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
        shape: const CircleBorder(),
        onPressed: () {},
        backgroundColor: AppColors.primaryColor,
        child: SvgPicture.asset(Assets.imagesAdd),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics:
              const NeverScrollableScrollPhysics(), // Disable swipe gesture
          children: const [
            Center(child: Text('Home')),
            Center(child: Text('Doner')),
            Center(child: Text('Need')),
            ProfileView(),
          ],
        ),
      ),
    );
  }
}
