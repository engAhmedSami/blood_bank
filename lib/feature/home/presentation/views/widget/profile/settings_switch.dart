import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsSwitch extends StatefulWidget {
  final String title;
  final bool value;

  const SettingsSwitch({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _SettingsSwitchState();
  }
}

class _SettingsSwitchState extends State<SettingsSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
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
              _value = value;
            });
          },
          activeColor: AppColors.primaryColor,
        ),
      ],
    );
  }
}
