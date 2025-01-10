// import 'package:blood_bank/core/utils/app_colors.dart';
// import 'package:blood_bank/core/utils/app_text_style.dart';
// import 'package:blood_bank/feature/localization/app_localizations.dart';
// import 'package:flutter/material.dart';

// class BloodTypeDropdown extends StatefulWidget {
//   final String? initialBloodType;
//   final Function(String) onBloodTypeSelected;

//   const BloodTypeDropdown({
//     super.key,
//     this.initialBloodType,
//     required this.onBloodTypeSelected,
//   });

//   @override
//   BloodTypeDropdownState createState() => BloodTypeDropdownState();
// }

// class BloodTypeDropdownState extends State<BloodTypeDropdown> {
//   String? selectedBloodType;

//   @override
//   void initState() {
//     super.initState();
//     selectedBloodType = widget.initialBloodType;
//   }

//   List<String> get _bloodTypes {
//     return [
//       'A+',
//       'A-',
//       'B+',
//       'B-',
//       'AB+',
//       'AB-',
//       'O+',
//       'O-',
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       value: selectedBloodType,
//       items: _bloodTypes
//           .map(
//             (type) => DropdownMenuItem(
//               value: type,
//               child: Text(
//                 type,
//                 style: TextStyles.semiBold14
//                     .copyWith(color: AppColors.lightPrimaryColor),
//               ),
//             ),
//           )
//           .toList(),
//       onChanged: (value) {
//         setState(() {
//           selectedBloodType = value!;
//         });
//         widget.onBloodTypeSelected(value!); // تم تحديث القيمة هنا
//       },
//       decoration: InputDecoration(
//         labelText: 'selectBloodType'.tr(context),
//         labelStyle:
//             TextStyles.semiBold14.copyWith(color: AppColors.primaryColor),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.primaryColor),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.lightPrimaryColor),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide(color: AppColors.primaryColorB),
//         ),
//       ),
//       icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
//       validator: (value) =>
//           value == null ? 'pleaseSelectBloodType'.tr(context) : null,
//       dropdownColor: AppColors.backgroundColor,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/core/utils/app_colors.dart';

class BloodTypeDropdown extends StatelessWidget {
  final String? selectedBloodType; // المفتاح المحدد مسبقًا
  final ValueChanged<String?> onChanged; // حدث عند تغيير القيمة

  const BloodTypeDropdown({
    super.key,
    this.selectedBloodType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> bloodTypes = [
      {'key': 'A+', 'name': 'A+'.tr(context), 'icon': Icons.bloodtype},
      {'key': 'A-', 'name': 'A-'.tr(context), 'icon': Icons.bloodtype},
      {'key': 'B+', 'name': 'B+'.tr(context), 'icon': Icons.bloodtype},
      {'key': 'B-', 'name': 'B-'.tr(context), 'icon': Icons.bloodtype},
      {'key': 'AB+', 'name': 'AB+'.tr(context), 'icon': Icons.bloodtype},
      {'key': 'AB-', 'name': 'AB-'.tr(context), 'icon': Icons.bloodtype},
      {'key': 'O+', 'name': 'O+'.tr(context), 'icon': Icons.bloodtype},
      {'key': 'O-', 'name': 'O-'.tr(context), 'icon': Icons.bloodtype},
    ];

    return DropdownButtonFormField<String>(
      value: selectedBloodType, // القيمة المحددة حاليًا
      items: bloodTypes.map((governorate) {
        return DropdownMenuItem<String>(
          value: governorate['key'] as String, // تخزين المفتاح
          child: Row(
            children: [
              Icon(
                governorate['icon'] as IconData, // الأيقونة
                color: AppColors.lightPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                governorate['name'] as String, // الاسم المترجم
                style: TextStyles.semiBold14.copyWith(
                  color: AppColors.lightPrimaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged, // تحديث القيمة عند التغيير
      decoration: InputDecoration(
        labelText: 'bloodType'.tr(context),
        labelStyle:
            TextStyles.semiBold14.copyWith(color: AppColors.backgroundColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColorB),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
      validator: (value) =>
          value == null ? 'pleaseSelectBloodType'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}
