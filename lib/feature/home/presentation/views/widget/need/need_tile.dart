import 'dart:developer';

import 'package:blood_bank/core/helper_function/validators_textform.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/widget/coustom_aleart_diloage.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/need/need_details_screen.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NeedTile extends StatelessWidget {
  final String donationId;
  final Map<String, dynamic> data;

  const NeedTile({
    super.key,
    required this.donationId,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          data['patientName'] ?? 'no_name'.tr(context)), // Localized fallback
      subtitle: Text(
        '${'hospital'.tr(context)}: ${data['hospitalName'] ?? 'no_hospital'.tr(context)}', // Localized strings
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit button
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.primaryColorB,
            ),
            onPressed: () => _editDonation(context, donationId, data),
          ),
          // Delete button
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: AppColors.backgroundColor,
            ),
            onPressed: () => _deleteDonation(context, donationId),
          ),
        ],
      ),
      onTap: () {
        _handleDonationTap(
            context, donationId, data); // Pass data to handle tap
      },
    );
  }

  // Handle donation tap
  void _handleDonationTap(
      BuildContext context, String donationId, Map<String, dynamic> data) {
    // Navigate to the DonationDetailsScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NeedDetailsScreen(
          needData: data,
        ),
      ),
    );
  }

  // Edit donation
  void _editDonation(
      BuildContext context, String donationId, Map<String, dynamic> data) {
    // Open a dialog to edit the donation
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: data['name']);
        final hospitalController =
            TextEditingController(text: data['hospitalName']);
        final formKey = GlobalKey<FormState>(); // Form key for validation
        bool isLoading = false; // Loading state

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'edit_donation'.tr(context), // Localized title
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColorB,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'edit_donation_data'.tr(context),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name Field
                      CustomRequestTextField(
                        hintStyle: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                        controller: nameController,
                        hintText: 'Name'.tr(context),
                        validator: (value) =>
                            Validators.validateName(value, context),
                        onSaved: (value) {
                          log('Name: ${nameController.text} ${data['name']}');
                        },
                      ),
                      const SizedBox(height: 20), // Spacing between fields
                      // Hospital Field
                      CustomRequestTextField(
                        hintStyle: TextStyle(
                          color: AppColors.primaryColor,
                        ),
                        controller: hospitalController,
                        hintText: 'hospitalName'.tr(context),
                        validator: (value) =>
                            Validators.validateHospitalName(value, context),
                        onSaved: (value) {
                          log('Hospital Name: ${hospitalController.text}      ${data['hospitalName']}');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text(
                    'cancel'.tr(context), // Localized cancel button
                    style: const TextStyle(
                      color: Colors.black, // Dark text for contrast
                      fontSize: 16,
                    ),
                  ),
                ),
                // Save Button
                TextButton(
                  onPressed: isLoading
                      ? null // Disable button while loading
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true; // Show loading state
                            });

                            // Update the donation in Firestore
                            await FirebaseFirestore.instance
                                .collection('neederRequest')
                                .doc(donationId)
                                .update({
                              'name': nameController.text,
                              'hospitalName': hospitalController.text,
                            });

                            setState(() {
                              isLoading = false; // Hide loading state
                            });

                            Navigator.pop(context); // Close the dialog
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors
                                .primaryColor, // Loading indicator color
                          ),
                        )
                      : Text(
                          'Save'.tr(context), // Localized save button
                          style: const TextStyle(
                            color: AppColors
                                .primaryColor, // Primary color for text
                            fontSize: 16,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Delete donation
  void _deleteDonation(BuildContext context, String donationId) async {
    // Show a confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'delete_donation'.tr(context),
          content: 'confirm_delete_donation'.tr(context),
          confirmText: 'delete'.tr(context),
          cancelText: 'cancel'.tr(context),
          onConfirm: () {
            Navigator.pop(context, true); // Confirm deletion
          },
          onCancel: () {
            Navigator.pop(context, false); // Cancel deletion
          },
        );
      },
    );

    if (confirmed == true) {
      // Delete the donation from Firestore
      await FirebaseFirestore.instance
          .collection('neederRequest')
          .doc(donationId)
          .delete();
    }
  }
}
