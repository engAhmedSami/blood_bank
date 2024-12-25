import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/widget/GenderDropdown.dart';
import 'package:blood_bank/core/widget/bloodTypeDropDown.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/core/widget/datePickerField.dart';
import 'package:blood_bank/core/widget/donationTypeDropDown.dart';
import 'package:blood_bank/core/widget/governorate_drop_down.dart';
import 'package:blood_bank/feature/home/domain/entities/doner_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_doner_request_cubit/add_doner_request_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  // Variables initialized with default values
  String name = '';
  String? address;
  String notes = '';
  String medicalConditions = '';
  String? bloodType;
  String? donationType;
  String? gender;
  DateTime? lastDonationDate;
  DateTime? nextDonationDate;
  num age = 0;
  num contact = 0;
  num units = 0;
  num idCard = 0;
  String hospitalName = '';
  num distance = 0;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void _clearFormFields() {
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
    setState(() {
      bloodType = null;
      donationType = null;
      gender = null;
      address = null;
      lastDonationDate = null;
      nextDonationDate = null;
    });
  }

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  final List<String> _donationTypes = [
    'Whole Blood',
    'Plasma',
    'Platelets',
  ];

  final List<String> _genders = ['Male', 'Female'];

  Future<bool> _canSubmitNewRequest(String userId) async {
    final querySnapshot = await _firestore
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

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_user == null) {
        failureTopSnackBar(context, 'User not authenticated');
        return;
      }
      final canSubmit = await _canSubmitNewRequest(_user.uid);
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
        uId: _user.uid,
        hospitalName: hospitalName,
        distance: distance,
        photoUrl: _user.photoURL,
        lastRequestDate: DateTime.now(),
      );

      context.read<AddDonerRequestCubit>().addRequest(request);

      successTopSnackBar(context, 'Request submitted successfully!');
      _clearFormFields();
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            spacing: 10,
            children: [
              CustomRequestTextField(
                controller: nameController,
                hintText: 'Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) {
                  name = value!;
                },
              ),
              CustomRequestTextField(
                controller: ageController,
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your age' : null,
                hintText: 'Age',
                onSaved: (value) {
                  age = num.parse(value!);
                },
              ),
              BloodTypeDropdown(onBloodTypeSelected: _bloodTypes),
              DonationTypeDropdown(onTypeSelected: _donationTypes),
              // donationTypeDropDown(),
              // genderDropDown(),

              GenderDropdown(
                genders: _genders,
                onGenderSelected: (gender) {
                  setState(() {
                    gender = gender;
                  });
                },
              ),

              CustomRequestTextField(
                controller: idCardController,
                hintText: 'National ID Number',
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your ID number' : null,
                onSaved: (value) {
                  idCard = num.parse(value!);
                },
              ),
              datePickerField(
                context: context,
                label: 'Last Donation Date',
                selectedDate: lastDonationDate,
                onDateSelected: (date) {
                  setState(() {
                    lastDonationDate = date;
                  });
                },
                isNextDonationDate: false,
              ),
              datePickerField(
                context: context,
                label: 'Next Donation Date',
                selectedDate: nextDonationDate,
                onDateSelected: (date) {
                  setState(() {
                    nextDonationDate = date;
                  });
                },
                isNextDonationDate: true,
              ),
              CustomRequestTextField(
                controller: medicalConditionsController,
                hintText: 'Medical Conditions',
                maxLines: 3,
                onSaved: (value) {
                  medicalConditions = value!;
                },
              ),
              CustomRequestTextField(
                controller: unitsController,
                hintText: 'Units Required',
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the units required' : null,
                onSaved: (value) {
                  units = num.parse(value!);
                },
              ),
              CustomRequestTextField(
                controller: contactController,
                hintText: 'Contact Number',
                textInputType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your contact number' : null,
                onSaved: (value) {
                  contact = num.parse(value!);
                },
              ),
              GovernorateDropdown(
                selectedGovernorate: address,
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
              ),
              CustomRequestTextField(
                controller: notesController,
                hintText: 'Notes',
                maxLines: 3,
                onSaved: (value) {
                  notes = value!;
                },
              ),
              CustomRequestTextField(
                controller: hospitalNameController,
                hintText: 'Hospital Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the hospital name' : null,
                onSaved: (value) {
                  hospitalName = value!;
                },
              ),
              CustomRequestTextField(
                  controller: distanceController,
                  textInputType: TextInputType.number,
                  hintText: 'Distance',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the distance' : null,
                  onSaved: (value) {
                    distance = num.parse(value!);
                  }),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Submit Request',
                onPressed: _submitRequest,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
