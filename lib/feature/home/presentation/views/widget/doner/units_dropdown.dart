import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class UnitsDropdown extends StatelessWidget {
  final int selectedUnits;
  final ValueChanged<int?> onChanged;

  const UnitsDropdown({
    super.key,
    required this.selectedUnits,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<int>(
        borderRadius: BorderRadius.circular(12),
        value: selectedUnits,
        dropdownColor: AppColors.primaryColor,
        style: TextStyles.bold19.copyWith(color: Colors.white),
        iconEnabledColor: Colors.white,
        items: List.generate(
          10,
          (index) => DropdownMenuItem<int>(
            value: index + 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
