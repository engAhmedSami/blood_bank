import 'package:flutter/material.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/core/utils/app_colors.dart';

class GovernorateDropdown extends StatelessWidget {
  final String? selectedKey; // المفتاح المحدد مسبقًا
  final ValueChanged<String?> onChanged; // حدث عند تغيير القيمة

  const GovernorateDropdown({
    super.key,
    this.selectedKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // خريطة المحافظات بالمفاتيح والأيقونات
    final List<Map<String, dynamic>> governorates = [
      {
        'key': 'cairo',
        'name': 'cairo'.tr(context),
        'icon': Icons.location_city
      },
      {
        'key': 'alexandria',
        'name': 'alexandria'.tr(context),
        'icon': Icons.beach_access
      },
      {'key': 'giza', 'name': 'giza'.tr(context), 'icon': Icons.terrain},
      {
        'key': 'dakahlia',
        'name': 'dakahlia'.tr(context),
        'icon': Icons.agriculture
      },
      {'key': 'red sea', 'name': 'red sea'.tr(context), 'icon': Icons.water},
      {'key': 'beheira', 'name': 'beheira'.tr(context), 'icon': Icons.grass},
      {'key': 'fayoum', 'name': 'fayoum'.tr(context), 'icon': Icons.search},
      {'key': 'gharbia', 'name': 'gharbia'.tr(context), 'icon': Icons.wb_sunny},
      {'key': 'ismailia', 'name': 'ismailia'.tr(context), 'icon': Icons.flag},
      {'key': 'menofia', 'name': 'menofia'.tr(context), 'icon': Icons.house},
      {'key': 'minya', 'name': 'minya'.tr(context), 'icon': Icons.location_on},
      {'key': 'qaliubiya', 'name': 'qaliubiya'.tr(context), 'icon': Icons.map},
      {
        'key': 'new valley',
        'name': 'new valley'.tr(context),
        'icon': Icons.eco
      },
      {'key': 'suez', 'name': 'suez'.tr(context), 'icon': Icons.anchor},
      {'key': 'aswan', 'name': 'aswan'.tr(context), 'icon': Icons.landscape},
      {'key': 'assiut', 'name': 'assiut'.tr(context), 'icon': Icons.park},
      {
        'key': 'beni suef',
        'name': 'beni suef'.tr(context),
        'icon': Icons.nature
      },
      {
        'key': 'port said',
        'name': 'port said'.tr(context),
        'icon': Icons.directions_boat
      },
      {'key': 'damietta', 'name': 'damietta'.tr(context), 'icon': Icons.anchor},
      {
        'key': 'sharkia',
        'name': 'sharkia'.tr(context),
        'icon': Icons.filter_vintage
      },
      {
        'key': 'south sinai',
        'name': 'south sinai'.tr(context),
        'icon': Icons.filter_drama
      },
      {
        'key': 'kafr el sheikh',
        'name': 'kafr el sheikh'.tr(context),
        'icon': Icons.flare
      },
      {
        'key': 'matrouh',
        'name': 'matrouh'.tr(context),
        'icon': Icons.filter_hdr
      },
      {
        'key': 'north sinai',
        'name': 'north sinai'.tr(context),
        'icon': Icons.ac_unit
      },
      {'key': 'qena', 'name': 'qena'.tr(context), 'icon': Icons.location_city},
      {'key': 'sohag', 'name': 'sohag'.tr(context), 'icon': Icons.terrain},
      {
        'key': 'luxor',
        'name': 'luxor'.tr(context),
        'icon': Icons.temple_buddhist
      },
    ];

    return DropdownButtonFormField<String>(
      value: selectedKey, // القيمة المحددة حاليًا
      items: governorates.map((governorate) {
        return DropdownMenuItem<String>(
          value: governorate['key'] as String, // تخزين المفتاح
          child: Row(
            children: [
              Icon(
                governorate['icon'] as IconData, // الأيقونة
                color: AppColors.lightPrimaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                governorate['name'] as String, // الاسم المترجم
                style: TextStyles.semiBold14.copyWith(
                  color: AppColors.lightPrimaryColor,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged, // تحديث القيمة عند التغيير
      decoration: InputDecoration(
        labelText: 'select_governorate'.tr(context),
        labelStyle:
            TextStyles.semiBold14.copyWith(color: AppColors.backgroundColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightPrimaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColorB),
        ),
      ),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
      validator: (value) =>
          value == null ? 'please_select_governorate'.tr(context) : null,
      dropdownColor: AppColors.backgroundColor,
    );
  }
}
