import 'dart:convert';
import 'dart:io';
import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blood_bank/core/widget/custom_button.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isLoading = false;

  String? _userId;
  String? _selectedBloodType;
  String? _selectedUserState;

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
  final List<String> _userStates = ['Donor', 'Need'];

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        _userId = currentUser.uid;
        await _loadUserData(_userId!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is logged in')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing user: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _ageController.text = data['age'] ?? '';
        _contactNumberController.text = data['contactNumber'] ?? '';
        _locationController.text = data['location'] ?? '';
        _uploadedImageUrl = data['photoUrl'];
        _selectedBloodType =
            _bloodTypes.contains(data['bloodType']) ? data['bloodType'] : null;
        _selectedUserState =
            _userStates.contains(data['userState']) ? data['userState'] : null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      await storageRef.putFile(_selectedImage!);
      _uploadedImageUrl = await storageRef.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (_selectedImage != null) {
        await _uploadImage();
      }

      final updatedData = {
        if (_nameController.text.isNotEmpty) 'name': _nameController.text,
        if (_ageController.text.isNotEmpty) 'age': _ageController.text,
        if (_selectedBloodType != null) 'bloodType': _selectedBloodType,
        if (_contactNumberController.text.isNotEmpty)
          'contactNumber': _contactNumberController.text,
        if (_locationController.text.isNotEmpty)
          'location': _locationController.text,
        if (_uploadedImageUrl != null) 'photoUrl': _uploadedImageUrl,
        if (_selectedUserState != null) 'userState': _selectedUserState,
      };

      try {
        if (_userId != null) {
          final userRef =
              FirebaseFirestore.instance.collection('users').doc(_userId);

          final docExists = (await userRef.get()).exists;

          if (docExists) {
            await userRef.update(updatedData);
          } else {
            await userRef.set(updatedData);
          }

          final currentUserData = {...updatedData, 'uId': _userId};
          Prefs.setString(kUserData, jsonEncode(currentUserData));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data successfully updated!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating data: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Edit Profile',
          leadingIcon: Icons.arrow_back_ios_new_rounded,
        ),
        body: CustomProgrssHud(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (_uploadedImageUrl != null
                                ? NetworkImage(_uploadedImageUrl!)
                                : null) as ImageProvider?,
                        child:
                            _selectedImage == null && _uploadedImageUrl == null
                                ? const Icon(Icons.camera_alt, size: 50)
                                : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter age' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: _bloodTypes.contains(_selectedBloodType)
                          ? _selectedBloodType
                          : null,
                      items: _bloodTypes
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) => setState(() {
                        _selectedBloodType = value;
                      }),
                      decoration:
                          const InputDecoration(labelText: 'Blood Type'),
                      validator: (value) =>
                          value == null ? 'Please select blood type' : null,
                    ),
                    TextFormField(
                      controller: _contactNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Contact Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter contact number' : null,
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter location' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: _userStates.contains(_selectedUserState)
                          ? _selectedUserState
                          : null,
                      items: _userStates
                          .map((state) => DropdownMenuItem(
                              value: state, child: Text(state)))
                          .toList(),
                      onChanged: (value) => setState(() {
                        _selectedUserState = value;
                      }),
                      decoration:
                          const InputDecoration(labelText: 'Donor or Need'),
                      validator: (value) =>
                          value == null ? 'Please select a state' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: _submitForm,
                      text: 'Update Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
