import 'package:blood_bank/constants.dart';
import 'package:blood_bank/core/helper_function/failuer_top_snak_bar.dart';
import 'package:blood_bank/core/helper_function/scccess_top_snak_bar.dart';
import 'package:blood_bank/core/services/firestor_service.dart';
import 'package:blood_bank/core/utils/app_text_style.dart';
import 'package:blood_bank/core/utils/assets_images.dart';
import 'package:blood_bank/core/utils/page_rout_builder.dart';
import 'package:blood_bank/core/widget/custom_app_bar.dart';
import 'package:blood_bank/core/widget/custom_button.dart';
import 'package:blood_bank/feature/auth/presentation/view/widget/preference_button.dart';
import 'package:blood_bank/feature/home/presentation/views/custom_bottom_nav_bar.dart';
import 'package:blood_bank/feature/localization/app_localizations.dart';
import 'package:blood_bank/core/services/shared_preferences_sengleton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class DonorOrNeed extends StatefulWidget {
  const DonorOrNeed({super.key});

  @override
  State<DonorOrNeed> createState() => _DonorOrNeedState();
}

class _DonorOrNeedState extends State<DonorOrNeed> {
  String? selectedOption;
  bool isLoading = true; // حالة التحميل عند التحقق من حالة المستخدم
  bool isSaving = false; // حالة التحميل عند حفظ البيانات
  final FirestorService firestoreService = FirestorService();

  @override
  void initState() {
    super.initState();
    _checkIfUserStateExists();
  }

  Future<void> _checkIfUserStateExists() async {
    bool isUserStateSelected = Prefs.getBool(kIsUserStateSelected);
    if (isUserStateSelected) {
      // إذا تم اختيار الحالة مسبقًا، الانتقال مباشرة للصفحة الرئيسية
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          buildPageRoute(const CustomBottomNavBar()),
        );
      });
    } else {
      setState(() {
        isLoading = false; // إنهاء حالة التحميل عند التحقق
      });
    }
  }

  Future<void> _saveSelectionToPrefs(String option) async {
    selectedOption = option;
    setState(() {}); // تحديث الواجهة
  }

  Future<void> saveUserState() async {
    if (selectedOption != null) {
      setState(() {
        isSaving = true; // بدء حالة الحفظ
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // تحديث الحقل userState في Firestore
          await firestoreService.updateData(
            path: 'users',
            docuementId: user.uid,
            data: {
              'userState': selectedOption,
            },
          );

          // قراءة البيانات الحالية من Prefs
          final currentUserData = Prefs.getString(kUserData);
          Map<String, dynamic> userData = {};
          if (currentUserData != null && currentUserData.isNotEmpty) {
            userData = jsonDecode(currentUserData);
          }

          // تحديث بيانات userState في Prefs
          userData['userState'] = selectedOption;
          Prefs.setString(kUserData, jsonEncode(userData));

          // حفظ حالة الاختيار باستخدام Prefs
          Prefs.setBool(kIsUserStateSelected, true);

          if (!mounted) return;

          succesTopSnackBar(
            context,
            'User state updated successfully',
          );

          // الانتقال إلى الصفحة الرئيسية مع إيقاف اللودينج
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              buildPageRoute(const CustomBottomNavBar()),
            );
          });
        } else {
          failuerTopSnackBar(
            context,
            'User not authenticated',
          );
        }
      } catch (e) {
        failuerTopSnackBar(
          context,
          'Failed to update user state: $e',
        );
      } finally {
        // تعيين حالة الحفظ إلى false فقط إذا لم يتم التنقل
        if (mounted) {
          setState(() {
            isSaving = false;
          });
        }
      }
    } else {
      failuerTopSnackBar(
        context,
        'Please select an option',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // عرض مؤشر التحميل
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        top: 120,
        left: 50,
        title: '',
        leadingIcon: Icons.arrow_back_ios_new_rounded,
        onSkipPressed: () {},
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizintalPadding),
            child: Column(
              children: [
                const SizedBox(height: 90),
                Text(
                  "Choose which one do you prefer?".tr(context),
                  style: TextStyles.semiBold19,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PreferenceButton(
                      image: Assets.imagesNeed,
                      label: "Need",
                      isSelected: selectedOption == "Need",
                      onPressed: () {
                        _saveSelectionToPrefs("Need");
                      },
                    ),
                    const SizedBox(width: 40),
                    PreferenceButton(
                      image: Assets.imagesDoner,
                      label: "Donor",
                      isSelected: selectedOption == "Donor",
                      onPressed: () {
                        _saveSelectionToPrefs("Donor");
                      },
                    ),
                  ],
                ),
                const Spacer(),
                CustomButton(
                  onPressed: saveUserState, // تعطيل الزر أثناء الحفظ
                  text: isSaving ? "Saving...".tr(context) : "Next".tr(context),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          if (isSaving) // حالة الحفظ
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
