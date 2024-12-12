import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/logout_button.dart';
import 'package:blood_bank/feature/localization/cubit/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/big_info_card.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/custom_app_bar_profile.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_item.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_switch.dart';
import 'package:blood_bank/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              StreamBuilder<UserModel>(
                stream:
                    getUserStream(), // اشتراك في التحديثات المباشرة لبيانات المستخدم
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('No user data available'));
                  }

                  final user = snapshot.data!;

                  return CustomProfileAppBar(
                    name: user.name,
                    photoUrl: user.photoUrl,
                    userState: user.userState,
                  );
                },
              ),
              const SizedBox(height: 60),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: kHorizintalPadding),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SettingsSwitch(
                      title: 'Available To Donate',
                      keyName: 'available_to_donate',
                    ),
                    SettingsSwitch(
                      title: 'Notification',
                      keyName: 'notification',
                    ),
                    SettingsSwitch(
                      title: 'Allow Tracking',
                      keyName: 'allow_tracking',
                    ),
                    SettingsItem(
                      title: 'Manage Address',
                      icon: Icons.location_on,
                    ),
                    SettingsItem(
                      title: 'Language',
                      icon: Icons.language,
                      onTap: () => _showLanguagePicker(context),
                    ),
                    SettingsItem(
                      title: 'Contact Details',
                      icon: Icons.arrow_forward_ios,
                    ),
                    const SizedBox(height: 20),
                    LogoutFeature(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 175,
            left: 20,
            right: 20,
            child: StreamBuilder<UserModel>(
              stream: getUserStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No user data available'));
                }

                final user = snapshot.data!;
                return BigInfoCard(
                  savedLives: '3 life saved',
                  bloodGroup: '${user.bloodType} Group',
                  nextDonationDate: 'Next Donation',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Language',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: const Text('English',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: const Text('العربية',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage('ar');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
