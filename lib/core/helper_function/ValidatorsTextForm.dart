import 'dart:developer'; // Import the developer package for logging
import 'package:flutter/material.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';

class Validators {
  static String? validateName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      log('Name validation failed: Field is empty');
      return 'please_enter_name'.tr(context);
    }
    log('Name validation passed: $value');
    return null;
  }

  static String? validateAge(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      log('Age validation failed: Field is empty');
      return 'ageError'.tr(context);
    }
    log('Age validation passed: $value');
    return null;
  }

  static String? validateIdCard(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      log('ID Card validation failed: Field is empty');
      return 'idCardError'.tr(context);
    }

    // Check if the value is a valid integer
    if (int.tryParse(value) == null) {
      log('ID Card validation failed: Not a valid integer');
      return 'ID Card must be a number'.tr(context);
    }

    // Check if the value has more than 11 digits
    if (value.length > 11) {
      log('ID Card validation failed: Exceeds 11 digits');
      return 'ID Card must be at most 11 digits'.tr(context);
    }

    log('ID Card validation passed: $value');
    return null;
  }

  static String? validateContactNumber(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      log('Contact Number validation failed: Field is empty');
      return 'contactNumberError'.tr(context);
    }
    log('Contact Number validation passed: $value');
    return null;
  }

  static String? validateHospitalName(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      log('Hospital Name validation failed: Field is empty');
      return 'hospitalNameError'.tr(context);
    }
    log('Hospital Name validation passed: $value');
    return null;
  }

  static String? validateUnitsRequired(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      log('Units Required validation failed: Field is empty');
      return 'Please enter the units required'.tr(context);
    }
    log('Units Required validation passed: $value');
    return null;
  }

  static String? validateDistance(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      log('Distance validation failed: Field is empty');
      return 'Please enter the distance'.tr(context);
    }
    log('Distance validation passed: $value');
    return null;
  }

  static String? validateDate(DateTime? value, BuildContext context) {
    if (value == null) {
      log('Date validation failed: No date selected');
      return 'pleaseSelectDate'.tr(context);
    }
    log('Date validation passed: $value');
    return null;
  }
}
