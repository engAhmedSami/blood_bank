// import 'package:blood_bank/core/utils/app_colors.dart';
// import 'package:blood_bank/core/utils/app_text_style.dart';
// import 'package:blood_bank/feature/localization/app_localizations.dart';
// import 'package:flutter/material.dart';

// class DonationTypeDropdown extends StatefulWidget {
//   final String? initialType;
//   final Function(String) onTypeSelected; // تعديل هنا لجعلها دالة

//   const DonationTypeDropdown({
//     super.key,
//     this.initialType,
//     required this.onTypeSelected,
//   });

//   @override
//   DonationTypeDropdownState createState() => DonationTypeDropdownState();
// }

// class DonationTypeDropdownState extends State<DonationTypeDropdown> {
//   String? selectedType;

//   @override
//   void initState() {
//     super.initState();
//     selectedType = widget.initialType;
//   }

//   List<String> get _donationTypes {
//     return [
//       'wholeBlood'.tr(context),
//       'plasma'.tr(context),
//       'platelets'.tr(context),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: selectedType,
//       items: _donationTypes.map((type) {
//         return DropdownMenuItem(
//           value: type,
//           child: Row(
//             children: [
//               Icon(
//                 Icons.bloodtype,
//                 color: AppColors.lightPrimaryColor,
//                 size: 20,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 type,
//                 style: TextStyles.semiBold14
//                     .copyWith(color: AppColors.lightPrimaryColor),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           selectedType = value!;
//         });
//         widget.onTypeSelected(value!); // استدعاء الدالة وتمرير القيمة المحددة
//       },
//       decoration: InputDecoration(
//         labelText: 'selectDonationType'.tr(context),
//         labelStyle:
//             TextStyles.semiBold14.copyWith(color: AppColors.lightPrimaryColor),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.lightPrimaryColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.primaryColor),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.primaryColorB),
//         ),
//       ),
//       icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
//       validator: (value) =>
//           value == null ? 'pleaseSelectDonationType'.tr(context) : null,
//       dropdownColor: AppColors.backgroundColor,
//     );
//   }
// }
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class DonationTypeDropdown extends StatefulWidget {
  final String? initialType;
  final Function(String) onTypeSelected;

  const DonationTypeDropdown({
    super.key,
    this.initialType,
    required this.onTypeSelected,
  });

  @override
  DonationTypeDropdownState createState() => DonationTypeDropdownState();
}

class DonationTypeDropdownState extends State<DonationTypeDropdown> {
  String? selectedKey;

  @override
  void initState() {
    super.initState();
    selectedKey = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    // خريطة التبرع
    final Map<String, String> donationTypesMap = {
      'wholeBlood': 'wholeBlood'.tr(context),
      'plasma': 'plasma'.tr(context),
      'platelets': 'platelets'.tr(context),
    };

    return DropdownButtonFormField<String>(
      value: selectedKey,
      items: donationTypesMap.keys.map((key) {
        return DropdownMenuItem(
          value: key,
          child: Row(
            children: [
              Icon(
                Icons.bloodtype,
                color: AppColors.lightPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                donationTypesMap[key]!,
                style: TextStyles.semiBold14
                    .copyWith(color: AppColors.lightPrimaryColor),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedKey = value!;
        });
        widget.onTypeSelected(value!); // إرجاع المفتاح
      },
      decoration: InputDecoration(
        labelText: 'selectDonationType'.tr(context),
        labelStyle: TextStyles.semiBold14.copyWith(
          color: AppColors.backgroundColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
      ),
      validator: (value) =>
          value == null ? 'pleaseSelectDonationType'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}
