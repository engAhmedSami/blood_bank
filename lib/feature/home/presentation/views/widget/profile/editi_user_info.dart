// import 'dart:convert';
// import 'dart:io';
// import 'package:blood_bank/constants.dart';
// import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
// import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
// import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
// import 'package:blood_bank/core/widget/blood_type_drop_down.dart';
// import 'package:blood_bank/core/widget/custom_app_bar.dart';
// import 'package:blood_bank/core/widget/custom_text_field.dart';
// import 'package:blood_bank/core/widget/doner_or_neder_state.dart';
// import 'package:blood_bank/core/widget/governorate_drop_down.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:blood_bank/core/widget/custom_button.dart';

// class UserProfilePage extends StatefulWidget {
//   const UserProfilePage({super.key});

//   @override
//   State<UserProfilePage> createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _contactNumberController =
//       TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController bloodTypeController = TextEditingController();
//   final TextEditingController donerOrNederController = TextEditingController();

//   File? _selectedImage;
//   String? _uploadedImageUrl;
//   bool _isLoading = false;

//   String? _userId;
//   // String? _selectedBloodType;
//   // String? _selectedUserState;
//   // String? _selectedGender;

//   @override
//   void initState() {
//     super.initState();
//     _initializeUser();
//   }

//   Future<void> _initializeUser() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         _userId = currentUser.uid;
//         await _loadUserData(_userId!);
//       } else {
//         failureTopSnackBar(context, ' No user is logged in');
//       }
//     } catch (e) {
//       failureTopSnackBar(context, ' Error initializing user: $e');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadUserData(String userId) async {
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       if (doc.exists) {
//         final data = doc.data()!;
//         _nameController.text = data['name'] ?? '';
//         _ageController.text = data['age'] ?? '';
//         _contactNumberController.text = data['contactNumber'] ?? '';
//         locationController.text = data['location'] ?? '';
//         _uploadedImageUrl = data['photoUrl'];
//         bloodTypeController.text = data['bloodType'] ?? ''; // تعيين الفصيلة هنا
//         donerOrNederController.text = data['userState'] ?? '';
//       }
//     } catch (e) {
//       failureTopSnackBar(context, ' Error loading data: $e');
//     }
//   }

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _uploadImage() async {
//     if (_selectedImage == null) return;

//     final storageRef = FirebaseStorage.instance
//         .ref()
//         .child('user_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

//     try {
//       await storageRef.putFile(_selectedImage!);
//       _uploadedImageUrl = await storageRef.getDownloadURL();
//     } catch (e) {
//       failureTopSnackBar(context, 'Error uploading image: $e');
//     }
//   }

//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       if (_selectedImage != null) {
//         await _uploadImage();
//       }

//       final updatedData = {
//         if (_nameController.text.isNotEmpty) 'name': _nameController.text,
//         if (_ageController.text.isNotEmpty) 'age': _ageController.text,
//         if (bloodTypeController.text.isNotEmpty)
//           'bloodType': bloodTypeController.text, // حفظ الفصيلة
//         if (_contactNumberController.text.isNotEmpty)
//           'contactNumber': _contactNumberController.text,
//         if (locationController.text.isNotEmpty)
//           'location': locationController.text,
//         if (_uploadedImageUrl != null) 'photoUrl': _uploadedImageUrl,
//         if (donerOrNederController.text.isNotEmpty)
//           'userState': donerOrNederController.text,
//       };

//       try {
//         if (_userId != null) {
//           final userRef =
//               FirebaseFirestore.instance.collection('users').doc(_userId);

//           final docExists = (await userRef.get()).exists;

//           if (docExists) {
//             await userRef.update(updatedData);
//           } else {
//             await userRef.set(updatedData);
//           }

//           final currentUserData = {...updatedData, 'uId': _userId};
//           Prefs.setString(kUserData, jsonEncode(currentUserData));

//           successTopSnackBar(context, ' Data successfully updated!');

//           Navigator.pop(context);
//         }
//       } catch (e) {
//         failureTopSnackBar(context, 'Error updating data: $e');
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   // DropdownButtonFormField<String> bloodTypeDropDown() {
//   //   return DropdownButtonFormField<String>(
//   //     value: _selectedBloodType,
//   //     items: _bloodTypes
//   //         .map((type) => DropdownMenuItem(
//   //               value: type,
//   //               child: Text(type),
//   //             ))
//   //         .toList(),
//   //     onChanged: (value) => setState(() {
//   //       _selectedBloodType = value;
//   //     }),
//   //     decoration: InputDecoration(
//   //       hintText: 'Select Blood Type',
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(10),
//   //       ),
//   //     ),
//   //     validator: (value) => value == null ? 'Please select blood type' : null,
//   //   );
//   // }

//   // DropdownButtonFormField<String> stateDropDown() {
//   //   return DropdownButtonFormField<String>(
//   //     value: _selectedGender,
//   //     items: _userStates
//   //         .map((userStates) => DropdownMenuItem(
//   //               value: userStates,
//   //               child: Text(userStates),
//   //             ))
//   //         .toList(),
//   //     onChanged: (value) => setState(() {
//   //       _selectedGender = value;
//   //     }),
//   //     decoration: InputDecoration(
//   //       hintText: 'Select State',
//   //       border: OutlineInputBorder(
//   //         borderRadius: BorderRadius.circular(10),
//   //       ),
//   //     ),
//   //     validator: (value) => value == null ? 'Please select State' : null,
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: 'Edit Profile',
//         leadingIcon: Icons.arrow_back_ios_new_rounded,
//       ),
//       body: CustomProgrssHud(
//         isLoading: _isLoading,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
//           child: Form(
//             key: _formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: CircleAvatar(
//                       radius: 50,
//                       backgroundImage: _selectedImage != null
//                           ? FileImage(_selectedImage!)
//                           : (_uploadedImageUrl != null
//                               ? NetworkImage(_uploadedImageUrl!)
//                               : null) as ImageProvider?,
//                       child: _selectedImage == null && _uploadedImageUrl == null
//                           ? const Icon(Icons.camera_alt, size: 50)
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextFormField(
//                     controller: _nameController,
//                     hintText: 'Name',
//                     validator: (value) =>
//                         value!.isEmpty ? 'Please enter a name' : null,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextFormField(
//                     controller: _ageController,
//                     hintText: 'Age',
//                     textInputType: TextInputType.number,
//                     validator: (value) =>
//                         value!.isEmpty ? 'Please enter age' : null,
//                   ),
//                   const SizedBox(height: 16),
//                   CustomTextFormField(
//                     controller: _contactNumberController,
//                     hintText: 'Contact Number',
//                     textInputType: TextInputType.phone,
//                     validator: (value) =>
//                         value!.isEmpty ? 'Please enter contact number' : null,
//                   ),
//                   // const SizedBox(height: 16),
//                   // bloodTypeDropDown(),
//                   const SizedBox(height: 16),
//                   // stateDropDown(),
//                   BloodTypeDropdown(
//                     selectedBloodType: bloodTypeController.text.isNotEmpty
//                         ? bloodTypeController.text
//                         : null, // استخدام القيمة المحفوظة
//                     onChanged: (selectedBloodType) {
//                       setState(() {
//                         bloodTypeController.text =
//                             selectedBloodType ?? ''; // تحديث القيمة المختارة
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 16),
//                   StateDropdown(
//                     selectedKey: donerOrNederController.text.isNotEmpty
//                         ? donerOrNederController.text
//                         : null, // استخدم القيمة التي تم تحميلها من Firebase
//                     onChanged: (selectedState) {
//                       setState(() {
//                         donerOrNederController.text =
//                             selectedState ?? ''; // تحديث القيمة المختارة
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 16),
//                   GovernorateDropdown(
//                     selectedKey: locationController.text.isNotEmpty
//                         ? locationController.text
//                         : null,
//                     onChanged: (value) {
//                       setState(() {
//                         locationController.text = value ?? '';
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   CustomButton(
//                     onPressed: _submitForm,
//                     text: 'Update Profile',
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
import 'package:blood_bank/core/utils/custom_progrss_hud.dart';
import 'package:blood_bank/core/widget/blood_type_drop_down.dart';
import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/core/widget/custom_text_field.dart';
import 'package:blood_bank/core/widget/doner_or_neder_state.dart';
import 'package:blood_bank/core/widget/governorate_drop_down.dart';
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
  final TextEditingController locationController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController donerOrNederController = TextEditingController();

  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _isLoading = false;

  String? _userId;

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
        failureTopSnackBar(context, 'No user is logged in');
      }
    } catch (e) {
      failureTopSnackBar(context, 'Error initializing user: $e');
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
        setState(() {
          _nameController.text = data['name'] ?? '';
          _ageController.text = data['age'] ?? '';
          _contactNumberController.text = data['contactNumber'] ?? '';
          locationController.text = data['location'] ?? '';
          bloodTypeController.text = data['bloodType'] ?? '';
          donerOrNederController.text = data['userState'] ?? '';
          _uploadedImageUrl = data['photoUrl'];
        });
      }
    } catch (e) {
      failureTopSnackBar(context, 'Error loading data: $e');
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
      failureTopSnackBar(context, 'Error uploading image: $e');
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
        if (bloodTypeController.text.isNotEmpty)
          'bloodType': bloodTypeController.text,
        if (_contactNumberController.text.isNotEmpty)
          'contactNumber': _contactNumberController.text,
        if (locationController.text.isNotEmpty)
          'location': locationController.text,
        if (_uploadedImageUrl != null) 'photoUrl': _uploadedImageUrl,
        if (donerOrNederController.text.isNotEmpty)
          'userState': donerOrNederController.text,
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

          successTopSnackBar(context, 'Data successfully updated!');

          Navigator.pop(context);
        }
      } catch (e) {
        failureTopSnackBar(context, 'Error updating data: $e');
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
      backgroundColor: Colors.white,
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
                      child: _selectedImage == null && _uploadedImageUrl == null
                          ? const Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _nameController,
                    hintText: 'Name',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _ageController,
                    hintText: 'Age',
                    textInputType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter age' : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _contactNumberController,
                    hintText: 'Contact Number',
                    textInputType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter contact number' : null,
                  ),
                  const SizedBox(height: 16),
                  BloodTypeDropdown(
                    selectedBloodType: bloodTypeController.text.isNotEmpty
                        ? bloodTypeController.text
                        : null,
                    onChanged: (selectedBloodType) {
                      setState(() {
                        bloodTypeController.text = selectedBloodType ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  StateDropdown(
                    selectedKey: donerOrNederController.text.isNotEmpty
                        ? donerOrNederController.text
                        : null,
                    onChanged: (selectedState) {
                      setState(() {
                        donerOrNederController.text = selectedState ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  GovernorateDropdown(
                    selectedKey: locationController.text.isNotEmpty
                        ? locationController.text
                        : null,
                    onChanged: (value) {
                      setState(() {
                        locationController.text = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    onPressed: _submitForm,
                    text: 'Update Profile',
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
