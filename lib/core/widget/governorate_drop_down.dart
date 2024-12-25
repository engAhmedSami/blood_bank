import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/core/utils/app_colors.dart';

class GovernorateDropdown extends StatelessWidget {
  final String? selectedGovernorate;
  final ValueChanged<String?> onChanged;

  const GovernorateDropdown({
    super.key,
    this.selectedGovernorate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> governorates = [
      {'name': 'Cairo'.tr(context), 'icon': Icons.location_city},
      {'name': 'Alexandria'.tr(context), 'icon': Icons.beach_access},
      {'name': 'Giza'.tr(context), 'icon': Icons.terrain},
      {'name': 'Dakahlia'.tr(context), 'icon': Icons.agriculture},
      {'name': 'Red Sea'.tr(context), 'icon': Icons.water},
      {'name': 'Beheira'.tr(context), 'icon': Icons.grass},
      {'name': 'Fayoum'.tr(context), 'icon': Icons.search},
      {'name': 'Gharbia'.tr(context), 'icon': Icons.wb_sunny},
      {'name': 'Ismailia'.tr(context), 'icon': Icons.flag},
      {'name': 'Menofia'.tr(context), 'icon': Icons.house},
      {'name': 'Minya'.tr(context), 'icon': Icons.location_on},
      {'name': 'Qaliubiya'.tr(context), 'icon': Icons.map},
      {'name': 'New Valley'.tr(context), 'icon': Icons.eco},
      {'name': 'Suez'.tr(context), 'icon': Icons.anchor},
      {'name': 'Aswan'.tr(context), 'icon': Icons.landscape},
      {'name': 'Assiut'.tr(context), 'icon': Icons.park},
      {'name': 'Beni Suef'.tr(context), 'icon': Icons.nature},
      {'name': 'Port Said'.tr(context), 'icon': Icons.directions_boat},
      {'name': 'Damietta'.tr(context), 'icon': Icons.anchor},
      {'name': 'Sharkia'.tr(context), 'icon': Icons.filter_vintage},
      {'name': 'South Sinai'.tr(context), 'icon': Icons.filter_drama},
      {'name': 'Kafr El Sheikh'.tr(context), 'icon': Icons.flare},
      {'name': 'Matrouh'.tr(context), 'icon': Icons.filter_hdr},
      {'name': 'North Sinai'.tr(context), 'icon': Icons.ac_unit},
      {'name': 'Qena'.tr(context), 'icon': Icons.location_city},
      {'name': 'Sohag'.tr(context), 'icon': Icons.terrain},
      {'name': 'Luxor'.tr(context), 'icon': Icons.temple_buddhist},
    ];

    return DropdownButtonFormField<String>(
      value: selectedGovernorate,
      items: governorates
          .map(
            (governorate) => DropdownMenuItem<String>(
              value: governorate['name'] as String,
              child: Row(
                children: [
                  Icon(
                    governorate['icon'] as IconData,
                    color: AppColors.lightPrimaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    governorate['name'] as String,
                    style: TextStyles.semiBold14.copyWith(
                      color: AppColors.lightPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'select_governorate'.tr(context),
        labelStyle:
            TextStyles.semiBold14.copyWith(color: AppColors.lightPrimaryColor),
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
          value == null ? 'please_select_governorate'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}
