// import 'package:blood_bank/core/utils/app_colors.dart';
// import 'package:blood_bank/core/utils/app_text_style.dart';
// import 'package:flutter/material.dart';

// class CustomTextFormField extends StatelessWidget {
//   const CustomTextFormField({
//     super.key,
//     required this.hintText,
//     this.textInputType,
//     this.suffixIcon,
//     this.onSaved,
//     this.obobscureText = false, // Corrected typo here
//     this.controller,
//     this.validator,
//     this.prefixIcon,
//     this.onSubmitted,
//     this.maxLines, // Added this parameter
//   });

//   final String hintText;
//   final TextInputType? textInputType;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;
//   final void Function(String?)? onSaved;
//   final bool obobscureText; // Corrected typo here
//   final TextEditingController? controller;
//   final FormFieldValidator<String>? validator;
//   final void Function(String)? onSubmitted; // Added this parameter
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       maxLines: maxLines,
//       style: TextStyles.semiBold14,
//       controller: controller,
//       obscureText: obobscureText,
//       onSaved: onSaved,
//       validator: validator,
//       keyboardType: textInputType,
//       onFieldSubmitted: onSubmitted, // Use this for handling submissions
//       decoration: InputDecoration(
//         prefixIcon: prefixIcon,
//         suffixIcon: suffixIcon,
//         hintText: hintText,
//         filled: true,
//         fillColor: Colors.transparent,
//         border: buildBorder(),
//         enabledBorder: buildBorder(),
//         focusedBorder: buildBorder(),
//       ),
//     );
//   }

//   OutlineInputBorder buildBorder() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: const BorderSide(
//         width: 1,
//         color: AppColors.primaryColor,
//       ),
//     );
//   }
// }
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.textInputType,
    this.suffixIcon,
    this.onSaved,
    this.obobscureText = false, // Corrected typo here
    this.controller,
    this.validator,
    this.prefixIcon,
    this.onSubmitted,
    this.maxLines,
    this.readOnly = false, // Added readOnly
    this.onTap, // Added onTap
  });

  final String hintText;
  final TextInputType? textInputType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function(String?)? onSaved;
  final bool obobscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final bool readOnly; // Added readOnly
  final VoidCallback? onTap; // Added onTap

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      style: TextStyles.semiBold14,
      controller: controller,
      obscureText: obobscureText,
      onSaved: onSaved,
      validator: validator,
      keyboardType: textInputType,
      onFieldSubmitted: onSubmitted,
      readOnly: readOnly, // Use readOnly
      onTap: onTap, // Use onTap
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: 1,
        color: AppColors.primaryColor,
      ),
    );
  }
}
