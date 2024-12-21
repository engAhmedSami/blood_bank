import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BloodGroupSelector extends StatelessWidget {
  final String? selectedBloodGroup;
  final Function(String) onSelect;

  const BloodGroupSelector({
    super.key,
    required this.selectedBloodGroup,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: bloodGroups.map((bloodGroup) {
        final isSelected = bloodGroup['type'] == selectedBloodGroup;
        return GestureDetector(
          onTap: () => onSelect(bloodGroup['type']!),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: isSelected ? Colors.red.shade100 : Colors.white,
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : Colors.grey,
                width: isSelected ? 3 : 1,
              ),
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  Assets.imagesFinddoners,
                  height: 50,
                  width: 50,
                  fit: BoxFit.contain,
                ),
                Positioned(
                  bottom: 16,
                  child: Text(
                    bloodGroup['type']!,
                    style: TextStyles.bold19.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Blood groups data
final List<Map<String, String>> bloodGroups = [
  {'type': 'A+'},
  {'type': 'B+'},
  {'type': 'AB+'},
  {'type': 'O+'},
  {'type': 'A-'},
  {'type': 'B-'},
  {'type': 'AB-'},
  {'type': 'O-'},
];
