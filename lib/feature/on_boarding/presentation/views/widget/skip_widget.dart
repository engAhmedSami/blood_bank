import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class SkipWidget extends StatelessWidget {
  const SkipWidget({
    super.key,
    required this.pageController,
    required this.currentPage,
  });
  final PageController pageController;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Visibility(
        visible: currentPage == 0 ? true : false,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: PopupMenuButton<String>(
            color: AppColors.primaryColor,
            onSelected: (value) {},
            icon: const Icon(
              Icons.language,
              color: Colors.white,
              size: 22,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'en',
                child: Text('English', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'ar',
                child: Text('العربية', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      Visibility(
        visible: currentPage == 0 ? false : true,
        child: GestureDetector(
          onTap: () {
            if (currentPage > 0) {
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
      const Spacer(),
      GestureDetector(
        onTap: () {
          pageController.animateToPage(3,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        child: Opacity(
          opacity: 0.5,
          child: Text(
            'Skip',
            style: TextStyles.bold19.copyWith(color: Colors.grey.shade900),
          ),
        ),
      ),
    ]);
  }
}
