import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.isChecked,
    required this.onChange,
    this.width = 24,
    this.height = 24,
    this.size = 16,
  });
  final bool isChecked;
  final ValueChanged<bool> onChange;
  final double? width;
  final double? height;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange(!isChecked);
      },
      child: AnimatedContainer(
        width: width,
        height: height,
        duration: const Duration(milliseconds: 100),
        decoration: ShapeDecoration(
          color: isChecked ? AppColors.primaryColor : Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.5,
              color: isChecked ? Colors.transparent : const Color(0xffdcdede),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isChecked
            ? Padding(
                padding: EdgeInsets.all(2),
                child: Icon(
                  Icons.check,
                  size: size,
                  color: Colors.white,
                ))
            : const SizedBox(),
      ),
    );
  }
}
