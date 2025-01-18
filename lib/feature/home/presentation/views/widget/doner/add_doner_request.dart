import 'dart:developer';

import 'package:blood_bank/core/helper_function/add_doner_functions_class.dart';
import 'package:blood_bank/core/helper_function/validators_textform.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/core/widget/blood_type_drop_down.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/core/widget/date_picker_field.dart';
import 'package:blood_bank/core/widget/donation_type_drop_down.dart';
import 'package:blood_bank/core/widget/gender_drop_down.dart';
import 'package:blood_bank/core/widget/governorate_drop_down.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonerRequest extends StatefulWidget {
  const DonerRequest({super.key});

  @override
  DonerRequestState createState() => DonerRequestState();
}

class DonerRequestState extends State<DonerRequest> {
  final _formKey = GlobalKey<FormState>();
  final User? _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController medicalConditionsController =
      TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController unitsController = TextEditingController();
  final TextEditingController idCardController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController lastDonationDateController =
      TextEditingController();
  final TextEditingController nextDonationDateController =
      TextEditingController();
  final TextEditingController donationTypeController = TextEditingController();

  late AddDonerFunctions _addDonerFunction;

  @override
  void initState() {
    super.initState();
    _addDonerFunction = AddDonerFunctions(
      context: context,
      firestore: _firestore,
      user: _user,
      formKey: _formKey,
      nameController: nameController,
      ageController: ageController,
      lastdonationdateController: lastDonationDateController,
      idCardController: idCardController,
      medicalConditionsController: medicalConditionsController,
      contactController: contactController,
      unitsController: unitsController,
      notesController: notesController,
      addressController: addressController,
      hospitalNameController: hospitalNameController,
      distanceController: distanceController,
      bloodTypeController: bloodTypeController,
      genderController: genderController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            spacing: 12,
            children: [
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: nameController,
                hintText: 'Name'.tr(context),
                validator: (value) => Validators.validateName(value, context),
                onSaved: (value) {
                  log('Name: ${nameController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: ageController,
                textInputType: TextInputType.number,
                validator: (value) => Validators.validateAge(value, context),
                hintText: 'age'.tr(context),
                onSaved: (value) {
                  log('Age: ${ageController.text}');
                },
              ),
              BloodTypeDropdown(
                selectedBloodType: bloodTypeController.text.isNotEmpty
                    ? bloodTypeController.text
                    : null,
                onChanged: (selectedBloodType) {
                  bloodTypeController.text = selectedBloodType ?? '';
                  log('Blood Type: ${bloodTypeController.text}');
                },
              ),
              DonationTypeDropdown(
                initialType: null,
                onTypeSelected: (selectedType) {
                  donationTypeController.text = selectedType;
                  log('Donation Type: ${donationTypeController.text}');
                },
              ),
              GovernorateDropdown(
                selectedKey: addressController.text.isNotEmpty
                    ? addressController.text
                    : null,
                onChanged: (value) {
                  addressController.text = value ?? '';
                  log('Address: ${addressController.text}');
                },
              ),
              GenderDropdown(
                onGenderSelected: (gender) {
                  genderController.text = gender;
                  log('Gender: ${genderController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: idCardController,
                hintText: '302090********* only 14'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) => Validators.validateIdCard(value, context),
                onSaved: (value) {
                  log('ID Card: ${idCardController.text}');
                },
              ),
              DatePickerField(
                controller: lastDonationDateController,
                hintStyle: TextStyle(color: AppColors.primaryColor),
                context: context,
                label: 'last_donation_date'.tr(context),
                selectedDate: null,
                onDateSelected: (date) {
                  lastDonationDateController.text =
                      date.toString().split(' ')[0];
                  log('Last Donation Date: ${lastDonationDateController.text}');
                },
                isNextDonationDate: false,
              ),
              DatePickerField(
                controller: nextDonationDateController,
                hintStyle: TextStyle(color: AppColors.primaryColor),
                context: context,
                label: 'next_donation_date'.tr(context),
                selectedDate: null,
                onDateSelected: (date) {
                  nextDonationDateController.text =
                      date.toString().split(' ')[0];
                  log('Next Donation Date: ${nextDonationDateController.text}');
                },
                isNextDonationDate: true,
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: medicalConditionsController,
                hintText: 'medicalConditions'.tr(context),
                maxLines: 3,
                onSaved: (value) {
                  log('Medical Conditions: ${medicalConditionsController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: unitsController,
                hintText: 'UnitsRequired'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) =>
                    Validators.validateUnitsRequired(value, context),
                onSaved: (value) {
                  log('Units Required: ${unitsController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: contactController,
                hintText: 'contactNumber'.tr(context),
                textInputType: TextInputType.phone,
                validator: (value) =>
                    Validators.validateContactNumber(value, context),
                onSaved: (value) {
                  log('Contact Number: ${contactController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: notesController,
                hintText: 'Notes'.tr(context),
                maxLines: 3,
                onSaved: (value) {
                  log('Notes: ${notesController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: hospitalNameController,
                hintText: 'hospitalName'.tr(context),
                validator: (value) =>
                    Validators.validateHospitalName(value, context),
                onSaved: (value) {
                  log('Hospital Name: ${hospitalNameController.text}');
                },
              ),
              CustomRequestTextField(
                hintStyle: TextStyle(color: AppColors.primaryColor),
                controller: distanceController,
                textInputType: TextInputType.number,
                hintText: 'Distance'.tr(context),
                validator: (value) =>
                    Validators.validateDistance(value, context),
                onSaved: (value) {
                  log('Distance: ${distanceController.text}');
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Submit Request'.tr(context),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    _addDonerFunction.submitRequest(
                      name: nameController.text,
                      age: num.parse(ageController.text),
                      bloodType: bloodTypeController.text,
                      donationType: donationTypeController.text,
                      gender: genderController.text,
                      idCard: num.parse(idCardController.text),
                      lastDonationDate:
                          lastDonationDateController.text.isNotEmpty
                              ? DateTime.parse(lastDonationDateController.text)
                              : null,
                      nextDonationDate:
                          nextDonationDateController.text.isNotEmpty
                              ? DateTime.parse(nextDonationDateController.text)
                              : null,
                      medicalConditions: medicalConditionsController.text,
                      units: num.parse(unitsController.text),
                      contact: num.parse(contactController.text),
                      address: addressController.text,
                      notes: notesController.text,
                      hospitalName: hospitalNameController.text,
                      distance: num.parse(distanceController.text),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
