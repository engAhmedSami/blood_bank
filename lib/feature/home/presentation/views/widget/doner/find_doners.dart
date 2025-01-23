import 'dart:developer';
import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/coustom_circular_progress_indicator.dart';
import 'package:blood_bank/core/widget/governorate_drop_down.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'blood_group_selector.dart';
import 'units_dropdown.dart';
import 'package:blood_bank/core/widget/custom_button.dart';

class FindDonors extends StatefulWidget {
  const FindDonors({super.key});

  @override
  State<FindDonors> createState() => _FindDonorsState();
}

class _FindDonorsState extends State<FindDonors> {
  String? selectedBloodGroup;
  int selectedUnits = 1;
  String? location;
  bool isLoading = false;
  List<Map<String, dynamic>> donors = [];

  Future<void> findDonors() async {
    log("Selected Blood Group: $selectedBloodGroup");
    log("Location: $location");

    if (selectedBloodGroup == null || location == null || location!.isEmpty) {
      failureTopSnackBar(
        context,
        'please_fill_all_fields'.tr(
          context,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('donerRequest')
          .where('bloodType', isEqualTo: selectedBloodGroup)
          .where('address', isEqualTo: location)
          .get();

      final fetchedDonors = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      setState(() {
        donors = fetchedDonors;
      });
    } catch (e) {
      log("Error fetching donors: $e");
      failureTopSnackBar(context, 'failed_to_fetch_donors'.tr(context));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "choose_blood_group".tr(context),
                style: TextStyles.semiBold19,
              ),
              const SizedBox(height: 30),
              BloodGroupSelector(
                selectedBloodGroup: selectedBloodGroup,
                onSelect: (value) {
                  log("Blood Group Selected: $value");
                  setState(() {
                    selectedBloodGroup = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "blood_unit_needed".tr(context),
                    style: TextStyles.semiBold16,
                  ),
                  UnitsDropdown(
                    selectedUnits: selectedUnits,
                    onChanged: (value) {
                      setState(() {
                        selectedUnits = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "enter_location".tr(context),
                style: TextStyles.semiBold16,
              ),
              const SizedBox(height: 8),
              GovernorateDropdown(
                selectedKey: location,
                onChanged: (value) {
                  setState(() {
                    location = value;
                  });
                },
              ),
              const SizedBox(height: 60),
              CustomButton(
                onPressed: findDonors,
                text: 'find_donors_button'.tr(context),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Center(child: CoustomCircularProgressIndicator())
              else if (donors.isNotEmpty)
                Column(
                  children: donors.map((donor) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6, // تأثير الظل

                      color: Colors.white,
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(16), // إضافة padding داخلي
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.white, // لون الأيقونة
                          ),
                        ),
                        title: Text(
                          donor['name'] ?? "Unknown",
                          style: TextStyles.semiBold16.copyWith(
                              color:
                                  AppColors.primaryColor), // يمكن تغيير اللون
                        ),
                        subtitle: Text(
                          '${"location".tr(context)}: ${donor['address'].toString().tr(context)}, ${"blood_group".tr(context)}: ${donor['bloodType'].toString().tr(context)}',
                          style: TextStyles.regular13.copyWith(
                              color:
                                  AppColors.primaryColor), // يمكن تغيير اللون
                        ),
                        trailing: Text(
                          '${donor['units'] ?? "0"} ${"units".tr(context)}',
                          style: TextStyles.semiBold14.copyWith(
                              color:
                                  AppColors.primaryColor), // يمكن تغيير اللون
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                Center(
                  child: Text("no_donors_found".tr(context)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(
      "find_donors".tr(context),
      style: TextStyles.bold19.copyWith(color: Colors.black),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => Navigator.pop(context),
    ),
  );
}
