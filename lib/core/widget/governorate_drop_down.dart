import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

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
    final List<String> governorates = [
      'Cairo'.tr(context),
      'Alexandria'.tr(context),
      'Giza'.tr(context),
      'Dakahlia'.tr(context),
      'Red Sea'.tr(context),
      'Beheira'.tr(context),
      'Fayoum'.tr(context),
      'Gharbia'.tr(context),
      'Ismailia'.tr(context),
      'Menofia'.tr(context),
      'Minya'.tr(context),
      'Qaliubiya'.tr(context),
      'New Valley'.tr(context),
      'Suez'.tr(context),
      'Aswan'.tr(context),
      'Assiut'.tr(context),
      'Beni Suef'.tr(context),
      'Port Said'.tr(context),
      'Damietta'.tr(context),
      'Sharkia'.tr(context),
      'South Sinai'.tr(context),
      'Kafr El Sheikh'.tr(context),
      'Matrouh'.tr(context),
      'North Sinai'.tr(context),
      'Qena'.tr(context),
      'Sohag'.tr(context),
      'Luxor'.tr(context),
    ];

    return DropdownButtonFormField<String>(
      value: selectedGovernorate,
      items: governorates
          .map(
            (governorate) => DropdownMenuItem(
              value: governorate,
              child: Text(
                governorate,
                style: TextStyles.semiBold14,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'select_governorate'.tr(context),
        hintStyle: TextStyles.semiBold14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) =>
          value == null ? 'please_select_governorate'.tr(context) : null,
    );
  }
}
