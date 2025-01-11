import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoColumn extends StatelessWidget {
  final String title;
  final String image;
  final bool isTodayDonationDay;
  const InfoColumn({
    super.key,
    required this.title,
    required this.image,
    this.isTodayDonationDay = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(image, height: 30),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: isTodayDonationDay
              ? TextStyles.semiBold13.copyWith(color: Colors.red)
              : TextStyles.semiBold13,
        ),
      ],
    );
  }
}
