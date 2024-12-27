import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/core/utils/app_colors.dart';

class StateDropdown extends StatelessWidget {
  final String? selectedKey; // المفتاح المحدد مسبقًا
  final ValueChanged<String?> onChanged; // حدث عند تغيير القيمة

  const StateDropdown({
    super.key,
    this.selectedKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> governorates = [
      {
        'key': 'doner',
        'name': 'doner'.tr(context),
        'icon': Icons.bloodtype,
      },
      {
        'key': 'need',
        'name': 'need'.tr(context),
        'icon': Icons.bloodtype,
      },
    ];

    return DropdownButtonFormField<String>(
      value: selectedKey, // القيمة المحددة حاليًا
      items: governorates.map((governorate) {
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
        labelText: 'state'.tr(context),
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
      validator: (value) => value == null ? 'user_state'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}
