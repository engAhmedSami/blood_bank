import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/core/widget/custom_request_text_field.dart';
import 'package:blood_bank/feature/home/domain/entities/needer_request_entity.dart';
import 'package:blood_bank/feature/home/presentation/manger/add_need_request_cubit/add_need_request_cubit.dart';
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

  // Variables initialized with default values
  String patientName = '';
  String address = '';
  String medicalConditions = '';
  String bloodType = 'A+';
  String donationType = 'Whole Blood';
  String gender = 'Male';
  num age = 0;
  num contact = 0;
  num idCard = 0;
  String hospitalName = '';

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

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
        .collection('neederRequest')
        .where('uId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'You have an active request. Please complete it before submitting a new one.'),
        ),
      );
      return false;
    }

    return true;
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }
      final canSubmit = await _canSubmitNewRequest(_user.uid);
      if (!canSubmit) {
        return;
      }

      NeederRequestEntity request = NeederRequestEntity(
        patientName: patientName,
        age: age,
        bloodType: bloodType,
        donationType: donationType,
        gender: gender,
        idCard: idCard,
        medicalConditions: medicalConditions,
        contact: contact,
        address: address,
        uId: _user.uid,
        hospitalName: hospitalName,
      );

      context.read<AddNeederRequestCubit>().addNeederRequest(request);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request submitted successfully!')),
      );
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
                hintText: 'PatientName',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your patientName' : null,
                onSaved: (value) {
                  patientName = value!;
                },
              ),
              CustomRequestTextField(
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your age' : null,
                hintText: 'Age',
                onSaved: (value) {
                  age = num.parse(value!);
                },
              ),
              bloodTypeDropDown(),
              donationTypeDropDown(),
              genderDropDown(),
              CustomRequestTextField(
                hintText: 'National ID',
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your ID card number' : null,
                onSaved: (value) {
                  idCard = num.parse(value!);
                },
              ),
              CustomRequestTextField(
                hintText: 'Medical Conditions',
                maxLines: 3,
                onSaved: (value) {
                  medicalConditions = value!;
                },
              ),
              CustomRequestTextField(
                hintText: 'Contact Number',
                textInputType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter contact number' : null,
                onSaved: (value) {
                  contact = num.parse(value!);
                },
              ),
              CustomRequestTextField(
                hintText: 'Address',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter address' : null,
                onSaved: (value) {
                  address = value!;
                },
              ),
              CustomRequestTextField(
                hintText: 'Hospital Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter hospital name' : null,
                onSaved: (value) {
                  hospitalName = value!;
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Add Request',
                onPressed: _submitRequest,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget datePickerField({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
    required bool isNextDonationDate,
  }) {
    return CustomRequestTextField(
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
          initialDate: DateTime.now(),
          firstDate: isNextDonationDate ? DateTime.now() : DateTime(2000),
          lastDate: isNextDonationDate
              ? DateTime.now().add(const Duration(days: 365 * 11))
              : DateTime.now(),
        );
        if (date != null) {
          onDateSelected(date);
        }
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
        hintText: 'Select Blood Type',
        hintStyle: TextStyles.semiBold14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) => value == null ? 'Please select blood type' : null,
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
        hintText: 'Select Donation Type',
        hintStyle: TextStyles.semiBold14,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) =>
          value == null ? 'Please select donation type' : null,
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
