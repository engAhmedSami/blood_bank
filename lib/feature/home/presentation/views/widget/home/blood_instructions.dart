import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';

class BloodInstructions extends StatelessWidget {
  const BloodInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          "blood_instructions".tr(context),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSectionTitle("additional_tips_before".tr(context)),
            buildBulletPoint("no_aspirin".tr(context)),
            buildBulletPoint("ask_friend".tr(context)),
            buildBulletPoint("download_app".tr(context)),
            const SizedBox(height: 16),
            buildSectionTitle("additional_tips_day".tr(context)),
            buildBulletPoint("drink_extra_water".tr(context)),
            buildBulletPoint("eat_healthy_meal".tr(context)),
            buildBulletPoint("preferred_arm".tr(context)),
            const SizedBox(height: 16),
            buildSectionTitle("additional_tips_after".tr(context)),
            buildBulletPoint("keep_bandage".tr(context)),
            buildBulletPoint("no_heavy_lifting".tr(context)),
            buildBulletPoint("eat_iron_rich".tr(context)),
            const SizedBox(height: 16),
            buildSectionTitle("blood_type_matching".tr(context)),
            const SizedBox(height: 16),
            SvgPicture.asset(Assets.imagesBloodmatch),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(title,
        style: TextStyles.semiBold19.copyWith(
          color: AppColors.primaryColor,
        ));
  }

  Widget buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyles.semiBold19),
          Expanded(
            child: Text(text, style: TextStyles.regular16),
          ),
        ],
      ),
    );
  }

  Widget buildBloodTypeTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        border: TableBorder.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        children: [
          _buildTableRow(
            [
              "blood_type".tr(context as BuildContext),
              "give_blood_to".tr(context as BuildContext),
              "receive_blood_from".tr(context as BuildContext)
            ],
            isHeader: true,
          ),
          _buildTableRow([
            "A+",
            "a_plus_give".tr(context as BuildContext),
            "a_plus_receive".tr(context as BuildContext)
          ], colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow([
            "O+",
            "o_plus_give".tr(context as BuildContext),
            "o_plus_receive".tr(context as BuildContext)
          ], colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow([
            "B+",
            "b_plus_give".tr(context as BuildContext),
            "b_plus_receive".tr(context as BuildContext)
          ], colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow([
            "AB+",
            "ab_plus_give".tr(context as BuildContext),
            "everyone".tr(context as BuildContext)
          ], colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow([
            "A-",
            "a_minus_give".tr(context as BuildContext),
            "a_minus_receive".tr(context as BuildContext)
          ], colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow([
            "O-",
            "everyone".tr(context as BuildContext),
            "o_minus_receive".tr(context as BuildContext)
          ], colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow([
            "B-",
            "b_minus_give".tr(context as BuildContext),
            "b_minus_receive".tr(context as BuildContext)
          ], colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow([
            "AB-",
            "ab_minus_give".tr(context as BuildContext),
            "ab_minus_receive".tr(context as BuildContext)
          ], colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
        ],
      ),
    );
  }

  TableRow _buildTableRow(
    List<String> cells, {
    bool isHeader = false,
    Color? colorColumn2,
    Color? colorColumn3,
  }) {
    return TableRow(
      decoration: isHeader
          ? const BoxDecoration(
              color: AppColors.primaryColor,
            )
          : null,
      children: cells.asMap().entries.map((entry) {
        int index = entry.key;
        String cell = entry.value;

        Color textColor = Colors.black;
        if (index == 1 && !isHeader) {
          textColor = colorColumn2 ?? Colors.black;
        } else if (index == 2 && !isHeader) {
          textColor = colorColumn3 ?? Colors.black;
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          alignment: Alignment.center,
          child: Text(
            cell,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : textColor,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
