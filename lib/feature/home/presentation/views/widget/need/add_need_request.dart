import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
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
  List<String> get _bloodTypes {
    return [
      'bloodTypeAPlus'.tr(context),
      'bloodTypeAMinus'.tr(context),
      'bloodTypeBPlus'.tr(context),
      'bloodTypeBMinus'.tr(context),
      'bloodTypeOPlus'.tr(context),
      'bloodTypeOMinus'.tr(context),
      'bloodTypeABPlus'.tr(context),
      'bloodTypeABMinus'.tr(context),
    ];
  }

  List<String> get _donationTypes {
    return [
      'wholeBlood'.tr(context),
      'plasma'.tr(context),
      'platelets'.tr(context),
    ];
  }

  final List<String> _genders = ['Male', 'Female'];

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

  DropdownButtonFormField<String> bloodTypeDropDown() {
    return DropdownButtonFormField<String>(
      value: bloodType,
      items: _bloodTypes
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type, style: TextStyles.semiBold14),
              ))
          .toList(),
      onChanged: (value) => setState(() {
        bloodType = value!;
      }),
      decoration: InputDecoration(
        hintText: 'selectBloodType'.tr(context),
        hintStyle: TextStyles.semiBold14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) =>
          value == null ? 'pleaseSelectBloodType'.tr(context) : null,
    );
  }

  DropdownButtonFormField<String> donationTypeDropDown() {
    return DropdownButtonFormField<String>(
      value: donationType,
      items: _donationTypes
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type, style: TextStyles.semiBold14),
              ))
          .toList(),
      onChanged: (value) => setState(() {
        donationType = value!;
      }),
      decoration: InputDecoration(
        hintText: 'pleaseSelectDonationType'.tr(context),
        hintStyle: TextStyles.semiBold14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) =>
          value == null ? 'selectDonationType'.tr(context) : null,
    );
  }

  DropdownButtonFormField<String> genderDropDown() {
    return DropdownButtonFormField<String>(
      value: gender,
      items: _genders
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender, style: TextStyles.semiBold14),
              ))
          .toList(),
      onChanged: (value) => setState(() {
        gender = value!;
      }),
      decoration: InputDecoration(
        hintText: 'selectGender'.tr(context),
        hintStyle: TextStyles.semiBold14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) =>
          value == null ? 'pleaseSelectGender'.tr(context) : null,
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
      );

      context.read<AddNeederRequestCubit>().addNeederRequest(request);

      successTopSnackBar(context, 'Request submitted successfully!');
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
                hintText: 'patientName'.tr(context),
                validator: (value) =>
                    value!.isEmpty ? 'patientNameError'.tr(context) : null,
                onSaved: (value) {
                  patientName = value!;
                },
              ),
              CustomRequestTextField(
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'ageError'.tr(context) : null,
                hintText: 'age'.tr(context),
                onSaved: (value) {
                  age = num.parse(value!);
                },
              ),
              bloodTypeDropDown(),
              donationTypeDropDown(),
              genderDropDown(),
              CustomRequestTextField(
                hintText: 'nationalId'.tr(context),
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'idCardError'.tr(context) : null,
                onSaved: (value) {
                  idCard = num.parse(value!);
                },
              ),
              CustomRequestTextField(
                hintText: 'medicalConditions'.tr(context),
                maxLines: 3,
                onSaved: (value) {
                  medicalConditions = value!;
                },
              ),
              CustomRequestTextField(
                hintText: 'contactNumber'.tr(context),
                textInputType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'contactNumberError'.tr(context) : null,
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
