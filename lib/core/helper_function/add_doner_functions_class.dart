import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/widget/coustom_dialog.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_cubit/add_doner_request_cubit.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddDonerFunctions {
  final BuildContext context;
  final FirebaseFirestore firestore;
  final User? user;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController idCardController;
  final TextEditingController medicalConditionsController;
  final TextEditingController contactController;
  final TextEditingController unitsController;
  final TextEditingController notesController;
  final TextEditingController addressController;
  final TextEditingController hospitalNameController;
  final TextEditingController distanceController;
  final TextEditingController bloodTypeController;
  final TextEditingController genderController;
  final TextEditingController lastdonationdateController;

  AddDonerFunctions({
    required this.context,
    required this.firestore,
    required this.user,
    required this.lastdonationdateController,
    required this.formKey,
    required this.nameController,
    required this.ageController,
    required this.idCardController,
    required this.medicalConditionsController,
    required this.contactController,
    required this.unitsController,
    required this.notesController,
    required this.addressController,
    required this.hospitalNameController,
    required this.distanceController,
    required this.bloodTypeController,
    required this.genderController,
  });

  Future<bool> _canSubmitNewRequest(String userId) async {
    final querySnapshot = await firestore
        .collection('donerRequest')
        .where('uId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return true; // No previous requests found, allow submission
    }

    final existingRequest = querySnapshot.docs.first.data();
    final Timestamp? lastDonationTimestamp =
        existingRequest['lastRequestDate'] as Timestamp?;

    final DateTime now = DateTime.now();

    if (lastDonationTimestamp != null) {
      final DateTime lastDonationDate = lastDonationTimestamp.toDate();
      final Duration difference = now.difference(lastDonationDate);
      const int requiredDays = 100; // Minimum days between donations

      if (difference.inDays < requiredDays) {
        final int remainingDays = requiredDays - difference.inDays;
        final DateTime nextDonationDate =
            lastDonationDate.add(const Duration(days: requiredDays));

        // Show alert dialog with remaining days and next donation date
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: 'donation_request_alert'.tr(context), // Localized title
              confirmText: 'ok'.tr(context), // Localized confirm button text
              content: '${'must_wait_days'.trWithParams(context, {
                    'remainingDays':
                        remainingDays.toString(), // Dynamic parameter
                  })}\n\n${'next_eligible_date'.trWithParams(context, {
                    'nextDonationDate': nextDonationDate
                        .toLocal()
                        .toString()
                        .split(' ')[0], // Dynamic parameter
                  })}',
            );
          },
        );

        return false; // Prevent submission
      }
    }

    return true; // Allow submission
  }

  void submitRequest({
    required String name,
    required num age,
    required String? bloodType,
    required String? donationType,
    required String? gender,
    required num idCard,
    required DateTime? lastDonationDate,
    required DateTime? nextDonationDate,
    required String medicalConditions,
    required num units,
    required num contact,
    required String? address,
    required String notes,
    required String hospitalName,
    required num distance,
  }) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (user == null) {
        failureTopSnackBar(context, 'User not authenticated');
        return;
      }
      final canSubmit = await _canSubmitNewRequest(user!.uid);
      if (!canSubmit) {
        return;
      }

      DonerRequestEntity request = DonerRequestEntity(
        name: name,
        age: age,
        bloodType: bloodType ?? '',
        donationType: donationType ?? '',
        gender: gender ?? '',
        idCard: idCard,
        lastDonationDate: lastDonationDate,
        nextDonationDate: nextDonationDate,
        medicalConditions: medicalConditions,
        units: units,
        contact: contact,
        address: address ?? '',
        notes: notes,
        uId: user!.uid,
        hospitalName: hospitalName,
        distance: distance,
        photoUrl: user!.photoURL,
        lastRequestDate: DateTime.now(),
      );

      context.read<AddDonerRequestCubit>().addRequest(request);

      successTopSnackBar(context, 'Request submitted successfully!');
      clearFormFields();
    } else {
      // Handle form validation errors
    }
  }

  void clearFormFields() {
    unitsController.clear();
    notesController.clear();
    addressController.clear();
    distanceController.clear();
    nameController.clear();
    ageController.clear();
    idCardController.clear();
    medicalConditionsController.clear();
    lastdonationdateController.clear();
    contactController.clear();
    hospitalNameController.clear();
    bloodTypeController.clear();
    genderController.clear();
  }
}
