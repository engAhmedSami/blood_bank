import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class GovernorateDropdown extends StatelessWidget {
  final String? selectedGovernorateKey; // المفتاح المخزن
  final ValueChanged<String?> onChanged;

  const GovernorateDropdown({
    super.key,
    this.selectedGovernorateKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> governorates = {
      'cairo': 'Cairo',
      'alexandria': 'Alexandria',
      'giza': 'Giza',
      'dakahlia': 'Dakahlia',
      'red_sea': 'Red Sea',
      'beheira': 'Beheira',
      'fayoum': 'Fayoum',
      'gharbia': 'Gharbia',
      'ismailia': 'Ismailia',
      'menofia': 'Menofia',
      'minya': 'Minya',
      'qaliubiya': 'Qaliubiya',
      'new_valley': 'New Valley',
      'suez': 'Suez',
      'aswan': 'Aswan',
      'assiut': 'Assiut',
      'beni_suef': 'Beni Suef',
      'port_said': 'Port Said',
      'damietta': 'Damietta',
      'sharkia': 'Sharkia',
      'south_sinai': 'South Sinai',
      'kafr_el_sheikh': 'Kafr El Sheikh',
      'matrouh': 'Matrouh',
      'north_sinai': 'North Sinai',
      'qena': 'Qena',
      'sohag': 'Sohag',
      'luxor': 'Luxor',
    };

    return DropdownButtonFormField<String>(
      value: selectedGovernorateKey,
      items: governorates.entries
          .map(
            (entry) => DropdownMenuItem(
              value: entry.key, // Ensures unique value is used
              child: Text(
                entry.value.tr(context), // Translates the name dynamically
                style: TextStyles.semiBold14,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'select_governorate'.tr(context), // Dynamic translation
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
