import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/widget/blood_type_drop_down.dart';
import 'package:blood_bank/core/widget/gender_drop_down.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/core/widget/donation_type_drop_down.dart';
import 'package:blood_bank/core/widget/governorate_drop_down.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_need_request_cubit/add_need_request_cubit.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NeedRequest extends StatefulWidget {
  const NeedRequest({super.key});

  @override
  NeedRequestState createState() => NeedRequestState();
}

class NeedRequestState extends State<NeedRequest> {
  final _formKey = GlobalKey<FormState>();
  final User? _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Controllers
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController idCardController = TextEditingController();
  final TextEditingController medicalConditionsController =
      TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController hospitalNameController = TextEditingController();

  // ----------------- Form Fields -----------------
  String patientName = '';
  String? address;
  String medicalConditions = '';
  String? bloodType;
  String? donationType;
  String? gender;
  num age = 0;
  num contact = 0;
  num idCard = 0;
  String hospitalName = '';

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  void _clearFormFields() {
    patientNameController.clear();
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
    });
  }

  List<String> get bloodTypes {
    return [
      'A+'.tr(context),
      'A-'.tr(context),
      'B+'.tr(context),
      'B-'.tr(context),
      'O+'.tr(context),
      'O-'.tr(context),
      'AB+'.tr(context),
      'AB-'.tr(context),
    ];
  }

  List<String> get donationTypes {
    return [
      'wholeBlood'.tr(context),
      'plasma'.tr(context),
      'platelets'.tr(context),
    ];
  }

  List<String> get genders {
    return [
      'male'.tr(context),
      'female'.tr(context),
    ];
  }

  Future<bool> _canSubmitNewRequest(String userId) async {
    final querySnapshot = await _firestore
        .collection('neederRequest')
        .where('uId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      failureTopSnackBar(context, 'activeRequest'.tr(context));

      return false;
    }

    return true;
  }

  Widget datePickerField({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
    required bool isNextDonationDate,
  }) {
    return FormField<DateTime>(
      initialValue: selectedDate,
      validator: (value) {
        if (value == null) {
          return 'pleaseSelectDate'.tr(context); // Validation message
        }
        return null; // Return null if the date is selected
      },
      builder: (formFieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomRequestTextField(
              controller: TextEditingController(
                text: selectedDate != null
                    ? selectedDate.toLocal().toString().split(' ')[0]
                    : '',
              ),
              hintText: label,
              suffixIcon: const Icon(Icons.calendar_today),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate:
                      isNextDonationDate ? DateTime.now() : DateTime(2000),
                  lastDate: isNextDonationDate
                      ? DateTime.now().add(const Duration(days: 365 * 11))
                      : DateTime.now(),
                );
                if (date != null) {
                  onDateSelected(date);
                  formFieldState.didChange(date); // Update the FormField value
                }
              },
            ),
            if (formFieldState.hasError) // Check if there's an error
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  formFieldState.errorText!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
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

      NeederRequestEntity request = NeederRequestEntity(
        patientName: patientName,
        age: age,
        bloodType: bloodType ?? '',
        donationType: donationType ?? '',
        gender: gender ?? '',
        idCard: idCard,
        medicalConditions: medicalConditions,
        contact: contact,
        address: address ?? '',
        uId: _user.uid,
        hospitalName: hospitalName,
        dateTime: DateTime.now(),
        status: 'pending',
      );

      context.read<AddNeederRequestCubit>().addNeederRequest(request);

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
          child: Column(
            spacing: 10,
            children: [
              CustomRequestTextField(
                controller: patientNameController,
                hintText: 'patientName'.tr(context),
                validator: (value) =>
                    value!.isEmpty ? 'patientNameError'.tr(context) : null,
                onSaved: (value) {
                  patientName = value!;
                },
              ),
              CustomRequestTextField(
                controller: ageController,
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'ageError'.tr(context) : null,
                hintText: 'age'.tr(context),
                onSaved: (value) {
                  age = num.parse(value!);
                },
              ),
              BloodTypeDropdown(
                selectedBloodType: bloodType,
                onChanged: (selectedType) {
                  setState(() {
                    bloodType = selectedType;
                  });
                },
              ),
              DonationTypeDropdown(
                initialType: donationType,
                onTypeSelected: (selectedType) {
                  setState(() {
                    donationType = selectedType;
                  });
                },
              ),
              GenderDropdown(
                initialGender: gender,
                onGenderSelected: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              CustomRequestTextField(
                controller: idCardController,
                hintText: 'nationalId'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'idCardError'.tr(context) : null,
                onSaved: (value) {
                  idCard = num.parse(value!);
                },
              ),
              CustomRequestTextField(
                controller: medicalConditionsController,
                hintText: 'medicalConditions'.tr(context),
                maxLines: 3,
                onSaved: (value) {
                  medicalConditions = value!;
                },
              ),
              CustomRequestTextField(
                controller: contactController,
                hintText: 'contactNumber'.tr(context),
                textInputType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'contactNumberError'.tr(context) : null,
                onSaved: (value) {
                  contact = num.parse(value!);
                },
              ),
              GovernorateDropdown(
                selectedKey: address,
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
              ),
              CustomRequestTextField(
                controller: hospitalNameController,
                hintText: 'hospitalName'.tr(context),
                validator: (value) =>
                    value!.isEmpty ? 'hospitalNameError'.tr(context) : null,
                onSaved: (value) {
                  hospitalName = value!;
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'addRequest'.tr(context),
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
