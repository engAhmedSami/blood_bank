import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart'; // استبدل بـ `Prefs`

class SettingsSwitch extends StatefulWidget {
  final String title;
  final String keyName; // Key for SharedPreferences

  const SettingsSwitch({
    super.key,
    required this.title,
    required this.keyName,
  });

  @override
  State<StatefulWidget> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _loadSwitchValue();
  }

  void _loadSwitchValue() {
    setState(() {
      _value = Prefs.getBool(widget.keyName); // استرجاع القيمة المحفوظة
    });
  }

  void _saveSwitchValue(bool value) {
    Prefs.setBool(widget.keyName, value); // حفظ القيمة الجديدة
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16),
        ),
        Switch(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value; // تحديث الحالة
            });
            _saveSwitchValue(value); // حفظ القيمة الجديدة
          },
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
