import 'package:blood_bank/core/utils/app_text_style.dart';
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
      "Cairo",
      "Alexandria",
      "Giza",
      "Dakahlia",
      "Red Sea",
      "Beheira",
      "Fayoum",
      "Gharbia",
      "Ismailia",
      "Menofia",
      "Minya",
      "Qaliubiya",
      "New Valley",
      "Suez",
      "Aswan",
      "Assiut",
      "Beni Suef",
      "Port Said",
      "Damietta",
      "Sharkia",
      "South Sinai",
      "Kafr El Sheikh",
      "Matrouh",
      "North Sinai",
      "Qena",
      "Sohag",
      "Luxor",
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
        hintText: 'Select Governorate',
        hintStyle: TextStyles.semiBold14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) =>
          value == null ? 'Please select a governorate' : null,
    );
  }
}
