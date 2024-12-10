import 'package:blood_bank/core/helper_function/get_user.dart';
import 'package:flutter/material.dart';
import 'package:blood_bank/feature/auth/data/models/user_model.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/big_info_card.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/custom_app_bar_profile.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_item.dart';
import 'package:blood_bank/feature/home/presentation/views/widget/profile/settings_switch.dart';
import 'package:blood_bank/core/utils/app_colors.dart';
import 'package:blood_bank/constants.dart';

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
                  children: const [
                    SettingsSwitch(title: 'Available To Donate', value: true),
                    SettingsSwitch(title: 'Notification', value: true),
                    SettingsSwitch(title: 'Allow Tracking', value: true),
                    SettingsItem(title: 'Manage Address'),
                    SettingsItem(title: 'History'),
                    SettingsItem(title: 'Contact Details'),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.primaryColor),
                        SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                              color: AppColors.primaryColor, fontSize: 16),
                        ),
                      ],
                    ),
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
}
