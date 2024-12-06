import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Row(
      children: [
        Visibility(
          visible: currentPage == 0 ? true : false,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: BlocBuilder<LocaleCubit, ChangeLocaleState>(
              builder: (context, state) {
                return PopupMenuButton<String>(
                  color: AppColors.primaryColor,
                  onSelected: (value) {
                    context.read<LocaleCubit>().changeLanguage(value);
                  },
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 22,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'en',
                      child: Text(
                        'English',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'ar',
                      child: Text(
                        'العربية',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
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
        currentPage == 2
            ? const SizedBox()
            : GestureDetector(
                onTap: () {
                  pageController.animateToPage(3,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: Opacity(
                  opacity: 0.3,
                  child: Text(
                    'Skip'.tr(context),
                    style:
                        TextStyles.bold19.copyWith(color: Colors.grey.shade900),
                  ),
                ),
              ),
      ],
    );
  }
}
