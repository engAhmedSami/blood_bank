import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/on_boarding/presentation/views/widget/page_view_item.dart';
import 'package:flutter/material.dart';

class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: const [
        PageViewItem(
          image: Assets.imagesOnBordingOnBordingOne,
          titel: 'Easy Donor Search',
          subtitle:
              'Easy to find available donor nearby you will verify when they near your location ',
        ),
        PageViewItem(
          image: Assets.imagesOnBordingOnBordingTwo,
          titel: 'Track your Donor',
          subtitle:
              'you can track your donor’s location and know the estimated time to arrive',
        ),
        PageViewItem(
          image: Assets.imagesOnBordingOnBordingThree,
          titel: 'Emergency Post',
          subtitle:
              'you can post when you have emergency situation and the donors can find you easily to donate',
        ),
      ],
    );
  }
}
