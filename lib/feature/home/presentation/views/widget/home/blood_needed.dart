import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/home/blood_drop.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class BloodNeededWidget extends StatelessWidget {
  final List<String> bloodTypes = ['B+', 'O+', 'AB+', 'O-', 'AB-', 'A+'];
  final List<double> bloodFillPercentages = [1.0, 0.25, 0.75, 0.0, 0.25, 0.5];

  BloodNeededWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: kHorizintalPadding),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'blood_needed'.tr(context),
            style: TextStyles.semiBold16,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(bloodTypes.length, (index) {
              return BloodDropWidget(
                bloodType: bloodTypes[index],
                fillPercentage: bloodFillPercentages[index],
              );
            }),
          ),
        ],
      ),
    );
  }
}
