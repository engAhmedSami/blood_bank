import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:flutter/material.dart';

class BloodTypeDropdown extends StatefulWidget {
  final String? initialBloodType;
  final List<String> onBloodTypeSelected;

  const BloodTypeDropdown({
    super.key,
    this.initialBloodType,
    required this.onBloodTypeSelected,
  });

  @override
  _BloodTypeDropdownState createState() => _BloodTypeDropdownState();
}

class _BloodTypeDropdownState extends State<BloodTypeDropdown> {
  String? selectedBloodType;

  @override
  void initState() {
    super.initState();
    selectedBloodType = widget.initialBloodType;
  }

  List<String> get _bloodTypes {
    return [
      'bloodTypeAPlus'.tr(context),
      'bloodTypeAMinus'.tr(context),
      'bloodTypeBPlus'.tr(context),
      'bloodTypeBMinus'.tr(context),
      'bloodTypeOPlus'.tr(context),
      'bloodTypeOMinus'.tr(context),
      'bloodTypeABPlus'.tr(context),
      'bloodTypeABMinus'.tr(context),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedBloodType,
      items: _bloodTypes
          .map(
            (type) => DropdownMenuItem(
              value: type,
              child: Text(
                type,
                style: TextStyles.semiBold14
                    .copyWith(color: AppColors.lightPrimaryColor),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedBloodType = value!;
        });
        widget.onBloodTypeSelected;
      },
      decoration: InputDecoration(
        labelText: 'selectBloodType'.tr(context),
        labelStyle:
            TextStyles.semiBold14.copyWith(color: AppColors.primaryColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColorB),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
      validator: (value) =>
          value == null ? 'pleaseSelectBloodType'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}
