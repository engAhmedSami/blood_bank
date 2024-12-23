import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BloodInstructions extends StatelessWidget {
  const BloodInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Blood Instructions",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildSectionTitle("Additional tips before donating:"),
            buildBulletPoint(
                "Don't take aspirin for 2 days before your appointment."),
            buildBulletPoint(
                "Ask a friend to donate at the same time. You can support each other and do twice as much good!"),
            buildBulletPoint(
                "Download the Blood Bank App to receive appointment reminders, start your RapidPass and more."),
            const SizedBox(height: 16),
            buildSectionTitle("Additional tips the day of your donation:"),
            buildBulletPoint(
                "Drink an extra 16 oz. of water (or other nonalcoholic drink) before your appointment."),
            buildBulletPoint(
                "Eat a healthy meal, avoiding fatty foods like hamburgers, fries or ice cream."),
            buildBulletPoint(
                "Let us know if you have a preferred arm or particular vein that has been used successfully in the past to draw blood."),
            const SizedBox(height: 16),
            buildSectionTitle("Additional tips after donating:"),
            buildBulletPoint(
                "Keep the strip bandage on for the next several hours. To avoid a skin rash, clean the area around the bandage."),
            buildBulletPoint(
                "Don't do any heavy lifting or vigorous exercise for the rest of the day."),
            buildBulletPoint("Keep eating iron-rich foods."),
            const SizedBox(height: 16),
            buildSectionTitle("Blood type matching:"),
            const SizedBox(height: 16),
            SvgPicture.asset(Assets.imagesBloodmatch)
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
            ["o", "YOU CAN GIVE BLOOD TO", "YOU CAN RECEIVE BLOOD FROM"],
            isHeader: true,
          ),
          _buildTableRow(["A+", "A+, AB+", "A+, A-, O+, O-"],
              colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow(["O+", "O+, A+, B+, AB+", "O+, O-"],
              colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow(["B+", "B+, AB+", "B+, B-, O+, O-"],
              colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow(["AB+", "AB+", "EVERYONE"],
              colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow(["A-", "A-, A+, AB-, AB+", "A-, O-"],
              colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow(["O-", "EVERYONE", "O-"],
              colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow(["B-", "B-, B+, AB-, AB+", "B-, O-"],
              colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
          _buildTableRow(["AB-", "AB-, AB+", "AB-, A-, B-, O-"],
              colorColumn2: Colors.red.shade900, colorColumn3: Colors.black),
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
