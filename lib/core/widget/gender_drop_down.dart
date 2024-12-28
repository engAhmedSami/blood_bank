// import 'package:blood_bank/core/utils/app_colors.dart';
// import 'package:blood_bank/core/utils/app_text_style.dart';
// import 'package:blood_bank/feature/localization/app_localizations.dart';
// import 'package:flutter/material.dart';

// class GenderDropdown extends StatefulWidget {
//   final List<String> genders;
//   final String? initialGender;
//   final Function(String) onGenderSelected;

//   const GenderDropdown({
//     super.key,
//     required this.genders,
//     this.initialGender,
//     required this.onGenderSelected,
//   });

//   @override
//   GenderDropdownState createState() => GenderDropdownState();
// }

// class GenderDropdownState extends State<GenderDropdown> {
//   String? selectedGender;

//   @override
//   void initState() {
//     super.initState();
//     // التحقق من أن القيمة الافتراضية موجودة ضمن القائمة
//     selectedGender = widget.genders.contains(widget.initialGender)
//         ? widget.initialGender
//         : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // خريطة للأيقونات والألوان
//     final Map<String, IconData> genderIcons = {
//       'Male': Icons.male,
//       'Female': Icons.female,
//     };

//     final Map<String, Color> genderColors = {
//       'Male': AppColors.lightPrimaryColor,
//       'Female': AppColors.orangeColor,
//     };

//     return DropdownButtonFormField<String>(
//       value: selectedGender,
//       items: widget.genders.map((gender) {
//         return DropdownMenuItem(
//           value: gender,
//           child: Row(
//             children: [
//               Icon(
//                 genderIcons[gender] ?? Icons.person, // افتراضي لأي جنس غير معرف
//                 color: genderColors[gender] ?? AppColors.lightPrimaryColor,
//                 size: 20,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 gender,
//                 style: TextStyles.semiBold14.copyWith(
//                   color: genderColors[gender] ?? AppColors.orangeColor,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//       onChanged: (value) {
//         setState(() {
//           selectedGender = value!;
//         });
//         widget.onGenderSelected(value!); // تمرير القيمة المحددة إلى الدالة
//       },
//       decoration: InputDecoration(
//         labelText: 'selectGender'.tr(context),
//         labelStyle: TextStyles.semiBold14.copyWith(
//           color: AppColors.lightPrimaryColor,
//         ),
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
//           value == null ? 'pleaseSelectGender'.tr(context) : null,
//       dropdownColor: AppColors.backgroundColor,
//     );
//   }
// }
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class GenderDropdown extends StatefulWidget {
  final String? initialGender;
  final Function(String) onGenderSelected;

  const GenderDropdown({
    super.key,
    this.initialGender,
    required this.onGenderSelected,
  });

  @override
  GenderDropdownState createState() => GenderDropdownState();
}

class GenderDropdownState extends State<GenderDropdown> {
  String? selectedKey;

  @override
  void initState() {
    super.initState();
    selectedKey = widget.initialGender; // القيمة الافتراضية
  }

  @override
  Widget build(BuildContext context) {
    // خريطة القيم الثابتة مع النصوص المترجمة
    final Map<String, String> genderMap = {
      'male': 'male'.tr(context),
      'female': 'female'.tr(context),
    };

    // أيقونات للجنس
    final Map<String, IconData> genderIcons = {
      'male': Icons.male,
      'female': Icons.female,
    };

    return DropdownButtonFormField<String>(
      value: selectedKey,
      items: genderMap.keys.map((key) {
        return DropdownMenuItem(
          value: key,
          child: Row(
            children: [
              Icon(
                genderIcons[key] ?? Icons.person,
                color: AppColors.lightPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                genderMap[key]!,
                style: TextStyles.semiBold14.copyWith(
                  color: AppColors.lightPrimaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedKey = value!;
        });
        widget.onGenderSelected(value!); // إرجاع المفتاح
      },
      decoration: InputDecoration(
        labelText: 'selectGender'.tr(context),
        labelStyle:
            TextStyles.semiBold14.copyWith(color: AppColors.backgroundColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
      ),
      validator: (value) =>
          value == null ? 'pleaseSelectGender'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}
