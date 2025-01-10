import 'package:flutter/material.dart';

import 'package:blood_bank/feature/localization/app_localizations.dart';

class Validators {
  static String? validateName(String? value, BuildContext context) {
    return value!.isEmpty ? 'please_enter_name'.tr(context) : null;
  }

  static String? validateAge(String? value, BuildContext context) {
    return value!.isEmpty ? 'ageError'.tr(context) : null;
  }

  static String? validateIdCard(String? value, BuildContext context) {
    return value!.isEmpty ? 'idCardError'.tr(context) : null;
  }

  static String? validateContactNumber(String? value, BuildContext context) {
    return value!.isEmpty ? 'contactNumberError'.tr(context) : null;
  }

  static String? validateHospitalName(String? value, BuildContext context) {
    return value!.isEmpty ? 'hospitalNameError'.tr(context) : null;
  }

  static String? validateUnitsRequired(String? value, BuildContext context) {
    return value!.isEmpty
        ? 'Please enter the units required'.tr(context)
        : null;
  }

  static String? validateDistance(String? value, BuildContext context) {
    return value!.isEmpty ? 'Please enter the distance'.tr(context) : null;
  }

  static String? validateDate(DateTime? value, BuildContext context) {
    return value == null ? 'pleaseSelectDate'.tr(context) : null;
  }
}
