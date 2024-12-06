import 'package:blood_bank/core/widget/custom_text_field.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.onSaved,
    required this.controller,
    required this.hintText,
    this.validator,
  });
  final void Function(String?)? onSaved;
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obobscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: widget.controller,
      obobscureText: obobscureText,
      onSaved: widget.onSaved,
      hintText: widget.hintText,
      textInputType: TextInputType.visiblePassword,
      validator: widget.validator,
      suffixIcon: GestureDetector(
        onTap: () {
          obobscureText = !obobscureText;
          setState(() {});
        },
        child: obobscureText
            ? const Icon(
                Icons.visibility_off,
                color: Color(0XFFC9CECF),
              )
            : const Icon(
                Icons.remove_red_eye,
                color: Color(0XFFC9CECF),
              ),
      ),
    );
  }
}
