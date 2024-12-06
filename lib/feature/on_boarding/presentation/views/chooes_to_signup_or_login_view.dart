import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/widget/custom_botton.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/feature/on_boarding/presentation/views/widget/page_view_item.dart';
import 'package:flutter/material.dart';

class ChooesToSignupOrLoginView extends StatelessWidget {
  const ChooesToSignupOrLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PageViewItem(
            titel: 'title_on_boarding_four'.tr(context),
            subtitle: 'subtitle_on_boarding_four'.tr(context),
            image: Assets.imagesOnBordingOnBordingFour,
          ),
          SizedBox(
            height: 90,
          ),
          CustomBotton(
            onPressed: () {},
            text: 'sign_up'.tr(context),
          ),
          SizedBox(
            height: 19,
          ),
          CustomBotton(
            onPressed: () {},
            text: 'login'.tr(context),
            backgroundColor: Colors.transparent,
            color: AppColors.primaryColor,
          )
        ],
      ),
    ));
  }
}
