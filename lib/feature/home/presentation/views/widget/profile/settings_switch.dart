import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart'; // استبدل بـ `Prefs`

class SettingsSwitch extends StatefulWidget {
  final String title;
  final String keyName; // Key for SharedPreferences
  final bool value; // قيمة الـ Switch
  final Function(bool) onChanged; // دالة التغيير

  const SettingsSwitch({
    super.key,
    required this.title,
    required this.keyName,
    required this.value,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => _SettingsSwitchState();
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value; // تعيين القيمة الأولية
    _loadSwitchValue();
  }

  void _loadSwitchValue() {
    setState(() {
      _value = Prefs.getBool(widget.keyName) ??
          widget.value; // استرجاع القيمة المحفوظة أو استخدام القيمة الافتراضية
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
            widget.onChanged(value); // استدعاء دالة التغيير
          },
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
