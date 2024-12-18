import 'dart:developer';

import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/widget/custom_text_field.dart';
import 'package:flutter/material.dart';

class DonerRequest extends StatefulWidget {
  const DonerRequest({super.key});

  @override
  DonerRequestState createState() => DonerRequestState();
}

class DonerRequestState extends State<DonerRequest> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();
  final TextEditingController _medicalConditionsController =
      TextEditingController();

  DateTime? _lastDonationDate;
  DateTime? _nextDonationDate;

  String? _selectedBloodType;
  String? _selectedDonationType;
  String? _selectedGender;

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

  final List<String> _genders = ['Male', 'Female']; // Gender options

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
              CustomTextFormField(
                controller: _nameController,
                hintText: 'Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              CustomTextFormField(
                controller: _ageController,
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your age' : null,
                hintText: 'Age',
              ),
              bloodTypeDropDown(),
              donationTypeDropDown(),
              genderDropDown(), // New dropdown for gender
              CustomTextFormField(
                controller: _idCardController,
                hintText: 'National ID',
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your ID card number' : null,
              ),
              datePickerField(
                label: 'Last Donation Date',
                selectedDate: _lastDonationDate,
                onDateSelected: (date) {
                  setState(() {
                    _lastDonationDate = date;
                  });
                },
              ),
              datePickerField(
                label: 'Next Donation Date',
                selectedDate: _nextDonationDate,
                onDateSelected: (date) {
                  setState(() {
                    _nextDonationDate = date;
                  });
                },
              ),
              CustomTextFormField(
                controller: _medicalConditionsController,
                hintText: 'Medical Conditions',
                maxLines: 3,
              ),
              CustomTextFormField(
                controller: _unitsController,
                hintText: 'Units',
                textInputType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter required units' : null,
              ),
              CustomTextFormField(
                controller: _contactController,
                hintText: 'Contact Number',
                textInputType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter contact number' : null,
              ),
              CustomTextFormField(
                controller: _addressController,
                hintText: 'Address',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter address' : null,
              ),
              CustomTextFormField(
                controller: _notesController,
                hintText: 'Notes',
                maxLines: 3,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      final data = {
        'name': _nameController.text,
        'age': _ageController.text,
        'bloodType': _selectedBloodType,
        'donationType': _selectedDonationType,
        'idCard': _idCardController.text,
        'lastDonationDate': _lastDonationDate?.toIso8601String(),
        'nextDonationDate': _nextDonationDate?.toIso8601String(),
        'medicalConditions': _medicalConditionsController.text,
        'contact': _contactController.text,
        'address': _addressController.text,
        'notes': _notesController.text,
        'units': _unitsController.text,
        'gender': _selectedGender,
      };

      // Perform form submission logic here
      log(data.toString());
    }
  }

  Widget datePickerField({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return CustomTextFormField(
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
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
    );
  }

  DropdownButtonFormField<String> bloodTypeDropDown() {
    return DropdownButtonFormField<String>(
      value: _selectedBloodType,
      items: _bloodTypes
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type, style: TextStyles.semiBold14),
              ))
          .toList(),
      onChanged: (value) => setState(() {
        _selectedBloodType = value;
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
      value: _selectedDonationType,
      items: _donationTypes
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type, style: TextStyles.semiBold14),
              ))
          .toList(),
      onChanged: (value) => setState(() {
        _selectedDonationType = value;
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
      value: _selectedGender,
      items: _genders
          .map((gender) => DropdownMenuItem(
                value: gender,
                child: Text(gender, style: TextStyles.semiBold14),
              ))
          .toList(),
      onChanged: (value) => setState(() {
        _selectedGender = value;
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
