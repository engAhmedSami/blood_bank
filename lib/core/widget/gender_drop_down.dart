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
