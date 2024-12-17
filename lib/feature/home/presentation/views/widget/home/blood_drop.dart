import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BloodDropWidget extends StatelessWidget {
  final String bloodType;
  final double fillPercentage;

  const BloodDropWidget({
    super.key,
    required this.bloodType,
    required this.fillPercentage,
  });

  SvgPicture getImagePath() {
    if (fillPercentage == 1.0) {
      return SvgPicture.asset(Assets.imagesFulldrop);
    } else if (fillPercentage == 0.5) {
      return SvgPicture.asset(Assets.imagesHalfdrop);
    } else if (fillPercentage == 0.25) {
      return SvgPicture.asset(Assets.imagesQuerterdrop);
    } else if (fillPercentage == 0.75) {
      return SvgPicture.asset(Assets.imagesAbovehalfdrop);
    } else {
      return SvgPicture.asset(Assets.imagesEmptydrop);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getImagePath(),
        const SizedBox(height: 4),
        Text(
          bloodType,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
