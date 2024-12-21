import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/request_for_blood_items.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/custom_card.dart';
import 'package:flutter/material.dart';

class CustomCardItems extends StatelessWidget {
  const CustomCardItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 25,
            children: [
              CustomCard(
                title: 'Find Donors',
                imagePath: Assets.imagesSearch,
                onTap: () {},
              ),
              CustomCard(
                title: 'Request                       for blood',
                imagePath: Assets.imagesRequest,
                onTap: () {
                  Navigator.of(context).push(
                    buildPageRoute(
                      const BloodRequestScreen(),
                    ),
                  );
                },
              ),
              CustomCard(
                title: 'Blood Instructions',
                imagePath: Assets.imagesInstructions,
                onTap: () {},
              ),
            ]),
      ),
    );
  }
}
