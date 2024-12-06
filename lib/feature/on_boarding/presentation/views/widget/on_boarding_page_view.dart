import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/on_boarding/presentation/views/widget/page_view_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        PageViewItem(
          image: Assets.imagesOnBordingOnBordingOne,
          titel: "title_on_boarding_one".tr(context),
          subtitle: 'subtitle_on_boarding_one'.tr(context),
        ),
        PageViewItem(
          image: Assets.imagesOnBordingOnBordingTwo,
          titel: 'title_on_boarding_two'.tr(context),
          subtitle: 'subtitle_on_boarding_two'.tr(context),
        ),
        PageViewItem(
          image: Assets.imagesOnBordingOnBordingThree,
          titel: 'title_on_boarding_three'.tr(context),
          subtitle: 'subtitle_on_boarding_three'.tr(context),
        ),
      ],
    );
  }
}
