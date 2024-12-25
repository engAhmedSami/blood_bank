import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class GenderDropdown extends StatefulWidget {
  final List<String> genders;
  final String? initialGender;
  final Function(String) onGenderSelected;

  const GenderDropdown({
    super.key,
    required this.genders,
    this.initialGender,
    required this.onGenderSelected,
  });

  @override
  GenderDropdownState createState() => GenderDropdownState();
}

class GenderDropdownState extends State<GenderDropdown> {
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGender,
      items: widget.genders.map((gender) {
        IconData icon = gender == 'Male' ? Icons.male : Icons.female;
        Color iconColor = gender == 'Male'
            ? AppColors.lightPrimaryColor
            : AppColors.orangeColor;

        return DropdownMenuItem(
          value: gender,
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 10),
              Text(
                gender,
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
          selectedGender = value!;
        });
        widget.onGenderSelected(value!);
      },
      decoration: InputDecoration(
        labelText: 'selectGender'.tr(context),
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
          value == null ? 'pleaseSelectGender'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}
