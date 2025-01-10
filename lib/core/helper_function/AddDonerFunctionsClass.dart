import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_cubit/add_doner_request_cubit.dart';
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

  AddDonerFunctions({
    required this.context,
    required this.firestore,
    required this.user,
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
      return true; // No previous requests found
    }

    final existingRequest = querySnapshot.docs.first.data();
    final Timestamp? lastRequestTimestamp =
        existingRequest['lastRequestDate'] as Timestamp?;
    final Timestamp? nextDonationTimestamp =
        existingRequest['nextDonationDate'] as Timestamp?;

    final DateTime now = DateTime.now();
    DateTime? nextDonationDate;

    if (nextDonationTimestamp != null) {
      nextDonationDate = nextDonationTimestamp.toDate();
    }

    if (lastRequestTimestamp != null) {
      final DateTime lastRequestDate = lastRequestTimestamp.toDate();
      if (lastRequestDate.year == now.year &&
          lastRequestDate.month == now.month &&
          lastRequestDate.day == now.day) {
        String additionalMessage = '';
        if (nextDonationDate != null && now.isBefore(nextDonationDate)) {
          additionalMessage =
              '\nAnd your next eligible request date is ${nextDonationDate.toLocal().toString().split(' ')[0]}.';
        }

        successTopSnackBar(
            context, 'You have already submitted a request $additionalMessage');
        return false;
      }
    }

    // If current date is before `nextDonationDate`
    if (nextDonationDate != null && now.isBefore(nextDonationDate)) {
      successTopSnackBar(context,
          'You can submit a new request after ${nextDonationDate.toLocal().toString().split(' ')[0]}');

      return false;
    }

    return true; // Allow submitting a new request
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
    contactController.clear();
    hospitalNameController.clear();
    bloodTypeController.clear();
    genderController.clear();
  }

  DropdownButtonFormField<String> genderDropDown(List<String> genders) {
    return DropdownButtonFormField<String>(
      value: genderController.text.isNotEmpty ? genderController.text : null,
      items: genders
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(
                  gender,
                  style: TextStyles.semiBold14,
                ),
              ))
          .toList(),
      onChanged: (value) {
        genderController.text = value ?? '';
      },
      decoration: InputDecoration(
        hintText: 'Select Gender',
        hintStyle: TextStyles.semiBold14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) => value == null ? 'Please select gender' : null,
    );
  }
}
